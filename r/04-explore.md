# 04. Load and Explore the Penguins

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do I give an AI assistant enough context to write code for *my* data?
- How do I know the AI used the right dataset and the right column names?

**Objectives**
- Load the tidyverse and `palmerpenguins` in a fresh R session.
- Paste `glimpse()` output into a prompt so the AI sees the real column names.
- Check AI-written exploration code against base R (`nrow()`, `table()`, `is.na()`).
- Explain why R 4.5 and later has two different `penguins` datasets.

## Set Up the Script

Open your `ml103-penguins` RStudio Project and create a new script called
`analysis.R`. You will add to this one script in episodes 04 to 07. Start it
with two lines and run them:

```r
library(tidyverse)
library(palmerpenguins)
```

Then run `glimpse(penguins)` and keep the output on screen. You will paste it
into your prompt.

> [!WARNING]
> Paste code, error messages and `glimpse()` output into a web AI. Do not paste
> real research data. The penguins data are public, which is why we use them.

## Explore the Data

### Prompt 1: the quick version

```text
analyse the penguins data in R
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **No question, so no useful answer.** "Analyse" can mean anything. AI
  assistants often return a long tour: a summary, a correlation matrix, three
  plots and a regression, none of which you asked for or can check in 15 minutes.
- **The wrong `penguins`.** Since R 4.5.0, base R ships its own `penguins` in the
  `datasets` package with short column names (`bill_len`, `bill_dep`,
  `flipper_len`, `body_mass`). The `palmerpenguins` package uses `bill_length_mm`,
  `bill_depth_mm`, `flipper_length_mm` and `body_mass_g`. The AI cannot see which
  one you have, so it may mix the two sets of names in one script.
- **Missing `library()` calls.** Code that uses `glimpse()` or `count()` without
  `library(tidyverse)` stops with `could not find function "glimpse"`.
- **Mixed styles.** Base R, `%>%` and `|>` in the same answer, or functions from
  packages you have not installed (`skimr`, `GGally`, `janitor`).
- **Silent NA handling.** Means and correlations computed with `na.rm = TRUE`
  without saying so, or `NA` results that the answer does not mention.

### Prompt 2: a better version

```text
I am using R 4.x in RStudio with the tidyverse and the palmerpenguins package.
I ran library(tidyverse), library(palmerpenguins) and glimpse(penguins).
This is the output:

<paste your glimpse(penguins) output here>

Using only the column names shown above, write R code that:
1. counts the penguins of each species
2. counts the missing values in every column

Use tidyverse functions and the native pipe |>. Do not use other packages.
Give the complete code in one block, then explain each line in one sentence.
```

| Part of the prompt | What it fixes |
|---|---|
| `R 4.x … tidyverse and the palmerpenguins package` | Tells the AI which `penguins` you mean and which style to write |
| Pasted `glimpse()` output | Real column names and types, so the AI does not guess them |
| `Using only the column names shown above` | Stops the AI switching to `bill_len` or inventing columns |
| Two numbered, specific questions | Small answers you can check in a minute |
| `native pipe \|>` and `no other packages` | Consistent style that runs on your setup |
| `explain each line` | You read the code before you run it |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
# 1. Count the penguins of each species
penguins |>
  count(species)

# 2. Count the missing values in every column
penguins |>
  summarise(across(everything(), ~ sum(is.na(.x))))
```

**Output when run:**

```text
# A tibble: 3 × 2
  species       n
  <fct>     <int>
1 Adelie      152
2 Chinstrap    68
3 Gentoo      124
# A tibble: 1 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
    <int>  <int>          <int>         <int>             <int>       <int>
1       0      0              2             2                 2           2
# ℹ 2 more variables: sex <int>, year <int>
```

**Notes:** Counts match the base R check (152, 68, 124; 2 NAs per measurement column, 11 in `sex`). The AI used `~ sum(is.na(.x))` rather than `\(x)`; both work.

</details>

Replace `4.x` with your version (run `R.version.string`).

### Check it

Run the AI's code, then check its answers with base R you already know:

```r
nrow(penguins)            # total rows
table(penguins$species)   # penguins per species
colSums(is.na(penguins))  # missing values per column
```

You should get 344 rows: 152 Adelie, 68 Chinstrap and 124 Gentoo. Four
measurement columns have 2 missing values each and `sex` has 11. If the AI's
counts differ, find out why before you go on.

**The two-penguins trap.** On R 4.5 or later, restart R (*Session > Restart R*)
and run this *before* loading `palmerpenguins`:

```r
names(penguins)                  # base R version: bill_len, bill_dep, ...
library(palmerpenguins)
names(penguins)                  # now: bill_length_mm, bill_depth_mm, ...
names(datasets::penguins)        # base R version, by its full name
names(palmerpenguins::penguins)  # package version, by its full name
```

When you load `palmerpenguins`, R prints that `penguins` and `penguins_raw` are
masked from `package:datasets`. From then on, `penguins` means the package
version. The order matters: if your script uses `bill_length_mm` but you forgot
`library(palmerpenguins)`, R 4.5 finds the base R `penguins` instead and you get
errors such as ``Column `bill_length_mm` doesn't exist``. Worse, base R code
like `mean(penguins$bill_length_mm)` returns `NA` with only a warning. Code
written with `bill_len` runs only on R 4.5 or later and fails on R 4.3 and 4.4.
The two datasets hold the same 344 penguins, so the numbers agree once the names
match.

On R 4.3 or 4.4, the first `names(penguins)` gives an "object not found" error,
because base R has no `penguins` yet.

Ask your AI assistant: "Which column names does the penguins dataset have?"
Note whether its answer matches `glimpse()`.

<details>
<summary>Reference solution</summary>

```r
library(tidyverse)
library(palmerpenguins) # load AFTER tidyverse; masks datasets::penguins on R >= 4.5

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
```

Catch-up file: [`checkpoints/after-04.R`](checkpoints/after-04.R).

</details>

> [!TIP]
> **Agent extension (Track B)**
> Give the agent the task with acceptance criteria instead of pasting output:
>
> ```text
> Create analysis.R in this project. It must start with library(tidyverse)
> then library(palmerpenguins), use the native pipe |>, count penguins per
> species and count missing values per column. Run it with Rscript and show me
> the output. Acceptance: 344 rows; species counts match table(penguins$species);
> the script uses only palmerpenguins column names (bill_length_mm, not bill_len).
> ```
>
> Approve each file edit and each `Rscript` run. Then ask the agent to check
> which `penguins` the script uses with `find("penguins")` and to explain the
> result.

## Key points

- Paste `glimpse()` output and your R version into the prompt so the AI uses
  your real column names.
- Ask one or two specific questions, not "analyse the data".
- R 4.5 and later has a base R `penguins` with different column names. Load
  `palmerpenguins` and use its names (`bill_length_mm`).
- Check every AI answer with base R you trust: `nrow()`, `table()`, `is.na()`.
