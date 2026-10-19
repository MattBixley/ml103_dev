# R Prompt Library

Copy-paste prompts from the R episodes 04 to 08. Each pair shows the quick
version a learner might type and a better version. Replace anything in
`<angle brackets>` and `4.x` with your own details before you send it.

> [!WARNING]
> Paste code, error messages and `glimpse()` output only. Do not paste real
> research data into a web AI.

## 04. Load and Explore

Episode: [`r/04-explore.md`](../r/04-explore.md)

### Explore the Data

**Quick version**

```text
analyse the penguins data in R
```

**Better version**

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

## 05. Wrangle with dplyr and Debug

Episode: [`r/05-wrangle.md`](../r/05-wrangle.md)

### Clean and Summarise

**Quick version**

```text
clean the penguins data and summarise it
```

**Better version**

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

### Debug with an AI

**Quick version**

```text
my R code doesn't work
```

**Better version**

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

## 06. Visualise with ggplot2

Episode: [`r/06-visualise.md`](../r/06-visualise.md)

### Bill Length vs Bill Depth

**Quick version**

```text
plot penguins in ggplot
```

**Better version**

```text
I am using R 4.x with ggplot2 4.x (tidyverse) and the data frame
penguins_clean (palmerpenguins columns, no missing values).

Write ggplot2 code that creates an object called p_bill:
- x = bill_length_mm, y = bill_depth_mm, points coloured by species
- one straight-line fit per species: geom_smooth(method = "lm",
  formula = y ~ x, se = FALSE), using linewidth not size
- a colour-blind-safe palette (scale_colour_viridis_d)
- axis labels with units: "Bill length (mm)", "Bill depth (mm)"; legend title "Species"
- theme_minimal()
Then print p_bill and save it with
ggsave("figures/bill_length_depth.png", p_bill, width = 7, height = 5, dpi = 300),
creating the figures folder if it does not exist.
Give the complete code in one block.
```

### Body Mass by Species and Sex

**Quick version**

```text
make a boxplot of penguin weight
```

**Better version**

```text
Using penguins_clean (palmerpenguins columns) and ggplot2, create p_mass:
body_mass_g by species as a boxplot (outlier.shape = NA) with the individual
penguins as jittered points (width = 0.2, height = 0), one panel per sex
(facet_wrap), boxes filled by species with scale_fill_viridis_d, y label
"Body mass (g)", no x label, no legend, theme_minimal().
Save it with ggsave("figures/body_mass.png", p_mass, width = 7, height = 5, dpi = 300).
```

## 07. Statistics

Episode: [`r/07-statistics.md`](../r/07-statistics.md)

### Bill Length and Bill Depth

**Quick version**

```text
Is there a relationship between bill length and bill depth in penguins? Give me R code.
```

**Better version**

```text
I am using R with the tidyverse and the data frame penguins_clean
(palmerpenguins columns). The data contain three species.

I want to know how bill_depth_mm relates to bill_length_mm.
1. Fit the relationship for all penguins together, then separately within
   each species, using lm() and the native pipe |>.
2. Tell me whether the two answers could disagree, and why.
3. List the variables in this dataset that could confound the relationship.
Do not state a conclusion until I have run the code.
```

### Body Mass by Species

**Quick version**

```text
what does this mean?
<pasted summary(mass_model) output>
```

**Better version**

```text
I fitted lm(body_mass_g ~ species, data = penguins_clean) in R, where species
is a factor with levels Adelie, Chinstrap and Gentoo. Here is summary() output:

<paste summary(mass_model) output>

Explain each part of the output (Call, Residuals, each Coefficients row and
column, Residual standard error, R-squared, F-statistic) in plain language for
a biologist. Say which species is the reference level and what the intercept
means. List the assumptions of this model and what would make the conclusions
wrong. Finish with one claim from your explanation that I can check myself in
base R, and the code to check it.
```

### t-Test Check

```text
Write R code for a t-test of whether male and female penguins differ in body
mass, and tell me when this test would be wrong.
```

## 08. Assemble the Quarto Report

Episode: [`r/08-report.md`](../r/08-report.md)

### Build the Report

**Quick version**

```text
write a report about the penguins data
```

**Better version**

```text
I have an R script analysis.R (tidyverse, palmerpenguins, native pipe |>) that
creates penguins_clean, species_summary, p_bill, p_mass and
mass_model <- lm(body_mass_g ~ species, data = penguins_clean).
Here is the script:

<paste analysis.R>

Turn it into a Quarto document penguins_report.qmd that renders to HTML with
`quarto render penguins_report.qmd`.
- YAML header: title, author, date: today, format: html with
  embed-resources: true, code-fold: true and toc: true
- A setup chunk that loads the packages (message: false)
- Sections: Introduction and data source; Data cleaning; Summary tables
  (by species, island and sex, using knitr::kable); Figures; Simple comparison
  (overall vs per-species slopes, mass_model); Limitations; AI-use statement;
  Session information (sessionInfo())
- Use Quarto #| chunk options with labels, figure captions and fig-width: 7,
  fig-height: 5
- Create every object inside the document. No install.packages(), setwd() or
  rm(list = ls()).
- Use inline R code for every number in the text.
Leave the Limitations and AI-use statement sections as headings with a
placeholder sentence: I will write those myself.
```
