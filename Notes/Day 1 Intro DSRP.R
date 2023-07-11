2+2
number <- 5
number
number + 1
number <- number + 1

#this is a comment
number <- 10 #set number to 10

# R Objects ####
ls() #print the names of all objects in our enviornment
rm("number") # removes objects

number <- 5
decimal <- 1.5

letter <- "a"
word <- "hello"

logic <- TRUE
logic2 <- FALSE

## types of variables
## there are 3 main classes: numeric, character, and logical
class(number)
class(decimal) #numeric

class(letter) #character
class(word)

class(logic) #logical

## there is more variation in types
typeof(number)
typeof(decimal)

typeof(letter)
typeof(word)

typeof(logic)

## we can change the type of an object
as.character(number)
as.integer(number)
as.integer(decimal)

## how to round number
round(decimal) #less than 0.5, rounds down. Greater than or equal to 0.5, rounds up
round(22/7, 3) #3 values after the decimal
?round

22/7
ceiling(22/7) #ceiling always rounds up
floor(22/7) #floor always rounds down

?as.integer
as.integer("hello")
word_as_int <- as.integer("hello")

## NA values
NA + 5

## naming
name<- "Sarah"
NAME <- "Joe"
n.a.m.e <- "Sam"
n_a_m_e <- "Lisa"
name <- "Bob"

## illegal naming characters:
# starting with a number
# starting with an underscore
# operators: +, -, /, *
# conditional: &, |, <, >, !
# others: \ , /, space

## good naming conventions
camelCase <- "start with capital letter"
snake_case<- "undersocres between words"


## Object manipulation ####
number 
number + 7

decimal
number + decimal

name
paste(name, "parker", "is", "awesome")
paste(name, 5) # concatenate character vectors
paste("Programming", "with", "R", sep="_")

logic <- T
paste0(name, logic)


?grep
food <- "watermelon"
grepl("me", food)

## substituing characters in words
sub("me", "_", food)
sub("me", "you", food)
sub("me", "", food)


# Vectors ####

# make a vector of numerics
numbers <- c(2,4,6,8,10)
range_of_vals <- 1:5 #all integers from 1 to 5
5:10 #all integers from 5 to 10
seq(2, 10, 2) #from 2 to 10 by 2's
seq(from = 2, to = 10, by = 2)
seq(by = 2, from = 2, to = 10) #can put parameters out of order if they are named
seq(from = 2, to = 9, by = 2)

seq(from = 1, to = 5, by = 0.5)

c(rep(1,3),rep(2,3))

rep(1:2, each=3)

rep(3, 5) #repeat 3 5 times
rep(c(1,2),5) #repeats 1,2 5 times

#make a vector of characters
letters <- c("a", "b", "c")
letters
paste("a", "b", "c") #paste() is different from c()

letters <- c(letters, "d")
letters
letter
letters <- c(letters, letter)
letters
letters <- c("x", letters, "w")

numbers <- c(seq(1,20,1))
numbers <- 1:20
five_nums <- sample(numbers, 5) # choose 5 values from the vector numbers

five_nums <- sort(five_nums)
five_nums <- rev(five_nums)


fifteen_nums <- sample(numbers, 15, replace = T)
fifteen_nums <- sort(fifteen_nums)
length(fifteen_nums) # length of a vector
unique(fifteen_nums) # what are the unique values in the vector

length(unique(fifteen_nums))

table(fifteen_nums) # get the count of values in the vector

fifteen_nums

fifteen_nums + 5
fifteen_nums/2

nums1 <- c(1,2,3)
nums2 <- c(4,5,6)
nums1 + nums2 # values are added together element-wise

nums3 <- c(nums1, nums2)
nums3 + nums1 #values are recycled to add together
nums3 + nums1 + 1

sum(nums3 + 1)
sum(nums3) + 1

# Vector Indexing 
numbers <- rev(numbers)
numbers
numbers[1]
numbers[5]

numbers[c(1,2,3,4,5)]
numbers[1:5]
numbers[c(1,5,2,12)]
i <- 5
numbers[i]

# Datasets ####
?mtcars
mtcars # print entire dataset to console

View(mtcars) # view entire dataset in a new tab

summary(mtcars) # gives us information about the spread of each variable
str(mtcars) # preview the structure of the dataset

names(mtcars) #names of variables
head(mtcars, 10) # preview the first number of rows

## Pull out individual variables as vectors
mpg <- mtcars[,1] #blank means "all". All rows first, first column
mtcars[2,2] # value at second row. second column
mtcars[3,] # third row, all columns
mtcars["mpg"]

#first 3 columns
mtcars[,1:3]

# use the names to pull out columns
mtcars$gear # pull out the "gear" column
mtcars[,c("gear", "mpg")] # pull out the gear and mpg columns

sum(mtcars$gear)


# Statistics ####
View(iris)
first5 <- iris[1:5,1]

mean(first5)
mean(iris[,1])
median(first5)
median(iris[,1])

max(first5) - min(first5)
range(first5)
max(iris[,1]) - min(iris[,1])

var(iris[,1])
sd(first5)
sqrt(var(first5))
sd(iris[,1])

## IQR
IQR(first5) # range
quantile(first5, 0.25) #Q1
quantile(first5, 0.75) #Q3

## outliers
upper <- mean(iris[,1]) + 3*sd(iris[,1])
lower <- mean(iris[,1]) - 3*sd(iris[,1])

quantile(iris[,1], 0.25) - 1.5*IQR(iris[,1])
quantile(iris[,1], 0.75) + 1.5*IQR(iris[,1])

## subsetting vectors
first5
first5 < 4.75
first5[first5 < 4.75]

values <- c(first5,3,9)

#removes outliers
values_no_outliers <- values[values > lower & values < upper]

## read in data
getwd() # get working directory
read.csv("data/DSRP2023/super_hero_powers.csv")

## Conditionals ####
x <- 5 # set x to 5
x < 3
x > 3
x == 3
x == 5
x != 3

numbers <- 1:5

numbers < 3
numbers == 3

numbers[1]
numbers[c(1,2)]
numbers[1:2]

numbers[numbers < 3] # numbers "where" numbers < 3

# outlier thresholds
lower <- 2
upper <- 4

#pull out only outliers
numbers[numbers < lower]
numbers[numbers > upper]

#combine with | (or)
numbers[numbers < lower | numbers > upper]

#use & to get all values in between outlier thresholds
numbers[numbers >= lower & numbers <= upper]

#using & with outlier thresholds doesn't work
numbers[numbers < lower & numbers > upper]

## NA values
NA #unknown
NA + 5

sum(1,2,3,NA) #returns NA if any value is NA
sum(1,2,3,NA, na.rm = T)


mean(c(1,2,3,NA), na.rm = T)
