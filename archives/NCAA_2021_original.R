# options(repos = c(CRAN = "https://cloud.r-project.org"))
# install.packages(c("Hmisc", "corrplot", "factoextra"))
getwd()
setwd("/Users/cedrickpaul/Documents/Projects/NCAA/March_Madness_2021/Data")

#Liste des équipes dans les NCAA March Madness 2021

NCAA_MM2021 <- c("Gonzaga (WCC)", "Baylor (Big 12)", "Illinois (Big Ten)", "Michigan (Big Ten)",
                "Alabama (SEC)", "Ohio St. (Big Ten)", "Iowa (Big Ten)", "Houston (AAC)",
                "Arkansas (SEC)","West Virginia (Big 12)", "Texas (Big 12)", "Kansas (Big 12)", 
                "Florida St. (ACC)", "Purdue (Big Ten)", "Oklahoma St. (Big 12)",
                "Virginia (ACC)", "Creighton (Big East)", "Villanova (Big East)",
                "Tennessee (SEC)", "Colorado (Pac-12)", "Southern California (Pac-12)",
                "Texas Tech (Big 12)", "BYU (WCC)", "San Diego St. (Mountain West)",
                "Oregon (Pac-12)", "UConn (Big East)","Clemson (ACC)","Florida (SEC)",
                "LSU (SEC)","Loyola Chicago (MVC)", "North Carolina (ACC)","Oklahoma (Big 12)",
                "Missouri (SEC)","Georgia Tech (ACC)","Wisconsin (Big Ten)","Maryland (Big Ten)",
                "St. Bonaventure (Atlantic 10)","Virginia Tech (ACC)", "VCU (Atlantic 10)",
                "Rutgers (Big Ten)", "Syracuse (ACC)","Utah St. (Mountain West)",
                "Michigan St. (Big Ten)", "UCLA (Pac-12)","Wichita St. (AAC)",
                "Oregon St. (Pac-12)","Georgetown (Big East)","Drake (MVC)","Winthrop (Big South)",
                "UC Santa Barbara (Big West)","Ohio (MAC)","North Texas (C-USA)","Liberty (ASUN)",
                "UNC Greensboro (SoCon)", "Abilene Christian (Southland)", "Morehead St. (OVC)",
                "Colgate (Patriot)", "Eastern Wash. (Big Sky)", "Grand Canyon (WAC)",
                "Cleveland St. (Horizon)", "Oral Roberts (Summit League)", "Iona (MAAC)",
                "Drexel (CAA)", "Hartford (America East)","Mount St. Mary's (NEC)",
                "Texas Southern (SWAC)", "Norfolk St. (MEAC)","App State (Sun Belt)")

NCAA_MM2021 <- sort(NCAA_MM2021)




#Importation et lecture du jeu de données

