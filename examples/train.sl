#!/bin/bash
#SBATCH --job-name=llm-train
#SBATCH --partition=gpu_p100
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=logs/train_%j.log

# Load required modules
module load Miniforge3 CUDA/12.1

# Activate virtual environment
source activate llm-env

# Set cache directories
export TRANSFORMERS_CACHE=$HOME/.cache/huggingface
export HF_HOME=$HOME/.cache/huggingface

# Run training script
python train_llm.py