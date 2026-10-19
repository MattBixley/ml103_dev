# ML103 checkpoint: end of episode 07 (Statistics)
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

# ---- 07 Statistics ----------------------------------------------------------

# Simpson's paradox: the slope across all species has the opposite sign to the
# slope within each species.
coef(lm(bill_depth_mm ~ bill_length_mm, data = penguins_clean))   # slope -0.082

penguins_clean |>
  group_by(species) |>
  summarise(slope = coef(lm(bill_depth_mm ~ bill_length_mm))[2])  # 0.177, 0.222, 0.208

# Body mass by species: linear model (one-way ANOVA)
mass_model <- lm(body_mass_g ~ species, data = penguins_clean)
summary(mass_model)
anova(mass_model)

# t-test: male vs female body mass, within ONE species (Adelie)
adelie <- penguins_clean |>
  filter(species == "Adelie")
t.test(body_mass_g ~ sex, data = adelie)

# Check it: the intercept is the Adelie mean, Gentoo coefficient is a difference
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)
# Adelie 3706.164 = intercept; Gentoo 5092.437 - 3706.164 = 1386.27
