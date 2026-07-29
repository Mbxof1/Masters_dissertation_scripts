#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=sambambedgraph
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

# read in unique reads, then generate normalised bedgraph from the data
for i in STAR_results/tryp_align/*unique.bam
do
	echo "starting alignment of sample ${i}"
	bamCoverage -b ${i} -o ${i}.norm.bedgraph -of bedgraph --normalizeUsing CPM -p 12
done

