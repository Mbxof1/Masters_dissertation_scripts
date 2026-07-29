#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=makebam
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=150g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cd STAR_results/cow_align/RNA-seq/Jackson_PLoSNTD2015/

# convert to bam file, then sort
for i in ERR2368{59..62}.Aligned.out.sam.unmapped.sam
do
	samtools view -b ${i} |  samtools sort - -@ 8 > ${i}.sorted.bam
#	rm ${i}
done
