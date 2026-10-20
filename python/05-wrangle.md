# 05. Wrangle with pandas

**Time:** 25 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do pandas method chains relate to the indexing I already know?
- How do I make an AI state exactly what it does with missing values?
- How do I ask an AI for help with an error so that it can actually help?

**Objectives**
- Read `dropna()`, `assign()`, `groupby()` and `agg()` as the indexing
  operations you already know.
- Create `penguins_clean` and `species_summary` with a prompt that names the
  methods, the NA policy and the style.
- Write a debugging prompt that includes the code, the full traceback, your
  package versions and the result you expected.

## From Indexing to Method Chains

You already know how to subset a data frame with `[]` and `.loc[]`. pandas
also gives each common job a method that returns a new data frame, so you can
write the steps one after another as a **method chain**. Read each `.` at the
start of a line as "and then". The outer brackets let the chain run over
several lines.

| Job | Indexing | Method chain |
|---|---|---|
| Keep rows | `penguins[penguins["sex"].notna()]` | `penguins.dropna(subset=["sex"])` |
| Keep columns | `penguins[["species", "sex"]]` | `penguins.loc[:, ["species", "sex"]]` |
| Add a column | `df["body_mass_kg"] = df["body_mass_g"] / 1000` | `df.assign(body_mass_kg=lambda d: d["body_mass_g"] / 1000)` |
| Summarise by group | a loop over species with `.loc[mask, "body_mass_g"].mean()` | `df.groupby("species")["body_mass_g"].mean()` |

Here is the cleaning step for this workshop, written both ways:

```python
# Indexing
penguins_clean_idx = penguins.loc[penguins["sex"].notna()].copy()
penguins_clean_idx["body_mass_kg"] = penguins_clean_idx["body_mass_g"] / 1000

# Method chain
penguins_clean = (
    penguins
    .dropna(subset=["sex"])
    .assign(body_mass_kg=lambda df: df["body_mass_g"] / 1000)
)
```

Inside `assign()`, `lambda df:` means "the data frame at this step of the
chain". The chain never changes `penguins`; it builds a new data frame. That
also avoids the copy warnings you meet in the indexing version if you leave
out `.copy()`.

## Clean and Summarise

### Prompt 1: the quick version

```text
clean the penguins data and summarise it with pandas
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **An NA policy you did not choose.** AI code often uses `dropna()` with no
  arguments, which removes a row if *any* column is missing. On penguins this
  happens to give the same 333 rows as dropping missing `sex`, because the 2
  rows with no measurements also lack `sex`. On your own data the two rules can
  give very different answers, and the AI rarely tells you which rows it removed.
- **Missing values skipped without a word.** pandas `mean()` and `std()` skip
  `NaN` by default (`skipna=True`). On the raw data, the Adelie mean body mass
  is 3700.7 g from 151 penguins; after cleaning it is 3706.2 g from 146.
  Neither result mentions how many values it used. `value_counts()` also
  drops `NaN` unless you pass `dropna=False`.
- **Comparing with `NaN`.** `penguins[penguins["sex"] != np.nan]` keeps all
  344 rows, because `NaN` is never equal to anything, itself included.
  `== None` keeps none. Use `.notna()` or `dropna(subset=...)`.
- **`inplace=True`.** `penguins_clean = penguins.dropna(subset=["sex"], inplace=True)`
  changes `penguins` and sets `penguins_clean` to `None`. The next step fails
  with `AttributeError: 'NoneType' object has no attribute 'assign'`.
- **Chained assignment.** `penguins[penguins["sex"].notna()]["body_mass_kg"] = ...`
  never changes `penguins`. pandas 2 warns with `SettingWithCopyWarning`;
  pandas 3 warns with `ChainedAssignmentError` and says the assignment
  "never works". Adding a column to a filtered subset without `.copy()` gives
  the same `SettingWithCopyWarning` on pandas 2 and no warning on pandas 3.
- **Removed and mismatched functions.** `df.append()` was removed in pandas
  2.0 (`AttributeError: 'DataFrame' object has no attribute 'append'`); use
  `pd.concat()`. `np.std()` divides by *n*, while pandas `std()` divides by
  *n* − 1, so the two give different standard deviations.

### Prompt 2: a better version

```text
I am using Python 3.x with pandas 2.x and palmerpenguins. The data frame is
`penguins`, loaded with load_penguins(). penguins.info() gives:
<paste your penguins.info() output here>

Write pandas code as method chains (one method per line, inside brackets) that:
1. creates penguins_clean: remove only the rows where sex is missing, with
   dropna(subset=["sex"]), then add a column body_mass_kg = body_mass_g / 1000
   with assign()
