#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=cdsfromgff
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

# pull coding sequences from FASTA file using gffread
gffread -g data/AJackson_tryp_assembly/TvY486_LIV26.fasta -x data/AJackson_tryp_assembly/TvY486_LIV26_CDs.fasta data/AJackson_tryp_assembly/TvY486_LIV26.gff