#3FGM-3FGA
ThreePts_FGM_FGA <- read.csv2("3FGM-3FGA.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(ThreePts_FGM_FGA)
colnames(ThreePts_FGM_FGA) <- c("Rank", "Team", "GM", "W-L", "FG_3P" , "FG_3PA")

ThreePts_FGM_FGA2<- ThreePts_FGM_FGA[ThreePts_FGM_FGA$Team %in% NCAA_MM2021, ]
colnames(ThreePts_FGM_FGA2) <- c("Rank",  "Team",  "GM",    "W-L" ,  "FG_3P" , "FG_3PA")

ThreePts_FGM_FGA2$FG_3P_PG <- round(ThreePts_FGM_FGA2$FG_3P/ThreePts_FGM_FGA2$GM,1)
ThreePts_FGM_FGA2$FGA_3P_PG <- round(ThreePts_FGM_FGA2$FG_3PA/ThreePts_FGM_FGA2$GM,1)
ThreePts_FGM_FGA2$Perc_3P <- round((ThreePts_FGM_FGA2$FG_3P/ThreePts_FGM_FGA2$FG_3PA)*100,1)
ThreePts_FGM_FGA2 <-  ThreePts_FGM_FGA2[c("Team","GM", "FG_3P_PG","FGA_3P_PG","Perc_3P","FG_3P","FG_3PA")]

#3PTS-DEF
ThreePts_Def <- read.csv2("3PTS-DEF.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(ThreePts_Def)
colnames(ThreePts_Def) <- c("Rank", "Team", "GM", "W-L", "Opp_3FGA","Opp_3FG","Pct")

ThreePts_Def2<- ThreePts_Def[ThreePts_Def$Team %in% NCAA_MM2021, ]
colnames(ThreePts_Def2) <- c("Rank", "Team", "GM", "W-L", "Opp_3FGA","Opp_3FG","Opp_3P_Pct")

ThreePts_Def2$Opp_3FG_PG <- round(ThreePts_Def2$Opp_3FG/ThreePts_Def2$GM,1)
ThreePts_Def2$Opp_3FGA_PG <- round(ThreePts_Def2$Opp_3FGA/ThreePts_Def2$GM,1)
ThreePts_Def2 <-  ThreePts_Def2[c("Team","Opp_3FG_PG","Opp_3FGA_PG","Opp_3P_Pct")]

#ASTS-TOsRatio
ASTS_TOsRatio <- read.csv2("ASTS-TOsRatio.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(ASTS_TOsRatio)
colnames(ASTS_TOsRatio) <- c("Rank", "Team", "GM", "W-L", "AST", "TO", "Ast_ToRatio")

ASTS_TOsRatio2<- ASTS_TOsRatio[ASTS_TOsRatio$Team %in% NCAA_MM2021, ]
colnames(ASTS_TOsRatio2) <- c("Rank", "Team", "GM", "W-L", "AST", "TO", "Ast_ToRatio")
ASTS_TOsRatio2 <-  ASTS_TOsRatio2[c("Team","Ast_ToRatio")]

#ASTS
ASTS <- read.csv2("ASTS.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(ASTS)
colnames(ASTS) <- c("Rank", "Team", "GM", "W-L","AST","APG")

ASTS_2<- ASTS[ASTS$Team %in% NCAA_MM2021, ]
colnames(ASTS_2) <- c("Rank", "Team", "GM", "W-L","AST","APG")
ASTS_2 <-  ASTS_2[c("Team","APG")]

#DEF-PPG
DEF_PPG <- read.csv2("DEF-PPG.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(DEF_PPG)
colnames(DEF_PPG) <- c("Rank", "Team", "GM", "W-L", "OPP-PTS", "OPP_PPG")

DEF_PPG2<- DEF_PPG[DEF_PPG$Team %in% NCAA_MM2021, ]
colnames(DEF_PPG2) <- c("Rank", "Team", "GM", "W-L", "OPP-PTS", "OPP_PPG")
DEF_PPG2 <- DEF_PPG2[c("Team", "OPP_PPG")]

#FG-DEF
FG_DEF <- read.csv2("FG-DEF.csv", header=T, sep=";", dec=",", stringsAsFactors = F)
head(FG_DEF)
colnames(FG_DEF) <- c("Rank", "Team", "GM", "W-L" , "OPP_FG", "OPP_FGA", "OPP_FG_Perc")

FG_DEF2<- FG_DEF[FG_DEF$Team %in% NCAA_MM2021, ]
colnames(FG_DEF2) <- c("Rank", "Team", "GM", "W-L" , "OPP_FG", "OPP_FGA", "OPP_FG_Perc")

FG_DEF2$OPP_FG_PG <- round(FG_DEF2$OPP_FG/FG_DEF2$GM,1)
FG_DEF2$OPP_FGA_PG <- round(FG_DEF2$OPP_FGA/FG_DEF2$GM,1)
FG_DEF2 <- FG_DEF2[c("Team","OPP_FG_Perc","OPP_FG_PG","OPP_FGA_PG")]

#FGM-FGMA-FG_Perc
FGM_FGMA  <- read.csv2("FGM-FGMA-FG%.csv", header=T, sep=";", dec=",", stringsAsFactors = F)
head(FGM_FGMA)
colnames(FGM_FGMA) <- c("Rank", "Team", "GM", "W-L", "FGM", "FGA", "FG_Perc")

FGM_FGMA2<- FGM_FGMA[FGM_FGMA$Team %in% NCAA_MM2021, ]
colnames(FGM_FGMA2) <- c("Rank", "Team", "GM", "W-L", "FGM", "FGA", "FG_Perc")

FGM_FGMA2$FGM_PG <- round(FGM_FGMA2$FGM/FGM_FGMA2$GM,1)
FGM_FGMA2$FGA_PG <- round(FGM_FGMA2$FGA/FGM_FGMA2$GM,1)
FGM_FGMA2 <- FGM_FGMA2[c("Team","FG_Perc", "FGM_PG", "FGA_PG", "FGM", "FGA")]


#FT
FT <- read.csv2("FT.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(FT)
colnames(FT) <- c("Rank", "Team", "GM", "W-L", "FT", "FTA", "FT_Perc")

FT_2<- FT[FT$Team %in% NCAA_MM2021, ]
colnames(FT_2) <- c("Rank", "Team", "GM", "W-L", "FT", "FTA", "FT_Perc")

FT_2$FT_PG <- round(FT_2$FT/FT_2$GM,1)
FT_2$FTA_PG <- round(FT_2$FTA/FT_2$GM,1)
FT_2 <- FT_2[c("Team","FT_PG", "FTA_PG", "FT_Perc")]

#Off-PPG
Off_PPG <- read.csv2("Off-PPG.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(Off_PPG)
colnames(Off_PPG) <- c("Rank", "Team", "GM", "W-L","PTS", "PPG")

Off_PPG2<- Off_PPG[Off_PPG$Team %in% NCAA_MM2021, ]
colnames(Off_PPG2) <- c("Rank", "Team", "GM", "W-L","PTS", "PPG")
Off_PPG2 <- Off_PPG2[c("Team","PPG")]

#PFoulsPerGame
PFoulsPerGame <- read.csv2("PFoulsPerGame.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(PFoulsPerGame)
colnames(PFoulsPerGame) <- c("Rank", "Team", "GM", "W-L", "Fouls", "PFPG", "DQ")

PFoulsPerGame_2<- PFoulsPerGame[PFoulsPerGame$Team %in% NCAA_MM2021, ]
colnames(PFoulsPerGame_2) <- c("Rank", "Team", "GM", "W-L", "Fouls", "PFPG", "DQ")
PFoulsPerGame_2<- PFoulsPerGame_2[c("Team","PFPG", "DQ")]

#REB_MARgin
REB_Margin <- read.csv2("REB-Margin.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(REB_Margin)
colnames(REB_Margin) <- c("Rank","Team","GM","W-L","REB","RPG","OPP_REB","OPP_RPG","REB_MAR")

REB_Margin2<- REB_Margin[REB_Margin$Team %in% NCAA_MM2021, ]
colnames(REB_Margin2) <- c("Rank","Team","GM","W-L","REB","RPG","OPP_REB","OPP_RPG","REB_MAR")
REB_Margin2<- REB_Margin2[c("Team","RPG","OPP_RPG","REB_MAR")]

#REBS
REBS <- read.csv2("REBS.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(REBS)
colnames(REBS) <- c("Rank","Team","GM","ORebs","DRebs", "REB", "RPG")

REBS_2<- REBS[REBS$Team %in% NCAA_MM2021, ]
colnames(REBS_2) <- c("Rank","Team","GM","ORebs","DRebs", "REB", "RPG")

REBS_2$OffRebsPG <- round(REBS_2$ORebs/REBS_2$GM,1)
REBS_2$DefRebsPG <- round(REBS_2$DRebs/REBS_2$GM,1)
head(REBS_2)

REBS_2 <- REBS_2[c("Team","OffRebsPG","DefRebsPG")]

#STEALS
STEALS <- read.csv2("STEALS.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(STEALS)
colnames(STEALS) <- c("Rank", "Team", "GM", "W-L", "ST", "STPG")

STEALS_2<- STEALS[STEALS$Team %in% NCAA_MM2021, ]
colnames(STEALS_2) <- c("Rank", "Team", "GM", "W-L", "ST", "STPG")
STEALS_2 <- STEALS_2[c("Team","STPG")]

#TO-Forced
TO_Forced<- read.csv2("TO-Forced.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(TO_Forced)
colnames(TO_Forced) <- c("Rank", "Team", "GM", "Opp-TO", "Avg")

TO_Forced2<- TO_Forced[TO_Forced$Team %in% NCAA_MM2021, ]
colnames(TO_Forced2) <- c("Rank", "Team", "GM", "Opp-TO", "Opp_TOAvg")
TO_Forced2 <- TO_Forced2[c("Team","Opp_TOAvg")]

#TO-Margin
TO_Margin<- read.csv2("TO-Margin.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(TO_Margin)
colnames(TO_Margin) <- c("Rank", "Team", "GM", "W-L", "Opp-TO", "TO", "ToRatioMarg")

TO_Margin2<- TO_Margin[TO_Margin$Team %in% NCAA_MM2021, ]
colnames(TO_Margin2) <- c("Rank", "Team", "GM", "W-L", "Opp-TO", "TO", "ToRatioMarg")
TO_Margin2 <- TO_Margin2[c("Team", "ToRatioMarg")]

#TO
TO <- read.csv2("TO.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(TO)
colnames(TO) <- c("Rank","Team", "GM", "W-L", "TO", "TOPG")

TO_2<- TO[TO$Team %in% NCAA_MM2021, ]
colnames(TO_2) <- c("Rank","Team", "GM", "W-L", "TO", "TOPG")
TO_2 <- TO_2[c("Team", "TOPG")]

#W-L
W_L<- read.csv2("W-L%.csv", header=T, sep=";", dec=",",stringsAsFactors = F)
head(W_L)
colnames(W_L) <- c("Rank", "Team", "W", "L", "Pct_W_L")

W_L2<- W_L[W_L$Team %in% NCAA_MM2021, ]
colnames(W_L2) <- c("Rank", "Team", "W", "L", "Pct_W_L")
W_L2 <- W_L2[c("Team", "W", "L", "Pct_W_L")]

#Regroupement de tous les stats des tous les équipes du March Madness
NCAA_ALL <- merge(ASTS_2, 
                  merge(ASTS_TOsRatio2, 
                        merge(DEF_PPG2,
                              merge(FG_DEF2,
                                    merge(FGM_FGMA2,
                                          merge(FT_2,
                                                merge(Off_PPG2,
                                                      merge(PFoulsPerGame_2, 
                                                            merge(REB_Margin2, 
                                                                  merge(REBS_2, 
                                                                        merge(STEALS_2,
                                                                              merge(ThreePts_Def2, 
                                                                                    merge(ThreePts_FGM_FGA2,
                                                                                          merge(TO_2,
                                                                                                merge(TO_Forced2,
                                                                                                      merge(TO_Margin2, W_L2, 
                                                                                                            by="Team"),
                                                                                                      by="Team"),
                                                                                                by="Team"),
                                                                                          by="Team"),
                                                                                    by="Team"),
                                                                              by="Team"),
                                                                        by="Team"),
                                                                  by="Team"),
                                                            by="Team"),
                                                      by="Team"),
                                                by="Team"),
                                          by="Team"),
                                    by="Team"),
                              by="Team"),
                        by="Team"))
head(NCAA_ALL)

#EFFECTIVE FG
NCAA_ALL$EFG <- ((FGM_FGMA2$FGM + ThreePts_FGM_FGA2$FG_3P*0.5)/FGM_FGMA2$FGA)*100

#Offense
NCAA_OFF <- NCAA_ALL[c("Team","APG","Ast_ToRatio","FG_Perc", "EFG", "FGM_PG", "FGA_PG", "FT_PG", 
                       "FTA_PG","FT_Perc", "PPG","RPG","OffRebsPG","Perc_3P",
                       "FG_3P_PG", "FGA_3P_PG", "ToRatioMarg", "W", "L", "Pct_W_L")]
head(NCAA_OFF)
#ACP sur le jeu de données: 
NCAA_OFF.acp <- princomp(formula= ~APG + Ast_ToRatio + FG_Perc + EFG + FGM_PG + FGA_PG + 
                                 FT_PG + FTA_PG + FT_Perc + PPG + RPG + OffRebsPG + Perc_3P +
                                 FG_3P_PG + FGA_3P_PG + ToRatioMarg + W + L + Pct_W_L,
                              data = NCAA_OFF, cor = T) 
# création du graphique des observations :  
plot(NCAA_OFF.acp$scores[,1], NCAA_OFF.acp$scores[,2], 
     type="n",xlab="Premier axe", ylab="Deuxieme axe", 
     main="ACP, Différentes valeurs offensives des équipes NCAA") 
abline(h=0,v=0) 
#Biplot avec la 8e colonne esc12 en plus (comme étiquette)
text(NCAA_OFF.acp$scores[,1],NCAA_OFF.acp$scores[,2], 
     labels=NCAA_OFF[,1],cex=0.5) 

#Corrélation et interprétation des CP
library(Hmisc)

correl_off <- rcorr(as.matrix(NCAA_OFF[, (2:20)]), as.matrix(NCAA_OFF.acp$scores))

library(corrplot)
corrplot(correl_off$r[c(1:16),c(17:21)],method="circle",type="full", 
         p.mat=correl_off$P[c(1:16),c(17:21)],sig.level=0.05,insig="pch",pch="*")

#Defense
NCAA_DEF <- NCAA_ALL[c("Team","OPP_PPG", "OPP_FG_Perc","OPP_FG_PG", "OPP_FGA_PG", "OPP_RPG",
                       "REB_MAR", "DefRebsPG","STPG","PFPG","Opp_3P_Pct","TOPG",
                       "Opp_TOAvg","Opp_3FG_PG","Opp_3FGA_PG","W", "L", "Pct_W_L")]
head(NCAA_DEF)
#ACP sur le jeu de données: 
NCAA_DEF.acp <- princomp(formula= ~OPP_PPG + OPP_FG_Perc + OPP_FG_PG + OPP_FGA_PG + OPP_RPG +
                          REB_MAR+ DefRebsPG + STPG + PFPG + Opp_3P_Pct + TOPG +
                         Opp_TOAvg + Opp_3FG_PG + Opp_3FGA_PG + W + L + Pct_W_L,
                         data = NCAA_DEF, cor = T) 
# création du graphique des observations :  
plot(NCAA_DEF.acp$scores[,1], NCAA_DEF.acp$scores[,2], 
     type="n",xlab="Premier axe", ylab="Deuxieme axe", 
     main="ACP, Différentes valeurs défensives des équipes NCAA") 
abline(h=0,v=0) 
#Biplot avec la 8e colonne esc12 en plus (comme étiquette)
text(NCAA_DEF.acp$scores[,1],NCAA_DEF.acp$scores[,2], 
     labels=NCAA_DEF[,1],cex=0.5) 

#Corrélation et interprétation des CP
library(Hmisc)

correl_def <- rcorr(as.matrix(NCAA_DEF[, (2:18)]), as.matrix(NCAA_DEF.acp$scores))

library(corrplot)
corrplot(correl_def$r[c(1:14),c(15:19)],method="circle",type="full",
         p.mat=correl_def$P[c(1:14),c(15:19)],sig.level=0.05,insig="pch",pch="*")

#Miscellaneous
NCAA_Misc <- NCAA_ALL[c("GM","DQ")]

#ACP Offense et Defense
NCAA_OFF_DEF <- NCAA_ALL[c("Team","APG","Ast_ToRatio","FG_Perc", "EFG", "FGM_PG", "FGA_PG", 
                           "FT_PG","FTA_PG","FT_Perc", "PPG","RPG","OffRebsPG","Perc_3P",
                           "FG_3P_PG","FGA_3P_PG", "ToRatioMarg","OPP_PPG","OPP_FG_Perc",
                           "OPP_FG_PG", "OPP_FGA_PG", "OPP_RPG","REB_MAR","DefRebsPG",
                           "STPG","PFPG","Opp_3P_Pct","TOPG","Opp_TOAvg","Opp_3FG_PG",
                           "Opp_3FGA_PG","W", "L", "Pct_W_L")]
#ACP sur le jeu de données: 
NCAA_OFF_DEF.acp <- princomp(formula= ~APG + Ast_ToRatio + FG_Perc + EFG + FGM_PG + FGA_PG +
                                     FT_PG + FTA_PG + FT_Perc + PPG + RPG + OffRebsPG + 
                                     Perc_3P + FG_3P_PG +
                           FGA_3P_PG + ToRatioMarg + OPP_PPG + OPP_FG_Perc + OPP_FG_PG + 
                           OPP_FGA_PG + OPP_RPG + REB_MAR+ DefRebsPG + STPG + PFPG + 
                           Opp_3P_Pct + TOPG + Opp_TOAvg + Opp_3FG_PG + Opp_3FGA_PG + W + L + Pct_W_L, 
                         data = NCAA_OFF_DEF, cor = T) 
# création du graphique des observations :  
plot(NCAA_OFF_DEF.acp$scores[,1], NCAA_OFF_DEF.acp$scores[,2], 
     type="n",xlab="Premier axe", ylab="Deuxieme axe", 
     main="ACP, Différentes valeurs offensives et défensive des équipes NCAA") 
abline(h=0,v=0) 
#Biplot avec la 8e colonne esc12 en plus (comme étiquette)
text(NCAA_OFF_DEF.acp$scores[,1],NCAA_OFF_DEF.acp$scores[,2], 
     labels=NCAA_OFF_DEF[,1],cex=0.5) 

#Corrélation et interprétation des CP
library(Hmisc)

correl_off_def <- rcorr(as.matrix(NCAA_OFF_DEF[, (2:34)]), as.matrix(NCAA_OFF_DEF.acp$scores))

library(corrplot)
corrplot(correl_off_def$r[c(1:30),c(31:35)],method="circle",type="full", 
         p.mat=correl_off_def$P[c(1:30),c(31:35)],sig.level=0.05,insig="pch",pch="*")


NCAA_OFF$FG_Perc[NCAA_OFF$Team=="Michigan (Big Ten)"]
NCAA_OFF$FGM_PG[NCAA_OFF$Team=="Michigan (Big Ten)"]
NCAA_OFF$PPG[NCAA_OFF$Team=="Michigan (Big Ten)"]

NCAA_OFF$FG_Perc[NCAA_OFF$Team=="LSU (SEC)"]
NCAA_OFF$FGM_PG[NCAA_OFF$Team=="LSU (SEC)"]
NCAA_OFF$PPG[NCAA_OFF$Team=="LSU (SEC)"]

subset(NCAA_OFF,NCAA_OFF$Team=="Michigan (Big Ten)")
subset(NCAA_OFF,NCAA_OFF$Team=="LSU (SEC)")

subset(NCAA_DEF,NCAA_DEF$Team=="Michigan (Big Ten)")
subset(NCAA_DEF,NCAA_DEF$Team=="LSU (SEC)")

library(factoextra)
get_eig(NCAA_OFF.acp)
get_eig(NCAA_DEF.acp)
get_eig(NCAA_OFF_DEF.acp)





