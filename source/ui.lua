-- UI module: drawing helpers using the Playdate SDK.
-- Depends on Constants and Strings globals (loaded via import in main.lua).

local gfx = playdate.graphics

-- luacheck: globals UI
UI = {}

local card_font = gfx.font.new("fonts/Roobert-9-Mono-Condensed")

-- Formats fuel seconds as M:SS (e.g. 90 → "1:30", 5 → "0:05").
-- Uses ceil so the display holds at the current second until a full
-- second has elapsed, rather than dropping immediately after each frame.
local function format_fuel(seconds)
  local s = math.ceil(seconds)
  return string.format("%d:%02d", math.floor(s / 60), s % 60)
end

-- Draws a value + label pair centred horizontally in a column.
-- value_y and label_y are absolute screen y positions.
local function draw_cell(value, label, center_x, value_y, label_y)
  gfx.drawTextAligned(value, center_x, value_y, kTextAlignment.center)
  gfx.drawTextAligned(label, center_x, label_y, kTextAlignment.center)
end

-- Returns the horizontal centre of a column spanning x1..x2.
local function col_center(x1, x2)
  return math.floor((x1 + x2) / 2)
end

-- Draws the aircraft card as a flight progress strip at position (x, y).
--
--   ┌──┬──────────┬────────┬────────┬──────────────────┐
--   │▓▓│ CALLSIGN │  8000  │  1:30  │  Normal          │
--   │▓▓│ CALLSIGN │  ALT   │  FUEL  │  STATUS          │
--   └──┴──────────┴────────┴────────┴──────────────────┘
--
-- Four columns separated by vertical dividers. Each column shows
-- a value on the top row and a small label on the bottom row.
-- Divider constants (DIV1_X etc.) are offsets from x, not absolute positions.
-- If focused is true, the card border is drawn thicker to indicate selection.
function UI.draw_aircraft_card(aircraft, x, y, focused)
  local c = Constants.CARD
  local s = Strings.card

  if focused then
    gfx.setLineWidth(c.FOCUSED_LINE_WIDTH)
    gfx.drawRect(x, y, c.WIDTH, c.HEIGHT)
    gfx.setLineWidth(1)
  else
    gfx.drawRect(x, y, c.WIDTH, c.HEIGHT)
  end

  -- Solid left tab (like a physical strip-holder bay)
  gfx.fillRect(x, y, c.TAB_WIDTH, c.HEIGHT)

  -- Column dividers (offsets from x)
  local div1 = x + c.DIV1_X
  local div2 = x + c.DIV2_X
  local div3 = x + c.DIV3_X
  gfx.drawLine(div1, y, div1, y + c.HEIGHT - 1)
  gfx.drawLine(div2, y, div2, y + c.HEIGHT - 1)
  gfx.drawLine(div3, y, div3, y + c.HEIGHT - 1)

  -- Column centre x positions
  local col1_cx = col_center(x + c.TAB_WIDTH, div1)
  local col2_cx = col_center(div1, div2)
  local col3_cx = col_center(div2, div3)
  local col4_cx = col_center(div3, x + c.WIDTH)

  -- Absolute y positions for value and label rows
  local value_y = y + c.VALUE_Y_OFFSET
  local label_y = y + c.LABEL_Y_OFFSET

  gfx.setFont(card_font)
  draw_cell(aircraft.callsign, s.callsign_label, col1_cx, value_y, label_y)
  draw_cell(tostring(aircraft.altitude), s.altitude_label, col2_cx, value_y, label_y)
  draw_cell(format_fuel(aircraft.fuel), s.fuel_label, col3_cx, value_y, label_y)
  draw_cell(aircraft.situation, s.situation_label, col4_cx, value_y, label_y)
  gfx.setFont(gfx.getSystemFont())
end

-- Draws a section header label centred on screen.
local function draw_section_header(text, y)
  gfx.setFont(card_font)
  gfx.drawTextAligned(text, Constants.SCREEN_WIDTH / 2, y, kTextAlignment.center)
  gfx.setFont(gfx.getSystemFont())
end

-- Draws the full shift screen: LANDING section header + cards, HOLDING section header + cards.
-- cursor is { section = Constants.SECTION_LANDING|SECTION_HOLDING, index = 1 }
function UI.draw_shift_screen(shift_state, cursor)
  local c = Constants
  gfx.clear(gfx.kColorWhite)

  local card_step = c.CARD.HEIGHT + c.CARD.CARD_GAP
  local current_y = c.CARD_LIST_START_Y

  -- LANDING section header
  local landing_count = #shift_state.landing
  local landing_header = string.format("%s %d/%d", Strings.shift.landing_label, landing_count, c.MAX_LANDING)
  draw_section_header(landing_header, current_y)
  current_y = current_y + c.SECTION_HEADER_HEIGHT

  -- Landing cards
  for i, aircraft in ipairs(shift_state.landing) do
    local focused = cursor.section == c.SECTION_LANDING and cursor.index == i
    UI.draw_aircraft_card(aircraft, c.CARD.X, current_y, focused)
    current_y = current_y + card_step
  end

  -- HOLDING section header
  draw_section_header(Strings.shift.holding_label, current_y)
  current_y = current_y + c.SECTION_HEADER_HEIGHT

  -- Holding cards
  for i, aircraft in ipairs(shift_state.holding) do
    local focused = cursor.section == c.SECTION_HOLDING and cursor.index == i
    UI.draw_aircraft_card(aircraft, c.CARD.X, current_y, focused)
    current_y = current_y + card_step
  end
end