2. creates species_summary: for each species, the number of penguins (n) and
   the mean and standard deviation of bill_length_mm, flipper_length_mm and
   body_mass_g. Use groupby("species", as_index=False) and agg() with named
   aggregations.

Do not use inplace=True, chained assignment or .append(). penguins_clean
should have no missing values left. After the code, give me plain pandas lines
(len, value_counts, .loc with a boolean mask) that I can use to check the
results.
```

| Part of the prompt | What it fixes |
|---|---|
| `remove only the rows where sex is missing` | You choose the NA policy, not the AI |
| Object names `penguins_clean`, `species_summary` | Later episodes and the report depend on these names |
| `method chains` and named methods | One consistent, current pandas style |
| `as_index=False` | `species` stays a normal column, ready for tables and plots |
| `Do not use inplace=True, chained assignment or .append()` | No `None` objects, copy warnings or removed methods |
| `no missing values left` | Every later mean uses all the rows you kept |
| `give me plain pandas lines … to check` | Builds the cross-check into the answer |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
penguins_clean = (
    penguins
    .dropna(subset=["sex"])
    .assign(body_mass_kg=lambda d: d["body_mass_g"] / 1000)
)

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
print(species_summary.round(1))

# Checks
print(len(penguins_clean))
print(penguins_clean.isna().sum().sum())
print(penguins_clean["species"].value_counts())
```

**Output when run:**

```text
     species    n  bill_length_mean  bill_length_sd  flipper_length_mean  flipper_length_sd  body_mass_mean  \
0     Adelie  146              38.8             2.7                190.1                6.5          3706.2   
1  Chinstrap   68              48.8             3.3                195.8                7.1          3733.1   
2     Gentoo  119              47.6             3.1                217.2                6.6          5092.4   

   body_mass_sd  
0         458.6  
1         384.3  
2         501.5  
333
0
species
Adelie       146
Gentoo       119
Chinstrap     68
Name: count, dtype: int64
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Check it

Compare the method-chain results with plain pandas:

```python
print(len(penguins_clean))                       # expect 333 (344 minus 11 with missing sex)
print(penguins_clean["species"].value_counts())  # Adelie 146, Gentoo 119, Chinstrap 68
print(penguins_clean.isna().sum())               # all zero
for species in ["Adelie", "Chinstrap", "Gentoo"]:
    mass = penguins_clean.loc[penguins_clean["species"] == species, "body_mass_g"]
    print(species, mass.mean(), mass.std())
