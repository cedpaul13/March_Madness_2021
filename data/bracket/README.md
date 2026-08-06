# 2021 bracket results

`2021_bracket_results.csv` — every game actually played in the 2021 NCAA Division I men's tournament, First Four through the Championship, used to score the model's picks against reality.

**Source**: the Kaggle *March Machine Learning Mania* competition files (`MNCAATourneyCompactResults.csv`, `MNCAATourneySeeds.csv`, `MTeams.csv`, `MSeasons.csv`) — the same ground-truth dataset the 2026 model was validated against. Derived programmatically rather than transcribed by hand, so scores and seeds carry no copy errors.

**66 games, not 67.** Oregon's first-round game against VCU was declared a no-contest — VCU withdrew under COVID-19 protocols — so Oregon advanced without playing. There is no result row for a game that never happened.

**Columns**

| Column | Meaning |
| --- | --- |
| `round` | First Four, Round of 64, Round of 32, Sweet 16, Elite Eight, Final Four, Championship |
| `day_num` | Kaggle `DayNum` (days since that season's `DayZero`), kept for ordering |
| `region` | East, West, Midwest, South — empty for Final Four and Championship, where teams come from different regions |
| `winner` / `loser` | team names, normalized to match the naming in [`../raw/`](../raw/) so they join directly |
| `seed_w` / `seed_l` | tournament seed, 1–16 |
| `score_w` / `score_l` | final score |
| `overtime` | number of overtime periods (0 for regulation) |

Region letters were resolved via `MSeasons.csv`, which for 2021 maps W→East, X→West, Y→Midwest, Z→South. Twenty Kaggle team spellings (`TX Southern`, `Mt St Mary's`, `USC`, …) were mapped to the stat exports' spellings (`Texas Southern`, `Mount St. Mary's`, `Southern California`, …); the build asserts that all 66 games' teams resolve before writing.
