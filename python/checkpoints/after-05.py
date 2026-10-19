# ML103 checkpoint: end of episode 05 (Wrangle with pandas)
# Copy this file to your ml103-penguins/ project as analysis.py and carry on.
# Runs on its own from a fresh Python session: python analysis.py
# The `# %%` lines mark cells for VS Code and Jupyter; Python ignores them.

import pandas as pd
from palmerpenguins import load_penguins

pd.set_option("display.max_columns", None)  # print every column
pd.set_option("display.width", 120)

# %% 04 Load and explore -------------------------------------------------------

penguins = load_penguins()  # palmerpenguins, not sns.load_dataset("penguins")

penguins.info()

# How many penguins of each species?
print(penguins.groupby("species").size())

# How many missing values in each column?
print(penguins.isna().sum())

# %% 05 Wrangle ----------------------------------------------------------------

# Drop the 11 rows with missing sex (they include the 2 rows with no
# measurements) and add body mass in kilograms.
penguins_clean = (
    penguins
    .dropna(subset=["sex"])
    .assign(body_mass_kg=lambda df: df["body_mass_g"] / 1000)
)

# n, mean and sd of bill length, flipper length and body mass by species
species_summary = (
    penguins_clean
    .groupby("species", as_index=False)
    .agg(
        n=("species", "size"),
        bill_length_mean=("bill_length_mm", "mean"),
        bill_length_sd=("bill_length_mm", "std"),
        flipper_length_mean=("flipper_length_mm", "mean"),
        flipper_length_sd=("flipper_length_mm", "std"),
        body_mass_mean=("body_mass_g", "mean"),
        body_mass_sd=("body_mass_g", "std"),
    )
)

print(species_summary)

# Check it with plain pandas
print(len(penguins_clean))                       # 333
print(penguins_clean["species"].value_counts())  # Adelie 146, Gentoo 119, Chinstrap 68
adelie_mass = penguins_clean.loc[penguins_clean["species"] == "Adelie", "body_mass_g"]
print(adelie_mass.mean())                        # 3706.164, matches body_mass_mean
print(penguins_clean.isna().sum())               # all zero
for species in ["Adelie", "Chinstrap", "Gentoo"]:
    mass = penguins_clean.loc[penguins_clean["species"] == species, "body_mass_g"]
    print(species, mass.mean(), mass.std())      # match body_mass_mean and body_mass_sd