```

The means (Adelie 3706.164, Chinstrap 3733.088, Gentoo 5092.437) should equal
`body_mass_mean` in `species_summary`. The standard deviations (Adelie 458.620,
Chinstrap 384.335, Gentoo 501.476) should equal `body_mass_sd`.

<details>
<summary>Reference solution</summary>

```python
penguins_clean = (
    penguins
    .dropna(subset=["sex"])
    .assign(body_mass_kg=lambda df: df["body_mass_g"] / 1000)
)

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
```

If `print()` hides some columns behind `...`, add
`pd.set_option("display.max_columns", None)` near the top of the script.

Catch-up file: [`checkpoints/after-05.py`](checkpoints/after-05.py).

</details>

## Debug with an AI

Sooner or later, AI code (or your edit of it) fails. Say you want the mean of
every measurement for each species, and you run a line that appears in many
older tutorials:

```python
species_means = penguins_clean.groupby("species").mean()
```

Python stops with a long traceback that ends:

```text
  File ".../pandas/core/arrays/base.py", line 2808, in _groupby_op
    raise TypeError(
TypeError: dtype 'str' does not support operation 'mean'
```

On pandas 2, the last line reads
`TypeError: agg function failed [how->mean,dtype->object]` instead.

### Prompt 1: the quick version

```text
my python code doesn't work
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **The AI has to guess.** With no code and no error, it lists ten common
  Python problems or asks you for details. You lose a round trip.
- **Half the traceback.** Learners often paste only the last line. The first
  lines show which line of *your* code failed; the last line says what went
  wrong.
- **A fix for the wrong version.** Before pandas 2.0, `groupby().mean()`
  quietly dropped text columns. Without your pandas version, the AI may tell
  you the code is correct, or suggest an argument your version does not have.
- **No expected result**, so the AI cannot tell whether code that runs is
  actually right.
- **A rewrite instead of a fix.** Asked vaguely, an AI may rewrite the whole
  script in a different style and introduce new problems.

### Prompt 2: a better version

```text
I am using Python 3.x with pandas 3.x and palmerpenguins.
This code:

species_means = penguins_clean.groupby("species").mean()

gives this error:

Traceback (most recent call last):
  File "analysis.py", line 52, in <module>
    species_means = penguins_clean.groupby("species").mean()
  ...
TypeError: dtype 'str' does not support operation 'mean'

Versions: Python 3.x.x, pandas 3.x.x (from print(pd.__version__)).

penguins_clean has 333 rows. species, island and sex are text columns; the
other columns are numbers. I expected a table with one row per species and
the mean of each measurement column.
Explain the cause in one or two sentences and give me the corrected line.
Do not change anything else.
```

| Part of the prompt | What it fixes |
|---|---|
| The exact code that failed | The AI sees your mistake, not a guess at it |
| The full traceback, copied from the terminal | Shows your line and the error pandas raised |
| Python and pandas versions | Fixes match the pandas you have, not the one the AI learned from |
| Which columns are text and what you expected | The AI can judge whether a fix is correct |
| `corrected line … do not change anything else` | A small fix you can read, not a rewrite |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
species_means = penguins_clean.groupby("species").mean(numeric_only=True)
print(species_means)
```

**Output when run:**

```text
           bill_length_mm  bill_depth_mm  flipper_length_mm  body_mass_g         year  body_mass_kg
species                                                                                            
Adelie          38.823973      18.347260         190.102740  3706.164384  2008.054795      3.706164
Chinstrap       48.833824      18.420588         195.823529  3733.088235  2007.970588      3.733088
Gentoo          47.568067      14.996639         217.235294  5092.436975  2008.067227      5.092437
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

Run `python --version` in the terminal and `print(pd.__version__)` in Python
and copy the results. Paste no data.

### Check it

Run the corrected code and check it with plain pandas:

```python
species_means = penguins_clean.groupby("species").mean(numeric_only=True)
print(species_means)

adelie = penguins_clean.loc[penguins_clean["species"] == "Adelie", "body_mass_g"]
print(adelie.mean())  # 3706.164, same as the Adelie body_mass_g mean above
```

`numeric_only=True` also averages `year`, which gives a meaningless "mean
year" of 2008.05 for Adelie. Selecting the columns you want first, as in
`species_summary`, avoids that. The error was pandas protecting you from a
silent choice.

Other errors worth knowing on sight:

- `ModuleNotFoundError: No module named 'palmerpenguins'`: the `.venv`
  environment is not active, or you installed the package into a different
  Python. Run `python -m pip install palmerpenguins` with the environment active.
- `KeyError: 'weight'` (or any column name): the column does not exist. Check
  the name against `penguins.columns`.
- `AttributeError: 'DataFrame' object has no attribute 'append'`: code written
  for pandas 1.x. Use `pd.concat()`.
- `ValueError: cannot assign without a target object` from
  `penguins_clean.query("sex = 'male'")`: `=` assigns; `==` tests equality.

<details>
<summary>Reference solution</summary>

```python
# Since pandas 2.0, mean() no longer drops text columns by itself
species_means = penguins_clean.groupby("species").mean(numeric_only=True)

print(species_means)  # Adelie body_mass_g 3706.164
```

</details>

> [!TIP]
> **Agent extension (Track B)**
> Give the agent the wrangling task with acceptance criteria:
>
> ```text
> Add a "05 Wrangle" section to analysis.py that creates penguins_clean
> (remove only rows where sex is missing; add body_mass_kg) and species_summary
> (n, mean and sd of bill_length_mm, flipper_length_mm, body_mass_g by species,
> groupby with as_index=False and named aggregations). Use method chains; no
> inplace=True and no chained assignment. Run the script with the Python in
> .venv. Acceptance: len(penguins_clean) == 333; no NaN in penguins_clean;
> species_summary body_mass_mean equals the .loc boolean-mask mean for each
> species to 3 decimal places. Show me the check output.
> ```
>
> Then break the script on purpose (`penguins_clean.groupby("species").mean()`)
> and ask the agent to run it, read the traceback and fix only that line.
> Compare how much context the agent collected for itself with the context you
> had to paste in Track A.

## Key points

- pandas methods do the same jobs as `[]`, `.loc[]` and loops over groups.
  Chain them inside brackets, one method per line.
- State your NA policy in the prompt. pandas skips missing values silently,
  so do not let the AI choose `dropna()` or `skipna` for you.
- For debugging, paste the code, the full traceback, your Python and pandas
  versions and what you expected. Ask for the smallest fix.
- Check row counts and group means with `len()`, `value_counts()` and `.loc`
  boolean masks.
