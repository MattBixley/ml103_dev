# 06. Visualise with seaborn

**Time:** 20 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What does a plot prompt need so the first answer is close to publishable?
- How do I check that a plot shows all the data and the right relationship?

**Objectives**
- Create `p_bill` and `p_mass` with prompts that name the variables, mappings,
  palette, labels and output size.
- Recognise outdated seaborn code (`ci=` on `barplot()`, `palette=` without
  `hue=`) from its warning.
- Check a plot by counting its points and comparing it with a quick pandas plot.
- Save figures to `figures/` with `savefig()` at 7 × 5 inches and 300 dpi.

## Bill Length vs Bill Depth

These notes use seaborn's classic functions (`sns.scatterplot()`,
`sns.regplot()`, `sns.boxplot()`, `sns.stripplot()`) on matplotlib figures,
because that is what most AI answers produce. `p_bill` and `p_mass` are
matplotlib `Figure` objects.

### Prompt 1: the quick version

```text
plot penguins with seaborn
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **The AI picks the question.** You may get `sns.pairplot()` of every
  column, or a bar chart of species counts, which is a valid plot but not the
  one you need.
- **One trend line for all species.** `sns.regplot()` has no `hue` argument.
  `sns.regplot(..., hue="species")` stops with
  `TypeError: regplot() got an unexpected keyword argument 'hue'`, and the
  usual "fix" drops `hue`, which fits one line through all the penguins. That
  line slopes the wrong way (episode 07 explains why).
- **A figure-level function in an axes-level layout.** `sns.lmplot(hue="species")`
  does draw one line per species, but it makes its own figure (a `FacetGrid`).
  It has no `ax=` argument and ignores `plt.subplots(figsize=...)`; its size
  comes from `height=` and `aspect=`. Mixing the two families gives empty figures or the
  wrong size.
- **Outdated arguments.** seaborn 0.12 replaced `ci=` with `errorbar=` in
  `barplot()`, `pointplot()` and `lineplot()`. Old code still draws, with a
  warning: ``FutureWarning: The `ci` parameter is deprecated. Use
  `errorbar='sd'` for the same effect.`` `regplot()` and `lmplot()` still use
  `ci=`, so the AI cannot apply one rule everywhere.
- **Missing values dropped in silence.** seaborn leaves out rows with `NaN`
  and gives no warning. Plot `penguins_clean` so the plot and your tables use
  the same 333 penguins.
- **Default colours.** The default palette includes red and green hues that
  many people with colour-vision deficiency cannot tell apart.
- **Axis labels from column names** (`bill_length_mm`) and no units.
- **Saving the wrong thing.** In a script, `plt.savefig()` after `plt.show()`
  saves an empty image once you close the plot window. Without `figsize=` and `dpi=`, matplotlib uses its
  defaults (6.4 × 4.8 inches at 100 dpi), so the file is too small to print.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| `seaborn 0.13 and matplotlib 3.x` | Current argument names, no deprecation warnings |
| `penguins_clean` | Same rows as your tables, no silent drops |
| Exact `x`, `y` and `hue` mapping | The plot you need |
| `loop over the species … regplot` and `Do not use lmplot()` | One line per species on your own figure |
| `viridis palette, as a dictionary` | Colours most readers can tell apart, matched between points and lines |
| Labels with units | A figure readers understand without the code |
| `figsize=(7, 5)` and `dpi=300` | The same 2100 × 1500 pixel file every time you run the script |
| `figure called p_bill` | The report in episode 08 reuses this name |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
from pathlib import Path

import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
species_list = sorted(penguins_clean["species"].unique())
colours = dict(zip(species_list, sns.color_palette("viridis", len(species_list))))

p_bill, ax = plt.subplots(figsize=(7, 5))
sns.scatterplot(data=penguins_clean, x="bill_length_mm", y="bill_depth_mm",
                hue="species", palette=colours, ax=ax)
for sp in species_list:
    sns.regplot(data=penguins_clean[penguins_clean["species"] == sp],
                x="bill_length_mm", y="bill_depth_mm",
                scatter=False, ci=None, color=colours[sp], ax=ax)
ax.set(xlabel="Bill length (mm)", ylabel="Bill depth (mm)")
ax.legend(title="Species")

Path("figures").mkdir(exist_ok=True)
p_bill.savefig("figures/bill_length_depth.png", dpi=300)
print("Saved figures/bill_length_depth.png")
```

**Output when run:**

```text
Saved figures/bill_length_depth.png
[plot: figures/bill_length_depth.png]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

Find your versions with `print(sns.__version__, matplotlib.__version__)`
after `import matplotlib`.

### Check it

A plot can look right and still be wrong. Check three things:

```python
ax = p_bill.axes[0]
print(len(ax.collections[0].get_offsets()))          # points drawn: should be 333
print(plt.imread("figures/bill_length_depth.png").shape)  # (1500, 2100, 4)

penguins_clean.plot.scatter(x="bill_length_mm", y="bill_depth_mm")  # quick pandas version
plt.show()
```

The scatter plot's points live in `ax.collections[0]`, and `get_offsets()`
returns one row per point. The image shape is height × width × colour
channels: 7 × 5 inches at 300 dpi gives 2100 × 1500 pixels.

Compare the two plots. Both should show three clusters. In the seaborn
version, each species' line should slope *upwards*. If you see a single
downward line, the per-species fits are missing.

<details>
<summary>Reference solution</summary>

```python
from pathlib import Path

import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
species_order = ["Adelie", "Chinstrap", "Gentoo"]
colours = dict(zip(species_order, sns.color_palette("viridis", 3)))

