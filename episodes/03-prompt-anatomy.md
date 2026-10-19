# 03. Anatomy of a Good Prompt

**Time:** 10 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What must a prompt say before an AI can write useful R code?
- How do you describe your data without pasting it?
- How do you make the AI show you how to check its answer?

**Objectives**
- Write a prompt with context, data shape, task, constraints, output format and a verification request.
- Use `glimpse()` output to describe your data.
- Use the reusable template at the end of this episode.

## Why the prompt matters

An AI assistant can only use what you give it. If you leave out the R version, the packages, the column names or the style you want, the AI fills the gaps with its own guesses. Those guesses often look right and are not.

Each prompt in this workshop has a weak version and a better version. Write your own attempt first, then compare.

## Describe your data without pasting it

Paste the output of `glimpse()`, not the data. `glimpse()` shows the column names, their types and a few values. Those sample values are real data, so check them before you paste. For real research data, paste only the column names and types (see Card 7 in episode 02). Run this in RStudio:

```r
library(palmerpenguins)
glimpse(penguins)
```

The output starts with `Rows: 344` and `Columns: 8`. Each row after that shows one column, its type in angle brackets (such as `<fct>` for a factor or `<dbl>` for a decimal number), and the first few values.

Do not paste the whole data set. The AI does not need every row, and the rest of the data may be sensitive in a real project. See [episode 01](01-ai-and-ethics.md) for what must stay out of a web AI tool.

## Prompt 1: the quick version

```text
make a graph of my data
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- The AI picks variables for you, and they may not be the ones you wanted.
- It may use base R plotting, so the code does not match your tidyverse style.
- It may invent column names, such as `bill_len`, because it cannot see your data.
- It may give you several code blocks split by long explanations, so you cannot copy and run the code in one go.
- It does not tell you how to check the plot.

## Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| R version and package versions | Stops the AI from using functions that your version does not have |
| `glimpse()` output | Replaces invented column names with the real ones |
| Task with named variables | Removes the AI's choice of what to plot |
| Pipe and package constraints | Keeps the code in tidyverse style, not a mix of base R and tidyverse |
| Colour-blind-safe scale and labels | Produces a plot you can read and publish |
| One complete code block | Lets you copy and run the code without editing it piece by piece |
| "List your assumptions" and "how to check" | Shows you what the AI assumed, and gives you a way to test the result |

### Check it

Run the code in a fresh R session. Use **Session** > **Restart R**, then run the script from the top.

Then check the numbers:

```r
nrow(penguins)
nrow(penguins_plot_data)
sum(is.na(penguins$bill_length_mm) | is.na(penguins$flipper_length_mm))
```

The first number is 344. The number of dropped rows that R reports must equal the third number, the count of rows missing either measurement. If it does not, ask the AI which rows it dropped and why.

Look at the plot itself. You should see three groups, one for each species.

<details>
<summary>Reference solution</summary>

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

> [!NOTE]
> The reference solution shows one good answer. Your AI assistant may give a different, equally valid version. Check it against the same test.

> [!TIP]
> **Agent extension (Track B)**
> Give the agent these acceptance criteria: the script runs in a fresh R session with no errors; `figures/bill_vs_flipper.png` exists; the message reports the same number of dropped rows as the NA count above. Ask the agent to report any warnings. You approve each command before it runs.

## Iterate

A first answer rarely fits exactly. Ask a follow-up that names the change:

```text
The points overlap heavily in the middle. Add a small amount of jitter, or use transparency, so that each point is visible. Keep everything else the same and give me the complete code block again.
```

Asking for "the complete code block again" stops the AI from giving you a fragment that you must merge by hand.

## Key points

- Give the AI your R version, packages, the `glimpse()` output and a specific task.
- Paste `glimpse()` output, never the data.
- Set constraints: the pipe, the packages, the colour scale and the output format.
- Ask the AI for its assumptions and for a way to check the result.
- Iterate with a named change, and ask for the complete code each time.
