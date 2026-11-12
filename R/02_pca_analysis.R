# PCA on the 2021 field: offense, defense, and both together.
#
# Keeps the three-way structure of the 2021 original. Two things change:
# princomp() becomes prcomp(), and the "biplots" are now actual biplots;
# the original plotted scores with team labels and no loading vectors.

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(factoextra)
  library(corrplot)
  library(Hmisc)
})

OFF_VARS <- c("APG", "Ast_ToRatio", "FG_Perc", "EFG", "FGM_PG", "FGA_PG", "FT_PG",
              "FTA_PG", "FT_Perc", "PPG", "RPG", "OffRebsPG", "Perc_3P",
              "FG_3P_PG", "FGA_3P_PG", "ToRatioMarg", "W", "L", "Pct_W_L")

DEF_VARS <- c("OPP_PPG", "OPP_FG_Perc", "OPP_FG_PG", "OPP_FGA_PG", "OPP_RPG",
              "REB_MAR", "DefRebsPG", "STPG", "PFPG", "Opp_3P_Pct", "TOPG",
              "Opp_TOAvg", "Opp_3FG_PG", "Opp_3FGA_PG", "W", "L", "Pct_W_L")

ALL_VARS <- union(OFF_VARS, DEF_VARS)

pca_input <- function(vars) {
  m <- as.data.frame(NCAA_ALL[vars])
  rownames(m) <- NCAA_ALL$Team   # so biplots label points with team names
  m
}

pca_offense  <- prcomp(pca_input(OFF_VARS), center = TRUE, scale. = TRUE)
pca_defense  <- prcomp(pca_input(DEF_VARS), center = TRUE, scale. = TRUE)
pca_combined <- prcomp(pca_input(ALL_VARS), center = TRUE, scale. = TRUE)

save_biplot <- function(pca, title, file, top_vars = NULL) {
  args <- list(pca, repel = TRUE, col.var = COL_VAR, col.ind = COL_IND,
               label = "all", title = title)
  if (!is.null(top_vars)) args$select.var <- list(contrib = top_vars)
  p <- do.call(fviz_pca_biplot, args)
  ggsave(file.path(FIGURE_DIR, file), p, width = 10, height = 8, dpi = 200)
}

save_biplot(pca_offense,  "2021 field: offensive profile", "biplot_offense.png")
save_biplot(pca_defense,  "2021 field: defensive profile", "biplot_defense.png")
save_biplot(pca_combined, "2021 field: offense and defense", "biplot_combined.png",
            top_vars = 15)

RECORD_VARS <- c("W", "L", "Pct_W_L")

# Every stat against wins, losses, win percentage, and the first two components.
# This is the layout the 2021 script used, and it is the useful one: the W and L
# columns say which numbers actually move the outcome. Index ranges come from the
# variable counts, since hardcoding them is what broke the original.
save_corrplot <- function(pca, vars, file) {
  stats <- setdiff(vars, RECORD_VARS)
  cr <- rcorr(as.matrix(NCAA_ALL[stats]),
              as.matrix(cbind(NCAA_ALL[RECORD_VARS], pca$x[, 1:2])))
  rows <- seq_along(stats)
  cols <- length(stats) + seq_len(length(RECORD_VARS) + 2)
  # Only five columns, so keep the canvas narrow. A wide one just pads the
  # sides with white and shrinks the circles once the page scales it down.
  png(file.path(FIGURE_DIR, file), width = 760, height = 1500, res = 150)
  corrplot(cr$r[rows, cols], method = "circle", type = "full",
           p.mat = cr$P[rows, cols], sig.level = 0.05, insig = "pch", pch = "*",
           tl.col = "black", tl.cex = 0.85, cl.cex = 0.75)
  dev.off()
  cr
}

corr_offense  <- save_corrplot(pca_offense,  OFF_VARS, "corrplot_offense.png")
corr_defense  <- save_corrplot(pca_defense,  DEF_VARS, "corrplot_defense.png")
corr_combined <- save_corrplot(pca_combined, ALL_VARS, "corrplot_combined.png")

# Separate figure for the deeper component view. PC3 is where opponent shooting
# actually lives, which is the whole reason PC2 turned out not to be defense.
save_component_corrplot <- function(pca, vars, file, n_pc = 5) {
  cr <- rcorr(as.matrix(NCAA_ALL[vars]), as.matrix(pca$x[, seq_len(n_pc)]))
  rows <- seq_along(vars)
  cols <- length(vars) + seq_len(n_pc)
  png(file.path(FIGURE_DIR, file), width = 1400, height = 1600, res = 180)
  corrplot(cr$r[rows, cols], method = "circle", type = "full",
           p.mat = cr$P[rows, cols], sig.level = 0.05, insig = "pch", pch = "*",
           tl.col = "black", tl.cex = 0.7)
  dev.off()
  cr
}

