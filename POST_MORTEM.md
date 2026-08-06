# The 2021 Post-Mortem: I Read a Chart With My Eyes and Called It a Model

*This was my first predictive model. I built it in four days during my first year of a statistics degree, having just started programming in R, at a point where PCA was brand new to me and felt like a superpower. 363 lines, seventeen spreadsheets, and a scatterplot I read by eye. Five years later I went back, wrote the rule down as actual code, and scored it against every game. Here's what I found, including two bugs and one axis that was never measuring what I thought it was.*

---

## The Final Ledger

| | 2021 Men's Tournament |
| :--- | :--- |
| **Champion** | Baylor (1) def. Gonzaga (1), **86-70** |
| **Date · Venue** | April 5 · Lucas Oil Stadium, Indianapolis |
| **The stakes** | Gonzaga showed up 31-0, chasing the first perfect season since Indiana in 1976 |
| **My board** | Gonzaga 1st of 68 · Baylor 3rd of 68 |
| **My final** | Gonzaga over Baylor. Nope. |

The whole tournament was played in one state, in a bubble, after a season where teams played wildly different schedules against wildly different competition. It produced a record fourteen upsets. If you were going to pick one year in history to trust raw per-game averages, it would not be this one.

My model was nothing but raw per-game averages. It still had the two teams that reached the final ranked first and third in the country, and then took the wrong one.

---

## The Method, Written Down at Last

The 2021 script ran a PCA over 33 team stats: shooting, rebounds, assists, turnovers, fouls, opponent equivalents, win-loss record. Then it plotted the field on the first two components.

PCA gives you coordinates and no labels, so naming the axes was on me. I did it by finding teams I already understood. Gonzaga sat far out on the first axis, and Gonzaga was the most offense-oriented team in the country. Houston anchored the second, and Houston was a Kelvin Sampson team, which meant defense above everything. Axis one is offense, axis two is defense. Rebuilding it years later, that read holds up remarkably well: Gonzaga finished first of 68 in both points per game and effective field goal percentage, and Houston finished first of 68 in opponent field goal percentage. I anchored on the actual best offense and the actual best defense in the field.

My rule, which existed entirely in my head, was that whoever sat further toward the good corner won.

Written out, it's one line:

```
ODI = PC1 + PC2        (both axes flipped so bigger = better)
```

Equal weight on both, because that's what your eye does with a chart. Nothing tuned, nothing calibrated, no backtest.

**An important caveat before the numbers.** This rule is a reconstruction, and every score below belongs to the reconstruction rather than to the bracket I actually submitted. That one went up on CBS and it was a blend: the chart, plus a week of reading about these teams, plus who was hot coming into the tournament, plus who was hurt. The analytics were the new thing I wanted to test, not the entire method. What follows is what the rule does on its own, cleanly, against all 66 games.

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
| UCLA's run from the First Four | Got the play-in, missed the rest | Final Four | ~ |
| Beating the seeds | 36 / 61 | Chalk: 42 / 61 | ✗ |

The top of the bracket was excellent. The middle was a disaster. I found the two best teams in the country and half the Final Four, then gave it all back in the rounds where most of a bracket is actually decided.

---

## The Number That Hurts

Just picking the better seed every time goes **42 of 61**. My model went **36 of 61** on those same games. It argued with the committee 24 times and won 9 of those arguments.

A room full of people with a whiteboard beat my computer by six games.

That's the honest headline for the rule taken on its own. It's also the number that never existed until I wrote this document, because in 2021 the analysis was one input among several and nobody was keeping score of it separately.

---

## The Storylines

### Gonzaga: right about the team, wrong about the trophy

Gonzaga topped my board by a distance, 9.59 to Baylor's 8.07, with the rest of the field well back. That wasn't noise. Their 2021 offense was one of the best in modern college basketball: 61.0% effective field goal percentage, first in the field by two and a half points.

They walked into the final 31-0.

