# 07. Statistics: Code You Can Run but Do Not Understand

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- Why is a confident AI answer to a statistics question dangerous?
- How do I use an AI to understand model output, not just produce it?

**Objectives**
- Show Simpson's paradox in the penguins data with `lm()`.
- Fit `mass_model` and check one AI claim about `summary(mass_model)` yourself.
- Optional: ask an AI when a t-test would be wrong, and act on the answer.

An AI assistant makes it trivial to produce statistical output. It does not
make you able to interpret it. The rule for this episode, and for your report:
**if you cannot explain it, it does not go in the report.**

## Bill Length and Bill Depth

### Prompt 1: the quick version

```text
Is there a relationship between bill length and bill depth in penguins? Give me R code.
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **One regression for all penguins.** The usual answer is
  `lm(bill_depth_mm ~ bill_length_mm, data = penguins)` or `cor.test()`, with a
  conclusion like "longer bills are slightly shallower (negative correlation)".
- **The conclusion is backwards for every species.** The penguins data contain
  three species, and species is a confounder: Gentoo penguins have long but
  shallow bills. Pooling them reverses the relationship. This is
  **Simpson's paradox**.
- **Confident wording.** A small p-value is presented as a finding, with no
  mention of grouping, confounders or assumptions.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| `The data contain three species` | Puts the grouping in front of the AI |
| `all together, then within each species` | Asks for both fits, so you can compare them |
| `could … disagree, and why` | Invites the Simpson's paradox explanation instead of one answer |
| `List … confounders` | Makes the AI reason about the design, not just the code |
| `Do not state a conclusion until I have run the code` | You see the numbers before any interpretation |

### Check it

Run both fits and compare the slopes:

```r
coef(lm(bill_depth_mm ~ bill_length_mm, data = penguins_clean))

penguins_clean |>
  group_by(species) |>
  summarise(slope = coef(lm(bill_depth_mm ~ bill_length_mm))[2])
```

Across all 333 penguins, the slope is **−0.082** mm of depth per mm of length.
Within species, the slopes are **0.177** (Adelie), **0.222** (Chinstrap) and
**0.208** (Gentoo). All three are positive. Look back at `p_bill` from episode 06:
each species' line slopes up, while the three clusters as a whole run downhill.

<details>
<summary>Reference solution</summary>

```r
# All penguins together: slope -0.082
coef(lm(bill_depth_mm ~ bill_length_mm, data = penguins_clean))

# Within each species: 0.177, 0.222, 0.208
penguins_clean |>
  group_by(species) |>
  summarise(slope = coef(lm(bill_depth_mm ~ bill_length_mm))[2])
```

</details>

## Body Mass by Species

Fit the model the report uses:

```r
mass_model <- lm(body_mass_g ~ species, data = penguins_clean)
summary(mass_model)
anova(mass_model)
```

### Prompt 1: the quick version

```text
what does this mean?
<pasted summary(mass_model) output>
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **"Chinstrap penguins are not different."** A p-value of 0.691 means the
  data do not show a difference from Adelie. That is not evidence that there is none.
- **Wrong reference level.** The AI may describe `speciesGentoo` as the mean
  Gentoo mass. It is the *difference* from the reference level, Adelie.
- **Assumptions skipped.** `lm()` assumes independent penguins, roughly normal
  residuals and similar spread in each group. A general answer rarely checks these.
- **Over-reach.** "Species causes body mass differences" from observational data.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| The model formula and factor levels | The AI knows how R coded the comparison |
| `Explain each part` | A line-by-line explanation, not a one-line verdict |
| `which species is the reference level` | Prevents misreading the coefficients |
| `assumptions … what would make the conclusions wrong` | Surfaces the caveats your Limitations section needs |
| `one claim … I can check myself` | Turns the explanation into something you verify |

### Check it

Check one claim yourself. The intercept should be the mean Adelie body mass,
and each other coefficient should be a difference from Adelie:

```r
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)
```

You should get Adelie 3706.164, Chinstrap 3733.088 and Gentoo 5092.437. The
intercept in `summary(mass_model)` is 3706.16. The Gentoo coefficient is
1386.27, which is 5092.437 − 3706.164. The Chinstrap coefficient (26.92) is
3733.088 − 3706.164. Species explains about 67% of the variation in body mass
(R² = 0.6745).

If the AI's explanation got any of this wrong, note what it was. That is the
kind of error you would otherwise have put in your report.

### Optional: a t-test, and when it would be wrong

> [!NOTE]
> **If you have time.** This section is optional. If you are short of time,
> skip to the Key points; the report in episode 08 does not need the t-test.

Ask your AI assistant: "Write R code for a t-test of whether male and female
penguins differ in body mass, and tell me when this test would be wrong."

A typical answer is `t.test(body_mass_g ~ sex, data = penguins_clean)`, which
runs and gives a tiny p-value. Before you trust it, ask:

- **Are the groups comparable?** This test pools three species of very
  different size, so the "male" and "female" groups are each a mixture. Compare
  within one species instead.
- **Which t-test?** R's `t.test()` runs Welch's test (unequal variances) by
  default. Many AI explanations describe Student's test with equal variances.
- **Are the observations independent?** One row per penguin, measured once.
  Check this for your own data.

```r
adelie <- penguins_clean |>
  filter(species == "Adelie")
t.test(body_mass_g ~ sex, data = adelie)
```

Within Adelie penguins, males are on average 675 g heavier
(females 3368.8 g, males 4043.5 g; 95% CI for the female minus male
difference: −776 to −573 g).

<details>
<summary>Reference solution</summary>

```r
mass_model <- lm(body_mass_g ~ species, data = penguins_clean)
summary(mass_model)
anova(mass_model)

# Check: intercept = Adelie mean; Gentoo coefficient = Gentoo mean - Adelie mean
tapply(penguins_clean$body_mass_g, penguins_clean$species, mean)

# t-test within one species, not pooled across species
adelie <- penguins_clean |>
  filter(species == "Adelie")
t.test(body_mass_g ~ sex, data = adelie)
```

Catch-up file: [`checkpoints/after-07.R`](checkpoints/after-07.R).

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Add a "07 Statistics" section to analysis.R: the overall and per-species
> slopes of bill_depth_mm on bill_length_mm, mass_model <- lm(body_mass_g ~
> species, data = penguins_clean) with summary() and anova(), and a within-Adelie
> t-test of body_mass_g by sex. Run the script. Acceptance: the overall slope is
> negative and all three species slopes are positive; the model intercept equals
> the Adelie mean from tapply(). Then write three sentences I could put in a
> Limitations section, and list any claim you are not sure of.
> ```
>
> Agents explain output as confidently as web AIs. Verify one claim from its
> explanation yourself before you accept the edit.

## Key points

- Pooling groups can reverse a relationship (Simpson's paradox). Ask the AI
  about grouping and confounders, then fit both ways.
- Ask the AI to explain each part of `summary()` output, then check one claim
  with base R.
- Ask what would make a test wrong before you report it.
- If you cannot explain a result, it does not go in the report. Record what
  you did not check in the Limitations section.
