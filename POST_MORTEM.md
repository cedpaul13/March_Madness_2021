# The 2021 Post-Mortem: What I Learned from an Early Bracket Model

*I built my first attempt at a predictive model in four days, during my first year studying statistics and soon after I began learning R. I used seventeen spreadsheets and judged the results by looking at a scatterplot. Five years later, I translated that approach into code and checked it against the tournament results. This is what I found, including two bugs and an axis that measured something different from what I thought.*

---

## The Final Ledger

| | 2021 Men's Tournament |
| :--- | :--- |
| **Champion** | Baylor (1) def. Gonzaga (1), **86-70** |
| **Date · Venue** | April 5 · Lucas Oil Stadium, Indianapolis |
| **The stakes** | Gonzaga showed up 31-0, chasing the first perfect season since Indiana in 1976 |
| **My board** | Gonzaga 1st of 68 · Baylor 3rd of 68 |
| **My final** | Gonzaga over Baylor. Nope. |

The tournament was played in a bubble, with every game in Indiana. During the season, teams had faced very different schedules and levels of competition. The tournament also had a record fourteen upsets, making raw per-game averages especially unreliable.

My model used only raw per-game averages. It ranked the two finalists first and third, but picked the wrong champion.

---

## The Method, Written Down at Last

The 2021 script ran a PCA over 33 team stats: shooting, rebounds, assists, turnovers, fouls, opponent equivalents, win-loss record. Then it plotted the field on the first two components.

PCA produces coordinates but doesn't label the axes, so I named them by looking at teams I knew. Gonzaga stood out on the first axis and had one of the country's strongest offenses. Houston stood out on the second; it was known for its defense under coach Kelvin Sampson. I concluded that the first axis represented offense and the second defense. When I rebuilt the analysis, the first interpretation held up: Gonzaga ranked first of 68 in both points per game and effective field goal percentage. Houston ranked first in opponent field goal percentage, which seemed to support my interpretation of the second axis.

My rule was simple: whichever team was farther toward the "good" corner of the chart would win.

Written as a formula, it is:

```
ODI = PC1 + PC2        (both axes flipped so bigger = better)
```

I gave the two axes equal weight. I hadn't tuned or calibrated the formula, and I hadn't tested it on past results.

**A note about the results:** this rule is a reconstruction. The scores below are for the reconstructed rule, not the bracket I submitted on CBS in 2021. My actual bracket also reflected what I had read about the teams, their recent form, and injuries. I was testing the PCA as one input, not using it to make every pick. The results below show how the rule performed on its own across the 66 games played.

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

The model ranked both finalists near the top and correctly picked both Final Four games. It did less well in the early rounds, where most bracket points are decided.

---

## Comparison with Higher-Seed Picks

Picking the higher seed every time got **42 of 61** games right. My model got **36 of 61** on those same games. It disagreed with the committee 24 times and got 9 of those picks right.

Picking the higher seed did six games better. I hadn't measured the PCA rule separately in 2021, because it was only one part of my approach.

---

## What Stood Out

### Gonzaga: a strong team, but the wrong champion

Gonzaga topped my rankings at 9.59, ahead of Baylor at 8.07, with the rest of the field further behind. Gonzaga had a strong offense in 2021, with a 61.0% effective field goal percentage, the best in the field by 2.5 percentage points.

Gonzaga entered the final with a 31-0 record.

The model gave Gonzaga a 1.52-point ODI advantage over Baylor. For comparison, its advantage over UCLA in the semifinal was 10.42 points. The difference suggested that the final would be close, but I hadn't defined how to interpret the size of an ODI margin.

Baylor won by sixteen, taking control before halftime.

The problem wasn't that I favored Gonzaga; many people did. The model gave no useful indication of how uncertain that pick was.

### Oral Roberts: an upset the model got right

Oral Roberts beat a No. 2 seed in overtime, then beat Florida before losing to Arkansas by two points in the Sweet 16.

The model picked both upsets, largely because it treated Oral Roberts' high scoring average in the Summit League as if it were directly comparable to scoring averages from stronger conferences.

The same issue affected many other mid-major teams. My top fifteen included Liberty (a 13-seed) in second place, Colgate (14) in fifth, Drake (11) in sixth, UC Santa Barbara (12) in eighth, Abilene Christian (14) in eleventh, Ohio (13) in fourteenth, and Winthrop (12) in fifteenth. Seven of the top fifteen teams were seeded 11th or lower.

Illinois, a No. 1 seed, ranked seventeenth.

Ranking a 13-seed second in the country points to a basic limitation: the model didn't account for strength of schedule. That usually makes rankings less reliable. In 2021, however, several mid-majors did well, and the model correctly picked nine upsets, including two of the biggest in the first round. Those results came from the same weakness in the model.

