# My First Data Science Project: An NCAA Bracket Model in Four Days

*Just three months into my first-ever statistics course on data analysis, I took on my first data science project. In four days, I coded every project function from scratch, built a pipeline to ingest 17 NCAA stat tables from CSVs I had downloaded manually, and ran PCA on 33 variables for 68 teams. It was a substantial end-to-end build for a first project. Five years later, I rebuilt the pipeline, scored the picks, and found useful lessons in the data.*

---

## The Final Ledger

| | 2021 Men's Tournament |
| :--- | :--- |
| **Champion** | Baylor (1) def. Gonzaga (1), **86-70** |
| **Date · Venue** | April 5 · Lucas Oil Stadium, Indianapolis |
| **The stakes** | Gonzaga showed up 31-0, chasing the first perfect season since Indiana in 1976 |
| **My board** | Gonzaga 1st of 68 · Baylor 3rd of 68 |
| **My final pick** | Gonzaga over Baylor |

The 2021 tournament took place in an Indiana bubble after a season in which teams faced very different schedules and levels of competition. It produced a record fourteen upsets, making schedule context especially relevant to a model built on raw per-game averages.

The model used raw per-game averages. Even so, it ranked the two finalists first and third in the field. Its final pick favored Gonzaga over Baylor.

---

## The Method, Written Down at Last

The 2021 script ran a PCA over 33 team stats: shooting, rebounds, assists, turnovers, fouls, opponent equivalents, win-loss record. Then it plotted the field on the first two components.

PCA provides coordinates, not labels, so I named the axes by looking at teams I knew well. PC1 appeared to track offense, with Gonzaga at one end; PC2 seemed to track defense, with Houston at the other. That initial reading was plausible: Gonzaga led the field in points per game and effective field goal percentage, while Houston led in opponent field goal percentage. Rechecking the correlations years later confirmed PC1's offensive signal and showed that PC2 tracked pace more than defensive efficiency.

My working rule was to favor whichever team sat closer to the "good" corner of the chart.

Written out, it's one line:

```
ODI = PC1 + PC2        (both axes flipped so bigger = better)
```

I gave the two axes equal weight, which made the rule simple to apply. I had not calibrated the score or backtested it before the tournament; this reconstruction makes the rule explicit.

**A note on the results:** these numbers belong to a reconstruction of my PCA rule, not the bracket I submitted on CBS. My actual bracket also reflected recent form, injuries, and what I had read about each team. I was testing the PCA as one input. The table below evaluates the reconstructed rule on its own across the 66 games played.

Run against all 66 games actually played:

| Round | Correct |
| :--- | :--- |
| First Four | 3 / 4 |
| Round of 64 | 15 / 31 |
| Round of 32 | 12 / 16 |
| Sweet 16 | 4 / 8 |
| Elite Eight | 3 / 4 |
| Final Four | 2 / 2 |
| Championship | 0 / 1 |
| **Overall** | **39 / 66 (59.1%)** |

