#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=featurecount
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

featureCounts -a data/AJ_cow_combined.gtf -t CDS -g gene_id -o R1_gene_counts.txt -t 8 STAR_results_R1/combined_reads_Aligned.sortedByCoord.out.bam STAR_results_R2/combined_reads_Aligned.sortedByCoord.out.bam