### The Michigan-LSU footnote

At the bottom of the original script, after the analysis, are six lines that retrieve shooting statistics for Michigan and LSU.

They appear unrelated until you check the schedule: Michigan played LSU in the Round of 32 on March 22, 2021. The lines show how I compared teams by hand before a game. This rebuild turns that comparison into a function.

The rebuilt model gives Michigan a 6.99-point advantage. Michigan won 86-78.

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

## Two Bugs I Found Later

**The corrplot bug** affected the display, not the analysis. The defensive correlation plot used matrices with different numbers of columns, so the significance stars appeared in the wrong cells. R issued a warning that I missed.

**The effective field goal bug** changed the results. The calculation combined two data frames that had been filtered separately and no longer had the same row order. `merge()` had sorted one of them alphabetically. As a result, **64 of the 68 teams had another team's three-point total included in their shooting efficiency.** The average error was 1.5 percentage points, with a maximum of 7.8.

Gonzaga's real EFG is 61.0%. My script had them at 65.0%.

That result should have prompted a closer look. A 65% effective field goal rate would have been extraordinary, and checking the column might have revealed the error. But I never printed it. The script didn't save its results, so I had nothing to review after closing RStudio.

---

## What I Didn't Have Yet

For years, I thought the main missing pieces were KenPom ratings and strength of schedule. Rebuilding the analysis and checking the component loadings showed that the problem was broader.

**PC1 (20.9% of variance) reflects offense.** It correlates with points per game at +0.94, effective field goal percentage at +0.67, and win percentage at +0.77. My interpretation of this axis was reasonable.

**PC2 (19.3%) does not reflect defense.** I called it defense for five years. It correlates with opponent points per game at +0.70, which contributed to my interpretation, but its correlation with *opponent field goal percentage* is **−0.01**. It tells us almost nothing about how well opponents shoot.

PC2 was measuring tempo. Higher scores are associated with more possessions, rebounds, free throws, and shots, as well as lower efficiency. Lower scores indicate a slower pace. Virginia and Loyola Chicago had the lowest PC2 scores; both played at a deliberate pace and emphasized defense.

My interpretation held up for so long because Houston, the team I used to label the axis, was both the best defense in the field and a slow-paced team. It landed in a place that seemed consistent with either explanation. Looking at teams with different combinations of pace and defensive strength would have helped distinguish the two.

The axis did capture a real difference between teams, but it was pace rather than defensive quality. Teams that play at a slower pace tend to allow fewer points, regardless of how well they defend.

**PC3** better reflected defensive quality, with a +0.62 correlation to opponent field goal percentage. I computed this component but never plotted it.

This is why adjusted efficiency ratings such as KenPom's are useful: they measure performance per 100 possessions and account for opponents. That would address both the tempo issue in PC2 and the strength-of-schedule problem that helped put Liberty second in my rankings. I was aware of these limitations in 2021 but didn't know how to address them.

The rebuild also showed that shooting statistics were more strongly associated with winning than the defensive statistics I examined. Field goals made per game correlates with wins at +0.47 and losses at −0.56. Opponent field goal percentage has a −0.26 correlation with win percentage. My model gave offense and defense equal weight, even though its inputs appeared to describe offense more clearly.

---

## Lessons That Became 2026

1. **Adjust for pace and opponent.** This is why the 2026 model uses KenPom and Barttorvik efficiency data instead of raw per-game averages.

2. **Score your predictions.** I went five years without measuring the model's results. The 2026 project includes a backtester, a game-by-game ledger, and a post-mortem published the week the tournament ended.

3. **Save your results.** A bug affecting 94% of the rows went unnoticed because I didn't save anything to review.

4. **Account for uncertainty.** The model gave advantages of 1.52 and 10.42 the same meaning, even though one suggested a close game and the other a more confident pick. The 2026 model outputs probabilities, which makes it possible to describe a champion's chances rather than just report a pick.

5. **Check what a variable measures before naming it.** I called PC2 defense based on a quick look at its loadings. Checking its correlations would have shown that this interpretation was wrong.

6. **A model's weaknesses can sometimes lead to a correct pick.** Overrating mid-majors hurt the overall record but also led to some of the model's best upset picks. The 2026 model accounts for upset potential separately.

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

I left win-loss record (`W`, `L`, `Pct_W_L`) among the PCA inputs, as it was in 2021. That means the rankings partly reflect regular-season results; `Pct_W_L` has a +0.77 loading on PC1. Removing those variables would change this reconstruction, so I kept them here. Later versions of the model no longer use them.

---

*Back to the [README](./README.md) · the version with charts is on [the site](https://cedpaul13.github.io/March_Madness_2021/) · and it all leads to [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/).*
