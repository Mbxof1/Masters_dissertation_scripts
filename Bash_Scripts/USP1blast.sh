#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=USP1fasta
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

#generate blastdb
makeblastdb -in data/AJackson_tryp_assembly/TvY486_LIV26.fasta -dbtype nucl -parse_seqids

# run blast search
blastn -db data/AJackson_tryp_assembly/TvY486_LIV26.fasta -query data/USP1.fasta -out USP1_blast.out
