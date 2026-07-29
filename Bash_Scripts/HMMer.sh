#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=hmmsearch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxof1@nottingham.ac.uk
#SBATCH --mail-type=all
#SBATCH --output=logs/slurm-%x-%j.out
#SBATCH --error=logs/slurm-%x-%j.out

source $HOME/.bash_profile
conda activate trypanosomes

#use HMM models taken from PFam to search for domains in the protein sequences
hmmsearch data/HMM_models/Alba.hmm.gz data/protein_sequences/AJ_protein_output.fasta > data/HMMsearch/Alba.out
hmmsearch data/HMM_models/CCCH.hmm.gz data/protein_sequences/AJ_protein_output.fasta > data/HMMsearch/CCCH.out
hmmsearch data/HMM_models/Pumilio.hmm.gz data/protein_sequences/AJ_protein_output.fasta > data/HMMsearch/Pumilio.out
hmmsearch data/HMM_models/RRM.hmm.gz data/protein_sequences/AJ_protein_output.fasta > data/HMMsearch/RRM.out

#concatenated hmm files must be pressed into binary to be accepted by HMMscan
#hmmpress data/HMM_models/VSG_Combined.hmm

#run HMMscan to compare proteins with both domains
#hmmscan -o data/HMMscan/VSG_Combined.out --tblout data/HMMscan/VSG_Combined_sequence_tbl.out --domtblout data/HMMscan/VSG_Combined_domain_tbl.out data/HMM_models/VSG_Combined.hmm data/protein_sequences/AJ_protein_output.fasta

#can try jackhmmer (iterative search) to try and fish out less clear results - couldnt get this to work
#jackhmmer -o data/HMMscan/VSG_Combined_jackhmmer.out data/HMM_models/VSG_Combined.hmm data/protein_sequences/AJ_protein_output.fasta
