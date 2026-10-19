# ML103 checkpoint: end of episode 06 (Visualise with ggplot2)
# Copy this file to your ml103-penguins/ project as analysis.R and carry on.
# Runs on its own from a fresh R session.

library(tidyverse)
library(palmerpenguins) # load AFTER tidyverse; masks datasets::penguins on R >= 4.5

# ---- 04 Load and explore ----------------------------------------------------

glimpse(penguins)

# How many penguins of each species?
penguins |>
  count(species)

# How many missing values in each column?
penguins |>
  summarise(across(everything(), \(x) sum(is.na(x))))

# ---- 05 Wrangle -------------------------------------------------------------

# Drop the 11 rows with missing sex (they include the 2 rows with no
# measurements) and add body mass in kilograms.
penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)

# n, mean and sd of bill length, flipper length and body mass by species
species_summary <- penguins_clean |>
  group_by(species) |>
  summarise(
    n = n(),
    bill_length_mean = mean(bill_length_mm),
    bill_length_sd = sd(bill_length_mm),
    flipper_length_mean = mean(flipper_length_mm),
    flipper_length_sd = sd(flipper_length_mm),
    body_mass_mean = mean(body_mass_g),
    body_mass_sd = sd(body_mass_g),
    .groups = "drop"
  )

species_summary

# ---- 06 Visualise -----------------------------------------------------------

# Bill length vs depth, coloured by species, with one straight line per species
p_bill <- ggplot(
  penguins_clean,
  aes(x = bill_length_mm, y = bill_depth_mm, colour = species)
) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1) +
  scale_colour_viridis_d(end = 0.85) +
  labs(
    x = "Bill length (mm)",
    y = "Bill depth (mm)",
    colour = "Species",
    title = "Bill depth increases with bill length within each species"
  ) +
  theme_minimal()

# Body mass by species, boxplot plus jittered points, one panel per sex
p_mass <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.5, size = 1) +
  facet_wrap(~sex) +
  scale_fill_viridis_d(end = 0.85) +
  labs(x = NULL, y = "Body mass (g)", title = "Body mass by species and sex") +
  theme_minimal() +
  theme(legend.position = "none")

p_bill
p_mass

dir.create("figures", showWarnings = FALSE)
ggsave("figures/bill_length_depth.png", p_bill, width = 7, height = 5, dpi = 300)
ggsave("figures/body_mass.png", p_mass, width = 7, height = 5, dpi = 300)

# Check it: one point per penguin, and the saved files exist
nrow(layer_data(p_bill, 1))   # 333
nrow(layer_data(p_mass, 2))   # jittered points: 333
# Medians should match the thick line in each box
tapply(penguins_clean$body_mass_g,
       list(penguins_clean$species, penguins_clean$sex), median)
file.exists("figures/bill_length_depth.png", "figures/body_mass.png")
