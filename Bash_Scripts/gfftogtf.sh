#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=gfftogtf
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

#gffread data/AJackson_tryp_assembly/TvY486_LIV26.gff -T -o data/AJackson_tryp_assembly/TvY486_LIV26.gtf

gffread TvSM_integration.gff3 -T -o TvSM_integration.gtf
