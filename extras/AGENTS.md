# Agent Rules for ml103-penguins

Example rules file from ML103: AI-Assisted Coding with R. Copy it into your
`ml103-penguins/` project folder and edit it to suit.

## Scope

- Work only inside the `ml103-penguins/` project folder. Do not read or change
  files outside it.
- Touch only the files the task names. If another file needs changing, ask first.

## Data

- The only data in this project is the `palmerpenguins` package data
  (`palmerpenguins::penguins`). Do not load, download or create other data sets.
- Do not use base R's `datasets::penguins`. It has different column names
  (`bill_len`, `body_mass`).
- If you find any other data file in the project, stop and tell me. Do not open it.

## Code Style

- R 4.3 or later, tidyverse style: `library(tidyverse)` and
  `library(palmerpenguins)`.
- Use the native pipe `|>`, not `%>%`.
- ggplot2: use `linewidth =` for lines, not `size =`.
- Save figures to `figures/` with `ggsave(width = 7, height = 5, dpi = 300)`.
- No hard-coded absolute paths. Use paths relative to the project folder.

## Before Claiming Success

- Always run the code before you say it works. Run `Rscript analysis.R` after
  changing it, and `quarto render penguins_report.qmd` after changing the report.
- Show me the relevant output: the end of the run, row counts or the render log.
- If something fails, say so and show the error. Do not hide or skip failures.

## Ask First

- Never install, update or remove R packages without asking me.
- Ask before deleting, moving or renaming any file.
- Ask before running any command that is not R, Quarto, a read-only `git` command,
  `bash -n` or `sbatch --test-only`. Always ask before a real `sbatch`, `scancel` or delete.
- If a request is unclear, ask a question instead of guessing.

## Secrets and Access

- Never read, write or ask for passwords, API keys, tokens or SSH keys.
- Never put secrets in code, files or commit messages.

## REANNZ Systems

On REANNZ systems (Mahuika), the REANNZ rules at
`/opt/nesi/share/mahuika-agents/dist/AGENTS.md` take precedence over this file.
Where the two disagree, follow the REANNZ rules. In particular: stay supervised,
ask which project to charge, ask before every `sbatch`, and do not poll the queue
in a loop.
