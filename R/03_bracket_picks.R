# Turn the 2021 eyeball method into code, then score it against what happened.
#
# In 2021 the picks were made by looking at where two teams sat on the PC1/PC2
# scatter and taking the one further toward the good corner. This reproduces that
# rule exactly: equal weight on both axes, because that is what reading a plot does.

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

# prcomp's component signs are arbitrary, so anchor them to a reference stat
# instead of trusting whichever direction the decomposition happened to pick.
# PC1 tracks scoring: positive should mean better offense.
# PC2 tracks points allowed: positive should mean better defense, so it flips.
pc1_sign <- sign(cor(pca_combined$x[, 1], NCAA_ALL$PPG))
pc2_sign <- -sign(cor(pca_combined$x[, 2], NCAA_ALL$OPP_PPG))

team_scores <- tibble(
  Team = NCAA_ALL$Team,
  PC1  = pc1_sign * pca_combined$x[, 1],
  PC2  = pc2_sign * pca_combined$x[, 2]
) |>
  mutate(ODI = PC1 + PC2) |>
  arrange(desc(ODI))

write.csv(team_scores, file.path(PROCESSED_DIR, "team_odi_2021.csv"), row.names = FALSE)

bracket <- read.csv(file.path(BRACKET_DIR, "2021_bracket_results.csv"),
                    stringsAsFactors = FALSE)

odi <- setNames(team_scores$ODI, team_scores$Team)
picks <- bracket |>
  mutate(odi_winner = unname(odi[winner]),
         odi_loser  = unname(odi[loser]),
         model_pick = ifelse(odi_winner >= odi_loser, winner, loser),
         edge       = round(abs(odi_winner - odi_loser), 2),
         correct    = model_pick == winner,
         upset      = seed_w > seed_l)

stopifnot(!anyNA(picks$odi_winner), !anyNA(picks$odi_loser))

round_levels <- c("First Four", "Round of 64", "Round of 32", "Sweet 16",
                  "Elite Eight", "Final Four", "Championship")
picks$round <- factor(picks$round, levels = round_levels)
picks <- picks |> arrange(round, region, desc(seed_w))

write.csv(picks, file.path(PROCESSED_DIR, "picks_vs_actual_2021.csv"), row.names = FALSE)

by_round <- picks |>
  group_by(round) |>
  summarise(games = n(), hits = sum(correct), .groups = "drop") |>
  mutate(pct = round(hits / games * 100, 1))

write.csv(by_round, file.path(PROCESSED_DIR, "accuracy_by_round_2021.csv"), row.names = FALSE)

p <- ggplot(by_round, aes(x = round, y = pct)) +
  geom_col(fill = COL_IND, width = 0.65) +
  geom_text(aes(label = paste0(hits, "/", games)), vjust = -0.5, size = 3.6) +
  scale_y_continuous(limits = c(0, 105), expand = c(0, 0)) +
  labs(title = "PC1/PC2 picks against the real 2021 bracket",
       subtitle = paste0("Overall: ", sum(picks$correct), " of ", nrow(picks), " games (",
                         round(mean(picks$correct) * 100, 1), "%)"),
       x = NULL, y = "Correct (%)") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.x = element_blank(),
        axis.text.x = element_text(angle = 20, hjust = 1))

ggsave(file.path(FIGURE_DIR, "bracket_accuracy_by_round.png"), p,
       width = 9, height = 5.5, dpi = 200)

message("Overall: ", sum(picks$correct), "/", nrow(picks),
        " (", round(mean(picks$correct) * 100, 1), "%)")
