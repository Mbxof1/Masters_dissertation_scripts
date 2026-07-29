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

# Generate STAR index
#STAR --runThreadN 12 --runMode genomeGenerate --genomeDir STAR_index_tryp --genomeFastaFiles data/AJackson_tryp_assembly/TvY486_LIV26.fasta --sjdbGTFfile data/TvY486_LIV26.gtf --sjdbOverhang 74 --genomeSAindexNbases 12

# load up index genome
STAR --runMode alignReads --genomeLoad LoadAndExit --genomeDir STAR_index_tryp

# Move into results directory
cd STAR_results/cow_align/RNA-seq/Jackson_PLoSNTD2015/

# Align bam files to index
for i in EPI1.bam EPI2.bam META1.bam META2.bam BSF1.bam BSF2.bam
do
	FILE=$(ls ${i})
	STAR --runThreadN 12 --runMode alignReads --genomeLoad LoadAndKeep --genomeDir ../../../../STAR_index_tryp --outFileNamePrefix ../../../tryp_align/Jackson/$FILE. --readFilesType SAM PE --readFilesCommand samtools view --readFilesIn $FILE --outSAMunmapped Within --outSAMattributes Standard --quantMode GeneCounts --alignMatesGapMax 1000 --alignSJoverhangMin 1000 --outSAMtype BAM Unsorted
done

# discard index genome from ram
STAR --runMode alignReads --genomeLoad Remove --genomeDir ../../../../STAR_index_tryp