p_bill, ax = plt.subplots(figsize=(7, 5))
sns.scatterplot(
    data=penguins_clean, x="bill_length_mm", y="bill_depth_mm",
    hue="species", hue_order=species_order, palette=colours, alpha=0.7, ax=ax,
)
for species, colour in colours.items():
    sns.regplot(
        data=penguins_clean[penguins_clean["species"] == species],
        x="bill_length_mm", y="bill_depth_mm",
        scatter=False, ci=None, color=colour, ax=ax,
    )
ax.set(
    xlabel="Bill length (mm)",
    ylabel="Bill depth (mm)",
    title="Bill depth increases with bill length within each species",
)
ax.legend(title="Species")

Path("figures").mkdir(exist_ok=True)
p_bill.savefig("figures/bill_length_depth.png", dpi=300)
```

</details>

## Body Mass by Species and Sex

### Prompt 1: the quick version

```text
make a boxplot of penguin weight
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **Points drawn twice.** A boxplot draws outliers as points; adding
  `sns.stripplot()` draws them a second time. Use `showfliers=False`.
- **Jitter added by hand.** Some answers add random noise with `numpy` to both
  x and y, so points no longer sit at their true body mass.
  `sns.stripplot(jitter=0.2)` moves points sideways only.
- **Sex left out**, although males are heavier in every species.
- **`weight` invented as a column name.** seaborn stops with
  ``ValueError: Could not interpret value `weight` for `y`.`` The column is
  `body_mass_g`.
- **`palette=` without `hue=`.** seaborn 0.13 warns: ``FutureWarning: Passing
  `palette` without assigning `hue` is deprecated``. Set `hue="species"` and
  `legend=False`.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| `body_mass_g` | No invented `weight` column |
| `showfliers=False` | Each penguin drawn once |
| `stripplot(jitter=0.2)` | Jitter moves points sideways only, so masses stay true |
| `hue="species", legend=False` | Current seaborn syntax for coloured boxes, no warning |
| `one panel per sex` | Shows the sex difference the model in episode 07 ignores |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
import matplotlib.pyplot as plt
import seaborn as sns

p_mass, axes = plt.subplots(1, 2, figsize=(7, 5), sharey=True)
for ax, sex in zip(axes, ["female", "male"]):
    subset = penguins_clean[penguins_clean["sex"] == sex]
    sns.boxplot(data=subset, x="species", y="body_mass_g", hue="species",
                palette="viridis", showfliers=False, legend=False, ax=ax)
    sns.stripplot(data=subset, x="species", y="body_mass_g",
                  jitter=0.2, color="black", alpha=0.5, ax=ax)
    ax.set_title(sex)
    ax.set_xlabel("")
axes[0].set_ylabel("Body mass (g)")

p_mass.savefig("figures/body_mass.png", dpi=300)
print(penguins_clean.groupby("sex").size())
```

**Output when run:**

```text
sex
female    165
male      168
dtype: int64
[plot: figures/body_mass.png]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Check it

```python
print(sum(len(c.get_offsets()) for ax in p_mass.axes for c in ax.collections))  # 333
print(penguins_clean.pivot_table(index="species", columns="sex",
                                 values="body_mass_g", aggfunc="median"))
```

Each `stripplot()` adds one collection of points per species, so the sum
counts every penguin across both panels. The medians from `pivot_table()`
(Adelie 3400 and 4000 g, Chinstrap 3550 and 3950 g, Gentoo 4700 and 5500 g for
females and males) should match the line inside each box.

> [!NOTE]
> With matplotlib 3.11 or later, you may see
> `MatplotlibDeprecationWarning: vert: bool was deprecated in Matplotlib 3.11`
> when warnings are switched on. It comes from inside seaborn 0.13.2, not from
> your code, and the plot is still correct. Read the file path in a warning
> before you ask an AI to "fix" it.

<details>
<summary>Reference solution</summary>

```python
p_mass, axes = plt.subplots(1, 2, figsize=(7, 5), sharey=True)
for ax, sex in zip(axes, ["female", "male"]):
    subset = penguins_clean[penguins_clean["sex"] == sex]
    sns.boxplot(
        data=subset, x="species", y="body_mass_g", order=species_order,
        hue="species", palette=colours, legend=False,
        showfliers=False, boxprops={"alpha": 0.5}, ax=ax,
    )
    sns.stripplot(
        data=subset, x="species", y="body_mass_g", order=species_order,
        color="black", jitter=0.2, alpha=0.5, size=3, ax=ax,
    )
    ax.set(title=sex, xlabel="", ylabel="Body mass (g)")
p_mass.suptitle("Body mass by species and sex")

p_mass.savefig("figures/body_mass.png", dpi=300)
```

Catch-up file: [`checkpoints/after-06.py`](checkpoints/after-06.py).

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Add a "06 Visualise" section to analysis.py that creates p_bill and p_mass
> as described in episode 06 and saves them to figures/ with
> savefig(dpi=300) from figures made with figsize=(7, 5). Run the script with
> the Python in .venv. Acceptance: no warnings in the output; p_bill shows
> 333 points; both PNG files exist and are 2100 x 1500 pixels; no lmplot(),
> no ci= on barplot() and no palette= without hue=.
> ```
>
> If your agent can read images, ask it to open `figures/bill_length_depth.png`
> and describe the slope of each species' line. Compare its description with
> what you see. Approve each edit and each run.

## Key points

- Name the variables, the mappings, the palette, the labels and the output
  size in the prompt.
- seaborn changed `ci=` to `errorbar=` in 0.12 and now wants `hue=` with
  `palette=`. A `FutureWarning` means the AI learned from older code.
- Check plots by counting points with `get_offsets()` and comparing with a
  quick pandas plot or `pivot_table()` summary.
- Save with `figsize=(7, 5)` and `savefig(dpi=300)`, and never after `plt.show()`.
