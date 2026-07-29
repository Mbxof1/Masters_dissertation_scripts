#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=grep
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=15g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cd STAR_results/tryp_align/

grep TvY486_LIV26_scaffold_10 ds1713_25.Aligned.out.sam.unmapped.sam.Aligned.out.sam.paired.bedgraph > ds1713_25.scaffold.10.paired.bedgraph
grep TvY486_LIV26_scaffold_10 ds1713_26.Aligned.out.sam.unmapped.sam.Aligned.out.sam.paired.bedgraph > ds1713_26.scaffold.10.paired.bedgraph
grep TvY486_LIV26_scaffold_10 ds1713_27.Aligned.out.sam.unmapped.sam.Aligned.out.sam.paired.bedgraph > ds1713_27.scaffold.10.paired.bedgraph
grep TvY486_LIV26_scaffold_10 ds1713_28.Aligned.out.sam.unmapped.sam.Aligned.out.sam.paired.bedgraph > ds1713_28.scaffold.10.paired.bedgraph
