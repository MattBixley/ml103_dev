#!/bin/bash -e
# Reference answer for episode 09 (Python): run analysis.py as a batch job.
# Written for REANNZ Mahuika. On another cluster, change the account,
# module names and (if your site needs one) the partition.
#
# Before you submit, from the ml103-penguins/ folder:
#   mkdir -p logs                         # Slurm will not create this folder for you
#   module spider Python                  # confirm the Python module name and version
#   bash -n run_analysis_py.sl            # shell syntax check
#   sbatch --test-only run_analysis_py.sl # scheduler check; submits nothing
#
# The Python packages must already be installed in a virtual environment in the
# project folder. Create it once on a login node, with the SAME module loaded:
#   module purge
#   module load Python/3.14.4-foss-2026
#   python3 -m venv .venv
#   source .venv/bin/activate
#   python -m pip install -r requirements.txt   # a copy of python/requirements.txt from the workshop repository
# Do not install packages inside this job.

#SBATCH --job-name=penguins-analysis-py
#SBATCH --account=nesi99999            # placeholder: replace with your project code
#SBATCH --time=00:15:00                # the script runs in about 2 minutes; 15 min is a safe margin
#SBATCH --mem=2G                       # pandas, seaborn and statsmodels on 344 rows need well under 1 GB
#SBATCH --cpus-per-task=1              # analysis.py is single-threaded
#SBATCH --output=logs/%x_%j.out        # %x = job name, %j = job ID
#SBATCH --error=logs/%x_%j.err
# No --partition: Mahuika picks one automatically (only hugemem must be requested).
# No GPU request: nothing in analysis.py uses a GPU.

# Start from a clean environment, then load Python.
module purge
# Python/3.14.4-foss-2026 is the newest version shown in the REANNZ docs (October 2026).
# Run `module spider Python` and use the version you see there. It must be the
# same version you used to create .venv, or the venv will not work.
module load Python/3.14.4-foss-2026

# Run from the folder you submitted from, so relative paths
# (.venv/, figures/, logs/) resolve the same way they do interactively.
cd "$SLURM_SUBMIT_DIR"

# Activate the project's virtual environment.
source .venv/bin/activate
# Ignore packages in ~/.local, so only the venv's packages are used.
export PYTHONNOUSERSITE=1

srun python analysis.py