corr_components <- save_component_corrplot(pca_combined, ALL_VARS,
                                           "corrplot_components_combined.png")

# The 2021 script only ever looked at PC1 and PC2. PC3 carries another 14% of the
# variance, so this is the view that was never available at the time.
scores_3d <- data.frame(Team = NCAA_ALL$Team,
                        Conference = NCAA_ALL$Conference,
                        pca_combined$x[, 1:3])

write_pca_table <- function(scores, path) {
  scores <- scores[order(scores$Team), ]
  rows <- vapply(seq_len(nrow(scores)), function(i) {
    sprintf("<tr><th scope=\"row\">%s</th><td>%s</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>",
            htmltools::htmlEscape(scores$Team[i]),
            htmltools::htmlEscape(scores$Conference[i]),
            scores$PC1[i], scores$PC2[i], scores$PC3[i])
  }, character(1))
  writeLines(c(
    '<!doctype html><html lang="en"><head><meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width, initial-scale=1">',
    '<title>2021 PCA data / Données ACP 2021</title>',
    '<style>body{font:1rem/1.6 system-ui,sans-serif;max-width:60rem;margin:auto;padding:1.5rem;color:#141c2c;background:#f5f7fb}a{color:#315ed0}table{border-collapse:collapse;width:100%;font-variant-numeric:tabular-nums}th,td{text-align:left;padding:.6rem;border-bottom:1px solid #dce3ed}th{font-weight:600}.scroll{overflow-x:auto}</style>',
    '</head><body><p><a href="./index.html#method">← Back to the story / Retour à l&rsquo;article</a></p>',
    '<h1>2021 PCA data / Données ACP 2021</h1>',
    '<p>Coordinates match the 3D chart before reorienting axes for the ODI rule.<br><span lang="fr">Coordonnées du graphique 3D avant la réorientation des axes pour la règle ODI.</span></p>',
    '<div class="scroll"><table><caption>68 teams / <span lang="fr">68 équipes</span></caption><thead><tr><th scope="col">Team / Équipe</th><th scope="col">Conference / Conférence</th><th scope="col">PC1</th><th scope="col">PC2</th><th scope="col">PC3</th></tr></thead><tbody>',
    rows,
    '</tbody></table></div></body></html>'
  ), path, useBytes = TRUE)
}
write_pca_table(scores_3d, file.path(DOCS_DIR, "pca3d-table.html"))

widget <- plotly::plot_ly(
    scores_3d, x = ~PC1, y = ~PC2, z = ~PC3,
    type = "scatter3d", mode = "markers",
    text = ~paste0(Team, " (", Conference, ")"), hoverinfo = "text",
    marker = list(size = 5, color = ~PC1, colorscale = "Viridis",
                  opacity = 0.85, line = list(width = 0))) |>
  plotly::layout(
    # No title and tight margins: the page embeds this in a figure that
    # supplies its own caption.
    margin = list(l = 0, r = 0, b = 0, t = 0),
    scene = list(xaxis = list(title = "PC1: offense"),
                 yaxis = list(title = "PC2: tempo"),
                 zaxis = list(title = "PC3: opponent shooting")))

# selfcontained = FALSE writes pca3d_files/ next to the html; bundling it into a
# single file needs pandoc, which this pipeline otherwise has no use for.
htmlwidgets::saveWidget(widget, file.path(DOCS_DIR, "pca3d.html"),
                        selfcontained = FALSE, title = "2021 NCAA field: 3D PCA")

eig_combined <- get_eig(pca_combined)
write.csv(eig_combined, file.path(PROCESSED_DIR, "pca_eigenvalues.csv"))

loadings_combined <- as.data.frame(pca_combined$rotation[, 1:3])
loadings_combined$Variable <- rownames(loadings_combined)
write.csv(loadings_combined[, c("Variable", "PC1", "PC2", "PC3")],
          file.path(PROCESSED_DIR, "pca_loadings.csv"), row.names = FALSE)

message("PCA variance explained (combined): PC1 ",
        round(eig_combined[1, 2], 1), "%, PC2 ", round(eig_combined[2, 2], 1),
        "%, PC3 ", round(eig_combined[3, 2], 1), "%")
