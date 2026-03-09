-- UI module: drawing helpers using the Playdate SDK.
-- Depends on Constants and Strings globals (loaded via import in main.lua).

local gfx = playdate.graphics

-- luacheck: globals UI
UI = {}

-- Formats fuel seconds as M:SS (e.g. 90 → "1:30", 5 → "0:05").
local function format_fuel(seconds)
  local s = math.floor(seconds)
  return string.format("%d:%02d", math.floor(s / 60), s % 60)
end

-- Draws the aircraft card: a bordered box with callsign, fuel countdown,
-- and situation text centred in the card.
function UI.draw_aircraft_card(aircraft)
  local c = Constants.CARD
  local card_center_x = c.X + c.WIDTH / 2

  gfx.drawRect(c.X, c.Y, c.WIDTH, c.HEIGHT)

  gfx.drawTextAligned(aircraft.callsign, card_center_x, c.CALLSIGN_Y, kTextAlignment.center)

  gfx.drawTextAligned(
    Strings.card.fuel_label .. ": " .. format_fuel(aircraft.fuel),
    card_center_x,
    c.FUEL_Y,
    kTextAlignment.center
  )

  gfx.drawTextAligned(
    Strings.card.situation_label .. ": " .. aircraft.situation,
    card_center_x,
    c.SITUATION_Y,
    kTextAlignment.center
  )
end
