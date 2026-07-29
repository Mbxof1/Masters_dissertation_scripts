#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=orthology
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=60g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

#translate cds to protein fasta
transeq -sequence data/TriTrypDB-68/TriTrypDB-68_TvivaxY486_AnnotatedTranscripts.fasta -outseq TriTryp_protein_output.fasta
transeq -sequence data/AJackson_tryp_assembly/TvY486_LIV26_CDs_edit.fasta -outseq AJ_protein_output.fasta
transeq -sequence data/Old_trypanosome_dataset/ncbi_dataset/data/GCA_021307395.1/cds_from_genomic.fna -outseq Old_assembly_protein_output.fasta

