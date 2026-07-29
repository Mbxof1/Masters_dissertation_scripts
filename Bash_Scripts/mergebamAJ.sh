#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=mergebam
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=150g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./logs/%x/slurm-%x-%j.out
#SBATCH --error=./logs/%x/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

cd STAR_results/cow_align/RNA-seq/Jackson_PLoSNTD2015/

# Merge technical replicates to create full bam files for alignment
samtools merge -o EPI1.bam ERR236850.Aligned.out.bam ERR236851.Aligned.out.bam
samtools merge -o EPI2.bam ERR236852.Aligned.out.bam ERR236853.Aligned.out.bam ERR236854.Aligned.out.bam
samtools merge -o META1.bam ERR236855.Aligned.out.bam ERR236856.Aligned.out.bam
samtools merge -o META2.bam ERR236857.Aligned.out.bam ERR236858.Aligned.out.bam
samtools merge -o BSF1.bam ERR236859.Aligned.out.bam ERR236860.Aligned.out.bam
samtools merge -o BSF2.bam ERR236861.Aligned.out.bam ERR236862.Aligned.out.bam
