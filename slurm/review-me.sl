#!/bin/bash
#SBATCH --job-name=penguins
#SBATCH --partition=gpu_p100
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=logs/penguins_%j.log

# Load required modules
module load r/4.3

# Activate environment
source activate r-env

# Set cache directories
export TRANSFORMERS_CACHE=$HOME/.cache/huggingface
export HF_HOME=$HOME/.cache/huggingface

# Run the analysis
cd /home/jsmith/ml103-penguins
Rscript analysis.R
