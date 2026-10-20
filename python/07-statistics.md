# 07. Statistics: Code You Can Run but Do Not Understand

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- Why is a confident AI answer to a statistics question dangerous?
- How do I use an AI to understand model output, not just produce it?

**Objectives**
- Show Simpson's paradox in the penguins data with `smf.ols()`.
- Fit `mass_model` and check one AI claim about `mass_model.summary()` yourself.
- Optional: ask an AI when a t-test would be wrong, and act on the answer.

An AI assistant makes it trivial to produce statistical output. It does not
make you able to interpret it. The rule for this episode, and for your report:
**if you cannot explain it, it does not go in the report.**

This episode uses the statsmodels formula interface, which reads model
formulas the same way R does:

```python
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
from scipy import stats
```

## Bill Length and Bill Depth

### Prompt 1: the quick version

```text
Is there a relationship between bill length and bill depth in penguins? Give me Python code.
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **One regression for all penguins.** The usual answer is
  `smf.ols("bill_depth_mm ~ bill_length_mm", data=penguins).fit()`,
  `scipy.stats.linregress()` or a correlation, with a conclusion like "longer
  bills are slightly shallower (negative correlation)".
- **The conclusion is backwards for every species.** The penguins data contain
  three species, and species is a confounder: Gentoo penguins have long but
  shallow bills. Pooling them reverses the relationship. This is
  **Simpson's paradox**.
- **A model with no intercept.** `sm.OLS(y, X)` without
  `sm.add_constant(X)` forces the line through zero. On penguins it gives a
  slope of +0.383, a different answer again, with no warning. The formula
  interface (`smf.ols()`) adds the intercept for you.
- **Correlation on the whole data frame.** `penguins.corr()` stops with
  `ValueError: could not convert string to float: 'Adelie'` on pandas 2 and
  later. The "fix", `corr(numeric_only=True)`, returns −0.229 for bill length
  and depth, which hides the paradox too.
- **Confident wording.** A small p-value is presented as a finding, with no
  mention of grouping, confounders or assumptions.

### Prompt 2: a better version

```text
I am using Python with pandas and statsmodels, and the data frame
penguins_clean (palmerpenguins columns). The data contain three species.

I want to know how bill_depth_mm relates to bill_length_mm.
1. Fit the relationship for all penguins together, then separately within
   each species, using statsmodels.formula.api.ols.
2. Tell me whether the two answers could disagree, and why.
3. List the variables in this dataset that could confound the relationship.
Do not state a conclusion until I have run the code.
```

| Part of the prompt | What it fixes |
|---|---|
| `The data contain three species` | Puts the grouping in front of the AI |
| `all together, then within each species` | Asks for both fits, so you can compare them |
| `statsmodels.formula.api.ols` | A formula with an intercept, not a bare `sm.OLS()` |
| `could … disagree, and why` | Invites the Simpson's paradox explanation instead of one answer |
| `List … confounders` | Makes the AI reason about the design, not just the code |
| `Do not state a conclusion until I have run the code` | You see the numbers before any interpretation |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
import statsmodels.formula.api as smf

# 1. All penguins together
overall = smf.ols("bill_depth_mm ~ bill_length_mm", data=penguins_clean).fit()
print("All penguins:", round(overall.params["bill_length_mm"], 3))

# 2. Within each species
for sp, df in penguins_clean.groupby("species"):
    fit = smf.ols("bill_depth_mm ~ bill_length_mm", data=df).fit()
    print(sp, round(fit.params["bill_length_mm"], 3))
```

**Output when run:**

```text
All penguins: -0.082
Adelie 0.177
Chinstrap 0.222
Gentoo 0.208
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Check it

Run both fits, then check the slopes with a second method, `np.polyfit()`,
which fits a straight line without statsmodels:

```python
overall_fit = smf.ols("bill_depth_mm ~ bill_length_mm", data=penguins_clean).fit()
print(overall_fit.params["bill_length_mm"])

for species, group in penguins_clean.groupby("species"):
    print(species, np.polyfit(group["bill_length_mm"], group["bill_depth_mm"], 1)[0])
