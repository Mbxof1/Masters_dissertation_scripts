#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=pullunmapped
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

cd STAR_results/tryp_align/

# filter for unique reads
for i in ds1713_{25..28}.Aligned.out.sam.unmapped.sam.Aligned.out.sam.sorted.bam
do
	samtools view -q 1 -b ${i} > ${i}.unique.bam
done
