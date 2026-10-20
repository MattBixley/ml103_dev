# 04. Load and Explore the Penguins

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do I give an AI assistant enough context to write code for *my* data?
- How do I know the AI used the right dataset and the right column names?

**Objectives**
- Load pandas and the `palmerpenguins` package in a fresh Python session.
- Paste `penguins.info()` output into a prompt so the AI sees the real column names.
- Check AI-written exploration code with plain pandas (`len()`, `value_counts()`, `count()`).
- Explain why `sns.load_dataset("penguins")` is not the same data source as `palmerpenguins`.

## Set Up the Script

Open your `ml103-penguins` folder in VS Code (or JupyterLab), activate the
`.venv` virtual environment you made during setup, and create a new file
called `analysis.py`. You will add to this one script in episodes 04 to 07.
Start it with these lines and run them:

```python
import pandas as pd
from palmerpenguins import load_penguins

penguins = load_penguins()
penguins.info()
```

Keep the `info()` output on screen. You will paste it into your prompt.

Run the script in a terminal with `python analysis.py`, or run it line by line
in the VS Code Interactive Window. In a script, Python only shows a value if
you `print()` it, so the code in these notes uses `print()` throughout.

> [!WARNING]
> Paste code, error messages and `info()` output into a web AI. Do not paste
> real research data. The penguins data are public, which is why we use them.

## Explore the Data

### Prompt 1: the quick version

```text
analyse the penguins data in python
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **No question, so no useful answer.** "Analyse" can mean anything. AI
  assistants often return a long tour: `describe()`, a correlation heatmap, a
  pair plot and a regression, none of which you asked for or can check in 15
  minutes.
- **The wrong penguins.** Many answers load the data with
  `sns.load_dataset("penguins")`. That function downloads a CSV file from the
  seaborn-data repository on GitHub every time the cache is empty, so it fails
  without internet access, for example on most cluster compute nodes. It also
  differs from the `palmerpenguins` package: it has 7 columns (no `year`) and
  stores `sex` as `Male` and `Female`, while `palmerpenguins` uses `male` and
  `female`. Code that tests `sex == "male"` finds 168 penguins in one and none
  in the other.
- **Invented imports.** `from palmerpenguins import penguins` runs without an
  error, but it imports a module, not a data frame. The next line,
  `penguins.head()`, stops with
  `AttributeError: module 'palmerpenguins.penguins' has no attribute 'head'`.
  Other answers read a `penguins.csv` file that you do not have.
- **Extra packages.** Answers often import `ydata-profiling`, `missingno` or
  `plotly`, which you have not installed, so the script stops with
  `ModuleNotFoundError`.
- **Silent NA handling.** pandas skips missing values in `mean()`, `sum()` and
  `value_counts()` by default and does not tell you. An answer can report
  means without saying how many penguins each one used.

### Prompt 2: a better version

```text
I am using Python 3.x with pandas 2.x and the palmerpenguins package (pip).
I loaded the data with:

from palmerpenguins import load_penguins
penguins = load_penguins()

penguins.info() gives:

<paste your penguins.info() output here>

Using only the column names shown above, write Python code that:
1. counts the penguins of each species
2. counts the missing values in every column

Use pandas only. Do not use sns.load_dataset() or any other package.
Print each result with print().
Give the complete code in one block, then explain each line in one sentence.
```

| Part of the prompt | What it fixes |
|---|---|
| `Python 3.x with pandas 2.x and the palmerpenguins package` | Tells the AI which data source you use and which pandas behaviour to expect |
| The two lines that load the data | The AI builds on your object name, `penguins`, not its own |
| Pasted `info()` output | Real column names and types, so the AI does not guess them |
| `Using only the column names shown above` | Stops the AI inventing columns such as `weight` |
| Two numbered, specific questions | Small answers you can check in a minute |
| `Do not use sns.load_dataset()` | No second copy of the data with different `sex` values |
| `explain each line` | You read the code before you run it |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
import pandas as pd
from palmerpenguins import load_penguins

penguins = load_penguins()

# 1. Count the penguins of each species
species_counts = penguins["species"].value_counts()
print(species_counts)

# 2. Count the missing values in every column
missing_counts = penguins.isna().sum()
print(missing_counts)
```

