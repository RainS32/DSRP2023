## install required packages
install.packages("janitor")
install.packages("tidyr")

## load required packages
library(tidyr)
library(janitor)
library(dplyr)

starwars
clean_names(starwars, case = "small_camel")
new_starwars <- clean_names(starwars, case = "small_camel")
clean_names(starwars, case = "upper_lower")

clean_names(new_starwars)

#StarWarsWomen <- select(arrange(filter(starwars, sex == "female"), birth_year), name, species)
StarWarsWomen <- filter(starwars, sex == "female")
StarWarsWomen <- arrange(StarWarsWomen, birth_year)
StarWarsWomen <- select(StarWarsWomen, name, species)

## using pipes
StarWarsWomen <- starwars |> 
  filter(sex == "female") |> 
  arrange(birth_year) |> 
  select(name, species)

## slicing
tallest <- slice_max(starwars, height, n = 2, by = species, with_ties = F) #top 2 tallest of each species

## tidy data ####
##pivot longer
table4a

tidy_table_4a <- pivot_longer(table4a,
                              cols = c(`1999`, `2000`),
                              names_to = "year", 
                              values_to = "cases")

table4b # shows population data

tidy_table_4b <- pivot_longer(table4b,
                              cols = c(`1999`, `2000`),
                              names_to = "year", 
                              values_to = "population")

## pivot wider
table2

pivot_wider(table2,
            names_from = type,
            values_from = count)

## separate
table3

separate(table3,
         rate,
         into = c("cases", "population"),
         sep = "/")

##unite
table5

tidy_table5 <- unite(table5,
                     "year",
                     c("century", "year"),
                     sep = "")

tidy_table5 <- table5 |>
  unite("year",
        c("century", "year"),
        sep = "") |>
  separate(rate,
           into = c("cases", "population"),
           sep = "/")

## bind rows
new_data <- data.frame(country = "USA", year = "1999,", cases = "1042", population = "3.5")

bind_rows(tidy_table5, new_data)