My model made them a favourite by 1.52 points of ODI. For scale, it had Gonzaga over UCLA in the semifinal by 10.42. It was quietly telling me this was the tightest game of the tournament, and I had no way to hear it, because 1.52 and 10.42 came out of the pipeline looking exactly alike.

Baylor won by sixteen. It stopped being a game around the eight-minute mark of the first half.

The mistake wasn't liking Gonzaga; everybody liked Gonzaga. The mistake was building something that couldn't say *this one's close*.

### Oral Roberts: the bug that paid

A 15-seed beats a 2-seed about once every four years. Oral Roberts did it in overtime, then beat Florida, then lost to Arkansas by two in the Sweet 16 and nearly made the Elite Eight.

I called both wins. Not because of any insight, but because Oral Roberts scored a pile of points in the Summit League and my model had never heard of the Summit League.

That's the mid-major problem in one sentence, and it cuts both ways. My top fifteen included Liberty (13-seed) at second overall, Colgate (14) at fifth, Drake (11) at sixth, UC Santa Barbara (12) at eighth, Abilene Christian (14) at eleventh, Ohio (13) at fourteenth, and Winthrop (12) at fifteenth. Seven of the top fifteen were seeded eleventh or worse.

Illinois, a 1-seed, came in seventeenth.

Ranking a 13-seed second in America isn't a small calibration issue. It's the model announcing that it has no idea who anybody played. Most years that wrecks your bracket. In 2021, with fourteen upsets and mid-majors everywhere, it bought me nine correct upset calls including the two biggest of the first round. The flaw and the highlight reel came from the same place.

### The Michigan-LSU footnote

At the very bottom of the original script, after the analysis ends, sit six orphaned lines pulling shooting numbers for Michigan and LSU.

They look like leftover junk until you check the schedule. Michigan played LSU in the round of 32 on March 22, 2021. Those lines are the process in action: two teams pulled up side by side and compared by hand the night before a real game, which is the exact operation this rebuild turns into a function.

Run properly, the model gives Michigan a 6.99 edge. Michigan won 86-78.

---

## Model Report Card

| Component | Grade | Notes |
| :--- | :---: | :--- |
| Spotting elite offense | A | Gonzaga first, Baylor third, out of 68. |
| Late rounds | A− | Final Four 2/2, Elite Eight 3/4. |
| Sniffing out upsets | B+ | Nine correct, including a 15-over-2 and an 8-over-1. |
| Knowing when it was guessing | C | Fine at the extremes, useless in the middle. |
| Round of 64 | D | 15 of 31, in the round with the most games. |
| Knowing who anybody played | F | A 13-seed finished second in the country. |
| Reproducibility | F | Nothing saved. No plot, no table, no score. |

On that C: when the ODI edge cleared 4 points, the model went 22 of 29 (75.9%). On genuine coin flips under 1 point it went 5 of 10, which is exactly right. But the 1-to-2 band went 3 of 10, worse than random. It knew a blowout and it knew a toss-up, and everything between was noise with a number attached.

---

## Two Bugs, Five Years Late

**The corrplot bug** was cosmetic. The defensive correlation plot handed one matrix five columns and the other four, so the significance stars landed on the wrong cells. R warned me. I didn't read it.

**The effective field goal bug** was not cosmetic. The line computing EFG did arithmetic across two data frames that had been filtered separately and were no longer in the same row order, because `merge()` had quietly re-sorted one of them alphabetically. The result: **64 of the 68 teams had another team's three-point total baked into their shooting efficiency.** Mean error 1.5 percentage points, worst case 7.8.

Gonzaga's real EFG is 61.0%. My script had them at 65.0%.

That number should have stopped me cold. A 65% would have been a program-record, era-defining figure, and one look at the column would have caught it. But I never printed the column. Nothing in that script wrote anything to disk, so nothing was ever reviewed. Every result lived in the RStudio plot pane until I closed the window.

---

## What I Didn't Have Yet

For years I've said the missing piece was KenPom and strength of schedule. That's true, and it's also the symptom rather than the disease. Rebuilding this and actually checking what the axes contained turned up something better.

