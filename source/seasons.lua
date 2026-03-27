-- Each season function returns a sorted array of arrival entries:
--   { time = <seconds>, aircraft = Aircraft.new(...) }
-- The schedule is consumed by Queue.check_arrivals via shift_state.schedule.

-- luacheck: globals Seasons
Seasons = {}

-- Returns the Spring shift schedule: "The Thaw"
-- April. Sill River running high. Mud season.
--
-- Conditions: low cloud ceiling (~1800 ft), intermittent rain, fog up the valley.
-- Traffic: light — Stillwater Air commuters, a few small props, first charters of season.
-- Emergencies: SAR for missing hikers (snowmelt trail), one medevac.
-- Weird escalation: PTA7 reports the Packard logging road is flooded and mentions
--   seeing something in the water from altitude. Doesn't elaborate.
--
-- Fuel margins (if promoted to landing immediately on arrival):
--   STW4  120 s fuel, 2500 ft alt (50 s approach) = 70 s margin
--   QUL3   90 s fuel, 3000 ft alt (60 s approach) = 30 s margin
--   SVC12 130 s fuel, 3500 ft alt (70 s approach) = 60 s margin
--   GCS1   85 s fuel, 2500 ft alt (50 s approach) = 35 s margin
--   CAM1   90 s fuel, 3000 ft alt (60 s approach) = 30 s margin
--   PTA7  110 s fuel, 4000 ft alt (80 s approach) = 30 s margin
function Seasons.spring()
  return {
    {
      time = 0,
      aircraft = Aircraft.new("STW4", 120, 2500, "Normal", "Overcast at 1800. Fog up the valley."),
    },
    {
      time = 25,
      aircraft = Aircraft.new("QUL3", 90, 3000, "Weather Divert", "Diverted from Ellensburg. Weather over the pass."),
    },
    {
      time = 55,
      aircraft = Aircraft.new("SVC12", 130, 3500, "Normal", nil),
    },
    {
      time = 85,
      aircraft = Aircraft.new("GCS1", 85, 2500, "Medical", "SAR crew. Missing hikers. Snowmelt trail."),
    },
    {
      time = 115,
      aircraft = Aircraft.new("CAM1", 90, 3000, "Medical", "Patient on board. Requesting priority."),
    },
    {
      time = 150,
      aircraft = Aircraft.new(
        "PTA7",
        110,
        4000,
        "Normal",
        "Packard road flooded. Saw something in the water. Didn't say more."
      ),
    },
  }
end
