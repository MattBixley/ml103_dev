# 03. Anatomy of a Good Prompt

**Time:** 10 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What must a prompt say before an AI can write useful R or Python code?
- How do you describe your data without pasting it?
- How do you make the AI show you how to check its answer?

**Objectives**
- Write a prompt with context, data shape, task, constraints, output format and a verification request.
- Use `glimpse()` output (Python: `penguins.info()` and `penguins.head()`) to describe your data.
- Use the reusable template at the end of this episode.

## Why the prompt matters

An AI assistant can only use what you give it. If you leave out the R or Python version, the packages, the column names or the style you want, the AI fills the gaps with its own guesses. Those guesses often look right and are not.

Each prompt in this workshop has a weak version and a better version. Write your own attempt first, then compare.

## Describe your data without pasting it

<!-- tabs -->

#### R

Paste the output of `glimpse()`, not the data. `glimpse()` shows the column names, their types and a few values. Those sample values are real data, so check them before you paste. For real research data, paste only the column names and types (see Card 7 in episode 02). Run this in RStudio:

```r
library(tidyverse)
library(palmerpenguins)
glimpse(penguins)
```

The output starts with `Rows: 344` and `Columns: 8`. Each row after that shows one column, its type in angle brackets (such as `<fct>` for a factor or `<dbl>` for a decimal number), and the first few values.

#### Python

Paste the output of `penguins.info()` and `penguins.head()`, not the data. `penguins.info()` gives the row count, column names, types and non-null counts. `penguins.head()` shows the first five rows, and those are real data values, so check them before you paste. For real research data, paste only `penguins.info()` (or `penguins.dtypes`) (see Card 7 in episode 02). Run this in Python:

```python
from palmerpenguins import load_penguins
penguins = load_penguins()
penguins.info()
print(penguins.head())
```

`penguins.info()` reports 344 entries and 8 columns. Types show as `str` for text columns (pandas 2 prints `object`) and `float64` for decimal numbers.

<!-- /tabs -->

Do not paste the whole data set. The AI does not need every row, and the rest of the data may be sensitive in a real project. See [episode 01](01-ai-and-ethics.md) for what must stay out of a web AI tool.

## Prompt 1: the quick version

```text
make a graph of my data
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- The AI picks variables for you, and they may not be the ones you wanted.
- It may use base R plotting, so the code does not match your tidyverse style. In Python it may mix plain matplotlib, pandas `.plot()` and seaborn.
- It may invent column names, such as `bill_len`, because it cannot see your data.
- It may give you several code blocks split by long explanations, so you cannot copy and run the code in one go.
- It does not tell you how to check the plot.

## Prompt 2: a better version

<!-- tabs -->

#### R

Before you use this prompt, run `R.version.string` and `packageVersion("tidyverse")` in the Console. Replace the bracketed text with the results and the `glimpse()` output from your own session.

```text
I am using R, and my R version is [paste the output of R.version.string]. I am working in RStudio. I have tidyverse version [paste the output of packageVersion("tidyverse")] and palmerpenguins installed. I am not using any other packages.

My data is palmerpenguins::penguins. Here is the output of glimpse(penguins):
[paste the glimpse() output here]

Task: make a scatter plot of bill length (bill_length_mm, on the x axis) against flipper length (flipper_length_mm, on the y axis), with one point per penguin, coloured by species. Drop rows that are missing either measurement, and tell me how many rows you dropped.

Constraints:
- Use ggplot2 from the tidyverse, and use the native pipe |> to build the code.
- Do not use base R plotting or any package other than tidyverse and palmerpenguins.
- Use a colour-blind-safe colour scale, and name the function you used.
- Give the plot a title, axis labels with units (mm), and a legend title.

Output: one complete, runnable code block that works in a fresh R session after library(tidyverse) and library(palmerpenguins). Put a comment above each step. Save the plot to figures/ with ggsave(width = 7, height = 5, dpi = 300).

Before the code, list your assumptions. After the code, tell me how to check that the plot is correct.
```

#### Python

Before you use this prompt, run `python --version` in a terminal, and `import pandas, seaborn; print(pandas.__version__, seaborn.__version__)` in Python. Replace the bracketed text with the results and your own `penguins.info()` and `penguins.head()` output.

```text
I am using Python [paste the output of python --version] in [Jupyter / VS Code]. I have pandas [version], seaborn [version] and palmerpenguins installed. I am not using any other packages.

