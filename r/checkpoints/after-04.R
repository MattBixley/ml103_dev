# ML103 checkpoint: end of episode 04 (Load and explore)
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

# Check it with base R
nrow(penguins)              # 344
table(penguins$species)     # Adelie 152, Chinstrap 68, Gentoo 124
colSums(is.na(penguins))    # 2 in each measurement column, 11 in sex
