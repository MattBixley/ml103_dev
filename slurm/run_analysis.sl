#!/bin/bash -e
# Reference answer for episode 09: run analysis.R as a batch job.
# Written for REANNZ Mahuika. On another cluster, change the account,
# module names and (if your site needs one) the partition.
#
# Before you submit, from the ml103-penguins/ folder:
#   mkdir -p logs                      # Slurm will not create this folder for you
#   module spider R                    # confirm the R module name and version
#   bash -n run_analysis.sl            # shell syntax check
#   sbatch --test-only run_analysis.sl # scheduler check; submits nothing
#
# The R packages (tidyverse, palmerpenguins) must already be installed in your
# R library. Install them once in an interactive R session, not inside this job.

#SBATCH --job-name=penguins-analysis
#SBATCH --account=nesi99999            # placeholder: replace with your project code
#SBATCH --time=00:15:00                # the script runs in about 2 minutes; 15 min is a safe margin
#SBATCH --mem=2G                       # tidyverse plus a 344-row data set needs well under 1 GB
#SBATCH --cpus-per-task=1              # analysis.R is single-threaded
#SBATCH --output=logs/%x_%j.out        # %x = job name, %j = job ID
#SBATCH --error=logs/%x_%j.err
# No --partition: Mahuika picks one automatically (only hugemem must be requested).
# No GPU request: nothing in analysis.R uses a GPU.

# Start from a clean environment, then load R.
module purge
# R/4.6.0-foss-2026 is the version shown in the REANNZ docs (October 2026).
# Run `module spider R` and use the version you see there.
module load R/4.6.0-foss-2026

# Run from the folder you submitted from, so relative paths
# (figures/, logs/) resolve the same way they do in RStudio.
cd "$SLURM_SUBMIT_DIR"

srun Rscript analysis.R
