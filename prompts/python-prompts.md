# Python Prompt Library

Copy-paste prompts from the Python episodes 04 to 08. Each pair shows the quick
version a learner might type and a better version. Replace anything in
`<angle brackets>` and `3.x` or `2.x` with your own details before you send it.

> [!WARNING]
> Paste code, error messages and `info()` output only. Do not paste real
> research data into a web AI.

## 04. Load and Explore

Episode: [`python/04-explore.md`](../python/04-explore.md)

### Explore the Data

**Quick version**

```text
analyse the penguins data in python
```

**Better version**

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

## 05. Wrangle with pandas and Debug

Episode: [`python/05-wrangle.md`](../python/05-wrangle.md)

### Clean and Summarise

**Quick version**

```text
clean the penguins data and summarise it with pandas
```

**Better version**

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

### Debug with an AI

**Quick version**

```text
my python code doesn't work
```

**Better version**

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

## 06. Visualise with seaborn

Episode: [`python/06-visualise.md`](../python/06-visualise.md)

### Bill Length vs Bill Depth

**Quick version**

```text
plot penguins with seaborn
```

**Better version**

```text
I am using Python 3.x with pandas, seaborn 0.13 and matplotlib 3.x, and the
data frame penguins_clean (palmerpenguins columns, no missing values).

Write code that creates a matplotlib figure called p_bill with
p_bill, ax = plt.subplots(figsize=(7, 5)):
- sns.scatterplot() of x = bill_length_mm, y = bill_depth_mm, coloured by
  species (hue)
- one straight-line fit per species: loop over the species and call
  sns.regplot(scatter=False, ci=None) on each subset, in the same colour as
  its points. Do not use lmplot().
- the viridis palette, as a dictionary from species name to colour
- axis labels with units: "Bill length (mm)", "Bill depth (mm)"; legend title "Species"
- sns.set_theme(style="whitegrid")
Then save it with p_bill.savefig("figures/bill_length_depth.png", dpi=300),
creating the figures folder if it does not exist. Do not call plt.show()
before savefig(). Give the complete code in one block.
```

### Body Mass by Species and Sex

**Quick version**

```text
make a boxplot of penguin weight
```

**Better version**

```text
Using penguins_clean (palmerpenguins columns), seaborn 0.13 and matplotlib,
create a figure p_mass with
p_mass, axes = plt.subplots(1, 2, figsize=(7, 5), sharey=True),
one panel per sex (female, male). In each panel: body_mass_g by species as
sns.boxplot(showfliers=False, hue="species", legend=False) with the viridis
palette, plus the individual penguins as
sns.stripplot(jitter=0.2, color="black", alpha=0.5). Panel titles = sex,
y label "Body mass (g)", no x label.
Save it with p_mass.savefig("figures/body_mass.png", dpi=300).
```

## 07. Statistics

Episode: [`python/07-statistics.md`](../python/07-statistics.md)

### Bill Length and Bill Depth

**Quick version**

```text
Is there a relationship between bill length and bill depth in penguins? Give me Python code.
```

**Better version**

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

### Body Mass by Species

**Quick version**

```text
what does this mean?
<pasted mass_model.summary() output>
```

**Better version**

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

### t-Test Check

```text
Write Python code for a t-test of whether male and female penguins differ in
body mass, and tell me when this test would be wrong.
```

## 08. Assemble the Quarto Report

Episode: [`python/08-report.md`](../python/08-report.md)

### Build the Report

**Quick version**

```text
write a report about the penguins data
```

**Better version**

```text
I have a Python script analysis.py (pandas, seaborn, matplotlib, statsmodels,
palmerpenguins) that creates penguins, penguins_clean, species_summary,
p_bill, p_mass and
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit().
Here is the script:

<paste analysis.py>

Turn it into a Quarto document penguins_report.qmd that renders to HTML with
`quarto render penguins_report.qmd` using the Jupyter engine.
- YAML header: title, author, date: today, jupyter: python3, format: html
  with embed-resources: true, code-fold: true and toc: true
- A setup cell that imports the packages and loads the data
- Sections: Introduction and data source; Data cleaning; Summary tables
  (by species, island and sex, shown as data frames); Figures; Simple
  comparison (overall vs per-species slopes, mass_model); Limitations;
  AI-use statement; Session information (Python and package versions)
- Use ```{python} cells with Quarto #| options: labels, figure captions and
  table captions. Keep figsize=(7, 5) and end each figure cell with plt.show().
- Create every object inside the document. No pip install, os.chdir() or
  %reset.
- Use inline `{python}` expressions for every number in the text, rounded
  with round().
Leave the Limitations and AI-use statement sections as headings with a
placeholder sentence: I will write those myself.
```
