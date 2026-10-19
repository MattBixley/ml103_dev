# ML103 Python Notes

These notes are the Python version of the language-specific episodes 04 to 08.
Each episode keeps the R version's timings, section headings, prompt pairs,
checks and reference solutions, rewritten for pandas, seaborn, statsmodels and
Quarto with the Jupyter engine. The welcome (00) and the shared episodes (01,
02, 03, 09 and 10) live in [`../episodes/`](../episodes/) and apply to both
languages.

You need basic Python: lists, data frames, indexing with `[]` and `.loc[]`,
and a simple matplotlib plot. You do not need method chains, seaborn,
statsmodels or Quarto; the episodes teach those.

| # | Episode | Minutes |
|---|---|---|
| 04 | [Load and explore the penguins](04-explore.md) | 15 |
| 05 | [Wrangle with pandas](05-wrangle.md) | 25 |
| 06 | [Visualise with seaborn](06-visualise.md) | 20 |
| 07 | [Statistics: code you can run but do not understand](07-statistics.md) | 15 |
| 08 | [Assemble the Quarto report](08-report.md) | 20 |

The prompts from these episodes are collected in
[`../prompts/python-prompts.md`](../prompts/python-prompts.md).

## Set Up

Create the project folder `ml103-penguins/`, copy [`requirements.txt`](requirements.txt)
into it, and make a virtual environment called `.venv`:

```bash
cd ml103-penguins
python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
python -m pip install -r requirements.txt
```

You also need [Quarto](https://quarto.org/) 1.4 or later for episode 08. Check
that Quarto finds the Python in `.venv` with `quarto check jupyter`.

## How This Mirrors `r/`

| R notes | Python notes |
|---|---|
| `library(tidyverse)`, `library(palmerpenguins)` | `import pandas as pd`, `from palmerpenguins import load_penguins` |
| `palmerpenguins::penguins` | `penguins = load_penguins()` |
| `glimpse(penguins)` | `penguins.info()` |
| Base R checks: `nrow()`, `table()`, `tapply()` | Plain pandas checks: `len()`, `value_counts()`, `.loc` boolean masks |
| dplyr verbs with `\|>` | pandas method chains: `dropna()`, `assign()`, `groupby()`, `agg()` |
| ggplot2 objects `p_bill`, `p_mass` | matplotlib figures `p_bill`, `p_mass` drawn with seaborn |
| `ggsave(width = 7, height = 5, dpi = 300)` | `figsize=(7, 5)` and `savefig(dpi=300)` |
| `lm(body_mass_g ~ species)` | `smf.ols("body_mass_g ~ species", data=penguins_clean).fit()` |
| `t.test()` (Welch by default) | `scipy.stats.ttest_ind(equal_var=False)` (Student by default) |
| `sessionInfo()` | Python version and `importlib.metadata.version()` for each package |
| `analysis.R`, run with `Rscript` | `analysis.py`, run with `python analysis.py` |
| `penguins_report.qmd` (knitr engine) | `penguins_report.qmd` (`jupyter: python3`) |

The object names match the R notes: `penguins`, `penguins_clean`,
`species_summary`, `p_bill`, `p_mass` and `mass_model`. Figures go to
`figures/bill_length_depth.png` and `figures/body_mass.png`, and every number
in the episodes (344 rows, 333 after cleaning, the slopes and the model
coefficients) is the same in both languages.

The R notes teach the base R `penguins` dataset as the "wrong penguins" trap.
The Python notes teach `sns.load_dataset("penguins")` instead: it needs
internet access and codes `sex` as `Male` and `Female`.

## Catch-Up Files

Each file in [`checkpoints/`](checkpoints/) runs on its own from a fresh
Python session. Copy one into your project as `analysis.py` (or
`penguins_report.qmd` for `after-08.qmd`) to catch up.

- [`after-04.py`](checkpoints/after-04.py), [`after-05.py`](checkpoints/after-05.py),
  [`after-06.py`](checkpoints/after-06.py), [`after-07.py`](checkpoints/after-07.py)
- [`after-08.qmd`](checkpoints/after-08.qmd)

The instructor reference files are [`solutions/analysis.py`](solutions/analysis.py)
and [`solutions/penguins_report.qmd`](solutions/penguins_report.qmd).

## Version Notes

The code was tested with Python 3.10, 3.12, 3.13 and 3.14, on both pandas
2.2 and pandas 3.0. The minimum versions are in `requirements.txt`.

- `palmerpenguins` 0.1.4 and older stop with
  `ModuleNotFoundError: No module named 'pkg_resources'` on new Python
  installs, which no longer include `setuptools`. Upgrade with
  `python -m pip install "palmerpenguins>=0.1.6"`. If you must keep the old
  version, `python -m pip install "setuptools<81"` also works.
- pandas 3 shows text columns as `str` where pandas 2 shows `object`, and
  replaces `SettingWithCopyWarning` with copy-on-write. Episode 05 covers both.
- seaborn 0.13.2 with matplotlib 3.11 or later raises a
  `MatplotlibDeprecationWarning` about `vert` inside `sns.boxplot()`. Python
  hides it by default, and the plot is correct.
