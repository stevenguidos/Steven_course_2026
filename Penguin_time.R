#install the following packages if needed
install.packages(c(
  "palmerpenguins",
  "tidyverse",
  "targets",
  "tarchetypes",
  "renv",
  "quarto",
  "usethis"
))

library(tidyverse)
library(targets)
library(tarchetypes)
library(renv)
library(quarto)
library(usethis)

# We can just use the penguin package for our analyses, since penguins are cool :)
# Just in case somebody has trouble getting their hands on the penguin data, save
# it as a csv on the github page so they can access it there
write.csv(
  penguins,
  "data/penguins.csv",
  row.names = FALSE
)

head(penguins)

# Now we can do some basic cleaning
# Remove penguins with missing body mass or flipper measurements and convert
# body mass from grams to kilograms.

penguins_clean <- penguins |>
  drop_na(body_mass, flipper_len) |>
  mutate(
    body_mass_kg = body_mass / 1000
  )

head(penguins_clean)

# Now we can make this cleaning script into a function in the "functions.R" script


