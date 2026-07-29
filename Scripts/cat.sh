#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=cat
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cat RNA-seq/*/*.fastq.gz > combined_reads.fastq.gz
cat RNA-seq/*/*R1*.fastq.gz > combined_R1_reads.fastq.gz
cat RNA-seq/*/*R2*.fastq.gz > combined_R2_reads.fastq.gz
