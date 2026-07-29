#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=star
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

#Generate STAR index
#STAR --runThreadN 12 --runMode genomeGenerate --genomeDir STAR_index --genomeFastaFiles data/AJ_cow_TvSM_combined.fasta --sjdbGTFfile data/AJ_cow_TvSM_combined.gtf --sjdbOverhang 74

#Align fastq files to index
for i in ./RNA-seq/ds1713/*
do
	echo "starting alignment of sample ${i}"
	# STAR cannot natively process wildcards in --readFilesIn

	FILE1=$(ls ${i}/*_L001_R1_001.fastq.gz)
	FILE2=$(ls ${i}/*_L002_R1_001.fastq.gz)
	FILE3=$(ls ${i}/*_L001_R2_001.fastq.gz)
        FILE4=$(ls ${i}/*_L002_R2_001.fastq.gz)

	echo "File 1 is $FILE1"
	echo "File 2 is $FILE2"
	echo "File 3 is $FILE3"
	echo "File 4 is $FILE4"

	STAR --runThreadN 12 --runMode alignReads --genomeDir STAR_index --outFileNamePrefix STAR_results/fixed/${i}. --readFilesCommand zcat --readFilesIn $FILE1,$FILE2 $FILE3,$FILE4 --outSAMunmapped Within --outSAMattributes Standard --quantMode GeneCounts --alignSJoverhangMin 1000
done
