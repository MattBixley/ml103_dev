#!/bin/bash -e
# Reference answer for episode 09: render penguins_report.qmd to HTML as a batch job.
# Written for REANNZ Mahuika. On another cluster, change the account,
# module names and (if your site needs one) the partition.
#
# Before you submit, from the ml103-penguins/ folder:
#   mkdir -p logs                       # Slurm will not create this folder for you
#   module spider R                     # confirm the R module name and version
#   module spider quarto                # is Quarto available as a module? (not confirmed in the docs)
#   bash -n render_report.sl            # shell syntax check
#   sbatch --test-only render_report.sl # scheduler check; submits nothing
#
# Rendering a .qmd with R chunks needs the Quarto command-line tool AND the
# R packages knitr and rmarkdown, plus tidyverse and palmerpenguins.
# Install the R packages once in an interactive R session, not inside this job.

#SBATCH --job-name=penguins-report
#SBATCH --account=nesi99999            # placeholder: replace with your project code
#SBATCH --time=00:20:00                # rendering takes a minute or two; 20 min is a safe margin
#SBATCH --mem=4G                       # R plus Quarto/pandoc; still small
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
# No --partition and no GPU request (see run_analysis.sl).

module purge
# R/4.6.0-foss-2026 is the version shown in the REANNZ docs (October 2026).
# Run `module spider R` and use the version you see there.
module load R/4.6.0-foss-2026

# Quarto: the REANNZ docs do not list a Quarto module (checked October 2026).
# If `module spider quarto` finds one, load it here, using the exact name it prints:
#   module load Quarto/<version>
# If it finds nothing, install the Quarto CLI in your project folder
# (https://docs.nesi.org.nz/Software/Installing_Applications_Yourself/) or ask
# REANNZ support, then put its bin/ folder on your PATH, for example:
#   export PATH="/nesi/project/nesi99999/quarto/bin:$PATH"
command -v quarto >/dev/null || { echo "quarto not found on PATH" >&2; exit 1; }

cd "$SLURM_SUBMIT_DIR"

srun quarto render penguins_report.qmd --to html
