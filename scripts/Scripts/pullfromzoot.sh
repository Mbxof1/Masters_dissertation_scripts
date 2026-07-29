#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=zootpull
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

scp -r lab@10.249.25.104:~/NGS/NGS_20260506-RNASeq/ds1713 RNA-seq
