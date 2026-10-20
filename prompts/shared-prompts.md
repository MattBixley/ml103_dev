# Shared Prompts

Copy and paste these prompts into your AI assistant. The same prompts appear in [episode 01](../episodes/01-ai-and-ethics.md) and [episode 03](../episodes/03-prompt-anatomy.md), with notes on why they work.

## Test a made-up function (episode 01)

```text
Show me how to use penguin_sex_ratio() from the palmerpenguins package to get the proportion of female penguins for each species. Give me a complete example.
```

Check it in RStudio with `exists("penguin_sex_ratio")`. R returns `FALSE`. In Python, `hasattr(palmerpenguins, "penguin_sex_ratio")` returns `False` after `import palmerpenguins`.

## Draft an AI-use disclosure statement (episode 01)

```text
Generative AI tools were used in this analysis. [Tool name and version, and date accessed] was used to [task, for example: draft R (or Python) code for data cleaning and suggest plot layouts]. All AI-generated code was run, read and checked against [method, for example: base R (or plain pandas) results and row counts] by the author, who takes responsibility for the final content. Prompts used are recorded in [file or appendix]. No sensitive or identifiable data was entered into any AI tool.
```

Replace each square-bracketed field with your own details.

## Weak prompt: make a graph (episode 03)

```text
make a graph of my data
```

## Better prompt: scatter plot of penguins, R (episode 03)

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

## Better prompt: scatter plot of penguins, Python (episode 03)

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

## Follow-up: reduce overlap (episode 03)

```text
The points overlap heavily in the middle. Add a small amount of jitter, or use transparency, so that each point is visible. Keep everything else the same and give me the complete code block again.
```

## Follow-ups that help you learn (episode 03)

Adapted from [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/02-effective-prompting.html) (CC BY 4.0).

```text
Explain this code line by line for someone new to R.
```

```text
Mention anything you are uncertain about.
```

```text
Here is what I expected: [expected result]. Here is what happened: [actual result or error]. What am I missing?
```

## Reusable prompt template (episode 03)

Copy this template for any task. Replace each bracketed field, then delete any constraint you do not need.

```text
I am using R, and my R version is [paste the output of R.version.string]. I am working in RStudio. I have [package name and version, from packageVersion("package name")] installed. I am not using any other packages.

My data is [data set name]. Here is the output of glimpse([data set name]):
[paste the glimpse() output here]

Task: [one specific task, with the variables named exactly as they appear in the glimpse() output].

Constraints:
- Use [style, for example: tidyverse functions and the native pipe |>].
- Do not use [packages or functions you want to avoid].
- [Any other constraint, such as the colour scale, the labels or the file type].

Output: one complete, runnable code block that works in a fresh R session after the library() calls. Put a comment above each step.

Before the code, list your assumptions. After the code, tell me how to check that the result is correct.
```
