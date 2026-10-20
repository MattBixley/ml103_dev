# AI Failure Modes

These are the mistakes an AI assistant makes most often in this workshop. Use them as teaching moments. Learners remember a failure they found themselves far longer than a warning you gave them.

AI output varies from run to run and between tools. Treat each entry as a pattern to look for, not a response you can predict. Before you teach a failure, reproduce it yourself on the day, and note the wording and tool that produced it.

## Summary

| Failure mode | Typical sign | Where it appears |
|---|---|---|
| [Two penguins datasets](#two-penguins-datasets) | Code uses `bill_len` where the learner expects `bill_length_mm` | Episode 04 |
| [Pipe style](#pipe-style) | `%>%` appears in code that asks for the native pipe | Episodes 05, 06 |
| [Superseded arguments](#superseded-arguments) | `size =` on a line geom, or `gather()` and `spread()` | Episodes 05, 06 |
| [Invented functions and arguments](#invented-functions-and-arguments) | A function or argument name that does not exist | Episodes 05, 06, 08 |
| [Silently dropped NA values](#silently-dropped-na-values) | Row counts fall without a warning or a mention | Episodes 04, 05 |
| [Wrong statistical interpretation](#wrong-statistical-interpretation) | A confident claim that a p-value is the probability the null is true | Episode 07 |
| [Simpson's paradox](#simpsons-paradox) | A correlation sign that flips when you group the data | Episode 07 |
| [Invented Slurm modules and partitions](#invented-slurm-modules-and-partitions) | A module name or partition that `module spider` does not list | Episode 09 |
| [Smart quotes from copy and paste](#smart-quotes-from-copy-and-paste) | `Error: unexpected input` on a line that looks correct | Episodes 04 to 08 |
| [Truncated code in AI Mode](#truncated-code-in-ai-mode) | The answer ends mid-function, or shows `# ... rest of code` | Episodes 04 to 08 |
| [Confidently wrong explanations](#confidently-wrong-explanations) | Plausible prose that contradicts the output | Episodes 07, 08 |
| [Outdated Quarto and R Markdown YAML](#outdated-quarto-and-r-markdown-yaml) | YAML that renders in an old format or fails to render | Episode 08 |

## Two Penguins Datasets

**What happens.** R 4.5 and later ship `datasets::penguins`, with short column names such as `bill_len`, `bill_dep`, `flipper_len` and `body_mass`. The `palmerpenguins` package uses `bill_length_mm`, `bill_depth_mm`, `flipper_length_mm` and `body_mass_g`. An AI assistant may write code for either version, without saying which one it chose.

**Teaching moment.** Ask learners to run the code the AI gives them. If it fails with "object not found" or "column doesn't exist", ask them which dataset the code uses. This failure makes a useful **Check it** exercise: the learner sees the mismatch, names the cause, and asks the AI to fix its own code with the dataset named in the prompt.

## Pipe Style

**What happens.** The native pipe `|>` arrived in R 4.1. Many AI answers still use the magrittr pipe `%>%`, which `library(tidyverse)` also makes available. Both pipes run in a `tidyverse` session, but mixed styles make a report harder to read.

**Teaching moment.** Put `|>` in the prompt. Then ask learners to find any `%>%` in the output and decide whether to change it. The workshop style is native pipe throughout.

## Superseded Arguments

**What happens.** ggplot2 3.4.0 replaced `size =` with `linewidth =` for lines. The old argument still runs with a deprecation warning, so learners may not notice. Likewise, `tidyr::gather()` and `tidyr::spread()` are superseded by `pivot_longer()` and `pivot_wider()`. Code with the old names still runs, but it signals an out-of-date source.

**Teaching moment.** Point out the deprecation warning when it appears. Ask learners to read the warning and check the function's help page for the current argument name. Put the style rule in the prompt so the AI does not use the old name.

## Invented Functions and Arguments

**What happens.** An AI assistant may call a function that does not exist, or pass an argument that a real function does not accept. Its explanation of the invented call often sounds sure of itself. Learners who cannot read R code well may not notice until the code fails.

**Teaching moment.** Ask learners to run `?function_name` for any function they do not recognise. If the help page does not list the argument, the AI made it up. Ask the AI to cite the help page, then check the citation yourself.

## Silently Dropped NA Values

**What happens.** Some functions drop missing values without a warning, and others return `NA` as the result. Filtering with `filter()` removes rows where the condition is `NA`. A summary that quietly excludes rows can change the numbers in the report. The `penguins_clean` object in episode 05 removes the 11 incomplete rows on purpose, so an unexplained change in row count is a warning sign.

**Teaching moment.** Ask learners to count rows before and after each step with `nrow()`. Then ask the AI what it did with the missing values. A good answer names the rows it removed. A poor answer does not mention them.

## Wrong Statistical Interpretation

**What happens.** An AI assistant often explains a p-value as the probability that the null hypothesis is true, or treats a non-significant result as proof of no effect. Its interpretation can also ignore the assumptions of a test. The wording sounds confident, so learners tend to copy it into the report.

**Teaching moment.** Use episode 07. Ask the AI to explain each line of the `summary()` output, then compare its explanation with a reference you trust. Ask it to name the assumptions and the conditions that would make the result wrong. Learners check one claim themselves before they accept any of them.

## Simpson's Paradox

**What happens.** In the penguins data, bill depth and bill length have a negative slope across all species combined, but a positive slope within each species. An AI answer that uses the pooled data gives a confident and wrong conclusion.

**Teaching moment.** Ask learners to plot the data twice, once pooled and once coloured by species. Then ask the AI what the two plots show. The better prompt in episode 07 asks about grouping and confounders. Use it to show why prompt wording changes the answer.

## Invented Slurm Modules and Partitions

**What happens.** An AI assistant may invent a module name, such as an R or conda module with a version that the cluster does not install. It may also name a partition, account or resource limit that the cluster does not use. The script looks reasonable, and fails only when the scheduler rejects it.

**Teaching moment.** Ask learners to run `module spider` on the cluster, or to check the documentation, before they accept any module name. Show how the AI's invented name differs from the real one. Do not criticise the learner who accepted it. Ask them to explain how they would check the name next time.

## Smart Quotes From Copy and Paste

**What happens.** Web pages and word processors replace straight quotes (`"` and `'`) with curly quotes (`“ ”` and `‘ ’`). R rejects curly quotes, and the error message does not explain why. The same code can look correct on screen.

**Teaching moment.** Ask learners to paste a line with a string into the R console, then read the error. Show them how to replace the curly quotes with straight quotes in the editor, using Find and Replace. Suggest that learners check the code in the editor before they run it.

## Truncated Code in AI Mode

**What happens.** Google Search AI Mode answers are short and grounded in search results. For long code, it may cut the answer short or replace part of it with a comment such as `# ... rest of code`.

**Teaching moment.** Add "give the complete code in one block" to the prompt. If the code is still cut short, ask the AI to continue from the last line. Show learners that the prompt is the fix, not a fault in their own code.

**Fallback.** If AI Mode is unavailable or truncates too often, switch to Duck.ai or logged-out ChatGPT, as the Track A backups. Use the same prompts. Note the tool change in the session notes.

## Confidently Wrong Explanations

**What happens.** An AI assistant may explain the output with fluent prose that contradicts the output. It can describe a plot that does not match the code, or claim a result the output does not show. Learners often trust the prose more than the numbers.

**Teaching moment.** Ask learners to find one claim in the explanation and check it against the output. The habit matters more than any single error. Use episode 10 to close the session with the human checklist.

## Outdated Quarto and R Markdown YAML

**What happens.** Older R Markdown templates use `output: html_document` in the YAML header. A Quarto document uses a `format:` key, and its YAML options differ from R Markdown. An AI assistant may mix the two, which produces a report that fails to render or renders without the options learners expect.

**Teaching moment.** In episode 08, ask learners to check the YAML header against the Quarto documentation before they render. Point out that `quarto render penguins_report.qmd` reads the header, so one wrong key can change the whole report.
