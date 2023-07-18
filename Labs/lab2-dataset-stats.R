getwd() # get working directory
df <- read.csv("Datasets/championsdata.csv")
str(df)
View(df)

## clean
df[df == "Warriorrs"] <- "Warriors"
df[df == "'Heat'"] <- "Heat"

mean <- mean(df$PTS)
median <- median(df$PTS)
range <- max(df$PTS) - min(df$PTS)
variance <- var(df$PTS)
sd <- sd(df$PTS)
IQR <- IQR(df$PTS)

upper <- mean(df$PTS) + 3*sd(df$PTS)
lower <- mean(df$PTS) - 3*sd(df$PTS)

values <- df$PTS
values_no_outliers <- values[values > lower & values < upper]
values2 <- c(values, seq(142,180,2), seq(0,60,2))

mean2 <- mean(values2)
median2 <- median(values2)
range2 <- max(df$PTS) - min(values2)
variance2 <- var(values2)
sd2 <- sd(values2)
IQR2 <- IQR(values2)

upper2 <- mean(df$PTS) + 3*sd(values2)
lower2 <- mean(df$PTS) - 3*sd(values2)
