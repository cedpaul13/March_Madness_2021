# March Madness 2021: Two Axes and a Scatterplot

This project started with four days, seventeen spreadsheets, and a principal component analysis I had just learned to run. I was in my first year of a statistics degree, new to R, and curious to see whether the charts could help me pick a bracket. Five years later, I turned that idea into code and measured how it did.

**The full story and charts are [here](https://cedpaul13.github.io/March_Madness_2021/), in English and French.**

The project looks at:

* Gonzaga and Baylor ranking first and third among 68 teams before they met in the final
* Nine correctly predicted upsets, including Oral Roberts beating a No. 2 seed
* How the reconstructed rule performed against simply picking the higher seed
* Why one axis I called "defense" was actually measuring tempo

---

## Dig deeper

* [Post-mortem: what those axes were actually made of](./POST_MORTEM.md)
* [The original 2021 script, untouched](./archives/NCAA_2021_original.R)
* [Where the bracket results came from](./data/bracket/README.md)
* [March Madness 2026](https://cedpaul13.github.io/March_Madness_2026/), where all of this ended up

---

## Run the pipeline

The four scripts load and merge the season stats, run the PCA, use its components to make picks, and compare those picks with the tournament results.

```bash
Rscript R/run_all.R
```

Run it from the project root. `R/00_setup.R` installs any missing packages (`dplyr`, `purrr`, `stringr`, `ggplot2`, `factoextra`, `corrplot`, `Hmisc`, `plotly`, `htmlwidgets`, and `htmltools`).

You'll get figures in `outputs/figures/` (biplots, correlation plots, the accuracy chart), tables in `data/processed/` (merged stats, team ratings, picks vs. results), and an interactive three-component view at `docs/pca3d.html` with an accessible table at `docs/pca3d-table.html`.

The site in `docs/` is ignored on the main branch and published separately on
`gh-pages`. The pipeline does not generate `docs/index.html`; retain or restore
the site files before editing them. Once `docs/` is ready, publish it with
[`scripts/deploy_site.sh`](./scripts/deploy_site.sh).
