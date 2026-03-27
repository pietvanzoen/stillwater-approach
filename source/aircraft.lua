-- luacheck: globals Aircraft
Aircraft = {}

-- fuel: seconds remaining (e.g. 90 = 1:30).
-- altitude: AGL feet. Decreases at Constants.APPROACH_RATE ft/sec in the landing queue; static in holding.
-- notes: optional flavor text shown at the bottom of the shift screen when this aircraft is focused.
function Aircraft.new(callsign, fuel, altitude, situation, notes)
  return {
    callsign = callsign,
    fuel = fuel,
    fuel_max = fuel, -- original fuel, used for display (e.g. fuel bar)
    altitude = altitude,
    situation = situation,
    notes = notes,
  }
end

function Aircraft.tick(aircraft, dt)
  aircraft.fuel = math.max(0, aircraft.fuel - dt)
end

function Aircraft.is_out_of_fuel(aircraft)
  return aircraft.fuel <= 0
end