**Output when run:**

```text
species
Adelie       152
Gentoo       124
Chinstrap     68
Name: count, dtype: int64
species               0
island                0
bill_length_mm        2
bill_depth_mm         2
flipper_length_mm     2
body_mass_g           2
sex                  11
year                  0
dtype: int64
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

Replace `3.x` and `2.x` with your versions. Run `python --version` in the
terminal and `print(pd.__version__)` in Python. pandas 3 prints text columns
in `info()` as `str`; pandas 2 prints them as `object`. Both are fine.

### Check it

Run the AI's code, then check its answers with plain pandas you already know:

```python
print(len(penguins))                       # total rows
print(penguins["species"].value_counts())  # penguins per species
print(len(penguins) - penguins.count())    # missing values per column
```

`count()` counts the values that are *not* missing, so subtracting it from the
number of rows gives the missing values without using `isna()`. You should get
344 rows: 152 Adelie, 68 Chinstrap and 124 Gentoo. Four measurement columns
have 2 missing values each and `sex` has 11. If the AI's counts differ, find
out why before you go on.

**The two-penguins trap.** Load the seaborn copy next to yours and compare
them (this needs internet access):

```python
import seaborn as sns

penguins_sns = sns.load_dataset("penguins")  # downloads a CSV from GitHub
print(penguins.columns.tolist())             # 8 columns, including year
print(penguins_sns.columns.tolist())         # 7 columns, no year
print(penguins["sex"].unique())              # male, female and nan
print(penguins_sns["sex"].unique())          # Male, Female and nan
print(len(penguins_sns.query("sex == 'male'")))  # 0
```

Both copies hold the same 344 penguins, and the measurement columns have the
same names. The differences sit in the details: the missing `year` column and
the capitalised `sex` values. An AI that learned from seaborn tutorials writes
`"Male"`; one that learned from `palmerpenguins` writes `"male"`. Neither error
message tells you, because a filter that matches nothing returns an empty data
frame, not an error.

`load_penguins()` reads a CSV file that ships inside the `palmerpenguins`
package, so it works offline and on a cluster compute node. Use it for every
episode.

Ask your AI assistant: "Which column names does the penguins dataset have, and
how is sex coded?" Note whether its answer matches `info()` and `unique()`.

<details>
<summary>Reference solution</summary>

```python
import pandas as pd
from palmerpenguins import load_penguins

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
```

Catch-up file: [`checkpoints/after-04.py`](checkpoints/after-04.py).

</details>

> [!TIP]
> **Agent extension (Track B)**
> Give the agent the task with acceptance criteria instead of pasting output:
>
> ```text
> Create analysis.py in this project. It must load the data with
> `from palmerpenguins import load_penguins` and `penguins = load_penguins()`,
> count penguins per species and count missing values per column, printing
> each result. Run it with the Python in .venv and show me the output.
> Acceptance: 344 rows; species counts match penguins["species"].value_counts();
> no sns.load_dataset() and no other data source; no packages beyond pandas
> and palmerpenguins.
> ```
>
> Approve each file edit and each run. Then ask the agent where
> `load_penguins()` reads its data from (`print(palmerpenguins.__file__)` is a
> start), and why that matters on a compute node without internet access.

## Key points

- Paste `info()` output and your Python and pandas versions into the prompt so
  the AI uses your real column names.
- Ask one or two specific questions, not "analyse the data".
- `sns.load_dataset("penguins")` downloads a different copy with no `year`
  column and capitalised `sex` values. Use `load_penguins()`.
- Check every AI answer with plain pandas you trust: `len()`,
  `value_counts()`, `count()`.
