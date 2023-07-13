## Compare the mass of male and female human star wars characters?
## null hypothesis: average mass of male and female star wars characters is the same
## alternative hypothesis: average mass of male and female star wars characters is different

swHumans <- starwars |> filter(species == "Human", mass > 0)
males <- swHumans |> filter(sex == "male")
females <- swHumans |> filter(sex == "female")

t.test(males$mass, females$mass, paired = F, alternative = "two.sided")
# p value is 0.06
# not significant, failed to reject null hypothesis