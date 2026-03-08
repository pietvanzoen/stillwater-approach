#!/usr/bin/env bash
# Appends a usage summary line to .claude/usage-log.jsonl at the project root.
# Invoked by Claude Code as a Stop hook (receives JSON on stdin).
#
# Parses the main session transcript plus any sibling transcripts (subagents)
# that started within the session's time range.
#
# Requires: jq

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
USAGE_LOG="$PROJECT_ROOT/.claude/usage-log.jsonl"

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
transcript_path=$(echo "$input" | jq -r '.transcript_path' | sed "s|^~|$HOME|")

[[ -f "$transcript_path" ]] || exit 0

transcript_dir=$(dirname "$transcript_path")

# Get the session's time range to identify sibling transcripts (subagents)
session_start=$(jq -rn 'first(inputs | select(.timestamp? != null)) | .timestamp' "$transcript_path")
session_end=$(jq -rn 'last(inputs | select(.timestamp? != null)) | .timestamp' "$transcript_path")

# Collect main transcript plus siblings whose first timestamp falls within our session
transcripts=("$transcript_path")
if [[ -n "$session_start" && "$session_start" != "null" && -n "$session_end" && "$session_end" != "null" ]]; then
  for sibling in "$transcript_dir"/*.jsonl; do
    [[ "$sibling" == "$transcript_path" ]] && continue
    sibling_start=$(jq -rn 'first(inputs | select(.timestamp? != null)) | .timestamp' "$sibling" 2>/dev/null || true)
    if [[ -n "$sibling_start" && "$sibling_start" != "null" \
          && "$sibling_start" > "$session_start" && "$sibling_start" < "$session_end" ]]; then
      transcripts+=("$sibling")
    fi
  done
fi

# Sum token counts from all assistant messages across all transcripts
data=$(cat "${transcripts[@]}" | jq -rn \
  '[inputs | select(.type == "assistant") | .message.usage | select(. != null)] |
   {
     input_tokens:          (map(.input_tokens                  // 0) | add // 0),
     output_tokens:         (map(.output_tokens                 // 0) | add // 0),
     cache_read_tokens:     (map(.cache_read_input_tokens       // 0) | add // 0),
     cache_creation_tokens: (map(.cache_creation_input_tokens   // 0) | add // 0)
   }')

# Skip empty sessions
total=$(echo "$data" | jq '.input_tokens + .output_tokens')
[[ "$total" -gt 0 ]] || exit 0

# Build and upsert log entry
date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
entry=$(echo "$data" | jq -c \
  --arg session_id "$session_id" \
  --arg date       "$date" \
  '{session_id: $session_id, date: $date,
    input_tokens, output_tokens, cache_read_tokens, cache_creation_tokens}')

touch "$USAGE_LOG"
if grep -qF "\"session_id\":\"$session_id\"" "$USAGE_LOG"; then
  tmp=$(mktemp)
  grep -vF "\"session_id\":\"$session_id\"" "$USAGE_LOG" > "$tmp" || true
  echo "$entry" >> "$tmp"
  mv "$tmp" "$USAGE_LOG"
else
  echo "$entry" >> "$USAGE_LOG"
fi
