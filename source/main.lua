-- Stillwater Approach

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
import("queue")
import("cursor")
import("scoring")
import("seasons")
import("ui")
import("cover")

local gfx <const> = playdate.graphics

local STATE_TITLE = "title"
local STATE_SHIFT = "shift"
local STATE_SCORE = "score"

local state = STATE_TITLE

-- Shift state: queue of landing and holding aircraft, cursor position, and last frame timestamp
local shift_state = nil -- { landing = {}, holding = {} }
local cursor = nil -- { section = Constants.SECTION_LANDING|SECTION_HOLDING, index = 1 }
local last_time = nil

-- Score screen state: set when the shift ends (win or lose)
local score_result = nil -- { win, total, landed_count, avg_fuel_pct, near_miss_count, failed_callsign, failure_type }

local function draw_title()
  Cover.draw()
  gfx.setColor(gfx.kColorBlack)
  gfx.drawTextAligned(Strings.title.prompt, Constants.SCREEN_CENTER_X, Constants.TITLE_PROMPT_Y, kTextAlignment.center)
end

local function handle_shift_input()
  if playdate.buttonJustPressed(playdate.kButtonUp) then
    Cursor.up(cursor, shift_state)
  elseif playdate.buttonJustPressed(playdate.kButtonDown) then
    Cursor.down(cursor, shift_state)
  elseif playdate.buttonJustPressed(playdate.kButtonA) then
    if cursor.section == Constants.SECTION_HOLDING then
      Queue.promote(shift_state, cursor.index)
      Cursor.clamp_after_promote(cursor, shift_state)
    end
    -- A on landing card: no-op
  end
end

local function update_shift()
  local now = playdate.getCurrentTimeMilliseconds()
  local dt = (now - last_time) / 1000.0
  last_time = now

  shift_state.elapsed = shift_state.elapsed + dt
  Queue.check_arrivals(shift_state, shift_state.elapsed)
  Queue.tick_all(shift_state, dt)

  local landed = Queue.resolve_touchdown(shift_state, dt)
  if landed then
    Cursor.clamp_after_land(cursor, shift_state)
  end

  -- Lose conditions: checked before win so a failure on the final landing tick
  -- resolves as a loss, not a win. Fuel checked before time (arbitrary ordering).
  local failed = Queue.find_out_of_fuel(shift_state)
  if failed then
    local partial = Scoring.calculate(shift_state.landed)
    score_result = {
      win = false,
      failed_callsign = failed,
      failure_type = "fuel",
      landed_count = partial.landed_count,
      avg_fuel_pct = 0, -- no efficiency credit on a failed shift
      near_miss_count = partial.near_miss_count,
      total = 0, -- no score for a failed shift
    }
    state = STATE_SCORE
    return
  end

  local time_failed = Queue.find_time_expired(shift_state)
  if time_failed then
    local partial = Scoring.calculate(shift_state.landed)
    score_result = {
      win = false,
      failed_callsign = time_failed,
      failure_type = "time",
      landed_count = partial.landed_count,
      avg_fuel_pct = 0,
      near_miss_count = partial.near_miss_count,
      total = 0,
    }
    state = STATE_SCORE
    return
  end

  if Queue.is_complete(shift_state) then
    score_result = Scoring.calculate(shift_state.landed)
    score_result.win = true
    score_result.failed_callsign = nil
    state = STATE_SCORE
    return
  end

  handle_shift_input()
  UI.draw_shift_screen(shift_state, cursor)
end

function playdate.update()
  if state == STATE_TITLE then
    draw_title()
    if playdate.buttonJustPressed(playdate.kButtonA) then
      shift_state = Queue.new(Constants.MAX_LANDING)
      shift_state.elapsed = 0
      shift_state.schedule = Seasons.spring()
      shift_state.next_arrival = 1
      cursor = { section = Constants.SECTION_HOLDING, index = 1 }
      last_time = playdate.getCurrentTimeMilliseconds()
      state = STATE_SHIFT
    end
  elseif state == STATE_SHIFT then
    update_shift()
  elseif state == STATE_SCORE then
    assert(score_result ~= nil, "reached STATE_SCORE with nil score_result")
    UI.draw_score_screen(score_result)
    if playdate.buttonJustPressed(playdate.kButtonA) then
      state = STATE_TITLE
      shift_state = nil
      score_result = nil
    end
  end
end
