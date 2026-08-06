# Full pipeline. Run from the project root: Rscript R/run_all.R

source("R/00_setup.R")
source("R/01_load_stats.R")
source("R/02_pca_analysis.R")
source("R/03_bracket_picks.R")

# Stage the figures the site embeds. docs/ is the deploy artifact, so it
# carries its own copies rather than reaching up into outputs/.
site_figs <- file.path(DOCS_DIR, "figures")
if (!dir.exists(site_figs)) dir.create(site_figs, recursive = TRUE)
site_assets <- c("biplot_combined.png", "corrplot_combined.png",
                 "corrplot_components_combined.png")
invisible(file.copy(file.path(FIGURE_DIR, site_assets), site_figs,
                    overwrite = TRUE))

message("Done. Figures in outputs/figures/, tables in data/processed/.")
