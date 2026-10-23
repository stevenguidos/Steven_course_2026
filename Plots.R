ggplot(
  penguins_clean,
  aes(
    x = flipper_len,
    y = body_mass_kg,
    color = species
  )
) +
  geom_point(size = 2, alpha = 0.7) +
  labs(
    title = "Penguin body mass vs flipper length",
    x = "Flipper length (mm)",
    y = "Body mass (kg)",
    color = "Species"
  ) +
  theme_minimal()
