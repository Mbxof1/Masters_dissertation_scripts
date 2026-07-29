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
#STAR --runThreadN 12 --runMode genomeGenerate --genomeDir STAR_index_tryp --genomeFastaFiles data/AJackson_tryp_assembly/TvY486_LIV26.fasta --sjdbGTFfile data/TvY486_LIV26.gtf --sjdbOverhang 74 --genomeSAindexNbases 12

# load up index genome
STAR --runMode alignReads --genomeLoad LoadAndExit --genomeDir STAR_index_tryp

cd STAR_results/cow_align/RNA-seq/ds1713/

# align bam files to index
for i in ds1713_{1..24}.Aligned.out.bam
do
	STAR --runThreadN 12 --runMode alignReads --genomeLoad LoadAndKeep --genomeDir ../../../../STAR_index_tryp --outFileNamePrefix ../../../../STAR_results/tryp_align/${i}. --readFilesType SAM PE --readFilesIn ${i} --readFilesCommand samtools view --outSAMunmapped Within --outSAMattributes Standard --quantMode GeneCounts --alignMatesGapMax 1000 --alignSJoverhangMin 1000 --outSAMtype BAM Unsorted
done
