-- Game-wide constants.
-- Centralises magic numbers for screen layout and game parameters.

-- luacheck: globals Constants
Constants = {
  -- Playdate display is always 400x240
  SCREEN_WIDTH = 400,
  SCREEN_HEIGHT = 240,
  SCREEN_CENTER_X = 200,
  SCREEN_CENTER_Y = 120,

  -- Title screen layout
  TITLE_HEADING_Y = 100,
  TITLE_PROMPT_Y = 10,

  -- Aircraft card layout (single-row flight progress strip).
  -- Fields are drawn left-to-right at fixed column offsets separated by vertical dividers; no header rows.
  CARD = {
    X = 10,
    Y = 91, -- vertically centred reference; shift screen uses CARD_LIST_START_Y instead
    WIDTH = 380,
    HEIGHT = 28,
    TAB_WIDTH = 6, -- solid left-edge tab, like a physical strip holder
    CARD_GAP = 3, -- vertical gap between stacked cards
    FOCUSED_LINE_WIDTH = 2, -- border line width for the focused card
    TEXT_Y_OFFSET = 10, -- y offset from card top to text baseline

    -- X offsets from card left edge for column dividers
    DIV1_X = 60, -- right edge of callsign column
    DIV2_X = 150, -- right edge of altitude column
    DIV3_X = 220, -- right edge of fuel column

    -- X offsets from card left edge for text in each column
    COL1_CX = 33, -- callsign centre: (TAB_WIDTH + DIV1_X) / 2
    COL2_X = 64, -- altitude left-aligned ("ALT: 8000"), 4px after DIV1_X
    COL3_X = 154, -- fuel left-aligned     ("F: 0:02"),   4px after DIV2_X
    COL4_CX = 300, -- situation centre: (DIV3_X + WIDTH) / 2
  },

  -- Single-column shift screen layout
  SECTION_HEADER_HEIGHT = 14,
  CARD_LIST_START_Y = 4,
  MAX_LANDING = 3,

  -- Section name identifiers used in cursor state
  SECTION_LANDING = "landing",
  SECTION_HOLDING = "holding",

  -- Landing approach: altitude lost per second once an aircraft enters the landing queue.
  -- Holding aircraft maintain their assigned altitude; only aircraft in the landing queue descend.
  -- At 50 ft/sec: 2500 ft → 50 s, 3500 ft → 70 s, 4500 ft → 90 s.
  APPROACH_RATE = 50,

  -- Minimum altitude separation (feet) between consecutive landing aircraft during descent.
  -- Prevents visual confusion when multiple aircraft are promoted close together.
  MIN_LANDING_SEP = 500,

  -- Duration (seconds) to display "Landed" on the card after touchdown before removing it.
  TOUCHDOWN_DWELL = 3,
}
