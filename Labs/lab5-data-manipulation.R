library(dplyr)
library(ggplot2)

getwd()
nba <- read.csv("Datasets/championsdata.csv")
View(nba)

## clean
nba[nba == "Warriorrs"] <- "Warriors"
nba[nba == "'Heat'"] <- "Heat"

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
summarizeNBA <- summarize(newNBA,
          Team_ppg = mean(PTS, na.rm = T),
          count = n(),
          .by = Team)

#Reorder a data table of your choice by one or more variables using arrange()
reorderNBA <- arrange(newNBA, Team, desc(PTS))

#Create at least one new visualization using some form of an updated dataset
ggplot(data = newNBA, aes(x = FGP, y = Win)) + 
  geom_point(aes(color = Team)) + 
  geom_smooth() +
  labs(x = "Field Goal %",
       y = "Win",
       title = "Distribution of Wins by FG%")

