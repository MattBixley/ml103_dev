# ML103 checkpoint: end of episode 06 (Visualise with seaborn)
# Copy this file to your ml103-penguins/ project as analysis.py and carry on.
# Runs on its own from a fresh Python session: python analysis.py
# The `# %%` lines mark cells for VS Code and Jupyter; Python ignores them.

from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
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

# %% 06 Visualise --------------------------------------------------------------

sns.set_theme(style="whitegrid")
species_order = ["Adelie", "Chinstrap", "Gentoo"]
colours = dict(zip(species_order, sns.color_palette("viridis", 3)))

# Bill length vs depth, coloured by species, with one straight line per species
p_bill, ax = plt.subplots(figsize=(7, 5))
sns.scatterplot(
    data=penguins_clean, x="bill_length_mm", y="bill_depth_mm",
    hue="species", hue_order=species_order, palette=colours, alpha=0.7, ax=ax,
)
for species, colour in colours.items():
    sns.regplot(
        data=penguins_clean[penguins_clean["species"] == species],
        x="bill_length_mm", y="bill_depth_mm",
        scatter=False, ci=None, color=colour, ax=ax,
    )
ax.set(
    xlabel="Bill length (mm)",
    ylabel="Bill depth (mm)",
    title="Bill depth increases with bill length within each species",
)
ax.legend(title="Species")

# Body mass by species, boxplot plus jittered points, one panel per sex
p_mass, axes = plt.subplots(1, 2, figsize=(7, 5), sharey=True)
for ax, sex in zip(axes, ["female", "male"]):
    subset = penguins_clean[penguins_clean["sex"] == sex]
    sns.boxplot(
        data=subset, x="species", y="body_mass_g", order=species_order,
        hue="species", palette=colours, legend=False,
        showfliers=False, boxprops={"alpha": 0.5}, ax=ax,
    )
    sns.stripplot(
        data=subset, x="species", y="body_mass_g", order=species_order,
        color="black", jitter=0.2, alpha=0.5, size=3, ax=ax,
    )
    ax.set(title=sex, xlabel="", ylabel="Body mass (g)")
p_mass.suptitle("Body mass by species and sex")

Path("figures").mkdir(exist_ok=True)
p_bill.savefig("figures/bill_length_depth.png", dpi=300)
p_mass.savefig("figures/body_mass.png", dpi=300)

# Check it: one point per penguin, and the saved files exist
print(len(p_bill.axes[0].collections[0].get_offsets()))  # 333
print(Path("figures/bill_length_depth.png").exists(), Path("figures/body_mass.png").exists())
print(sum(len(c.get_offsets()) for a in p_mass.axes for c in a.collections))  # jittered points: 333
# Medians should match the line in each box
print(penguins_clean.pivot_table(index="species", columns="sex",
                                 values="body_mass_g", aggfunc="median"))
