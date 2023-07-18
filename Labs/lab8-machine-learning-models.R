library(reshape2)
library(ggplot2)

getwd()
nba <- read.csv("Datasets/championsdata.csv")
View(nba)

## clean
nba[nba == "Warriorrs"] <- "Warriors"
nba[nba == "'Heat'"] <- "Heat"

## remove any non-numeric variables
nba_num <- select(nba, -Team)
nba_num

## remove any NAs
noNAs <- na.omit(nba_num)

## calculate mean, replace NA values
meanTPP <- mean(noNAs$TPP)
replaceWithMeans <- mutate(nba_num,
                           TPP = ifelse(is.na(TPP),
                                        meanTPP,
                                        TPP))

## do PCA
pcas <- prcomp(replaceWithMeans, scale. = T)
summary(pcas)
pcas$rotation

variancePercentages <- as.data.frame(pcas$rotation^2)
arrange(variancePercentages, desc(PC1))

## get the x values of PCAs and make it a data frame

#bind_cols(ds1, ds2["TPP"])
Team <- nba$Team

new_nba <- cbind(replaceWithMeans, Team)

pca_vals <- as.data.frame(pcas$x)
pca_vals$Team <- new_nba$Team

ggplot(pca_vals, aes(PC1, PC2, color = Team)) +
  geom_point() +
  theme_minimal()

## Calculate Correlations

nbaAllNumeric <- mutate(new_nba,
                     Team = as.integer(as.factor(Team)))

cor(nbaAllNumeric)

nbaCors <- nbaAllNumeric |>
  cor() |>
  melt() |>
  as.data.frame()

ggplot(nbaCors, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white",
                       midpoint = 0) +
  theme(axis.text.x = element_text(angle = 45))

# high correlation?
ggplot(nbaAllNumeric, aes(x = FGP, y = PTS)) +
  geom_point() +
  theme_minimal()

# low correlation?
ggplot(nbaAllNumeric, aes(x = TPP, y = PTS)) +
  geom_point() +
  theme_minimal()

## Separate Data into Testing and Training Sets
library(rsample)

# Set a seed for reproducability
set.seed(71723)

# Regression dataset splits
reg_split <- initial_split(nbaAllNumeric, prop = 0.75) # use 75% of data for training

# Use the split to form testing and training sets
reg_train <- training(reg_split)
reg_test <- testing(reg_split)


# Classification dataset splits (use nba instead of nbaAllNumeric)
class_split <- initial_split(new_nba, prop = 0.75)

class_train <- training(class_split)
class_test <- testing(class_split)

## Choose a ML model and train it
library(parsnip)

## Boosted Decision Trees
# regression
boost_reg_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("regression") |>
  fit(PTS ~ ., data = reg_train)

boost_reg_fit$fit$evaluation_log

# classification
# Use "classification" as the mode, and use Species as the predictor (independent) variable
# Use class_train as the data

boost_class_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("classification") |>
  fit(as.factor(Team) ~ ., data = class_train)

boost_class_fit$fit$evaluation_log


## Random Forest
# regression
forest_reg_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("regression") |>
  fit(PTS ~ ., data = reg_train)

forest_reg_fit$fit

# classification
forest_class_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("classification") |>
  fit(as.factor(Team) ~ ., data = class_train)

forest_class_fit$fit

# Calculate accuracy for classification models
#install.packages("Metrics")
#install.packages("caret")
library(Metrics)
library(MLmetrics)
library(caret)

class_results <- class_test

class_results$boost_pred <- predict(boost_class_fit, class_test)$.pred_class
class_results$forest_pred <- predict(forest_class_fit, class_test)$.pred_class

f1(class_results$Team, class_results$boost_pred)
f1(class_results$Team, class_results$forest_pred)

f1(class_results$Team == "Pistons", class_results$boost_pred == "Pistons")
f1(class_results$Team == "Rockets", class_results$forest_pred == "Rockets")

## Calculate errors for regression
library(yardstick)
#lm_fit, boost_reg_fit, forest_reg_fit
reg_results <- reg_test

reg_results$boost_pred <- predict(boost_reg_fit, reg_test)$.pred
reg_results$forest_pred <- predict(forest_reg_fit, reg_test)$.pred

yardstick::mae(reg_results, PTS, boost_pred)
yardstick::mae(reg_results, PTS, forest_pred)

yardstick::rmse(reg_results, PTS, boost_pred)
yardstick::rmse(reg_results, PTS, forest_pred)