**PC1 (20.9% of variance) is offense, exactly as advertised.** Correlates with points per game at +0.94, effective field goal percentage at +0.67, win percentage at +0.77. I read that axis correctly.

**PC2 (19.3%) is not defense.** I labelled it defense for five years. It correlates with opponent points per game at +0.70, which is what fooled me, and with *opponent field goal percentage* at **−0.01**. Zero. It has no relationship whatsoever with whether opponents actually shoot well against you.

PC2 was measuring tempo. High PC2 means possessions: rebounds at both ends, free throws, shots taken and allowed, and lower efficiency. Low PC2 means a grind. The two most extreme low-PC2 teams in the field are Virginia and Loyola Chicago, which is about as on-the-nose as basketball gets. Those were the two most deliberate, defense-first programs in the country that season.

And this is why it stayed hidden. Houston, the team I used to name that axis, really was the best defense in the field. Houston was also a Kelvin Sampson team, which meant it played slowly by design. Elite defense and slow tempo in the same team, landing in the same place on the chart. My anchor sat exactly where a defense axis and a tempo axis would both put it, so it could never tell me which one I was looking at. A fast team with a great defense, or a slow team with a bad one, would have blown the interpretation apart immediately.

So the axis was picking up something real. It just wasn't defensive quality; it was pace. Slow teams give up fewer points whether they defend or not.

Actual defensive quality was living on **PC3**, correlated with opponent field goal percentage at +0.62. That's the component I computed and never plotted.

Stated properly, this is what KenPom was for. Adjusted efficiency is measured per 100 possessions and corrected for opponent, which kills both problems with one change: the tempo confusion in PC2, and the strength-of-schedule inflation that put Liberty second in the country. I could feel both holes in 2021 and couldn't name either one.

There's a third thing the rebuild surfaced, and it's the one I'd have most wanted to know at the time. The correlation plot with wins and losses as columns, the one the original script drew and I never really read, says that shooting stats connect to winning about twice as strongly as anything defensive. Field goals made per game runs +0.47 against wins and −0.56 against losses. Opponent field goal percentage manages −0.26 against win percentage. My model weighted offense and defense equally while the data was telling me, in two columns, that it understood one far better than the other.

---

## Lessons That Became 2026

1. **Adjust for pace and opponent, or your axes will lie to you.** This is the single biggest reason the 2026 model runs on KenPom and Barttorvik efficiency data rather than raw per-game averages.

2. **Score your predictions.** Five years without a number. The 2026 project has a backtester, a game-by-game ledger, and a post-mortem published the week the tournament ended.

3. **If it isn't saved, it wasn't checked.** A bug touching 94% of the rows survived because every result disappeared when I closed a window.

4. **A model that can't express uncertainty will be confidently wrong at the worst possible moment.** 1.52 and 10.42 looked identical. The 2026 model outputs probabilities, which is why its post-mortem can discuss an 18.7% champion instead of a pick that failed.

5. **Check what a variable measures before you name it.** I called PC2 defense because the loadings looked defensive at a glance. One correlation would have caught it. Confirming what a feature does rather than trusting its label is the most portable thing this project taught me.

6. **Sometimes your worst flaw makes your best pick.** Overrating mid-majors sank the record and produced the best calls of the tournament. That tension doesn't resolve, it gets priced. The 2026 model has a dedicated upset-leverage component because of what happened here.

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

One thing I deliberately left alone: win-loss record (`W`, `L`, `Pct_W_L`) is still among the PCA inputs, exactly as it was in 2021. Feeding wins into a model whose job is predicting wins is circular, and it inflates how good PC1 looks; `Pct_W_L` loads on it at +0.77. Taking it out would make this a different analysis than the one I actually ran in 2021, so it stays. It's on the list of things later versions fixed.

---

*Back to the [README](./README.md) · the version with charts is on [the site](https://cedpaul13.github.io/March_Madness_2021/) · and it all leads to [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/).*
