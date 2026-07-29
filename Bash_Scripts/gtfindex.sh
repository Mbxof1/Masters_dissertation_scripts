#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=sortgtf
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes


cd data

bedtools sort -i AJ_cow_TvSM_combined.gtf > AJ_cow_TvSM_combined.sorted.gtf
bgzip AJ_cow_TvSM_combined.sorted.gtf
tabix -p gff AJ_cow_TvSM_combined.sorted.gtf.gz
