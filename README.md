# March Madness 2021: Two Axes and a Scatterplot

Before the ensemble and the 132,134 matchup probabilities, there was this: four days, seventeen spreadsheets, and a principal component analysis I had just learned to run. First year of a statistics degree, brand new to R, and convinced I was onto something. Five years later I wrote the rule down as code and finally scored it.

**The full story, charts included, lives [here](https://cedpaul13.github.io/March_Madness_2021/).** English and French.

Worth a click for:

* Gonzaga and Baylor ranked first and third out of 68 teams, weeks before they met in the final
* Nine correct upset calls, including the Oral Roberts 15-over-2 that torched everyone's bracket
* A reconstruction of the rule that still loses to simply picking the better seed, and the reason why
* An axis I called "defense" for five years that turns out to measure tempo

---

## Dig deeper

* [Post-mortem: what those axes were actually made of](./POST_MORTEM.md)
* [The original 2021 script, untouched](./archives/NCAA_2021_original.R)
* [Where the bracket results came from](./data/bracket/README.md)
* [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/), where all of this ended up

---

## Run the pipeline

Four scripts: load and merge the season stats, run the PCA, turn the components into picks, score them against what actually happened.

```bash
Rscript R/run_all.R
```

Run it from the project root. `R/00_setup.R` grabs anything you're missing (`dplyr`, `purrr`, `stringr`, `ggplot2`, `factoextra`, `corrplot`, `Hmisc`, `plotly`, `htmlwidgets`, `htmltools`).

You'll get figures in `outputs/figures/` (biplots, correlation plots, the accuracy chart), tables in `data/processed/` (merged stats, team ratings, picks vs. results), and an interactive three-component view at `docs/pca3d.html` with an accessible table at `docs/pca3d-table.html`.

The site in `docs/` is ignored on the main branch and published separately on
`gh-pages`. The pipeline does not generate `docs/index.html`; retain or restore
the site files before editing them. Once `docs/` is ready, publish it with
[`scripts/deploy_site.sh`](./scripts/deploy_site.sh).
