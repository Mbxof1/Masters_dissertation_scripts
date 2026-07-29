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

cd STAR_results/fixed/RNA-seq/ds1713/

bedtools sort -i ds1713_25.Aligned.out.sam.paired.bed | bgzip > ds1713_25.Aligned.out.sam.paired.bed.gz; tabix -p bed ds1713_25.Aligned.out.sam.paired.bed.gz
bedtools sort -i ds1713_26.Aligned.out.sam.paired.bed | bgzip > ds1713_26.Aligned.out.sam.paired.bed.gz; tabix -p bed ds1713_26.Aligned.out.sam.paired.bed.gz
bedtools sort -i ds1713_27.Aligned.out.sam.paired.bed | bgzip > ds1713_27.Aligned.out.sam.paired.bed.gz; tabix -p bed ds1713_27.Aligned.out.sam.paired.bed.gz
bedtools sort -i ds1713_28.Aligned.out.sam.paired.bed | bgzip > ds1713_28.Aligned.out.sam.paired.bed.gz; tabix -p bed ds1713_28.Aligned.out.sam.paired.bed.gz