```

Across all 333 penguins, the slope is **−0.082** mm of depth per mm of length.
Within species, the slopes are **0.177** (Adelie), **0.222** (Chinstrap) and
**0.208** (Gentoo). All three are positive. Look back at `p_bill` from episode 06:
each species' line slopes up, while the three clusters as a whole run downhill.

<details>
<summary>Reference solution</summary>

```python
# All penguins together: slope -0.082
overall_fit = smf.ols("bill_depth_mm ~ bill_length_mm", data=penguins_clean).fit()
print(overall_fit.params)

# Within each species: 0.177, 0.222, 0.208
species_slopes = pd.Series(
    {
        species: smf.ols("bill_depth_mm ~ bill_length_mm", data=group).fit().params["bill_length_mm"]
        for species, group in penguins_clean.groupby("species")
    },
    name="slope",
)
print(species_slopes)
```

</details>

## Body Mass by Species

Fit the model the report uses:

```python
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()
print(mass_model.summary())
print(sm.stats.anova_lm(mass_model))
```

### Prompt 1: the quick version

```text
what does this mean?
<pasted mass_model.summary() output>
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **"Chinstrap penguins are not different."** A p-value of 0.691 means the
  data do not show a difference from Adelie. That is not evidence that there is none.
- **Wrong reference level.** The AI may describe `species[T.Gentoo]` as the
  mean Gentoo mass. It is the *difference* from the reference level, Adelie.
  statsmodels picks the first level in alphabetical order; `T.` stands for
  treatment coding.
- **Over-reading the bottom block.** statsmodels prints Omnibus, Durbin-Watson,
  Jarque-Bera and Cond. No. under every model. Durbin-Watson (2.989 here)
  tests for correlation between *neighbouring rows*, which only means
  something when row order means something, such as a time series. An AI
  often interprets every number it is shown.
- **Assumptions skipped.** OLS assumes independent penguins, roughly normal
  residuals and similar spread in each group. A general answer rarely checks these.
- **Over-reach.** "Species causes body mass differences" from observational data.

### Prompt 2: a better version

```text
I fitted smf.ols("body_mass_g ~ species", data=penguins_clean).fit() with
statsmodels in Python, where species is a text column with the values Adelie,
Chinstrap and Gentoo. Here is the summary() output:

<paste print(mass_model.summary()) output>

Explain each part of the output (the top block including R-squared and
F-statistic, each coefficient row and column, and the bottom block with
Omnibus, Durbin-Watson, Jarque-Bera and Cond. No.) in plain language for a
biologist. Say which species is the reference level and what the Intercept
means, and which numbers in the bottom block do not apply to these data.
List the assumptions of this model and what would make the conclusions wrong.
Finish with one claim from your explanation that I can check myself with
plain pandas, and the code to check it.
```

| Part of the prompt | What it fixes |
|---|---|
| The model formula and the species values | The AI knows how statsmodels coded the comparison |
| `Explain each part` | A line-by-line explanation, not a one-line verdict |
| `which species is the reference level` | Prevents misreading the coefficients |
| `which numbers … do not apply` | Stops the AI interpreting Durbin-Watson for unordered data |
| `assumptions … what would make the conclusions wrong` | Surfaces the caveats your Limitations section needs |
| `one claim … I can check myself` | Turns the explanation into something you verify |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
import statsmodels.formula.api as smf

mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()

# Claim: the Intercept is the mean Adelie mass, and each coefficient
# is that species' mean minus the Adelie mean.
means = penguins_clean.groupby("species")["body_mass_g"].mean()
print(mass_model.params.round(1))
print(means.round(1))
print(round(means["Gentoo"] - means["Adelie"], 1))
```

**Output when run:**

```text
Intercept               3706.2
species[T.Chinstrap]      26.9
species[T.Gentoo]       1386.3
dtype: float64
species
Adelie       3706.2
Chinstrap    3733.1
Gentoo       5092.4
Name: body_mass_g, dtype: float64
1386.3
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Check it

Check one claim yourself. The intercept should be the mean Adelie body mass,
and each other coefficient should be a difference from Adelie:

```python
for species in ["Adelie", "Chinstrap", "Gentoo"]:
    mask = penguins_clean["species"] == species
    print(species, penguins_clean.loc[mask, "body_mass_g"].mean())

print(mass_model.params)
print(mass_model.rsquared)
```

