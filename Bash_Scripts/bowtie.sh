#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=bowtie_more_threads
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

#Build an index from the cow and tryp reference
#bowtie2-build data/combined_tryp_cow_genome.fasta combined_genome

#Align reads with the combined index, so reads which map primarily to the cow genome can be excluded
#bowtie2 -x bowtie_index/combined_genome -1 RNA-seq/combined_R1_reads.fastq.gz -2 RNA-seq/combined_R2_reads.fastq.gz -S combined_mapping.sam -p 8

#Partial alignment to estimate runtime
bowtie2 -x bowtie_index/combined_genome -1 RNA-seq/ds1713_1/ds1713_1_S2_L001_R1_001.fastq.gz -2 RNA-seq/ds1713_1/ds1713_1_S2_L001_R2_001.fastq.gz -S combined_mapping_partial.sam -p 8
