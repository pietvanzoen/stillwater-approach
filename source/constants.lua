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
  TITLE_PROMPT_Y = 140,

  -- Aircraft card layout
  CARD = {
    X = 20,
    Y = 20,
    WIDTH = 360,
    HEIGHT = 160,
    PADDING = 12,
    CALLSIGN_Y = 32,
    FUEL_Y = 80,
    SITUATION_Y = 128,
  },
}
