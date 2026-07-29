#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=indexbed
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

bedtools sort -i Cow_x_genes.paired.bedgraph | bgzip > Cow_x_genes.paired.bedgraph.gz; tabix -p bed Cow_x_genes.paired.bedgraph.gz
