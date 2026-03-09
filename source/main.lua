-- Ghostwood Approach
-- Entry point for the Playdate game

-- Debug logging: set to false before release to silence all log() calls
local DEBUG <const> = true

-- luacheck: globals log
function log(...)
  if DEBUG then
    print(...)
  end
end

import("CoreLibs/graphics")
import("strings")
import("constants")
import("aircraft")
import("ui")

local gfx <const> = playdate.graphics

-- Screen states
local STATE_TITLE = "title"
local STATE_SHIFT = "shift"

local state = STATE_TITLE

-- Shift state: the current aircraft card and last frame timestamp
local shift_aircraft = nil
local last_time = nil

-- Title screen: shows airport name and waits for A press
local function draw_title()
  gfx.clear(gfx.kColorWhite)
  gfx.drawTextAligned(
    Strings.title.heading,
    Constants.SCREEN_CENTER_X,
    Constants.TITLE_HEADING_Y,
    kTextAlignment.center
  )
  gfx.drawTextAligned(Strings.title.prompt, Constants.SCREEN_CENTER_X, Constants.TITLE_PROMPT_Y, kTextAlignment.center)
end

-- Shift screen: updates fuel each frame and redraws the aircraft card
local function update_shift()
  local now = playdate.getCurrentTimeMilliseconds()
  local dt = (now - last_time) / 1000.0
  last_time = now

  Aircraft.tick(shift_aircraft, dt)

  gfx.clear(gfx.kColorWhite)
  UI.draw_aircraft_card(shift_aircraft)
end

function playdate.update()
  if state == STATE_TITLE then
    draw_title()
    if playdate.buttonJustPressed(playdate.kButtonA) then
      -- Initialise a fresh aircraft when the shift begins
      shift_aircraft = Aircraft.new("GHOSTWOOD AIR 4", 90, "Normal")
      last_time = playdate.getCurrentTimeMilliseconds()
      state = STATE_SHIFT
    end
  elseif state == STATE_SHIFT then
    update_shift()
  end
end
