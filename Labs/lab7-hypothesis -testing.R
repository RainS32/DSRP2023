library(tidyr)
library(janitor)
library(dplyr)
library(ggplot2)

getwd()
nba <- read.csv("DSRP2023/Datasets/championsdata.csv")
View(nba)

## Compare the total rebounds per game between the lakers and the celtics
## null hypothesis: average total rebounds per game of between the lakers and the celtics is the same
## alternative hypothesis: average total rebounds per game of between the lakers and the celtics is different
lakers <- nba |> filter(Team == "Lakers")
celtics <- nba |> filter(Team == "Celtics")

t.test(lakers$TRB, celtics$TRB, paired = F, alternative = "two.sided")
