#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=indexbed
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cd STAR_results/tryp_align/

bedtools sort -i ds1713_25.scaffold.10.paired.bedgraph | bgzip > ds1713_25.scaffold.10.tryp.paired.bedgraph.gz; tabix -p bed ds1713_25.scaffold.10.tryp.paired.bedgraph.gz
bedtools sort -i ds1713_26.scaffold.10.paired.bedgraph | bgzip > ds1713_26.scaffold.10.tryp.paired.bedgraph.gz; tabix -p bed ds1713_26.scaffold.10.tryp.paired.bedgraph.gz
bedtools sort -i ds1713_27.scaffold.10.paired.bedgraph | bgzip > ds1713_27.scaffold.10.tryp.paired.bedgraph.gz; tabix -p bed ds1713_27.scaffold.10.tryp.paired.bedgraph.gz
bedtools sort -i ds1713_28.scaffold.10.paired.bedgraph | bgzip > ds1713_28.scaffold.10.tryp.paired.bedgraph.gz; tabix -p bed ds1713_28.scaffold.10.tryp.paired.bedgraph.gz
