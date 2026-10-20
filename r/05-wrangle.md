# 05. Wrangle with dplyr

**Time:** 25 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do dplyr verbs relate to the base R subsetting I already know?
- How do I make an AI state exactly what it does with missing values?
- How do I ask an AI for help with an error so that it can actually help?

**Objectives**
- Read `filter()`, `mutate()`, `group_by()` and `summarise()` as base R operations.
- Create `penguins_clean` and `species_summary` with a prompt that names the
  verbs, the NA policy and the pipe.
- Write a debugging prompt that includes the code, the full error, your
  package versions and the result you expected.

## From Base R to dplyr

You already know how to subset a data frame with `[rows, columns]`. dplyr gives
each common job its own verb, and the pipe `|>` passes the result of one step
into the next. Read `|>` as "and then".

| Job | Base R | dplyr |
|---|---|---|
| Keep rows | `penguins[!is.na(penguins$sex), ]` | `penguins \|> filter(!is.na(sex))` |
| Keep columns | `penguins[, c("species", "sex")]` | `penguins \|> select(species, sex)` |
| Add a column | `penguins$body_mass_kg <- penguins$body_mass_g / 1000` | `penguins \|> mutate(body_mass_kg = body_mass_g / 1000)` |
| Summarise by group | `tapply(penguins$body_mass_g, penguins$species, mean)` | `penguins \|> group_by(species) \|> summarise(mean = mean(body_mass_g))` |

Here is the cleaning step for this workshop, written both ways:

```r
# Base R
penguins_clean_base <- penguins[!is.na(penguins$sex), ]
penguins_clean_base$body_mass_kg <- penguins_clean_base$body_mass_g / 1000

# dplyr
penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)
```

Inside dplyr verbs you write `sex`, not `penguins$sex`: the verb looks up
column names in the data frame you piped in.

## Clean and Summarise

### Prompt 1: the quick version

```text
clean the penguins data and summarise it
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **An NA policy you did not choose.** AI code often uses `drop_na()` or
  `na.omit()`, which remove a row if *any* column is missing. On penguins this
  happens to give the same 333 rows as dropping missing `sex`, because the 2 rows
  with no measurements also lack `sex`. On your own data the two rules can give
  very different answers, and the AI rarely tells you which rows it removed.
- **`na.rm` left out, or added silently.** `mean(body_mass_g)` on the raw data
  returns `NA` for Adelie and Gentoo. Some answers fix this by adding
  `na.rm = TRUE` everywhere, which hides how many values each mean used.
- **`filter(sex != NA)`**: this returns 0 rows, because any comparison with `NA`
  gives `NA`. Use `!is.na(sex)`.
- **Superseded functions.** `%>%` instead of `|>`, `gather()`/`spread()` instead
  of `pivot_longer()`/`pivot_wider()`, `summarise_at()` or `mutate_each()`.
  They still work (mostly), but they mix styles and confuse later prompts.
- **The grouping message.** When you group by two columns, `summarise()` prints
  a message about regrouped output. The exact wording depends on your dplyr
  version. It is a message, not an error. Add `.groups = "drop"` to get an
  ungrouped result and no message.

### Prompt 2: a better version

```text
I am using R 4.x with the tidyverse and palmerpenguins. The data frame is
`penguins` with these columns:
<paste your glimpse(penguins) output here>

Write tidyverse code with the native pipe |> that:
1. creates penguins_clean: remove only the rows where sex is NA, then add a
   column body_mass_kg = body_mass_g / 1000
2. creates species_summary: for each species, the number of penguins (n) and
   the mean and standard deviation of bill_length_mm, flipper_length_mm and
   body_mass_g. Use .groups = "drop".

Use filter(), mutate(), group_by() and summarise(). Do not use drop_na(),
na.omit() or na.rm = TRUE: penguins_clean should have no missing values left.
After the code, give me base R lines (nrow, table, tapply) that I can use to
check the results.
```

| Part of the prompt | What it fixes |
|---|---|
| `remove only the rows where sex is NA` | You choose the NA policy, not the AI |
| Object names `penguins_clean`, `species_summary` | Later episodes and the report depend on these names |
| Named verbs and `\|>` | One consistent, current tidyverse style |
| `Do not use drop_na(), na.omit() or na.rm = TRUE` | No hidden row loss; a leftover NA shows up as `NA` |
| `.groups = "drop"` | No grouping surprises in the next step |
| `give me base R lines … to check` | Builds the cross-check into the answer |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)

species_summary <- penguins_clean |>
  group_by(species) |>
  summarise(
    n = n(),
    mean_bill_length = mean(bill_length_mm),
    sd_bill_length = sd(bill_length_mm),
    mean_flipper_length = mean(flipper_length_mm),
    sd_flipper_length = sd(flipper_length_mm),
    mean_body_mass = mean(body_mass_g),
    sd_body_mass = sd(body_mass_g),
    .groups = "drop"
  )

species_summary

# Base R checks
nrow(penguins_clean)
table(penguins_clean$species)
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)
```

**Output when run:**

```text
# A tibble: 3 × 8
  species       n mean_bill_length sd_bill_length mean_flipper_length
  <fct>     <int>            <dbl>          <dbl>               <dbl>
1 Adelie      146             38.8           2.66                190.
2 Chinstrap    68             48.8           3.34                196.
3 Gentoo      119             47.6           3.11                217.
# ℹ 3 more variables: sd_flipper_length <dbl>, mean_body_mass <dbl>,
#   sd_body_mass <dbl>
[1] 333

   Adelie Chinstrap    Gentoo
      146        68       119
   Adelie Chinstrap    Gentoo
 3706.164  3733.088  5092.437
```

