library(tidyr)
library(janitor)
library(dplyr)
library(ggplot2)

getwd()
nba <- read.csv("Datasets/championsdata.csv")
View(nba)

## clean
nba[nba == "Warriorrs"] <- "Warriors"
nba[nba == "'Heat'"] <- "Heat"

## T-test ####

## Compare the total rebounds per game between the lakers and the celtics
## null hypothesis: average total rebounds per game between the lakers and the celtics is the same
## alternative hypothesis: average total rebounds per game between the lakers and the celtics is different

lakers <- nba |> filter(Team == "Lakers")
celtics <- nba |> filter(Team == "Celtics")

t.test(lakers$TRB, celtics$TRB, paired = F, alternative = "two.sided")

## ANOVA ####

## Compare the total assists per game between the lakers, bulls, and spurs
## null hypothesis: average total assists per game of between the lakers, bulls, and the spurs is the same
## alternative hypothesis: average total rebounds per game of between the lakers, bulls, and the spurs is different

top3teams <- nba |>
  summarize(.by = Team,
            count = sum(!is.na(Team))) |>
  slice_max(count, n = 3)

top3teams 

nba_top3teams <- nba |>
  filter(Team %in% top3teams$Team)

a <- aov(AST ~ Team, data = nba_top3teams)
summary(a)
TukeyHSD(a)

## Chi-Square ####

## Compare whether points scored and assists are related
##Null Hypothesis: Points scored is independent from assists
##Alternate Hypothesis: Points scored is associated with assists (or not independent)

con_table <- table(nba$AST, nba$PTS)
results <- chisq.test(con_table)
