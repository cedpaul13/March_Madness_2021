# Archives

This folder breaks from the convention used in [March_Madness_2026](https://github.com/cedpaul13/March_Madness_2026), where `archives/` holds disposable, superseded drafts of the pipeline and is gitignored — safe to lose, no story attached.

Here, `archives/` holds the actual 2021 artifact:

- `NCAA_2021_original.R` — a verbatim copy of the script as it existed before this rebuild. Every bug discussed in `POST_MORTEM.md` (the broken `setwd()`, the mismatched `corrplot` column indices, the EFG calculation reading the wrong team's shooting stats) is preserved here exactly as it shipped.
- `ACP_Offense.pdf`, `ACP_Defense.pdf` — the two PCA scatter plots, manually exported from the RStudio plot pane in March 2021. They're the only surviving visual output of the original run; the script itself never saved a plot programmatically.

These are receipts, not drafts, so they're tracked in git rather than ignored.
