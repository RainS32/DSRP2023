## install required packages
##install.packages("ggplot2")
install.packages(c("usethis", "credentials"))

install.packages("Rtools")

## load required packages
library(ggplot2)

?ggplot2

## mpg dataset
?mpg
str(mpg)

ggplot(data = mpg, aes(x = hwy, y = cty)) + geom_point() + 
  labs(x = "highway mpg",
       y = "city mpg",
       title = "car city vs highway milage")

## historgam
ggplot(data = mpg, aes(x = hwy)) + geom_histogram()

str(iris)
?iris

# We can set the number of bars with "bins"
ggplot(data = iris, aes(x = Sepal.Length)) + geom_histogram(bins = 30) + 
  labs(x = "Sepal Length",
       y = "# of flowers",
       title = "Sepal Length vs # of flowers")

# We can set the size of bars with "binwidth"
ggplot(data = iris, aes(x = Sepal.Length)) + geom_histogram(binwidth = 0.25)

## density
ggplot(data = iris, aes(x = Sepal.Length, y = after_stat(count))) + geom_density() + 
  labs(x = "Sepal Length",
       y = "# of flowers",
       title = "Frequency of Iris Sepal Lengths")

## box plot
ggplot(data = iris, aes(x = Sepal.Length)) + geom_boxplot()

ggplot(data = iris, aes(y = Sepal.Length)) + geom_boxplot()

ggplot(data = iris, aes(x = Sepal.Length, y = Species)) + geom_boxplot()

## violin and boxplot
ggplot(data = iris, aes(x = Species, y = Sepal.Length)) + geom_violin() + 
  geom_boxplot(width = 0.2) + 
  labs(x = "Species",
       y = "Sepal Length",
       title = "Distribution of Iris Sepal Lengths by Species")

## colors
colors()
ggplot(data = iris, aes(x = Species, y = Sepal.Length)) + 
  geom_violin(color = "blue", fill = "seagreen1") + 
  geom_boxplot(width = 0.2) + 
  labs(x = "Species",
       y = "Sepal Length",
       title = "Distribution of Iris Sepal Lengths by Species")

## barplot
ggplot(data = iris, aes(x = Species, y = Sepal.Length, fill = Species)) + 
  geom_bar(stat = "summary", fun = "mean") + 
  labs(x = "Species",
       y = "Sepal Length",
       title = "Distribution of Iris Sepal Lengths by Species")

## scatterplots
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + 
  labs(x = "Sepal Length",
       y = "Sepal Width",
       title = "Distribution of Iris Sepal Lengths by Species")

ggplot(data = iris, aes(x = Species, y = Sepal.Length)) + 
  geom_jitter(width = 0.25) + 
  labs(x = "Species",
       y = "Sepal Length",
       title = "Distribution of Iris Sepal Lengths by Species")

## lineplots
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + 
  geom_line(stat = "summary", fun = "mean") + 
  labs(x = "Sepal Length",
       y = "Sepal Width",
       title = "Distribution of Iris Sepal Lengths by Species")

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + 
  geom_smooth(se = F) +
  labs(x = "Sepal Length",
       y = "Sepal Width",
       title = "Distribution of Iris Sepal Lengths by Species")

## color scales
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(color = Species)) + 
  scale_color_manual(values = c("red", "green", "blue")) +
  labs(x = "Sepal Length",
       y = "Sepal Width",
       title = "Distribution of Iris Sepal Lengths by Species")

## factors
mpg$year <- as.factor(mpg$year)

iris$Species <- factor(iris$Species, levels = c("versicolor", "setosa", "virginica"))
