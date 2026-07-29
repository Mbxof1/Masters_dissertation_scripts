#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=star
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=250g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

#Generate STAR index
#STAR --runThreadN 12 --runMode genomeGenerate --genomeDir STAR_index_cow --genomeFastaFiles data/Cow_genome/Cow_genome.fasta --sjdbGTFfile data/Cow_genome/Cow.gtf --sjdbOverhang 74

#load up index genome
STAR --runThreadN 12 --runMode alignReads --genomeLoad LoadAndExit --genomeDir STAR_index_cow

#Align fastq files to index
for i in ./RNA-seq/ds1713/ds1713_{1..24}
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

	STAR --runThreadN 12 --runMode alignReads --genomeLoad LoadAndKeep --genomeDir STAR_index_cow --outFileNamePrefix STAR_results/cow_align/${i}. --readFilesCommand zcat --readFilesIn $FILE1,$FILE2 $FILE3,$FILE4 --outSAMunmapped Within --outSAMattributes Standard --quantMode GeneCounts --alignSJoverhangMin 1000 --outSAMtype BAM Unsorted
done

#discard index genome from ram
STAR --runThreadN 12 --runMode alignReads --genomeLoad Remove --genomeDir STAR_index_cow
