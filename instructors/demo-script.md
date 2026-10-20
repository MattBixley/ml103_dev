# Demo Script

This script covers the live-coding demo for episodes 03 to 08. Use Google Search AI Mode on a projected screen, signed out, as the Track A tool. The demo follows the same weak-then-better pattern as the learner episodes, so learners see the method before they try it.

AI output varies. Read each "What to point out" item as a likely outcome, and rehearse each prompt before the session to see what your tool returns on the day. Do not promise learners a particular answer.

The demo runs in R. Python learners in the room follow the same prompts from [python/](../python/README.md), which mirror each R episode. Mention once, at episode 04, that their Prompt 2 blocks name the Python version, pandas and seaborn and paste `penguins.info()` and `penguins.head()` instead of `glimpse()`, and that the **Check it** numbers are the same.

## Before You Start

- Open a private window and sign out of Google. Load AI Mode, and check that it answers a simple question.
- Open the RStudio project `ml103-penguins` in a second window, with `analysis.R` ready. Do not type into it until the demo reaches that step.
- Keep the Prompt 1 and Prompt 2 blocks from each episode open in a text editor. Copy from the text file, not from the web page, so you avoid smart quotes in the prompt.
- Have [ai-failure-modes.md](ai-failure-modes.md) open for the entry that matches each episode.

## How to Run Each Episode Segment

For each episode:

1. **Type the weak prompt** (Prompt 1) into AI Mode, and say why you chose it. Do not explain the problems yet.
2. **Show the answer.** Pause, and ask learners what they notice. Then point out the failures listed below, if they appear.
3. **Type the better prompt** (Prompt 2) into a new AI Mode session, and say which part of the prompt you changed.
4. **Paste the code** into the project file, run it, and do the **Check it** step aloud.

If AI Mode returns truncated code, add "give the complete code in one block" and ask again.

## Episode 03: Anatomy of a Good Prompt

**Weak prompt.** "make a graph of my data". Type it, and show the answer, which will probably ask for more information.

**What to point out.**

- The answer often asks for the data, the variables and the package. Name each missing piece aloud. That is the lesson of this episode.
- Then type the better prompt from episode 03, which names the data shape, the package, the style and the output.

**Close.** Ask learners to name the four or five parts of the better prompt before you move on.

## Episode 04: Load and Explore Penguins

**Weak prompt.** "analyse the penguins data in R". Type it, and show the answer.

**What to point out.**

- The answer may use the `datasets::penguins` short names (`bill_len`, `flipper_len`) instead of `palmerpenguins`. Run the code and show the error if it appears. This is the **Two Penguins Datasets** failure in [ai-failure-modes.md](ai-failure-modes.md#two-penguins-datasets).
- The answer may use base R or tidyverse, or both, without saying which.

**Better prompt.** Type the Prompt 2 block, which names the R version, the tidyverse and `palmerpenguins`, and includes the `glimpse()` output. Paste the output from your own session, not from the text file, so learners see real output.

**Close.** Show that `glimpse(penguins)` in your session matches the column names in the better prompt.

## Episode 05: Wrangle with dplyr

**Weak prompt.** "clean the penguins data and summarise it". Type it, and show the answer.

**What to point out.**

- The answer may remove rows without saying how many, or may choose its own rule for missing values. Count the rows before and after with `nrow()`, as learners will do in the episode. See **Silently Dropped NA Values**.
- The answer may use `%>%`. Point out the pipe style, then compare it with the better prompt, which asks for `|>`.

**Better prompt.** Type the Prompt 2 block, which names the verbs, the NA policy and the base R cross-check. Run the cross-check and show that the row counts match.

**Close.** Ask learners what they would have to check if the cross-check failed.

## Episode 06: Visualise with ggplot2

**Weak prompt.** "plot penguins in ggplot". Type it, and show the answer.

**What to point out.**

- The answer may pick the variables for you, or may use `size =` for a line. See **Superseded Arguments**.
- Copying code from the answer into RStudio may produce an error about curly quotes. If it does, show the fix, and point out that the problem came from the copy, not the AI. See **Smart Quotes From Copy and Paste**.

**Better prompt.** Type the Prompt 2 block, which names the variables, the palette, the labels, the facets and the `ggsave()` size. Save the figure, and open it to check the labels and the legend.

**Close.** Ask learners to compare the `ggsave()` size with the value in the prompt.

## Episode 07: Statistics

**Weak prompt.** "Is there a relationship between bill length and bill depth in penguins? Give me R code.". Type it, and show the answer.

**What to point out.**

- The answer may give a confident yes or no, with no assumptions and no mention of grouping. See **Wrong Statistical Interpretation**.
- Ask learners whether the answer mentions species. If it does not, note that the question is open-ended, and that is why the better prompt is needed.

**Better prompt.** Type the better prompt from episode 07, which asks for the pooled and the per-species fits, whether the two could disagree, and which variables could confound the relationship.

**Simpson's paradox.** Show the pooled scatter plot first, then the per-species plot. Ask the AI what the pooled plot shows. A likely answer describes a negative relationship. Then show the coloured plot, and ask learners which answer they would put in the report. See **Simpson's Paradox**.

**Close.** Ask learners to name one claim from the answer that they checked themselves.

## Episode 08: Assemble the Quarto Report

**Weak prompt.** "write a report about the penguins data". Type it, and show the answer.

**What to point out.**

- The answer may use a YAML header that does not match Quarto. Show the header and point to the `format:` key. See **Outdated Quarto and R Markdown YAML**.
- The answer may stop before the end of the report. Use the truncation fallback if needed.

**Better prompt.** Type the Prompt 2 block, which asks for the section skeleton, the chunk options and the disclosure paragraph. Paste the skeleton into `penguins_report.qmd`, and render it with `quarto render penguins_report.qmd`.

**Close.** Open the rendered HTML and check that the AI-use statement matches the one learners drafted in episode 01.

## Running Track B Alongside the Demo

Track B learners work in Claude Code, in a terminal or the RStudio terminal, at the same time. Python learners on Track B start Claude Code with `.venv` active. The demo is for Track A, so keep it brief and return to the room.

- Set a helper to circulate. The helper checks that each Track B learner has approved actions one at a time, and has not turned on auto-approval.
- Point Track B learners to the **Agent extension** callout at the end of each episode. Ask them to write the acceptance criteria before they start the agent.
- Check that no learner runs a loop, a background job or a polling command such as `watch -n 1 squeue`. These break the REANNZ agent rules in episode 02.
- When a Track B learner finishes early, send them to the **Check it** step of the episode, then to [extras/agent-track.md](../extras/agent-track.md) for the deeper material.
- Show one Track B result on the screen at the close of episode 08, so Track A learners see what the agent extension produces.
