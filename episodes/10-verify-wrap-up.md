# 10. Verify and Wrap-Up

**Time:** 5 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do you know that the AI's output is correct?
- What do you do next?

**Objectives**
- Work through the verification checklist for your report.
- Find the next resource for the skill you want to build.

## Verification checklist

Before you submit or share your analysis, tick each item. If you cannot tick an item, go back and fix it.

- [ ] The code runs from a clean session. Use **Session** > **Restart R**, then run the script from the top.
- [ ] The row counts are what you expect. The raw data has 344 penguins, and every count after a filter or join matches what you can explain.
- [ ] Every column name exists in the data. Check with `names(penguins)`.
- [ ] You can explain what each line of code does, without reading the AI's explanation again.
- [ ] You can explain each part of the statistical output, including the assumptions it makes.
- [ ] Your report includes the AI-use statement from [episode 01](01-ai-and-ethics.md).
- [ ] You did not paste any sensitive data into an AI tool.

## Where next

- [R for Data Science, 2nd edition](https://r4ds.hadley.nz/) by Hadley Wickham, Mine Çetinkaya-Rundel and Garrett Grolemund. It covers the tidyverse in depth.
- [Quarto](https://quarto.org/) documentation, for building reports and websites from R, Python and other languages.
- [Introduction to R](https://genomicsaotearoa.github.io/Introduction-to-R/) from Genomics Aotearoa, for base R and ggplot2 if you need the foundations first.
- [NeSI documentation](https://docs.nesi.org.nz/), for the REANNZ and NeSI systems, policies and agent rules.
- The Python notes in `python/`, if you want the same workflow with pandas and seaborn.

## Give feedback

Tell your instructor what worked and what did not. If you are working through these notes on your own, note which step took the longest, and which prompt gave the worst answer. That feedback improves the next version.

<!-- Gap: no feedback channel (repository issue tracker or instructor contact) is named in the source plan. Add the channel before release. -->

> [!TIP]
> **Agent extension (Track B)**
> Ask the agent to run the verification checklist on your project. For each item, the agent reports pass or fail, with the command it ran and the output it saw. Read the evidence before you accept a pass.

## Key points

- Verify every analysis from a clean session, check the row counts and column names, and explain each line.
- Include the AI-use statement, and confirm that no sensitive data went into an AI tool.
- You are ready to explain, check and report AI-assisted R code, and to show a reader how you verified it.