*(66, not 67. Oregon's opener against VCU was called off when VCU withdrew under COVID protocols.)*

---

## Predictions vs. Reality

*Legend: ✓ hit · ~ near-miss · ✗ miss*

| Category | Model | Actual | Verdict |
| :--- | :--- | :--- | :---: |
| Champion | Gonzaga, 1st on the board | Baylor | ✗ |
| Both finalists spotted early | Gonzaga 1st, Baylor 3rd of 68 | Gonzaga vs. Baylor | ✓ |
| Final Four games | 2 of 2 | both correct | ✓ |
| Oral Roberts (15) over Ohio State (2) | Called | Oral Roberts 75-72 OT | ✓ |
| Abilene Christian (14) over Texas (3) | Called | Abilene Christian 53-52 | ✓ |
| Loyola Chicago (8) over Illinois (1) | Called | Loyola Chicago 71-58 | ✓ |
| UCLA's run from the First Four | Picked the play-in, not the later rounds | Final Four | ~ |
| Beating the seeds | 36 / 61 | Chalk: 42 / 61 | ✗ |

The model ranked both finalists first and third, picked both Final Four games, and identified nine upsets. Its performance varied by round: the later-round results were strong, while the seed-based baseline did better across comparable games.

---

## How It Compared with the Seeds

Always choosing the higher seed got **42 of 61** games; this rule picked **36 of 61** among those same games. It went against the seeds 24 times and correctly picked nine upsets.

The six-game gap is a useful benchmark for what the model captured—and where schedule strength and context could improve it.

---

## The Storylines

### Gonzaga: a strong ranking, an uncertain final

Gonzaga topped the ranking at 9.59, ahead of Baylor at 8.07. Its effective field goal percentage was 61.0%, highest in the field by 2.5 percentage points.

Gonzaga entered the final 31-0.

The model gave Gonzaga a 1.52-point ODI edge over Baylor, compared with a 10.42-point edge over UCLA. That smaller margin suggested a closer final, but the model had no probability calibration to express how close.

Baylor won by sixteen. The result reinforced a useful lesson: ranking a contender and estimating uncertainty in a single game are different tasks.

The challenge was not identifying Gonzaga as a contender; it was communicating how uncertain the final remained.

### Oral Roberts: an upset the model surfaced

No. 15 Oral Roberts beat No. 2 Ohio State in overtime, then beat Florida before losing to Arkansas by two points in the Sweet 16.

The model picked both upsets because it treated scoring averages from the Summit League as comparable to those from stronger conferences.

That same assumption shaped other mid-major rankings. My top fifteen included Liberty (13-seed) at second overall, Colgate (14) at fifth, Drake (11) at sixth, UC Santa Barbara (12) at eighth, Abilene Christian (14) at eleventh, Ohio (13) at fourteenth, and Winthrop (12) at fifteenth. Seven of the top fifteen were seeded eleventh or worse.

Illinois, a 1-seed, ranked seventeenth.

The model did not adjust for strength of schedule, which lifted Liberty and other mid-majors in the ranking. In a tournament with fourteen upsets, the same assumption also helped surface nine correct upset picks, including two of the biggest first-round surprises. It was a clear tradeoff: useful for finding surprises, less reliable without opponent context.

### The Michigan-LSU footnote

Six lines at the bottom of the original script retrieve shooting statistics for Michigan and LSU.

Their matchup in the Round of 32 explains why: on March 22, I compared the two teams by hand before the game. The rebuild turns that repeatable step into a function.

The rule gave Michigan a 6.99-point advantage; Michigan won 86-78.

---

## How the Model Performed

| Component | Grade | Notes |
| :--- | :---: | :--- |
| Rating elite offenses | A | Gonzaga first, Baylor third, out of 68. |
| Late rounds | A− | Final Four 2/2, Elite Eight 3/4. |
| Identifying potential upsets | B+ | Nine correct, including a 15-over-2 and an 8-over-1. |
| Expressing uncertainty | C | Clear margins were more reliable than the intermediate range. |
| Opening round | D | 15 of 31 games. |
| Opponent-strength adjustment | F | Strength of schedule was not included. |
| Reproducibility | F | The original script did not save intermediate results. |

The score margins showed where the rule was most useful: with an ODI edge above 4, it picked 22 of 29 winners (75.9%); below 1 point, it picked 5 of 10. The 1-to-2 range was less consistent at 3 of 10, a reminder that small margins needed probability calibration.

---

## What the Rebuild Uncovered

**A chart-display issue** put the significance stars in the wrong cells of the original defensive correlation plot: one matrix had five columns and the other had four. R issued a warning about the mismatch. Rebuilding the chart made the cause clear and reinforced the value of checking diagnostics.

**A data-alignment issue** affected effective field goal percentage. The calculation combined two separately filtered data frames after `merge()` had sorted one alphabetically, so their row orders no longer matched. That paired three-point totals with the wrong teams for **64 of 68 teams**. The average difference was 1.5 percentage points, with a maximum of 7.8.

Gonzaga's corrected EFG is 61.0%; the original script reported 65.0%.

The original script did not save intermediate results, so I could not review the row alignment after the session. Rebuilding the calculation made the mismatch visible and confirmed the corrected value. It also showed how much easier this work is to validate when intermediate tables are saved.

---

## What the Rebuild Revealed

I first thought KenPom ratings and strength of schedule were the main next steps. Rebuilding the analysis revealed a more basic point: understanding what the axes measured mattered just as much.

**PC1 (20.9% of variance) captured offense.** It correlated with points per game at +0.94, effective field goal percentage at +0.67, and win percentage at +0.77, supporting the initial interpretation.

**PC2 (19.3%) primarily tracked tempo.** It correlated with opponent points per game at +0.70, but barely with *opponent field goal percentage* at **−0.01**. That points to pace rather than defensive efficiency.

Higher PC2 scores aligned with more possessions, rebounds, free throws, and shots, as well as lower efficiency; lower scores reflected a slower pace. Virginia and Loyola Chicago had the lowest PC2 scores, consistent with their deliberate styles that season.

Houston helps explain why PC2 initially looked defensive: it was both the best at limiting opponent shooting and one of the slowest teams. Because those traits pointed in the same direction, Houston alone could not distinguish a defense signal from a pace signal. Comparing teams with different combinations of pace and defensive strength clarifies the difference.

The axis captured a real difference between teams; that difference was pace rather than defensive quality. Slower teams tend to allow fewer points, regardless of how well they defend.

**PC3** provided a clearer defensive signal, correlating with opponent field goal percentage at +0.62. I had computed it but did not include it in the original chart.

Adjusted efficiency ratings such as KenPom account for pace and opponent quality, addressing both the tempo effect and the strength-of-schedule differences that influenced this ranking. The rebuild clarified why those adjustments matter.

The rebuild also showed that shooting statistics were more strongly associated with wins and losses than the opponent metrics I had focused on. Field goals made per game correlated with wins at +0.47 and losses at −0.56; opponent field goal percentage correlated with win percentage at −0.26. This helps explain why the model captured offense more clearly than defense.

---

## Lessons That Became 2026

1. **Adjust for pace and opponent strength.** The 2026 model uses KenPom and Barttorvik efficiency data rather than raw per-game averages.

2. **Measure predictions.** The 2026 project includes a backtester, a game-by-game ledger, and a post-mortem published the week the tournament ended.

3. **Save intermediate results.** Keeping tables and scores makes it easier to verify calculations and revisit them later.

4. **Represent uncertainty.** ODI margins of 1.52 and 10.42 pointed to different levels of confidence, but the original rule did not express that difference. The 2026 model outputs probabilities, making it possible to discuss a champion's chances, such as 18.7%.

5. **Check what a variable measures before naming it.** Reviewing the correlations clarified that PC2 tracked pace more than opponent shooting. Confirming what a feature represents is one of the most portable lessons from the project.

6. **Account for tradeoffs.** The model's schedule-strength limitation affected mid-major rankings and also surfaced several successful upset picks. The 2026 model handles upset potential separately.

---

## Technical Notes

| | |
| :--- | :--- |
| **Data** | 17 season-stat exports covering the 68-team field, pulled March 17-18, 2021 |
| **Ground truth** | Kaggle *March Machine Learning Mania* tournament results, seeds, team IDs |
| **Method** | `prcomp` on 33 standardized variables, combined offense + defense model |
| **Rule** | ODI = PC1 + PC2, signs anchored to points scored and points allowed |
| **Variance** | PC1 20.9% · PC2 19.3% · PC3 14.5% |
| **Result** | 39 / 66 (59.1%); chalk 42 / 61 vs. model 36 / 61 |
| **Pipeline** | `R/00_setup.R` → `01_load_stats.R` → `02_pca_analysis.R` → `03_bracket_picks.R` |
| **Original** | [`archives/NCAA_2021_original.R`](./archives/NCAA_2021_original.R), untouched |

As in the original 2021 analysis, win-loss record (`W`, `L`, `Pct_W_L`) remains among the PCA inputs. This means the ranking partly reflects regular-season results; `Pct_W_L` loads on PC1 at +0.77. I kept these variables to preserve the original method, while later versions remove them to avoid that leakage.

---

*Back to the [README](./README.md) · the version with charts is on [the site](https://cedpaul13.github.io/March_Madness_2021/) · and it all leads to [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/).*
