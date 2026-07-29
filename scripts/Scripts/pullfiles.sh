#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=quast
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.out

module load rclone-uon/1.65.2