You should get Adelie 3706.164, Chinstrap 3733.088 and Gentoo 5092.437. The
`Intercept` in `mass_model.summary()` is 3706.16. The `species[T.Gentoo]`
coefficient is 1386.27, which is 5092.437 − 3706.164. The
`species[T.Chinstrap]` coefficient (26.92) is 3733.088 − 3706.164. Species
explains about 67% of the variation in body mass: the summary rounds R² to
0.674, and `mass_model.rsquared` gives 0.6745.

If the AI's explanation got any of this wrong, note what it was. That is the
kind of error you would otherwise have put in your report.

### Optional: a t-test, and when it would be wrong

> [!NOTE]
> **If you have time.** This section is optional. If you are short of time,
> skip to the Key points; the report in episode 08 does not need the t-test.

Ask your AI assistant: "Write Python code for a t-test of whether male and
female penguins differ in body mass, and tell me when this test would be wrong."

A typical answer is `stats.ttest_ind(male, female)` from scipy, run on all
penguins, which gives a tiny p-value. Before you trust it, ask:

- **Are the groups comparable?** This test pools three species of very
  different size, so the "male" and "female" groups are each a mixture. Compare
  within one species instead.
- **Which t-test?** scipy's `ttest_ind()` runs Student's test (equal
  variances) by default. R's `t.test()` runs Welch's test. Pass
  `equal_var=False` for Welch's test, and check which one the AI's
  explanation describes.
- **Are the observations independent?** One row per penguin, measured once.
  Check this for your own data.

```python
adelie = penguins_clean[penguins_clean["species"] == "Adelie"]
female_mass = adelie.loc[adelie["sex"] == "female", "body_mass_g"]
male_mass = adelie.loc[adelie["sex"] == "male", "body_mass_g"]

t_result = stats.ttest_ind(female_mass, male_mass, equal_var=False)
print(t_result)
print(t_result.confidence_interval())  # needs scipy 1.11 or later
print(female_mass.mean(), male_mass.mean())
```

Within Adelie penguins, males are on average 675 g heavier
(females 3368.8 g, males 4043.5 g; 95% CI for the female minus male
difference: −776 to −573 g).

<details>
<summary>Reference solution</summary>

```python
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()
print(mass_model.summary())
print(sm.stats.anova_lm(mass_model))

# Check: Intercept = Adelie mean; Gentoo coefficient = Gentoo mean - Adelie mean
for species in ["Adelie", "Chinstrap", "Gentoo"]:
    print(species, penguins_clean.loc[penguins_clean["species"] == species, "body_mass_g"].mean())

# t-test within one species, not pooled across species; Welch's test
adelie = penguins_clean[penguins_clean["species"] == "Adelie"]
female_mass = adelie.loc[adelie["sex"] == "female", "body_mass_g"]
male_mass = adelie.loc[adelie["sex"] == "male", "body_mass_g"]
t_result = stats.ttest_ind(female_mass, male_mass, equal_var=False)
print(t_result)
print(t_result.confidence_interval())
```

Catch-up file: [`checkpoints/after-07.py`](checkpoints/after-07.py).

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Add a "07 Statistics" section to analysis.py: the overall and per-species
> slopes of bill_depth_mm on bill_length_mm with smf.ols(),
> mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()
> with summary() and sm.stats.anova_lm(), and a within-Adelie Welch t-test
> (equal_var=False) of body_mass_g by sex. Run the script. Acceptance: the
> overall slope is negative and all three species slopes are positive; the
> Intercept equals the Adelie mean from a .loc boolean mask. Then write three
> sentences I could put in a Limitations section, and list any claim you are
> not sure of.
> ```
>
> Agents explain output as confidently as web AIs. Verify one claim from its
> explanation yourself before you accept the edit.

## Key points

- Pooling groups can reverse a relationship (Simpson's paradox). Ask the AI
  about grouping and confounders, then fit both ways.
- Use the formula interface, `smf.ols()`, so the model has an intercept.
- Ask the AI to explain each part of `summary()` output, including which parts
  do not apply, then check one claim with plain pandas.
- Ask what would make a test wrong before you report it. scipy's
  `ttest_ind()` assumes equal variances unless you pass `equal_var=False`.
- If you cannot explain a result, it does not go in the report. Record what
  you did not check in the Limitations section.
