#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=bamtosam
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

# samtools view -h STAR_results_R1/combined_reads_Aligned.sortedByCoord.out.bam | gzip > R1_reads_aligned.sam.gz
samtools view -h STAR_results_R2/combined_reads_Aligned.sortedByCoord.out.bam | gzip > R2_reads_aligned.sam.gz
