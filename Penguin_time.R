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

write.csv(
  penguins,
  "data/penguins.csv",
  row.names = FALSE
)

