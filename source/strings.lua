-- All displayed UI text lives here.
-- Edit this file to change any text shown on screen.

-- luacheck: globals Strings
Strings = {
  title = {
    heading = "STILLWATER APPROACH",
    prompt = "press Ⓐ to begin shift",
  },
  card = {
    altitude_prefix = "ALT: ",
    -- Shown on cards in the landing queue while altitude is descending toward 0.
    -- ASCII 'v' signals descent (UTF-8 down-arrow ▼ not supported by Roobert-9-Mono-Condensed bitmap font).
    altitude_approach_prefix = "ALTv ",
    fuel_prefix = "F: ",
    landed = "Landed",
  },
  shift = {
    placeholder = "SHIFT",
    landing_label = "LANDING",
    holding_label = "HOLDING",
    empty_landing = "no aircraft on approach",
    empty_holding = "no aircraft holding",
  },
  score = {
    win_heading = "SHIFT COMPLETE",
    lose_heading = "SHIFT FAILED",
    -- Appended after the failed aircraft callsign: "STW4 out of fuel"
    out_of_fuel = "out of fuel",
    landed_label = "Aircraft landed:",
    efficiency_label = "Efficiency:",
    near_miss_label = "Near misses:",
    score_label = "Score:",
    prompt = "press A to continue",
  },
}
