-- Ghostwood Approach
-- Entry point for the Playdate game

import("CoreLibs/graphics")
import("strings")
import("constants")

local gfx <const> = playdate.graphics

-- Screen states
local STATE_TITLE = "title"
local STATE_SHIFT = "shift"

local state = STATE_TITLE

-- Title screen: shows airport name and waits for A press
local function drawTitle()
  gfx.clear(gfx.kColorWhite)
  gfx.drawTextAligned(
    Strings.title.heading,
    Constants.SCREEN_CENTER_X,
    Constants.TITLE_HEADING_Y,
    kTextAlignment.center
  )
  gfx.drawTextAligned(Strings.title.prompt, Constants.SCREEN_CENTER_X, Constants.TITLE_PROMPT_Y, kTextAlignment.center)
end

-- Shift screen: placeholder until game logic is added
local function drawShift()
  gfx.clear(gfx.kColorWhite)
  gfx.drawTextAligned(
    Strings.shift.placeholder,
    Constants.SCREEN_CENTER_X,
    Constants.SCREEN_CENTER_Y,
    kTextAlignment.center
  )
end

function playdate.update()
  if state == STATE_TITLE then
    drawTitle()
    if playdate.buttonJustPressed(playdate.kButtonA) then
      state = STATE_SHIFT
    end
  elseif state == STATE_SHIFT then
    drawShift()
  end
end
