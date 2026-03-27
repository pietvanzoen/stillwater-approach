std = "lua54"

-- Playdate globals
globals = {
  "playdate",
  "import",
  "kTextAlignment",
  -- Module globals (Playdate's import doesn't return values, so modules assign to globals)
  "Strings",
  "Constants",
  "Aircraft",
  "Cursor",
  "Queue",
  "UI",
  "Cover",
  "Scoring",
  "Seasons",
  "log",
}

max_line_length = 120

max_cyclomatic_complexity = 10

-- busted test globals
files["spec/**/*_spec.lua"] = {
  std = "+busted",
}
