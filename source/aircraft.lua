-- luacheck: globals Aircraft
Aircraft = {}

-- fuel: seconds remaining (e.g. 90 = 1:30).
-- altitude: AGL feet. Decreases at Constants.APPROACH_RATE ft/sec in the landing queue; static in holding.
-- notes: optional flavor text shown at the bottom of the shift screen when this aircraft is focused.
-- time_limit: optional seconds deadline for emergency aircraft (medevac/SAR). nil = normal aircraft.
function Aircraft.new(callsign, fuel, altitude, situation, notes, time_limit)
  return {
    callsign = callsign,
    fuel = fuel,
    fuel_max = fuel, -- original fuel, used for display (e.g. fuel bar)
    altitude = altitude,
    situation = situation,
    notes = notes,
    time_remaining = time_limit, -- nil for normal aircraft; counts down to 0 for emergencies
  }
end

function Aircraft.tick(aircraft, dt)
  aircraft.fuel = math.max(0, aircraft.fuel - dt)
  if aircraft.time_remaining ~= nil then
    aircraft.time_remaining = math.max(0, aircraft.time_remaining - dt)
  end
end

function Aircraft.is_out_of_fuel(aircraft)
  return aircraft.fuel <= 0
end

function Aircraft.is_time_expired(aircraft)
  return aircraft.time_remaining ~= nil and aircraft.time_remaining <= 0
end
