#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=fastp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=150g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

# iterate through all of the Jackson RNA-seq folders, pull both of the paired end read files and trim them together 
for i in ./RNA-seq/Jackson_PLoSNTD2015/ERR2368{50..62}
do
        echo "starting alignment of sample ${i}"
        # STAR cannot natively process wildcards in --readFilesIn

        FILE1=$(ls ${i}/*1.fastq.gz)
        FILE2=$(ls ${i}/*2.fastq.gz)

        echo "File 1 is $FILE1"
        echo "File 2 is $FILE2"

	fastp -i $FILE1 -I $FILE2 -o $FILE1.trimmed -O $FILE2.trimmed --thread 12
done
