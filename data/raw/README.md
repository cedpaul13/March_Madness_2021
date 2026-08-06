# Raw stat data

17 season-stat exports covering the 68 teams in the 2021 NCAA Division I men's basketball tournament: shooting (FG/3PT/FT), rebounding, assists/turnovers, steals, fouls, and win-loss records.

**Format**: `;`-delimited, comma decimals, UTF-8 with BOM — a European-locale CSV export. Column shapes (`Rank;Team;GM;W-L;...`) match TeamRankings.com's team-stat pages. Scraped/exported March 17–18, 2021, just ahead of Selection Sunday.

**License note**: these were pulled for personal analysis, not redistributed as a dataset in their own right. If TeamRankings.com's terms of use restrict redistribution of scraped stat pages, that should be checked before treating this folder as a general-purpose public dataset rather than "the specific inputs this one analysis used."

Loaded and merged by [`R/01_load_stats.R`](../../R/01_load_stats.R).
