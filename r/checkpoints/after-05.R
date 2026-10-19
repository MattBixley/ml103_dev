# ML103 checkpoint: end of episode 05 (Wrangle with dplyr)
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

# Check it with base R
nrow(penguins_clean)                                              # 333
table(penguins_clean$species)                                     # 146, 68, 119
colSums(is.na(penguins_clean))                                    # all zero
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)  # matches body_mass_mean
aggregate(body_mass_g ~ species, data = penguins_clean, FUN = sd) # matches body_mass_sd
