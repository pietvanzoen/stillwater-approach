require("source.constants")
require("source.aircraft")
require("source.seasons")

describe("Seasons", function()
  describe("Seasons.spring", function()
    it("returns a non-empty schedule", function()
      local schedule = Seasons.spring()
      assert.is_true(#schedule > 0)
    end)

    it("each entry has a numeric time field", function()
      local schedule = Seasons.spring()
      for _, entry in ipairs(schedule) do
        assert.equals("number", type(entry.time))
      end
    end)

    it("each entry has an aircraft table", function()
      local schedule = Seasons.spring()
      for _, entry in ipairs(schedule) do
        assert.equals("table", type(entry.aircraft))
      end
    end)

    it("all aircraft have required fields", function()
      local schedule = Seasons.spring()
      for _, entry in ipairs(schedule) do
        local ac = entry.aircraft
        assert.equals("string", type(ac.callsign))
        assert.equals("number", type(ac.fuel))
        assert.equals("number", type(ac.altitude))
        assert.equals("string", type(ac.situation))
      end
    end)

    it("schedule is sorted ascending by time", function()
      local schedule = Seasons.spring()
      for i = 2, #schedule do
        assert.is_true(schedule[i].time >= schedule[i - 1].time)
      end
    end)

    it("fuel_max equals fuel on each aircraft", function()
      local schedule = Seasons.spring()
      for _, entry in ipairs(schedule) do
        assert.equals(entry.aircraft.fuel, entry.aircraft.fuel_max)
      end
    end)

    it("all altitudes are positive AGL values", function()
      local schedule = Seasons.spring()
      for _, entry in ipairs(schedule) do
        assert.is_true(entry.aircraft.altitude > 0)
      end
    end)

    it("weird escalation aircraft (PTA7) has notes about the Packard road", function()
      local schedule = Seasons.spring()
      local pta7
      for _, entry in ipairs(schedule) do
        if entry.aircraft.callsign == "PTA7" then
          pta7 = entry.aircraft
        end
      end
      assert.not_nil(pta7)
      assert.not_nil(pta7.notes)
      assert.is_true(pta7.notes:find("Packard") ~= nil)
    end)
  end)
end)
