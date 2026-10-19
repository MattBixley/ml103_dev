# ML103 checkpoint: end of episode 04 (Load and explore)
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

# Check it with plain pandas
print(len(penguins))                       # 344
print(penguins["species"].value_counts())  # Adelie 152, Gentoo 124, Chinstrap 68
print(len(penguins) - penguins.count())    # 2 in each measurement column, 11 in sex
