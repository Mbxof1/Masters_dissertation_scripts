#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=quast
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.out

module load python-uoneasy/3.12.3-GCCcore-13.3.0
source $HOME/.bash_profile
conda activate quast

python ../quast/quast.py -o ../quast/ ../trypanosome_datasets/AJackson_tryp_assembly/TvY486_LIV26.fasta ../trypanosome_datasets/Old_trypanosome_dataset/ncbi_dataset/data/GCA_021307395.1/GCA_021307395.1_TvIL_AH_1392_genomic.fna ../trypanosome_datasets/TriTrypDB-68/TriTrypDB-68_TvivaxY486_Genome.fasta
