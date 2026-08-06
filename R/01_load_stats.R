# Load the 17 season-stat exports, filter to the tournament field, merge to one table.

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
  library(stringr)
})

load_team_stat <- function(file, col_names) {
  df <- read.csv2(file.path(RAW_DIR, file), header = TRUE, sep = ";", dec = ",",
                  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
  stopifnot(ncol(df) == length(col_names))
  colnames(df) <- col_names
  df[df$Team %in% TOURNAMENT_FIELD, ]
}

three_pt <- load_team_stat("3FGM-3FGA.csv",
    c("Rank", "Team", "GM", "W_L", "FG_3P", "FG_3PA")) |>
  mutate(FG_3P_PG  = round(FG_3P / GM, 1),
         FGA_3P_PG = round(FG_3PA / GM, 1),
         Perc_3P   = round(FG_3P / FG_3PA * 100, 1)) |>
  select(Team, GM, FG_3P_PG, FGA_3P_PG, Perc_3P, FG_3P, FG_3PA)

three_pt_def <- load_team_stat("3PTS-DEF.csv",
    c("Rank", "Team", "GM", "W_L", "Opp_3FGA", "Opp_3FG", "Opp_3P_Pct")) |>
  mutate(Opp_3FG_PG  = round(Opp_3FG / GM, 1),
         Opp_3FGA_PG = round(Opp_3FGA / GM, 1)) |>
  select(Team, Opp_3FG_PG, Opp_3FGA_PG, Opp_3P_Pct)

ast_to <- load_team_stat("ASTS-TOsRatio.csv",
    c("Rank", "Team", "GM", "W_L", "AST", "TO", "Ast_ToRatio")) |>
  select(Team, Ast_ToRatio)

ast <- load_team_stat("ASTS.csv",
    c("Rank", "Team", "GM", "W_L", "AST", "APG")) |>
  select(Team, APG)

def_ppg <- load_team_stat("DEF-PPG.csv",
    c("Rank", "Team", "GM", "W_L", "OPP_PTS", "OPP_PPG")) |>
  select(Team, OPP_PPG)

fg_def <- load_team_stat("FG-DEF.csv",
    c("Rank", "Team", "GM", "W_L", "OPP_FG", "OPP_FGA", "OPP_FG_Perc")) |>
  mutate(OPP_FG_PG  = round(OPP_FG / GM, 1),
         OPP_FGA_PG = round(OPP_FGA / GM, 1)) |>
  select(Team, OPP_FG_Perc, OPP_FG_PG, OPP_FGA_PG)

fgm_fga <- load_team_stat("FGM-FGMA-FG%.csv",
    c("Rank", "Team", "GM", "W_L", "FGM", "FGA", "FG_Perc")) |>
  mutate(FGM_PG = round(FGM / GM, 1),
         FGA_PG = round(FGA / GM, 1)) |>
  select(Team, FG_Perc, FGM_PG, FGA_PG, FGM, FGA)

ft <- load_team_stat("FT.csv",
    c("Rank", "Team", "GM", "W_L", "FT", "FTA", "FT_Perc")) |>
  mutate(FT_PG  = round(FT / GM, 1),
         FTA_PG = round(FTA / GM, 1)) |>
  select(Team, FT_PG, FTA_PG, FT_Perc)

off_ppg <- load_team_stat("Off-PPG.csv",
    c("Rank", "Team", "GM", "W_L", "PTS", "PPG")) |>
  select(Team, PPG)

fouls <- load_team_stat("PFoulsPerGame.csv",
    c("Rank", "Team", "GM", "W_L", "Fouls", "PFPG", "DQ")) |>
  select(Team, PFPG, DQ)

reb_margin <- load_team_stat("REB-Margin.csv",
    c("Rank", "Team", "GM", "W_L", "REB", "RPG", "OPP_REB", "OPP_RPG", "REB_MAR")) |>
  select(Team, RPG, OPP_RPG, REB_MAR)

rebs <- load_team_stat("REBS.csv",
    c("Rank", "Team", "GM", "ORebs", "DRebs", "REB", "RPG")) |>
  mutate(OffRebsPG = round(ORebs / GM, 1),
         DefRebsPG = round(DRebs / GM, 1)) |>
  select(Team, OffRebsPG, DefRebsPG)

steals <- load_team_stat("STEALS.csv",
    c("Rank", "Team", "GM", "W_L", "ST", "STPG")) |>
  select(Team, STPG)

to_forced <- load_team_stat("TO-Forced.csv",
    c("Rank", "Team", "GM", "Opp_TO", "Opp_TOAvg")) |>
  select(Team, Opp_TOAvg)

to_margin <- load_team_stat("TO-Margin.csv",
    c("Rank", "Team", "GM", "W_L", "Opp_TO", "TO", "ToRatioMarg")) |>
  select(Team, ToRatioMarg)

turnovers <- load_team_stat("TO.csv",
    c("Rank", "Team", "GM", "W_L", "TO", "TOPG")) |>
  select(Team, TOPG)

win_loss <- load_team_stat("W-L%.csv",
    c("Rank", "Team", "W", "L", "Pct_W_L")) |>
  select(Team, W, L, Pct_W_L)

stat_frames <- list(three_pt, three_pt_def, ast_to, ast, def_ppg, fg_def, fgm_fga,
                    ft, off_ppg, fouls, reb_margin, rebs, steals, to_forced,
                    to_margin, turnovers, win_loss)

NCAA_ALL <- reduce(stat_frames, full_join, by = "Team")

# Effective FG% must come off the merged table. The original script computed it
# from two separately-filtered frames whose row order no longer matched after
# merge() re-sorted alphabetically, so most teams got another team's shooting line.
NCAA_ALL <- NCAA_ALL |>
  mutate(EFG = round((FGM + FG_3P * 0.5) / FGA * 100, 1),
         Conference = str_extract(Team, "(?<=\\()[^)]+(?=\\)$)"),
         Team = str_remove(Team, "\\s*\\([^)]+\\)$")) |>
  relocate(Team, Conference)

stopifnot(nrow(NCAA_ALL) == 68, !anyNA(NCAA_ALL$EFG))

write.csv(NCAA_ALL, file.path(PROCESSED_DIR, "ncaa_all_2021.csv"), row.names = FALSE)
message("Merged ", nrow(NCAA_ALL), " teams x ", ncol(NCAA_ALL), " columns.")
