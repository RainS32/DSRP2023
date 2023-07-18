#install.packages("xgboost")
#install.packages("ranger")
library(dplyr)
library(ggplot2)
library(rsample)
library(parsnip)

## Unsupervised Learning ####
## Principal Components Analysis 
head(iris)

## remove any non-numeric variables
iris_num <- select(iris, -Species)
iris_num

## do PCA
pcas <- prcomp(iris_num, scale. = T)
summary(pcas)
pcas$rotation

pcas$rotation^2

## get the x values of PCAs and make it a data frame
pca_vals <- as.data.frame(pcas$x)
pca_vals$Species <- iris$Species

ggplot(pca_vals, aes(PC1, PC2, color = Species)) +
  geom_point() +
  theme_minimal()

  
### Supervised Machine Learning Models ####

## load required packages
library(dplyr)

## Step 1: Collect Data
head(iris)

## Step 2: Clean and Process Data
## Get rid of NAs

# Remove rows that contain NA
# Only use na.omit when you have specifically selected for the
# variables you want to include in the model
noNAs <- na.omit(starwars)

noNAs <- filter(starwars, !is.na(mass), !is.na(height))

# Replace with means
replaceWithMeans <- mutate(starwars,
                           mass = ifelse(is.na(mass),
                                         mean(mass),
                                         mass))

## Encoding categories as factors or integers
# If categorical variable is a character, make it a factor
intSpecies <- mutate(starwars,
                     species = as.integer(as.factor(species)))

# If categorical variable is already a factor, make it an integer
irisAllNumeric <- mutate(iris,
                         Species = as.integer(Species))

## Step 3: Visualize Data
# Make a PCA
# Calculate Correlations
library(reshape2)
library(ggplot2)

cor(irisAllNumeric)

irisCors <- irisAllNumeric |>
  cor() |>
  melt() |>
  as.data.frame()

ggplot(irisCors, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white",
                       midpoint = 0)

# high correlation?
ggplot(irisAllNumeric, aes(x = Petal.Length, y = Sepal.Length)) +
  geom_point() +
  theme_minimal()

# low correlation?
ggplot(irisAllNumeric, aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point() +
  theme_minimal()

## Step 4: Perform Feature Selection
# Choose which variables you want to classify or predict
# Choose which variables you want to use as features in your model
# For iris data...
# Classify on Species (Classification) & Predict on Sepal.Length (Regression)


## Step 5: Separate Data into Testing and Training Sets
# Choose 70-85% of data to train on
library(rsample)

## Set a seed for reproducability
set.seed(71723)

## Regression dataset splits
# Create a split
reg_split <- initial_split(irisAllNumeric, prop = .75) # use 75% of data for training

# Use the split to form testing and training sets
reg_train <- training(reg_split)
reg_test <- testing(reg_split)


## Classification dataset splits (use iris instead of irisAllNumeric)
class_split <- initial_split(iris, prop = 0.75)
  
class_train <- training(class_split)
class_test <- testing(class_split)


## Steps 6 & 7: Choose a ML model and train it
library(parsnip)

## Linear Regression
lm_fit <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ Petal.Length + Petal.Width + Species + Sepal.Width,
      data = reg_train)

## Sepal.Length = 2.3 + Petal.Length*0.7967 + Petal.Width*-0.4067 + Species*-0.3312 + Sepal.Width*0.5501 
 
lm_fit$fit
summary(lm_fit$fit)


## Logistic Regression
# For logistic regression,
# 1. Filter data to only 2 groups in categorical variable of interest
# 2. Make the categorical variable a factor
# 3. Make your training and testing splits

# For our purposes, we are just going to filter test and training (don't do this)
binary_test_data <- filter(class_test, Species %in% c("setosa", "versicolor"))
binary_train_data <- filter(class_train, Species %in% c("setosa", "versicolor"))

# Build the model
log_fit <- logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification") |>
  fit(Species ~ Petal.Width + Petal.Length + ., data = binary_train_data)

log_fit$fit
summary(log_fit$fit)


## Boosted Decision Trees
# regression
boost_reg_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

boost_reg_fit$fit$evaluation_log

# classification
# Use "classification" as the mode, and use Species as the predictor (independent) variable
# Use class_train as the data

boost_class_fit <- boost_tree() |>
  set_engine("xgboost") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

boost_class_fit$fit$evaluation_log


## Random Forest
# regression
forest_reg_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("regression") |>
  fit(Sepal.Length ~ ., data = reg_train)

forest_reg_fit$fit

# classification
forest_class_fit <- rand_forest() |>
  set_engine("ranger") |>
  set_mode("classification") |>
  fit(Species ~ ., data = class_train)

forest_class_fit$fit

## Step 8: Evaluate Model Performance on Test Set
# Calculate errors for regression
library(yardstick)
#lm_fit, boost_reg_fit, forest_reg_fit
reg_results <- reg_test

reg_results$lm_pred <- predict(lm_fit, reg_test)$.pred
reg_results$boost_pred <- predict(boost_reg_fit, reg_test)$.pred
reg_results$forest_pred <- predict(forest_reg_fit, reg_test)$.pred

yardstick::mae(reg_results, Sepal.Length, lm_pred)
yardstick::mae(reg_results, Sepal.Length, boost_pred)
yardstick::mae(reg_results, Sepal.Length, forest_pred)

yardstick::rmse(reg_results, Sepal.Length, lm_pred)
yardstick::rmse(reg_results, Sepal.Length, boost_pred)
yardstick::rmse(reg_results, Sepal.Length, forest_pred)


# Calculate accuracy for classification models
#install.packages("Metrics")
library(Metrics)
class_results <- class_test

class_results$log_pred <- predict(log_fit, class_test)$.pred_class
class_results$boost_pred <- predict(boost_class_fit, class_test)$.pred_class
class_results$forest_pred <- predict(forest_class_fit, class_test)$.pred_class

#f1(class_results$Species, class_results$log_pred)
#f1(class_results$Species, class_results$boost_pred)
#f1(class_results$Species, class_results$forest_pred)

class_results$Species == "setosa"
class_results$log_pred == "setosa"

f1(class_results$Species == "verginica", class_results$log_pred == "virginica")



