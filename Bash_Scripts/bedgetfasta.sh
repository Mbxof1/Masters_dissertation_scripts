#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=bedgetfasta
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

bedtools getfasta -fi data/AJackson_tryp_assembly/TvY486_LIV26.fasta -bed data/TvY486_LIV26.cds.gtf.bed -fo STAR_results/tryp_align/bed_file.fasta -name
