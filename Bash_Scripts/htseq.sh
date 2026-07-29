#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=htseq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=300g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

htseq-count -f sam -r name -n 12 STAR_results/combined_reads_Aligned.out.sam data/AJ_cow_TvSM_combined.gtf > STAR_results/htseq_counts.txt
