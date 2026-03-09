require("source.aircraft")

describe("Aircraft", function()
  describe("Aircraft.new", function()
    -- Test 1: Aircraft.new sets all fields correctly
    it("sets callsign, fuel, fuel_max, and situation", function()
      local a = Aircraft.new("GA4", 90, "Normal")
      assert.equal("GA4", a.callsign)
      assert.equal(90, a.fuel)
      assert.equal(90, a.fuel_max)
      assert.equal("Normal", a.situation)
    end)
  end)

  describe("Aircraft.tick", function()
    -- Test 2: tick decreases fuel by dt
    it("decreases fuel by dt", function()
      local a = Aircraft.new("GA4", 90, "Normal")
      Aircraft.tick(a, 1)
      assert.equal(89, a.fuel)
    end)

    -- Test 3: tick clamps fuel at 0
    it("clamps fuel at 0", function()
      local a = Aircraft.new("GA4", 0.5, "Normal")
      Aircraft.tick(a, 1)
      assert.equal(0, a.fuel)
    end)

    -- Test 6: regression guard — tick does not mutate fuel_max
    it("does not mutate fuel_max", function()
      local a = Aircraft.new("GA4", 90, "Normal")
      Aircraft.tick(a, 10)
      assert.equal(90, a.fuel_max)
    end)
  end)

  describe("Aircraft.is_out_of_fuel", function()
    -- Test 4: returns false when fuel > 0
    it("returns false when fuel > 0", function()
      local a = Aircraft.new("GA4", 90, "Normal")
      assert.is_false(Aircraft.is_out_of_fuel(a))
    end)

    -- Test 5: returns true when fuel == 0
    it("returns true when fuel == 0", function()
      local a = Aircraft.new("GA4", 0, "Normal")
      assert.is_true(Aircraft.is_out_of_fuel(a))
    end)
  end)
end)
