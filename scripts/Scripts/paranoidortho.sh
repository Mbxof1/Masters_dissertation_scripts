#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=orthology
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=logs/slurm-%x-%j.out
#SBATCH --error=logs/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

#compare cds files to identify orthologues
sonicparanoid -i ./data/AJ_Brucei_comparison -o ./data/paranoid_AJ_TBrucei927 -p paranoid_pairwise -t 8 -op