**Notes:** 333 rows and the species means match the `tapply()` check. The AI chose its own column names (`mean_body_mass`, not `body_mass_mean`); rename them if later code expects the reference names.

</details>

### Check it

Compare the dplyr results with base R:

```r
nrow(penguins_clean)            # expect 333 (344 minus 11 with missing sex)
table(penguins_clean$species)   # Adelie 146, Chinstrap 68, Gentoo 119
colSums(is.na(penguins_clean))  # all zero
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)
aggregate(body_mass_g ~ species, data = penguins_clean, FUN = sd)
```

The `tapply()` means (Adelie 3706.164, Chinstrap 3733.088, Gentoo 5092.437)
should equal `body_mass_mean` in `species_summary`. The `aggregate()` standard
deviations should equal `body_mass_sd`.

<details>
<summary>Reference solution</summary>

```r
penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)

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
```

Catch-up file: [`checkpoints/after-05.R`](checkpoints/after-05.R).

</details>

## Debug with an AI

Sooner or later, AI code (or your edit of it) fails. Say you want only the
male penguins and run:

```r
males <- penguins_clean |>
  filter(sex = "male")
```

R stops with:

```text
Error in filter(penguins_clean, sex = "male") : We detected a named input.
ℹ This usually means that you've used `=` instead of `==`.
ℹ Did you mean `sex == "male"`?
```

### Prompt 1: the quick version

```text
my R code doesn't work
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **The AI has to guess.** With no code and no error, it lists ten common R
  problems or asks you for details. You lose a round trip.
- **Half the error.** Learners often paste only the last line. The first line
  says which function failed, and the `ℹ` lines often contain the fix.
- **A fix for the wrong version.** Without package versions, the AI may
  suggest arguments that do not exist in your version, or an old workaround.
- **No expected result**, so the AI cannot tell whether code that runs is
  actually right.
- **A rewrite instead of a fix.** Asked vaguely, an AI may rewrite the whole
  script in a different style and introduce new problems.

### Prompt 2: a better version

```text
I am using R 4.x with dplyr (from the tidyverse) and palmerpenguins.
This code:

males <- penguins_clean |>
  filter(sex = "male")

gives this error:

Error in filter(penguins_clean, sex = "male") : We detected a named input.
ℹ This usually means that you've used `=` instead of `==`.
ℹ Did you mean `sex == "male"`?

Relevant lines from sessionInfo():
R version 4.x.x ...
other attached packages: dplyr_1.x.x ...

penguins_clean has 333 rows and a factor column sex with levels female and
male. I expected a data frame of the male penguins only.
Explain the cause in one or two sentences and give me the corrected line.
Do not change anything else.
```

| Part of the prompt | What it fixes |
|---|---|
| The exact code that failed | The AI sees your mistake, not a guess at it |
| The full error, copied from the Console | Includes the function name and R's own hint |
| `sessionInfo()` lines | Fixes match your R and package versions |
| What the data look like and what you expected | The AI can judge whether a fix is correct |
| `corrected line … do not change anything else` | A small fix you can read, not a rewrite |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
males <- penguins_clean |>
  filter(sex == "male")

nrow(males)
```

**Output when run:**

```text
[1] 168
```

**Notes:** The fix changed only `=` to `==`, as asked. 168 male penguins, matching `table(penguins_clean$sex)`.

</details>

Run `sessionInfo()` in the Console and copy the R version and the
"other attached packages" lines. Paste no data.

### Check it

Run the corrected code and check it with base R:

```r
males <- penguins_clean |>
  filter(sex == "male")

nrow(males)                       # 168
table(penguins_clean$sex)         # female 165, male 168
```

Other errors worth knowing on sight:

- `could not find function "glimpse"`: a `library()` line is missing or did not run.
- `there is no package called 'palmerpenguin'`: a typo, or the package is not
  installed. Check the spelling before you run `install.packages()`.
- ``Column `bill_length_mm` doesn't exist``: you have the base R `penguins`
  (episode 04). Run `library(palmerpenguins)`.

<details>
<summary>Reference solution</summary>

```r
# `=` names an argument; `==` tests equality
males <- penguins_clean |>
  filter(sex == "male")

nrow(males)  # 168
```

</details>

> [!TIP]
> **Agent extension (Track B)**
> Give the agent the wrangling task with acceptance criteria:
>
> ```text
> Add a "05 Wrangle" section to analysis.R that creates penguins_clean
> (remove only rows where sex is NA; add body_mass_kg) and species_summary
> (n, mean and sd of bill_length_mm, flipper_length_mm, body_mass_g by species,
> .groups = "drop"). Use |> and no na.rm. Run the script with Rscript.
> Acceptance: nrow(penguins_clean) == 333; no NA in penguins_clean;
> species_summary$body_mass_mean equals tapply(...) to 3 decimal places.
> Show me the check output.
> ```
>
> Then break the script on purpose (`filter(sex = "male")`) and ask the agent
> to run it, read the error and fix only that line. Compare how much context
> the agent collected for itself with the context you had to paste in Track A.

## Key points

- dplyr verbs do the same jobs as base R `[ , ]`, `$<-` and `tapply()`. Pipe
  them together with `|>`.
- State your NA policy in the prompt. Do not let the AI choose `drop_na()` or
  `na.rm = TRUE` for you.
- For debugging, paste the code, the full error, `sessionInfo()` lines and
  what you expected. Ask for the smallest fix.
- Check row counts and group means with `nrow()`, `table()`, `tapply()` and
  `aggregate()`.
