# Shared setup: packages, paths, and the 2021 tournament field.

required <- c("dplyr", "purrr", "stringr", "ggplot2", "factoextra",
              "corrplot", "Hmisc", "plotly", "htmlwidgets", "htmltools")

missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = "https://cloud.r-project.org")
}

PROJ_ROOT <- getwd()
if (!dir.exists(file.path(PROJ_ROOT, "data", "raw"))) {
  stop("Run this from the project root (the folder containing data/raw). Current: ", PROJ_ROOT)
}

RAW_DIR       <- file.path(PROJ_ROOT, "data", "raw")
BRACKET_DIR   <- file.path(PROJ_ROOT, "data", "bracket")
PROCESSED_DIR <- file.path(PROJ_ROOT, "data", "processed")
FIGURE_DIR    <- file.path(PROJ_ROOT, "outputs", "figures")
DOCS_DIR      <- file.path(PROJ_ROOT, "docs")

for (d in c(PROCESSED_DIR, FIGURE_DIR, DOCS_DIR)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# Palette shared with the site so figures and HTML stay visually consistent.
COL_HIT  <- "#199e70"
COL_MISS <- "#d03b3b"
COL_VAR  <- "#d95926"
COL_IND  <- "#3987e5"

# The 68-team field, exactly as spelled in the March 2021 stat exports.
TOURNAMENT_FIELD <- sort(c(
  "Gonzaga (WCC)", "Baylor (Big 12)", "Illinois (Big Ten)", "Michigan (Big Ten)",
  "Alabama (SEC)", "Ohio St. (Big Ten)", "Iowa (Big Ten)", "Houston (AAC)",
  "Arkansas (SEC)", "West Virginia (Big 12)", "Texas (Big 12)", "Kansas (Big 12)",
  "Florida St. (ACC)", "Purdue (Big Ten)", "Oklahoma St. (Big 12)",
  "Virginia (ACC)", "Creighton (Big East)", "Villanova (Big East)",
  "Tennessee (SEC)", "Colorado (Pac-12)", "Southern California (Pac-12)",
  "Texas Tech (Big 12)", "BYU (WCC)", "San Diego St. (Mountain West)",
  "Oregon (Pac-12)", "UConn (Big East)", "Clemson (ACC)", "Florida (SEC)",
  "LSU (SEC)", "Loyola Chicago (MVC)", "North Carolina (ACC)", "Oklahoma (Big 12)",
  "Missouri (SEC)", "Georgia Tech (ACC)", "Wisconsin (Big Ten)", "Maryland (Big Ten)",
  "St. Bonaventure (Atlantic 10)", "Virginia Tech (ACC)", "VCU (Atlantic 10)",
  "Rutgers (Big Ten)", "Syracuse (ACC)", "Utah St. (Mountain West)",
  "Michigan St. (Big Ten)", "UCLA (Pac-12)", "Wichita St. (AAC)",
  "Oregon St. (Pac-12)", "Georgetown (Big East)", "Drake (MVC)", "Winthrop (Big South)",
  "UC Santa Barbara (Big West)", "Ohio (MAC)", "North Texas (C-USA)", "Liberty (ASUN)",
  "UNC Greensboro (SoCon)", "Abilene Christian (Southland)", "Morehead St. (OVC)",
  "Colgate (Patriot)", "Eastern Wash. (Big Sky)", "Grand Canyon (WAC)",
  "Cleveland St. (Horizon)", "Oral Roberts (Summit League)", "Iona (MAAC)",
  "Drexel (CAA)", "Hartford (America East)", "Mount St. Mary's (NEC)",
  "Texas Southern (SWAC)", "Norfolk St. (MEAC)", "App State (Sun Belt)"
))

stopifnot(length(TOURNAMENT_FIELD) == 68)
