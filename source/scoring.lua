-- Scoring module: calculates end-of-shift score from landed aircraft.
-- Pure Lua, no SDK dependency — fully unit-testable.

-- luacheck: globals Scoring
Scoring = {}

-- Calculates the score for a completed shift from a list of landed aircraft.
--
-- Scoring formula:
--   base       = 50  (awarded for completing the shift)
--   efficiency = floor(50 * avg_fuel_pct)  (0..50, based on average fuel remaining)
--   penalty    = 10 * near_miss_count      (deducted for each near-miss landing)
--   total      = max(0, base + efficiency - penalty)
--
-- A "near miss" is any aircraft that landed with fuel < CRITICAL_FUEL_PCT of its starting fuel.
-- Returns a result table:
--   landed_count   (number)  total aircraft that landed
--   avg_fuel_pct   (number)  average fuel fraction remaining (0.0–1.0)
--   near_miss_count (number) aircraft that landed critically low on fuel
--   total          (number)  final score (0–100)
function Scoring.calculate(landed)
  local n = #landed
  if n == 0 then
    return { landed_count = 0, avg_fuel_pct = 0, near_miss_count = 0, total = 0 }
  end

  local fuel_pct_sum = 0
  local near_miss_count = 0
  for _, aircraft in ipairs(landed) do
    local pct = aircraft.fuel / aircraft.fuel_max
    fuel_pct_sum = fuel_pct_sum + pct
    if pct < Constants.CRITICAL_FUEL_PCT then
      near_miss_count = near_miss_count + 1
    end
  end

  local avg_fuel_pct = fuel_pct_sum / n
  local base = 50
  local efficiency = math.floor(50 * avg_fuel_pct)
  local penalty = 10 * near_miss_count
  local total = math.max(0, base + efficiency - penalty)

  return {
    landed_count = n,
    avg_fuel_pct = avg_fuel_pct,
    near_miss_count = near_miss_count,
    total = total,
  }
end
