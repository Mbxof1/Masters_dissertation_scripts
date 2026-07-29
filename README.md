# Masters_dissertation_scripts
A collection of scripts used in the analysis of T. vivax expression data
Due to the size of RNA-seq data, example data is not provided

##########################
Bash script functionality:
##########################

bamtonormbedgraph - read in unique reads bam file, then generate a normalised bedgraph based on genome alignment of reads
base - base file used to create further bash scripts, contains header and conda environment information
bedgraphindex - sort a bedgraph file, convert to gzip format and index for visualisation in IGV
bedgraphindexfull - same as above, using different files
cdsfromgff - pull coding sequences from the Jackson assembly based on gff annotations
cdstoprotein - convert extracted coding sequences into protein sequences
fastp - iterate through RNA-seq data and trim the paired end reads
fastqc - assess quality of RNA-seq data
grep_scaffold3a - pull reads mapped to scaffold 3a
grep_scaffold10 - pull reads mapped to scaffold 10
gtfindex - index gtf for visualisation in IGV
HMMER - use HMM models from Pfam to search for proteins with specific domains
indexbamunique - index bam file containing non-multimapped reads
mergebamAJ - merge technical replicates togther into single bam files
pullunique - pull non-multimapped reads from bam files
pullunmapped - pull all reads which do not map to the cow genome
quast - perform comparative quast analysis of the three assemblies
sortbamcowAJ - sort bam files generated from the cow genome alignment
sortbamtrypAJ - same as above, but following tryp alignment
starcow - align fastq files to cow genome
starcowAJ - same as above, using different files
startryp - align bam files containing reads not mapped to the cow genome to the tryp genome
startrypAJ - same as above, using different files
USP1blast - BLAST known sequence of USP1 against annotated Jackson assembly

######################
R script functionaity:
######################

Karyplot - generation of expression graph plots, based on annotations from the jackson gff file and normalised bedgraph files
Proportional venn - generation of venn diagram based on known data using Eulerr
t.vivax_expression_data_analysis - majority of data analysis and figure generation. Contains gene count normalisation, PCA analysis and MA/ MM score calculation and plotting
VSG HMM overlap plotter - generation of venn diagram based on overlap of HMMsearch output lists and annotated genes using Eulerr

#################
Additional files:
#################

trypanosomes.yml - an export of the conda environment used in the project, containing all of the modules used in the bash scripts