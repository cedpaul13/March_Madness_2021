# March Madness 2021: Two Axes and a Scatterplot

Before the ensemble and the 132,134 matchup probabilities, there was this: seventeen spreadsheets, one principal component analysis, and a chart I read with my eyeballs to pick winners. It was the first model I ever built. I never scored it. Five years later, I finally did.

**The full story, charts included, lives [here](https://cedpaul13.github.io/March_Madness_2021/).** English and French.

Worth a click for:

* Gonzaga and Baylor ranked first and third out of 68 teams, weeks before they met in the final
* Nine correct upset calls, including Oral Roberts over Ohio State — the 15-over-2 that torched everyone's bracket
* A final record that still lost to just picking the better seed, and the reason why
* An axis I called "defense" for five years that turns out to measure tempo

---

## Dig deeper

* [Post-mortem: what those axes were actually made of](./POST_MORTEM.md)
* [The original 2021 script, untouched](./archives/NCAA_2021_original.R)
* [Where the bracket results came from](./data/bracket/README.md)
* [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/) — where all of this ended up

---

## Run the pipeline

Four scripts: load and merge the season stats, run the PCA, turn the components into picks, score them against what actually happened.

```bash
Rscript R/run_all.R
```

Run it from the project root. `R/00_setup.R` grabs anything you're missing (`dplyr`, `purrr`, `stringr`, `ggplot2`, `factoextra`, `corrplot`, `Hmisc`, `plotly`, `htmlwidgets`).

You'll get figures in `outputs/figures/` (biplots, correlation plots, the accuracy chart), tables in `data/processed/` (merged stats, team ratings, picks vs. results), and an interactive three-component view at `docs/pca3d.html`.
