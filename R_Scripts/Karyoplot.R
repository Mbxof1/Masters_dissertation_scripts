{
  library(edgeR)
  library(tidyverse)
  library(tidyr)
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
  library(DESeq2)
  library(karyoploteR)
  library(rtracklayer)
  library(GenomicFeatures)
  library(txdbmaker)
  library(plyranges)
  library(GenomeInfoDb)
}
 

# Read in .fai index file 
tryp_fai <- read.table("C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvY486_LIV26.fasta.fai", sep="\t", stringsAsFactors=FALSE)

# Extract chromosome names and lengths, using rep function to create a list of 1s equal to the number of rows
tryp_genome <- toGRanges(data.frame(chr = tryp_fai[,1], start = rep(1, nrow(tryp_fai)), end = tryp_fai[,2]))

# Import bedgraphs
ds1713_25.bedgraph <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/ds1713_25.Aligned.out.sam.unmapped.sam.Aligned.out.sam.sorted.bam.unique.bam.norm.bedgraph", format = "bedGraph")
ds1713_26.bedgraph <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/ds1713_26.Aligned.out.sam.unmapped.sam.Aligned.out.sam.sorted.bam.unique.bam.norm.bedgraph", format = "bedGraph")
ds1713_27.bedgraph <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/ds1713_27.Aligned.out.sam.unmapped.sam.Aligned.out.sam.sorted.bam.unique.bam.norm.bedgraph", format = "bedGraph")
ds1713_28.bedgraph <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/ds1713_28.Aligned.out.sam.unmapped.sam.Aligned.out.sam.sorted.bam.unique.bam.norm.bedgraph", format = "bedGraph")

# Import gff and convert to accepted data structure
LIV26_genes_gtf <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvY486_LIV26.gtf", format = "gtf")
LIV26_genes_gtf.tx <- makeTxDbFromGRanges(LIV26_genes_gtf)
LIV26_genes_gtf.kary <- makeGenesDataFromTxDb(LIV26_genes_gtf.tx, karyoplot = tryp_karyotype)

# Apply log10 scaling to normalised scores. Add 1 to all values to avoid negatives
ds1713_25.bedgraph$log_score <- log10(ds1713_25.bedgraph$score+1)
ds1713_26.bedgraph$log_score <- log10(ds1713_26.bedgraph$score+1)
ds1713_27.bedgraph$log_score <- log10(ds1713_27.bedgraph$score+1)
ds1713_28.bedgraph$log_score <- log10(ds1713_28.bedgraph$score+1)

# Import and modify gff to allow plotting of cytobands
LIV26_genes_gff <- import("C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvY486_LIV26_genes.gff", format = "gff3")
LIV26_genes_gff_df <- as.data.frame(LIV26_genes_gff)
mcols(LIV26_genes_gff)$strand <- droplevels(LIV26_genes_gff_df$strand)
mcols(LIV26_genes_gff)$gieStain <- seq(1:16420)
mcols(LIV26_genes_gff)$name <- mcols(LIV26_genes_gff)$ID
mcols(LIV26_genes_gff)$gieStain <- ifelse(as.character(mcols(LIV26_genes_gff)$strand) == "+", as.character('acen'), as.character('stalk'))
mcols(LIV26_genes_gff)$gieStain <- as.factor(mcols(LIV26_genes_gff)$gieStain)
levels(LIV26_genes_gff$strand)

# Plot scaffolds
tryp_karyotype <- plotKaryotype(genome = tryp_genome, 
                                zoom=toGRanges("TvY486_LIV26_scaffold_10", 0, 350000), 
                                chromosomes = c("TvY486_LIV26_scaffold_10","TvY486_LIV26_scaffold_3a"), 
                                cytobands = LIV26_genes_gff, 
                                plot.type = 2
                                )

# Plot bedgraph expression
scaffold10_bedgraph <- kpArea(tryp_karyotype, data=ds1713_25.bedgraph, y=ds1713_25.bedgraph$log_score, ymin = 0, ymax = 5, col = "cyan", data.panel = 1, r0 = 0.5, r1 = 0.95)
scaffold10_bedgraph <- kpArea(tryp_karyotype, data=ds1713_26.bedgraph, y=ds1713_26.bedgraph$log_score, ymin = 0, ymax = 5, col = "cyan", data.panel = 1, r0 = 0, r1 = 0.45)
scaffold10_bedgraph <- kpArea(tryp_karyotype, data=ds1713_27.bedgraph, y=ds1713_27.bedgraph$log_score, ymin = 0, ymax = 5, col = "cyan", data.panel = 2, r0 = 0, r1 = 0.45)
scaffold10_bedgraph <- kpArea(tryp_karyotype, data=ds1713_28.bedgraph, y=ds1713_28.bedgraph$log_score, ymin = 0, ymax = 5, col = "cyan", data.panel = 2, r0 = 0.5, r1 = 0.95)

scaffold10_bedgraph <- kpAddLabels(tryp_karyotype, labels = 'TvSM 1', data.panel = 1, r0 = 0.5, r1 = 0.95)
scaffold10_bedgraph <- kpAddLabels(tryp_karyotype, labels = 'TvSM 2', data.panel = 1, r0 = 0, r1 = 0.45)
scaffold10_bedgraph <- kpAddLabels(tryp_karyotype, labels = 'ND1 34o', data.panel = 2, r0 = 0, r1 = 0.45)
scaffold10_bedgraph <- kpAddLabels(tryp_karyotype, labels = 'ND1 37o', data.panel = 2, r0 = 0.5, r1 = 0.95)

scaffold10_bedgraph <- kpPlotGenes(tryp_karyotype, LIV26_genes_gtf.kary, gene.col = "red", plot.transcripts = F, plot.transcripts.structure = F, gene.names = F, data.panel = 2)

tryp_karyotype <- plotKaryotype(genome = tryp_genome, 
                                zoom=toGRanges("TvY486_LIV26_scaffold_10", 0, 350000), 
                                chromosomes = c("TvY486_LIV26_scaffold_10","TvY486_LIV26_scaffold_3a"), 
                                #cytobands = LIV26_genes_gff, 
                                #plot.type = 2
)
scaffold10_bedgraph <- kpPlotGenes(tryp_karyotype, data = LIV26_genes_gtf.kary)
