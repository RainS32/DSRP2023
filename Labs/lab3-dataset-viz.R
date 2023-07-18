library(ggplot2)
nba <- read.csv("DSRP2023/Datasets/championsdata.csv")
str(nba)

## clean
nba[nba == "Warriorrs"] <- "Warriors"
nba[nba == "'Heat'"] <- "Heat"

## 1 Variable ####
ggplot(data = nba, aes(x = PTS)) + 
  geom_histogram(fill = "#28e6f7") + 
  labs(x = "Points Scored",
       y = "# of times",
       title = "Distribution of Points Scored")

## Numeric vs Categorical ####
ggplot(data = nba, aes(x = Team, y = PTS, fill = Team)) + 
  geom_violin(width = 1.5) + 
  geom_boxplot(width = 0.25) + 
  labs(x = "Team",
       y = "Points Scored",
       title = "Distribution of PTS Scored by Team") + 
  theme(axis.text.x = element_text(angle = 45))

## Numeric vs Numeric ####
ggplot(data = nba, aes(x = PTS, y = FGP)) + 
  geom_point(aes(color = Team)) + 
  geom_smooth() +
  labs(x = "Points Scored",
       y = "Field Goal %",
       title = "Distribution of Points Scored  Field Goal %")
