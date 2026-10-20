# ml103-penguins

@AGENTS.md

## Project Facts

- RStudio Project: `ml103-penguins.Rproj`. Work from this folder.
- Python learners: same folder and object names; the script is `analysis.py`,
  data comes from `load_penguins()`, and packages live in `.venv`.
- Data: `palmerpenguins::penguins` (columns such as `bill_length_mm`,
  `flipper_length_mm`, `body_mass_g`).
- `analysis.R`: the working script. It creates these objects:
  - `penguins_clean`: penguins without the 11 rows that have missing `sex`,
    plus a `body_mass_kg` column (333 rows).
  - `species_summary`: n, mean and sd of bill length, flipper length and body
    mass by species.
  - `p_bill`: bill length vs bill depth, coloured by species, with per-species
    `lm` lines.
  - `p_mass`: body mass by species, boxplot plus jittered points, split by sex.
  - `mass_model`: `lm(body_mass_g ~ species, data = penguins_clean)`.
- `penguins_report.qmd`: the Quarto report. Render with
  `quarto render penguins_report.qmd` (HTML output). It must keep its
  Limitations and AI-use statement sections.
- `figures/`: saved plots.
- `slurm/`: batch job scripts for REANNZ Mahuika. Do not run `sbatch` without asking.
