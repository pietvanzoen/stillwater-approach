# ATC Reference Notes — Stillwater Approach

This document preserves the real-world ATC research conducted when designing the landing resolution mechanic (Milestone 5). It serves as reference context for future game design decisions involving altitude, approach procedures, and holding patterns.

---

## Research context

The question: what are realistic holding altitudes and approach procedures for a small single-runway airport in a Cascades river valley (Washington State), with surrounding ridges at ~3,000–4,000 ft and a valley floor at ~200–300 ft MSL?

---

## Mountainous terrain clearance (FAA)

The FAA requires greater obstacle clearance in mountainous terrain than in flat areas:

- **Non-mountainous terrain**: 1,000 ft above the highest obstacle within 4 miles
- **Mountainous terrain**: 2,000 ft above the highest obstacle within 4 miles

Source: FAA ATC handbook chap. 4 § 4-5 (Altitude Assignment and Verification); AIM § 7-6-7 (Mountain Flying)

For KSTW (fictional Cascades valley with ridges at ~3,000 ft AGL):
- Minimum safe holding altitude ≈ 3,000 + 2,000 = **5,000 ft MSL** in theory — but controllers use Minimum Vectoring Altitude (MVA) charts which account for terrain precisely
- Practical minimum holding altitude for the valley: approximately **2,500 ft MSL** (ridges at ~500–800 ft MSL on the lower slopes; MVA accounting for the 3,000 ft ridgeline = ~3,000 + 2,000 = 5,000 ft MSL strictly, but the fictional airport is set in the *foothills* with lower immediate surrounding terrain)
- For game purposes, the valley floor is ~200–300 ft MSL, pattern altitude is ~1,250 ft MSL, and holding begins at ~2,500 ft MSL AGL (above the runway) with 1,000 ft separation

---

## Holding stack separation

Holding patterns are assigned in **1,000 ft vertical increments**. This separation is mandatory IFR minimum between aircraft.

When 1–3 aircraft are stacked over KSTW waiting to land, a realistic stack (first to land at bottom):

| Position | Altitude (MSL) | Altitude (AGL above runway) |
|---|---|---|
| First to land | 2,500 ft MSL | ~2,250 ft AGL |
| Second | 3,500 ft MSL | ~3,250 ft AGL |
| Third | 4,500 ft MSL | ~4,250 ft AGL |

Source: FAA ATC handbook chap. 4 § 4-6 (Holding Aircraft); SKYbrary Holding Pattern article

Each aircraft circling a holding fix maintains its assigned altitude. As the first descends to approach, the second drops to 2,500 ft and the third drops to 3,500 ft to fill the gap.

---

## Traffic pattern altitude

Standard traffic pattern altitude (TPA) for small aircraft is **1,000 ft AGL** above the runway elevation.

- KSTW runway elevation: ~250 ft MSL (fictional river valley)
- TPA: ~1,250 ft MSL (~1,000 ft AGL)
- Base leg: 500–700 ft AGL (~750–950 ft MSL)
- Final approach: continuous descent from ~1,000 ft AGL to touchdown

Source: AOPA "Technique: The traffic pattern" (Sep 2019)

Turboprops like the De Havilland Dash 8 follow the same separation rules but fly faster approaches and have higher descent rates. They still observe 1,000 ft vertical separation in holding.

---

## Approach sequence (simplified)

For a light aircraft (Cessna 172, King Air) at KSTW:

1. **Holding**: circling at assigned altitude (2,500–4,500 ft AGL) waiting for clearance
2. **Cleared for approach**: begins descent from holding altitude
3. **Initial approach**: 3,000–2,000 ft AGL, inbound to airport
4. **Pattern entry**: joins traffic pattern at ~1,000 ft AGL
5. **Base leg**: turns to ~500 ft AGL
6. **Final approach**: aligned with runway, continuous descent
7. **Touchdown**: runway elevation (0 ft AGL)

Source: FAA ENR 1.5 (Approach Procedures); FAA ATC handbook chap. 4 § 4-8 (Approach Clearance Procedures)

---

## Game design application

### AGL vs MSL

The game displays altitude in **AGL (Above Ground Level)** rather than MSL:

- **Reason**: Players unfamiliar with ATC would find MSL confusing. "ALT: 2500" meaning "2,500 ft above the runway" is immediately intuitive — a high number means far from landing, zero means touchdown.
- **Abstraction**: The 250 ft MSL airport elevation is not tracked in game. All displayed altitudes are AGL. Aircraft hold at AGL values equivalent to the stack above (2,500 / 3,500 / 4,500 ft AGL).

### Approach rate

`APPROACH_RATE = 50` ft/sec was chosen as a game-paced descent rate (real approaches are ~8 ft/sec):

| Holding altitude (AGL) | Approach duration at 50 ft/sec |
|---|---|
| 2,500 ft | 50 seconds |
| 3,000 ft | 60 seconds |
| 3,500 ft | 70 seconds |
| 4,000 ft | 80 seconds |
| 4,500 ft | 90 seconds |

These durations align with aircraft fuel timers (60–140 seconds), creating meaningful tension without being too punishing.

### Test schedule altitudes (Milestone 5)

Milestone 5 replaces the original (unrealistic) test schedule altitudes with values grounded in the research above:

| Callsign | Old alt | New alt (AGL) | Approach time | Rationale |
|---|---|---|---|---|
| STW4 | 3,000 | 2,500 ft | 50 s | Local commuter, low hold slot |
| SVC12 | 8,000 | 3,500 ft | 70 s | Cargo prop, mid hold |
| TNK81 | 5,000 | 2,500 ft | 50 s | Tanker, low fuel — low hold |
| QUL3 | 6,000 | 4,500 ft | 90 s | Charter, high hold slot |
| CAM1 | 4,000 | 3,000 ft | 60 s | Medical — one slot above minimum |
| PTA7 | 7,000 | 4,000 ft | 80 s | Normal traffic, upper hold |

---

## Sources

- [FAA ATC handbook chap. 4 § 4-5: Altitude Assignment and Verification](https://www.faa.gov/air_traffic/publications/atpubs/atc_html/chap4_section_5.html)
- [FAA ATC handbook chap. 4 § 4-6: Holding Aircraft](https://www.faa.gov/air_traffic/publications/atpubs/atc_html/chap4_section_6.html)
- [FAA ATC handbook chap. 4 § 4-8: Approach Clearance Procedures](https://www.faa.gov/air_traffic/publications/atpubs/atc_html/chap4_section_8.html)
- [AIM § 7-6-7: Mountain Flying](https://www.faraim.org/faa/aim/chapter-7/section-7-6-7.html)
- [FAA ENR 1.5: Holding, Approach, and Departure Procedures](https://www.faa.gov/air_traffic/publications/atpubs/aip_html/part2_enr_section_1.5.html)
- [SKYbrary: Holding Pattern](https://skybrary.aero/articles/holding-pattern)
- [SKYbrary: Flight in Mountainous Terrain](https://skybrary.aero/articles/flight-mountainous-terrain)
- [AOPA: Technique — The traffic pattern (Sep 2019)](https://www.aopa.org/news-and-media/all-news/2019/september/flight-training-magazine/technique-traffic-pattern)
- [FAA: Tips on Mountain Flying (P-8740-60)](https://www.faa.gov/sites/faa.gov/files/regulations_policies/handbooks_manuals/aviation/tips_on_mountain_flying.pdf)
