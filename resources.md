# Resources and References

This page collects the books, guides, datasets, policies and documentation that the ML103 workshop draws on. Use it after the workshop to keep learning R or Python, to check a policy before you use an AI tool on NeSI systems, or to cite the workshop and its data.

Each entry gives the title, the authors or publisher and the year where known, and a line on why it helps with this workshop.

## Learning R and the tidyverse

> [!TIP]
> **Main next step after the workshop:** [R for Data Science (2e)](https://r4ds.hadley.nz/). Start here if you want to build on what you learned. It covers the same tidyverse tools you used in the workshop, with more depth and exercises.

- [R for Data Science (2e)](https://r4ds.hadley.nz/). Hadley Wickham, Mine Çetinkaya-Rundel and Garrett Grolemund. O'Reilly, 2023. The free online book for the tidyverse workflow. These chapters match the workshop:
  - [Data transformation](https://r4ds.hadley.nz/data-transform.html): filtering, selecting, summarising and grouping, as in the `dplyr` steps of the analysis.
  - [Data visualisation](https://r4ds.hadley.nz/data-visualize.html): the grammar of graphics behind the `ggplot2` plots.
  - [Quarto](https://r4ds.hadley.nz/quarto.html): writing reproducible reports, as in the penguins report.
  - [Workflow: getting help](https://r4ds.hadley.nz/workflow-help.html): how to ask for help and write a good reprex when an AI answer does not run.
- [Introduction to R](https://genomicsaotearoa.github.io/Introduction-to-R/). Genomics Aotearoa. A free introductory course on base R, which the workshop assumes you already know.
- [tidyverse style guide](https://style.tidyverse.org/). The naming, spacing and pipe conventions used in the workshop code.
- [ggplot2 documentation](https://ggplot2.tidyverse.org/). Reference for every plotting function and argument, with examples you can run.
- [dplyr documentation](https://dplyr.tidyverse.org/). Reference for the data verbs such as `filter()`, `mutate()` and `summarise()`.
- [Posit cheatsheets](https://posit.co/resources/cheatsheets/). One-page PDF references for the tidyverse and other Posit tools. Keep the `dplyr` and `ggplot2` sheets next to your keyboard.

## Learning Python for data analysis

The Python version of the workshop uses pandas, seaborn and statsmodels. These resources cover the same ground.

- [Python for Data Analysis, 3rd edition](https://wesmckinney.com/book/). Wes McKinney. O'Reilly, 2022. The standard book on pandas, written by its creator. Read the chapters on data wrangling and plotting first.
- [pandas documentation](https://pandas.pydata.org/docs/). Reference for DataFrame methods, including the ones that replace `dplyr` verbs in the Python version.
- [seaborn tutorial](https://seaborn.pydata.org/tutorial.html). Introduces the statistical plots that the Python version uses for the penguins figures.
- [statsmodels documentation](https://www.statsmodels.org/stable/). Reference for linear models and their summary tables, as used for the body mass model.

## Reporting with Quarto

Quarto renders a single source file into HTML, PDF or Word documents, and runs R or Python code inside it. The workshop uses it for the penguins report.

- [Get started with Quarto](https://quarto.org/docs/get-started/). Installation and your first document. Follow it if Quarto is not already installed.
- [Quarto: R computations](https://quarto.org/docs/computations/r.html). How code cells, chunk options and figure sizes work for R.
- [Quarto: Python computations](https://quarto.org/docs/computations/python.html). The same options for Python code cells, including the Jupyter engine used in the Python version.
- [R Markdown](https://rmarkdown.rstudio.com/). The earlier R reporting format that Quarto replaces. Use it only if you need to maintain an existing `.Rmd` file.

## The data

The workshop uses the Palmer Archipelago penguin data, collected by Kristen Gorman and colleagues at Palmer Station, Antarctica.

- [palmerpenguins package](https://allisonhorst.github.io/palmerpenguins/). Allison Horst, Alison Hill and Kristen Gorman. The R package that provides `penguins`. Use its documentation to check what each column means.
- Horst AM, Hill AP, Gorman KB (2020). *palmerpenguins: Palmer Archipelago (Antarctica) penguin data*. R package. [doi:10.5281/zenodo.3960218](https://doi.org/10.5281/zenodo.3960218). Cite this when you use the dataset.
- Gorman KB, Williams TD, Fraser WR (2014). Ecological sexual dimorphism and environmental variability within a community of Antarctic penguins (genus *Pygoscelis*). *PLoS ONE* 9(3): e90081. [doi:10.1371/journal.pone.0090081](https://doi.org/10.1371/journal.pone.0090081). The original study that the data come from.

> [!NOTE]
> R 4.5.0 and later include a smaller `penguins` dataset in the base `datasets` package, with different column names such as `bill_len` and `body_mass`. The workshop uses `palmerpenguins::penguins`. Check which one you have loaded with `head(penguins)`.

## Using AI for coding and research

### Carpentries lessons on AI

Three Carpentries lessons shaped parts of this workshop. All are CC BY 4.0.

- [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/). The Carpentries Incubator, 2026 (pre-alpha). A novice R lesson on prompting a chatbot for code and checking what it returns. Good next step for prompting patterns, predicting output before you run code, review-only prompts, and avoiding the illusion of competence. Ideas adapted in episodes 01, 03 and 05 to 10.
- [Trustworthy AI: Validity, Fairness, Explainability, and Uncertainty Assessments](https://carpentries-incubator.github.io/fair-explainable-ml/). The Carpentries Incubator, 2023 (alpha). An intermediate Python lesson on whether a machine learning model is valid, fair, explainable and honest about uncertainty. Read episodes 1, 2, 6 and 8 for bias, subgroup evaluation, uncertainty and documentation. Ideas adapted in episodes 01, 07 and 08.
- [GenAI in Workshops: Instructor Training Bonus Module](https://carpentries.github.io/instructor-training-genai/). The Carpentries, 2026. For instructors: how chatbots change practice, feedback and cognitive load in workshops, and how to teach with AI in the room. Ideas adapted in episode 00 and the instructor notes.

### AI tools used in the workshop

- [Claude Code documentation](https://docs.claude.com/en/docs/claude-code/overview). Anthropic. Setup, commands and permissions for Claude Code, the terminal agent used in Track B.
- [Google Search](https://www.google.com/). The Track A tool. Open a private window, select **AI Mode**, and paste your prompt.
- [Duck.ai](https://duck.ai). A backup chat tool for Track A if AI Mode is not available in your region.

## Ethics, data sovereignty and research integrity

- [Guidelines for the best practice use of GenAI in research](https://www.royalsociety.org.nz/assets/Guidelines-for-the-best-practice-use-of-GenAI-in-research_Royal-Society-Te-Aparangi_June-2025_English-.pdf). Royal Society Te Apārangi, 2025. New Zealand guidance on the best practice use of generative AI in research. Read it before you put research data into any AI tool.
- [Te Mana Raraunga](https://www.temanararaunga.maori.nz/). The Māori Data Sovereignty Network, Aotearoa New Zealand. Principles for the governance of Māori data. Read it before you analyse data about whānau, hapū, iwi or Māori communities.
- Carroll SR et al. (2020). The CARE Principles for Indigenous Data Governance. *Data Science Journal* 19: 43. [doi:10.5334/dsj-2020-043](https://doi.org/10.5334/dsj-2020-043). Collective benefit, authority to control, responsibility and ethics. Read it alongside Te Mana Raraunga when you work with Indigenous data.

## REANNZ and NeSI policies

Read these before you use an AI agent on Mahuika, the NeSI high-performance computing system.

- [Acceptable Use Policy](https://docs.nesi.org.nz/Policy/Acceptable_Use_Policy/). NeSI. The rules for using Mahuika and its data. Applies to every account, with or without AI tools.
- [Access Policy](https://docs.nesi.org.nz/Policy/Access_Policy/). NeSI. Who may hold an account and how access is granted and ended.
- [New Rules for AI Agents](https://docs.nesi.org.nz/Announcements/AI_Agent_Rules/). NeSI. The rules that AI agents must follow on Mahuika, and how to install them.
- [AI Agent Guidelines](https://docs.nesi.org.nz/Software/AI_Agents/AI_Agent_Guidelines/). NeSI. Practical guidance for using AI agents on Mahuika.

## Using AI agents on Mahuika

- [Claude Code on Mahuika](https://docs.nesi.org.nz/Software/AI_Agents/Claude_Code_on_Mahuika/). NeSI. How to run Claude Code on Mahuika, which Track B uses.
- [mahuika-agents repository](https://github.com/nesi/mahuika-agents). NeSI. The source for the REANNZ agent rules, and the `install.sh` script that adds them to your project.
- [NeSI documentation index (llms.txt)](https://docs.nesi.org.nz/llms.txt). NeSI. A plain-text index of the support documentation, written for AI agents to read. Give its URL to your AI tool when you ask about Mahuika.

## Mahuika software and HPC documentation

- [NeSI documentation home](https://docs.nesi.org.nz/). NeSI. The starting point for all Mahuika support documentation.
- [R on Mahuika](https://docs.nesi.org.nz/Software/Available_Applications/R/). NeSI. The R versions and modules that are installed, and how to load them.
- [Python on Mahuika](https://docs.nesi.org.nz/Software/Available_Applications/Python/). NeSI. The Python versions and modules that are installed, and how to load them.
- [Installing applications yourself](https://docs.nesi.org.nz/Software/Installing_Applications_Yourself/). NeSI. How to install R or Python packages in your own space when a module does not have them.
- [Filesystems and quotas](https://docs.nesi.org.nz/Storage/Filesystems_and_Quotas/). NeSI. Where to keep project data, and the limits on each filesystem.
- [Environment and modules](https://docs.nesi.org.nz/Tutorials/Introduction_To_HPC/Environment_And_Modules/). NeSI. An introduction to `module load`, which the Slurm scripts use.
- [Mahuika and HPC3 differences](https://docs.nesi.org.nz/Getting_Started/FAQs/Mahuika_HPC3_Differences/). NeSI. What changes between the two systems. Check it if a script works on one and not the other.

## Slurm and batch jobs

Slurm is the scheduler that runs batch jobs on Mahuika. Episode 9 covers writing Slurm scripts with AI help.

- [Slurm documentation](https://slurm.schedmd.com/documentation.html). SchedMD. The official reference for `sbatch`, `squeue`, `scancel` and every option you can put in a script header.
- [Batch Computing Guide](https://docs.nesi.org.nz/Batch_Computing/Batch_Computing_Guide/). NeSI. How batch jobs work on Mahuika, with worked examples.
- [Slurm reference sheet](https://docs.nesi.org.nz/Getting_Started/Cheat_Sheets/Slurm-Reference_Sheet/). NeSI. A one-page list of common Slurm commands and options for Mahuika.
- [Using GPUs](https://docs.nesi.org.nz/Batch_Computing/Using_GPUs/). NeSI. How to request a GPU in a Slurm script.

## Workshop materials

- [Source repository](https://github.com/MattBixley/ml103_dev). The R and Python code, Slurm scripts, episodes and instructor notes for ML103. Open an issue there if you find an error.
- [Licence](LICENSE.md). The written content is licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). The code is licensed under the MIT Licence. The `palmerpenguins` data is released under CC0 1.0 and is not covered by either licence.

### How to cite this workshop

Use this citation if you reuse or adapt the workshop material:

```text
Bixley M (2026) ML103: AI-Assisted Coding with R. REANNZ. https://mattbixley.github.io/ml103_dev/
```

Cite the `palmerpenguins` package and data as well, using the entries in [The data](#the-data).
