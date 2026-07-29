#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=pullunmapped
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=120g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cd STAR_results/cow_align/RNA-seq/Jackson_PLoSNTD2015/

# filter for unmapped reads, then export to a new bam file
for i in ERR2368{50..62}.Aligned.out.bam
do
	samtools view -f 12 -b ${i} > ${i}.unmapped.bam
	mv ${i}.unmapped.bam ${i}
done