My data is loaded with: from palmerpenguins import load_penguins; penguins = load_penguins()
Here is the output of penguins.info():
[paste the penguins.info() output here]
And penguins.head():
[paste the penguins.head() output here]

Task: make a scatter plot of bill length (bill_length_mm, on the x axis) against flipper length (flipper_length_mm, on the y axis), with one point per penguin, coloured by species. Drop rows that are missing either measurement, and tell me how many rows you dropped.

Constraints:
- Use pandas for the data step and seaborn for the plot (matplotlib only for saving and labels).
- Do not use any package other than pandas, seaborn, matplotlib and palmerpenguins.
- Use a colour-blind-safe palette, and name it.
- Give the plot a title, axis labels with units (mm), and a legend title.

Output: one complete, runnable code block that works in a fresh Python session. Put a comment above each step. Save the plot to figures/ with dpi=300 at 7 by 5 inches.

Before the code, list your assumptions. After the code, tell me how to check that the plot is correct.
```

<!-- /tabs -->

| Part of the prompt | What it fixes |
|---|---|
| R (or Python) version and package versions | Stops the AI from using functions that your version does not have |
| `glimpse()` (or `penguins.info()` and `penguins.head()`) output | Replaces invented column names with the real ones |
| Task with named variables | Removes the AI's choice of what to plot |
| Pipe and package constraints | Keeps the code in tidyverse style, not a mix of base R and tidyverse |
| Colour-blind-safe scale and labels | Produces a plot you can read and publish |
| One complete code block | Lets you copy and run the code without editing it piece by piece |
| "List your assumptions" and "how to check" | Shows you what the AI assumed, and gives you a way to test the result |

<!-- tabs -->

#### R

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```r
# Load the packages
library(tidyverse)
library(palmerpenguins)

# Drop rows missing either measurement and report how many were removed
penguins_plot_data <- penguins |>
  filter(!is.na(bill_length_mm), !is.na(flipper_length_mm))
cat("Rows dropped:", nrow(penguins) - nrow(penguins_plot_data), "\n")

# Scatter plot coloured by species, using the viridis scale (scale_colour_viridis_d)
p <- penguins_plot_data |>
  ggplot(aes(x = bill_length_mm, y = flipper_length_mm, colour = species)) +
  geom_point() +
  scale_colour_viridis_d() +
  labs(title = "Bill length vs flipper length",
       x = "Bill length (mm)", y = "Flipper length (mm)", colour = "Species")

# Save the plot
dir.create("figures", showWarnings = FALSE)
ggsave("figures/bill_vs_flipper.png", p, width = 7, height = 5, dpi = 300)
```

**Output when run:**

```text
Rows dropped: 2
[plot: figures/bill_vs_flipper.png]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

#### Python

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```python
# Load the packages and the data
import os
import matplotlib.pyplot as plt
import seaborn as sns
from palmerpenguins import load_penguins

penguins = load_penguins()

# Drop rows missing either measurement and report how many were removed
penguins_plot_data = penguins.dropna(subset=["bill_length_mm", "flipper_length_mm"])
print("Rows dropped:", len(penguins) - len(penguins_plot_data))

# Scatter plot coloured by species, using seaborn's "colorblind" palette
plt.figure(figsize=(7, 5))
ax = sns.scatterplot(data=penguins_plot_data, x="bill_length_mm",
                     y="flipper_length_mm", hue="species", palette="colorblind")
ax.set(title="Bill length vs flipper length",
       xlabel="Bill length (mm)", ylabel="Flipper length (mm)")
ax.legend(title="Species")

# Save the plot
os.makedirs("figures", exist_ok=True)
plt.savefig("figures/bill_vs_flipper.png", dpi=300)
```

**Output when run:**

