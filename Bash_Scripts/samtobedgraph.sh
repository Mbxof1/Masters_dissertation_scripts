#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=sambambedgraph
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

for i in STAR_results/tryp_align/*.sam
do
	echo "starting alignment of sample ${i}"
	samtools view -b ${i} | samtools sort - | bedtools genomecov -bg -pc -ibam - > ${i}.paired.bedgraph
done
rm samtools*.tmp.*.bam
