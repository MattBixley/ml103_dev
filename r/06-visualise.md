# 06. Visualise with ggplot2

**Time:** 20 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What does a plot prompt need so the first answer is close to publishable?
- How do I check that a plot shows all the data and the right relationship?

**Objectives**
- Create `p_bill` and `p_mass` with prompts that name the variables, mappings,
  palette, labels and output size.
- Recognise outdated ggplot2 code (`size =` for lines) from its warning.
- Check a plot by counting its points and comparing it with a quick base R plot.
- Save figures to `figures/` with `ggsave()`.

## Bill Length vs Bill Depth

### Prompt 1: the quick version

```text
plot penguins in ggplot
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **The AI picks the question.** You may get a bar chart of species counts or
  flipper length against body mass, which is a valid plot but not the one you need.
- **One trend line for all species.** If `colour = species` sits only inside
  `geom_point()`, `geom_smooth()` fits one line through all the penguins. That
  line slopes the wrong way (episode 07 explains why).
- **Outdated arguments.** `geom_smooth(size = 1)` and `geom_line(size = 1)`
  come from ggplot2 before 3.4.0. They still draw, with a warning:
  ``Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0. Please use
  `linewidth` instead.`` Points still use `size`.
- **Missing values.** Plotting raw `penguins` gives the warning ``Removed 2 rows
  containing missing values or values outside the scale range
  (`geom_point()`).`` Plot `penguins_clean` instead.
- **Default colours.** The default red, green and blue hues are hard to tell
  apart for many people with colour-vision deficiency.
- **Axis labels from column names** (`bill_length_mm`) and no units.
- **`ggsave()` without a size**, so the file takes the size of your plot window
  and changes every time you resize RStudio.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| `ggplot2 4.x` and `linewidth not size` | Current argument names, no deprecation warning |
| `penguins_clean` | No missing-value warning; same rows as your tables |
| Exact `x`, `y` and `colour` mapping | The plot you need, with one line per species |
| `scale_colour_viridis_d` | Colours most readers can tell apart, also in greyscale |
| Labels with units | A figure readers understand without the code |
| `ggsave(… width = 7, height = 5, dpi = 300)` | The same file every time you run the script |
| `object called p_bill` | The report in episode 08 reuses this name |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
p_bill <- ggplot(penguins_clean,
                 aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1) +
  scale_colour_viridis_d() +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)", colour = "Species") +
  theme_minimal()

print(p_bill)

if (!dir.exists("figures")) dir.create("figures")
ggsave("figures/bill_length_depth.png", p_bill, width = 7, height = 5, dpi = 300)
```

**Output when run:**

```text
[plot: figures/bill_length_depth.png]
```

**Notes:** No warnings. Each species' line slopes upwards. The default viridis palette ends in pale yellow, which is hard to see on white; the reference uses `end = 0.85`.

</details>

Find your ggplot2 version with `packageVersion("ggplot2")`.

### Check it

A plot can look right and still be wrong. Check three things:

```r
nrow(layer_data(p_bill, 1))   # points drawn: should be 333, nrow(penguins_clean)
plot(bill_depth_mm ~ bill_length_mm, data = penguins_clean,
     col = penguins_clean$species)  # quick base R version of the same plot
file.exists("figures/bill_length_depth.png")
```

Compare the two plots. Both should show three clusters. In the ggplot2
version, each species' line should slope *upwards*. If you see a single
downward line, the colour mapping is in the wrong place.

<details>
<summary>Reference solution</summary>

```r
p_bill <- ggplot(
  penguins_clean,
  aes(x = bill_length_mm, y = bill_depth_mm, colour = species)
) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1) +
  scale_colour_viridis_d(end = 0.85) +
  labs(
    x = "Bill length (mm)",
    y = "Bill depth (mm)",
    colour = "Species",
    title = "Bill depth increases with bill length within each species"
  ) +
  theme_minimal()

p_bill

dir.create("figures", showWarnings = FALSE)
ggsave("figures/bill_length_depth.png", p_bill, width = 7, height = 5, dpi = 300)
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
  `geom_jitter()` draws them a second time. Use `outlier.shape = NA`.
- **Jitter in both directions.** By default `geom_jitter()` moves points up and
  down as well as sideways, so points no longer sit at their true body mass.
  Set `height = 0` to keep the values true and spread points sideways only.
- **Sex left out**, although males are heavier in every species.
- **`weight` invented as a column name.** The column is `body_mass_g`.

### Prompt 2: a better version

```text
Using penguins_clean (palmerpenguins columns) and ggplot2, create p_mass:
body_mass_g by species as a boxplot (outlier.shape = NA) with the individual
penguins as jittered points (width = 0.2, height = 0), one panel per sex
(facet_wrap), boxes filled by species with scale_fill_viridis_d, y label
"Body mass (g)", no x label, no legend, theme_minimal().
Save it with ggsave("figures/body_mass.png", p_mass, width = 7, height = 5, dpi = 300).
```

| Part of the prompt | What it fixes |
|---|---|
| `body_mass_g` | No invented `weight` column |
| `outlier.shape = NA` | Each penguin drawn once |
| `height = 0` | Jitter moves points sideways only, so masses stay true |
| `one panel per sex` | Shows the sex difference the model in episode 07 ignores |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
p_mass <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.5) +
  facet_wrap(~ sex) +
  scale_fill_viridis_d() +
  labs(x = NULL, y = "Body mass (g)") +
  theme_minimal() +
  theme(legend.position = "none")

p_mass

ggsave("figures/body_mass.png", p_mass, width = 7, height = 5, dpi = 300)
```

**Output when run:**

```text
[plot: figures/body_mass.png]
```

**Notes:** No warnings. Check the jitter has `height = 0` so masses are not moved.

</details>

### Check it

```r
nrow(layer_data(p_mass, 2))                          # jittered points: 333
tapply(penguins_clean$body_mass_g,
       list(penguins_clean$species, penguins_clean$sex), median)
```

The medians from `tapply()` should match the thick line in each box.

<details>
<summary>Reference solution</summary>

```r
p_mass <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.5, size = 1) +
  facet_wrap(~sex) +
  scale_fill_viridis_d(end = 0.85) +
  labs(x = NULL, y = "Body mass (g)", title = "Body mass by species and sex") +
  theme_minimal() +
  theme(legend.position = "none")

p_mass

ggsave("figures/body_mass.png", p_mass, width = 7, height = 5, dpi = 300)
```

Catch-up file: [`checkpoints/after-06.R`](checkpoints/after-06.R).

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Add a "06 Visualise" section to analysis.R that creates p_bill and p_mass
> as described in episode 06 and saves them to figures/ with
> ggsave(width = 7, height = 5, dpi = 300). Run the script with Rscript.
> Acceptance: no warnings in the output; nrow(layer_data(p_bill, 1)) == 333;
> both PNG files exist; no use of size= for lines.
> ```
>
> If your agent can read images, ask it to open `figures/bill_length_depth.png`
> and describe the slope of each species' line. Compare its description with
> what you see. Approve each edit and each run.

## Key points

- Name the variables, the mappings, the palette, the labels and the output
  size in the prompt.
- ggplot2 uses `linewidth` for lines since version 3.4.0. A `size` warning
  means the AI learned from older code.
- Check plots by counting points with `layer_data()` and comparing with a quick
  base R plot or `tapply()` summary.
- Save with `ggsave()` and an explicit `width`, `height` and `dpi`.