```text
Rows dropped: 2
[plot: figures/bill_vs_flipper.png]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

<!-- /tabs -->

### Check it

<!-- tabs -->

#### R

Run the code in a fresh R session. Use **Session** > **Restart R**, then run the script from the top.

Then check the numbers:

```r
nrow(penguins)
nrow(penguins_plot_data)
sum(is.na(penguins$bill_length_mm) | is.na(penguins$flipper_length_mm))
```

#### Python

Restart the kernel (**Kernel** > **Restart**) and run every cell from the top, then check:

```python
print(len(penguins))
print(len(penguins_plot_data))
print((penguins["bill_length_mm"].isna() | penguins["flipper_length_mm"].isna()).sum())
```

<!-- /tabs -->

Use the AI's name for the filtered data frame if it chose a different one.

The first number is 344. The number of dropped rows that your code reports must equal the third number, the count of rows missing either measurement. If it does not, ask the AI which rows it dropped and why.

Look at the plot itself. You should see three groups, one for each species.

<!-- tabs -->

#### R

<details>
<summary>Reference solution (R)</summary>

```r
# Load the packages
library(tidyverse)
library(palmerpenguins)

# Keep only rows with both measurements present, and count what we drop
penguins_plot_data <- penguins |>
  drop_na(bill_length_mm, flipper_length_mm)

n_dropped <- nrow(penguins) - nrow(penguins_plot_data)
message("Rows dropped for missing values: ", n_dropped)

# Scatter plot coloured by species
p <- penguins_plot_data |>
  ggplot(aes(x = bill_length_mm, y = flipper_length_mm, colour = species)) +
  geom_point() +
  scale_colour_viridis_d() +
  labs(
    title = "Flipper length against bill length by species",
    x = "Bill length (mm)",
    y = "Flipper length (mm)",
    colour = "Species"
  )

p

# Save the plot to figures/
dir.create("figures", showWarnings = FALSE)
ggsave("figures/bill_vs_flipper.png", p, width = 7, height = 5, dpi = 300)
```

</details>

#### Python

<details>
<summary>Reference solution (Python)</summary>

```python
# Load the packages and the data
from pathlib import Path

import matplotlib.pyplot as plt
import seaborn as sns
from palmerpenguins import load_penguins

penguins = load_penguins()

# Keep only rows with both measurements present, and count what we drop
penguins_plot_data = penguins.dropna(subset=["bill_length_mm", "flipper_length_mm"])
n_dropped = len(penguins) - len(penguins_plot_data)
print(f"Rows dropped for missing values: {n_dropped}")

# Scatter plot coloured by species, with a colour-blind-safe palette
fig, ax = plt.subplots(figsize=(7, 5))
sns.scatterplot(
    data=penguins_plot_data,
    x="bill_length_mm",
    y="flipper_length_mm",
    hue="species",
    palette="colorblind",
    ax=ax,
)
ax.set_title("Flipper length against bill length by species")
ax.set_xlabel("Bill length (mm)")
ax.set_ylabel("Flipper length (mm)")
ax.legend(title="Species")

# Save the plot to figures/
Path("figures").mkdir(exist_ok=True)
fig.savefig("figures/bill_vs_flipper.png", dpi=300)
```

</details>

<!-- /tabs -->

> [!NOTE]
> The reference solution shows one good answer. Your AI assistant may give a different, equally valid version. Check it against the same test.

> [!TIP]
> **Agent extension (Track B)**
> Give the agent these acceptance criteria: the script runs in a fresh R (or Python) session with no errors; `figures/bill_vs_flipper.png` exists; the message reports the same number of dropped rows as the NA count above. Ask the agent to report any warnings. You approve each command before it runs.

## Iterate

A first answer rarely fits exactly. Ask a follow-up that names the change:

```text
The points overlap heavily in the middle. Add a small amount of jitter, or use transparency, so that each point is visible. Keep everything else the same and give me the complete code block again.
```

Asking for "the complete code block again" stops the AI from giving you a fragment that you must merge by hand.

## Key points

- Give the AI your R or Python version, packages, the `glimpse()` (or `penguins.info()` and `penguins.head()`) output and a specific task.
- Paste `glimpse()` or `penguins.info()` output, never the data.
- Set constraints: the pipe, the packages, the colour scale and the output format.
- Ask the AI for its assumptions and for a way to check the result.
- Iterate with a named change, and ask for the complete code each time.
