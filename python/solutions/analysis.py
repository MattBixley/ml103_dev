# ML103 reference solution: analysis.py (episodes 04 to 07)
# Instructor-verified. Run from the ml103-penguins/ project folder in a fresh
# Python session with `python analysis.py`. Writes two figures to figures/.
# The `# %%` lines mark cells for VS Code and Jupyter; Python ignores them.

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import statsmodels.api as sm
import statsmodels.formula.api as smf
from palmerpenguins import load_penguins
from scipy import stats

pd.set_option("display.max_columns", None)  # print every column
pd.set_option("display.width", 120)

# %% 04 Load and explore -------------------------------------------------------

penguins = load_penguins()  # palmerpenguins, not sns.load_dataset("penguins")

penguins.info()

# How many penguins of each species?
print(penguins.groupby("species").size())

# How many missing values in each column?
print(penguins.isna().sum())

# Check it with plain pandas
print(len(penguins))                       # 344
print(penguins["species"].value_counts())  # Adelie 152, Gentoo 124, Chinstrap 68
print(len(penguins) - penguins.count())    # 2 in each measurement column, 11 in sex

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

# %% 07 Statistics -------------------------------------------------------------

# Simpson's paradox: the slope across all species has the opposite sign to the
# slope within each species.
overall_fit = smf.ols("bill_depth_mm ~ bill_length_mm", data=penguins_clean).fit()
print(overall_fit.params)  # slope -0.082

species_slopes = pd.Series(
    {
        species: smf.ols("bill_depth_mm ~ bill_length_mm", data=group).fit().params["bill_length_mm"]
        for species, group in penguins_clean.groupby("species")
    },
    name="slope",
)
print(species_slopes)  # 0.177, 0.222, 0.208

# Body mass by species: linear model (one-way ANOVA)
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()
print(mass_model.summary())
print(sm.stats.anova_lm(mass_model))

# t-test: male vs female body mass, within ONE species (Adelie).
# scipy uses Student's t-test by default; equal_var=False gives Welch's test.
adelie = penguins_clean[penguins_clean["species"] == "Adelie"]
female_mass = adelie.loc[adelie["sex"] == "female", "body_mass_g"]
male_mass = adelie.loc[adelie["sex"] == "male", "body_mass_g"]
t_result = stats.ttest_ind(female_mass, male_mass, equal_var=False)
print(t_result)
print(t_result.confidence_interval())  # female minus male: about -776 to -573 g

# Check it: the intercept is the Adelie mean, Gentoo coefficient is a difference
for species in species_order:
    print(species, penguins_clean.loc[penguins_clean["species"] == species, "body_mass_g"].mean())
# Adelie 3706.164 = intercept; Gentoo 5092.437 - 3706.164 = 1386.27
print(np.polyfit(penguins_clean["bill_length_mm"], penguins_clean["bill_depth_mm"], 1)[0])  # -0.082
