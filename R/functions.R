clean_penguins <- function(data) {
  
  data |>
    dplyr::filter(
      !is.na(body_mass),
      !is.na(flipper_len)
    ) |>
    dplyr::mutate(
      body_mass_kg = body_mass / 1000
    )
  
}

# Check to see if it works as intended
penguins_clean <- clean_penguins(penguins)
head(penguins_clean)
