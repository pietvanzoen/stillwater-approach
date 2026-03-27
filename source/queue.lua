-- luacheck: globals Queue
Queue = {}

-- schedule and next_arrival are initialised to safe defaults so check_arrivals
-- can be called on a fresh queue without error.
function Queue.new(max_landing)
  return { landing = {}, holding = {}, landed = {}, max_landing = max_landing or 3, schedule = {}, next_arrival = 1 }
end

function Queue.promote(state, index)
  if index < 1 or index > #state.holding then
    return false
  end
  if #state.landing >= state.max_landing then
    return false
  end
  local aircraft = table.remove(state.holding, index)
  state.landing[#state.landing + 1] = aircraft
  return true
end

-- state.schedule: sorted array of { time = <seconds>, aircraft = <Aircraft> }
-- state.next_arrival: index of the next unprocessed schedule entry (starts at 1)
function Queue.check_arrivals(state, elapsed)
  while state.next_arrival <= #state.schedule do
    local entry = state.schedule[state.next_arrival]
    if entry.time <= elapsed then
      state.holding[#state.holding + 1] = entry.aircraft
      state.next_arrival = state.next_arrival + 1
    else
      break -- schedule is sorted, no need to look further
    end
  end
end

function Queue.land_front(state)
  if #state.landing == 0 then
    return nil
  end
  local aircraft = table.remove(state.landing, 1)
  state.landed[#state.landed + 1] = aircraft
  return aircraft
end

-- Manages the touchdown dwell for the front landing aircraft.
-- When the front aircraft reaches altitude 0, starts a TOUCHDOWN_DWELL-second timer.
-- Counts the timer down each tick; when it expires, calls land_front to clear the runway.
-- Returns true if land_front was called this tick (so the caller can adjust the cursor),
-- false in all other cases (no aircraft, still descending, dwell not yet expired).
function Queue.resolve_touchdown(state, dt)
  if #state.landing == 0 or state.landing[1].altitude > 0 then
    return false
  end
  local front = state.landing[1]
  if front.touchdown_timer == nil then
    -- Aircraft just touched down: start the dwell timer.
    front.touchdown_timer = Constants.TOUCHDOWN_DWELL
    return false
  end
  front.touchdown_timer = front.touchdown_timer - dt
  if front.touchdown_timer <= 0 then
    Queue.land_front(state)
    return true
  end
  return false
end

-- Aircraft in the touchdown dwell (touchdown_timer ~= nil) are excluded: they are safely
-- on the ground and must not trigger a failure even if their fuel reads 0.
-- Note: the dwell guard uses `== nil` (not `not touchdown_timer`). In Lua, 0 is truthy,
-- so both forms behave identically for number timers. The explicit nil check is clearer.
function Queue.find_out_of_fuel(state)
  for _, aircraft in ipairs(state.landing) do
    if aircraft.touchdown_timer == nil and Aircraft.is_out_of_fuel(aircraft) then
      return aircraft.callsign
    end
  end
  for _, aircraft in ipairs(state.holding) do
    if Aircraft.is_out_of_fuel(aircraft) then
      return aircraft.callsign
    end
  end
  return nil
end

-- Returns true when the shift is complete: the schedule is non-empty, all scheduled
-- aircraft have arrived, and both landing and holding queues are empty.
-- Requires a non-empty schedule so a fresh unscheduled queue never reads as complete.
function Queue.is_complete(state)
  return #state.schedule > 0 and state.next_arrival > #state.schedule and #state.landing == 0 and #state.holding == 0
end

-- Landing aircraft only descend if there is at least MIN_LANDING_SEP feet of separation
-- from the aircraft ahead, preventing visual confusion when multiple aircraft are close together.
function Queue.tick_all(state, dt)
  for i, aircraft in ipairs(state.landing) do
    Aircraft.tick(aircraft, dt)
    local prev = state.landing[i - 1]
    if prev == nil or aircraft.altitude - prev.altitude >= Constants.MIN_LANDING_SEP then
      aircraft.altitude = math.max(0, aircraft.altitude - Constants.APPROACH_RATE * dt)
    end
  end
  for _, aircraft in ipairs(state.holding) do
    Aircraft.tick(aircraft, dt)
  end
end
