#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=sortbam
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

for i in STAR_results/tryp_align/Jackson/*.bam
do
	samtools sort -@ 8 -o ${i}.sorted.bam ${i}
	mv ${i}.sorted.bam ${i}
done
