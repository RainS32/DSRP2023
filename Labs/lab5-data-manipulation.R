library(dplyr)
library(ggplot2)

getwd()
nba <- read.csv("Datasets/championsdata.csv")
nba$Team[df$col == ‘sth’] <- 
View(nba)

#filtering the observations of your dataset based on one or more variable using filter()
lakersCeltics <- filter(nba, Team == c("Lakers", "Celtics"))

#create a smaller dataset with a subset of variables using select()
newNBA <- select(nba, Team, Win, PTS, FG, FGP, TP, TPP, FT, FTP)       

#Add 2 new columns to your dataset using mutate()
newNBA <- mutate(newNBA,
       Team_ppg = mean(PTS, na.rm = T),
       .by = Team)

newNBA <- mutate(newNBA,
       Team_sum_wins = sum(Win, na.rm = T),
       .by = Team)

#Create a data table of grouped summaries on at least one numeric variable by at least 
#one categorical variable using summarize()
summarize(newNBA,
          Team_ppg = mean(PTS, na.rm = T),
          count = n(),
          .by = Team)
