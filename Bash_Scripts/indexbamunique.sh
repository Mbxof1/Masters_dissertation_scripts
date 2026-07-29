#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=
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

# move to tryp alignment results
cd STAR_results/tryp_align/

# index unique read bam files
for i in *.unique.bam
do
	samtools index ${i}
done

