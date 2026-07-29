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
library(pheatmap)
library(gridExtra)
}

sample_list <- list()

# load in each of the datasets in a tab delimited file and add them to a list
# sprintf is a c function used to append each number to 2 digits with leading zeroes
{
  for (i in (sprintf("%02d", 1:24))) {
    file.name <- paste0("C:/Users/oscar/Downloads/Trypanosome_MSc_project/Read_count_data/ds1713_",paste0(i),".Aligned.out.bam.ReadsPerGene.out.tab")
    assign(paste0("sample_",i),read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2")))
    sample_list[[i]] <- read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2"))
  }
  
  for (i in (sprintf("%02d", 25:28))) {
    file.name <- paste0("C:/Users/oscar/Downloads/Trypanosome_MSc_project/Read_count_data/ds1713_",paste0(i),".ReadsPerGene.out.tab")
    assign(paste0("sample_",i),read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2")))
    sample_list[[i]] <- read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2"))
  }

  for (i in (sprintf("%02d", 29:30))) {
    file.name <- paste0("C:/Users/oscar/Downloads/Trypanosome_MSc_project/Read_count_data/EPI_",paste0(i),".bam.ReadsPerGene.out.tab")
    assign(paste0("EPI_",i),read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2")))
    sample_list[[i]] <- read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2"))
  }

  for (i in (sprintf("%02d", 31:32))) {
    file.name <- paste0("C:/Users/oscar/Downloads/Trypanosome_MSc_project/Read_count_data/META_",paste0(i),".bam.ReadsPerGene.out.tab")
    assign(paste0("META_",i),read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2")))
    sample_list[[i]] <- read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2"))
  }

  for (i in (sprintf("%02d", 33:34))) {
    file.name <- paste0("C:/Users/oscar/Downloads/Trypanosome_MSc_project/Read_count_data/BSF_",paste0(i),".bam.ReadsPerGene.out.tab")
    assign(paste0("BSF_",i),read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2")))
    sample_list[[i]] <- read.delim(file.name, row.names = 1, header = FALSE, col.names = c("gene","combined","R1","R2"))
  }
}

# reads in first column of sample 1, then appends the first column of all the datasets before removing the it.
{
  merged_data <- sample_01[,1,drop=F]
    for (i in sample_list) {
      merged_data <- cbind(merged_data,(i[,1,drop=F]))
    }
  merged_data$combined <- NULL
  rm(i)
}

# creates a list of sample names, which can then be appended to the merged data frame
col_names <- list() 

{
for (i in (sprintf("%02d", 1:26))) {
  col_names[[i]] <- paste0("TvSM_",i)
}
for (i in (sprintf("%02d", 27:28))) {
  col_names[[i]] <- paste0("ND1_",i)
}
for (i in (sprintf("%02d", 29:30))) {
  col_names[[i]] <- paste0("EPI_",i)
}
for (i in (sprintf("%02d", 31:32))) {
  col_names[[i]] <- paste0("META_",i)
}
for (i in (sprintf("%02d", 33:34))) {
  col_names[[i]] <- paste0("BSF_",i)
}
}


col_names <- read.table("C:/Users/oscar/Downloads/Trypanosome_MSc_project/samples.txt")

colnames(merged_data) <- col_names[1:34, 2]

# clear out the individual sample data frames for neatness
rm(list = ls(pattern='sample_'))

# removes the rows containing unmapped/ excessively multimapped read data
merged_data_cleaned <- merged_data[-c(1:4),]
rm(merged_data)

# write the cleaned up dataframe to a .csv file
write.csv(merged_data_cleaned, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/STAR_edgeR_dataset_twice_mapped_with_Jackson_reads.csv')

# begin edgeR analysis
vsg_dataset <- merged_data_cleaned[,(1:34)]


# normalize dataset based on total counts, generate mean counts of the TvSM samples and create new data frames 
{
  norm_merged_data_cleaned <- DGEList(counts = merged_data_cleaned)
  norm_merged_data_cleaned <- calcNormFactors(norm_merged_data_cleaned, method = 'TMM')
  norm_merged_data_cleaned <- cpm(norm_merged_data_cleaned)
  TvSM <- as.data.frame(rowMeans(norm_merged_data_cleaned[,25:26]))
  ND1.34 <- as.data.frame(norm_merged_data_cleaned[,27])
  ND1.37 <- as.data.frame(norm_merged_data_cleaned[,28])
}

# pca analysis and graphing for the dataset with ND1 
{
  testpca <- prcomp(t(norm_merged_data_cleaned[,c(1:34)]))
  pca_eigenvalues <- testpca$sdev^2
  pca_eigenvalues <- tibble(PC = factor(1:length(pca_eigenvalues)), variance = pca_eigenvalues) %>%
    mutate(pct = variance/sum(variance)*100) %>% 
    mutate(pct_cum = cumsum(pct))
  
  pc_scores <- testpca$x
  pc_scores <- pc_scores %>% 
    as_tibble(rownames = "sample")
  
  pc_summary <- as.data.frame(summary(pc_scores))
  
  pc_scores %>% 
    ggplot(aes(x = PC1, y = PC2, label=rownames(t(norm_merged_data_cleaned[,c(1:34)])))) +
    geom_point() +
    geom_text_repel(max.overlaps = Inf, force = 10) +
    #xlim(-20000,20000) +
    #ylim(-15000,15000) +
    xlab(paste("PC1 (",signif(pca_eigenvalues[1,3],3),"%)")) +
    ylab(paste("PC2 (",signif(pca_eigenvalues[2,3],3),"%)")) 
  
  pc_dendrogram <- column_to_rownames(pc_scores, var="sample")
  
  dm<-dist(pc_dendrogram) 
  hc<-hclust(dm, method="complete") # simple dendrogram
  plot(hc, hang=-1) 
#  rect.hclust(hc, k=5, border="red") 
}

# pca analysis and graphing for the dataset without ND1
{
  testpca <- prcomp(t(norm_merged_data_cleaned[,c(1:26,29:34)]))
  pca_eigenvalues <- testpca$sdev^2
  pca_eigenvalues <- tibble(PC = factor(1:length(pca_eigenvalues)), variance = pca_eigenvalues) %>%
    mutate(pct = variance/sum(variance)*100) %>% 
    mutate(pct_cum = cumsum(pct))
  
  pc_scores <- testpca$x
  pc_scores <- pc_scores %>% 
    as_tibble(rownames = "sample")
  
  pc_summary <- as.data.frame(summary(pc_scores))
  
  pc_scores %>% 
    ggplot(aes(x = PC1, y = PC2, label=rownames(t(norm_merged_data_cleaned[,c(1:26,29:34)])))) +
    geom_point() +
    geom_text_repel(max.overlaps = Inf, force = 10) +
    #xlim(-20000,20000) +
    #ylim(-15000,15000) +
    xlab(paste("PC1 (",signif(pca_eigenvalues[1,3],3),"%)")) +
    ylab(paste("PC2 (",signif(pca_eigenvalues[2,3],3),"%)")) 
    
    pc_dendrogram <- column_to_rownames(pc_scores, var="sample")
    
    dm<-dist(pc_dendrogram) 
    hc<-hclust(dm, method="complete") # simple dendrogram
    plot(hc, hang=-1) 
    
    genepca <- prcomp(norm_merged_data_cleaned[,c(1:26,29:34)])
    pca_eigenvalues <- testpca$sdev^2
    pca_eigenvalues <- tibble(PC = factor(1:length(pca_eigenvalues)), variance = pca_eigenvalues) %>%
      mutate(pct = variance/sum(variance)*100) %>% 
      mutate(pct_cum = cumsum(pct))
    
    pc_gene_scores <- genepca$x
    pc_gene_scores <- pc_gene_scores %>% 
      as_tibble(rownames = "sample")
    
    pc_gene_dendrogram <- column_to_rownames(pc_gene_scores, var = "sample")
    top_genes_PC1 <- arrange(pc_gene_scores, desc(PC1))
    top_genes_PC2 <- arrange(pc_gene_scores, desc(PC2))
    
    PC1_gene_contribution_plot <- ggplot(top_genes_PC1[1:15,], aes(x = reorder(sample, PC1), y = PC1)) +
      geom_col(fill = "#3a86d4") +
      coord_flip() +
      xlab("Gene")
    
    plot(PC1_gene_contribution_plot)
    
    PC2_gene_contribution_plot <- ggplot(top_genes_PC2[1:15,], aes(x = reorder(sample, PC2), y = PC2)) +
      geom_col(fill = "#3a86d4") +
      coord_flip()+
      xlab("Gene")
    
    plot(PC2_gene_contribution_plot)
}

# calculate log2 expression difference between samples, and geometric mean of the 2 read counts
{
  rm(TvSM_vs_ND1.34); TvSM_vs_ND1.34 <- log2((ND1.34+1)/(TvSM+1)); names(TvSM_vs_ND1.34)[1] <- 'M'
  rm(TvSM_vs_ND1.37); TvSM_vs_ND1.37 <- log2((ND1.37+1)/(TvSM+1)); names(TvSM_vs_ND1.37)[1] <- 'M'
  rm(ND1.34_vs_ND1.37); ND1.34_vs_ND1.37 <- log2((ND1.34+1)/(ND1.37+1)); names(ND1.34_vs_ND1.37)[1] <- 'M'

  TvSM_vs_ND1.34[,2] <- log2(sqrt((ND1.34+1)*(TvSM+1))); names(TvSM_vs_ND1.34)[2] <- 'A'
  TvSM_vs_ND1.37[,2] <- log2(sqrt((ND1.37+1)*(TvSM+1))); names(TvSM_vs_ND1.37)[2] <- 'A'
  ND1.34_vs_ND1.37[,2] <- log2(sqrt((ND1.34+1)*(ND1.37+1))); names(ND1.34_vs_ND1.37)[2] <- 'A'
  
  TvSM_vs_ND1.34[,3:4] <- data.frame(Gene = row.names(TvSM_vs_ND1.34), Diff_Exp = abs(TvSM_vs_ND1.34$M) > 1)
  TvSM_vs_ND1.37[,3:4] <- data.frame(Gene = row.names(TvSM_vs_ND1.37), Diff_Exp = abs(TvSM_vs_ND1.37$M) > 1)
  ND1.34_vs_ND1.37[,3:4] <- data.frame(Gene = row.names(ND1.34_vs_ND1.37), Diff_Exp = abs(ND1.34_vs_ND1.37$M) > 1)
}

# collect a list of the most 10 most differently up and down expressed genes
{
  TvSM_vs_ND1.34_up_genes <- TvSM_vs_ND1.34 %>% filter(Diff_Exp = TRUE) %>% arrange(desc(M)) %>% dplyr::slice(1:10)
  TvSM_vs_ND1.34_down_genes <- TvSM_vs_ND1.34 %>% filter(Diff_Exp = TRUE) %>% arrange((M)) %>% dplyr::slice(1:10)
  TvSM_vs_ND1.34_diff_genes <- rbind(TvSM_vs_ND1.34_up_genes, TvSM_vs_ND1.34_down_genes)
  
  TvSM_vs_ND1.37_up_genes <- TvSM_vs_ND1.37 %>% filter(Diff_Exp = TRUE) %>% arrange(desc(M)) %>% dplyr::slice(1:10)
  TvSM_vs_ND1.37_down_genes <- TvSM_vs_ND1.37 %>% filter(Diff_Exp = TRUE) %>% arrange((M)) %>% dplyr::slice(1:10)
  TvSM_vs_ND1.37_diff_genes <- rbind(TvSM_vs_ND1.37_up_genes, TvSM_vs_ND1.37_down_genes)
  
  ND1.34_vs_ND1.37_up_genes <- ND1.34_vs_ND1.37 %>% filter(Diff_Exp = TRUE) %>% arrange(desc(M)) %>% dplyr::slice(1:10)
  ND1.34_vs_ND1.37_down_genes <- ND1.34_vs_ND1.37 %>% filter(Diff_Exp = TRUE) %>% arrange((M)) %>% dplyr::slice(1:10)
  ND1.34_vs_ND1.37_diff_genes <- rbind(ND1.34_vs_ND1.37_up_genes, ND1.34_vs_ND1.37_down_genes)
}

# generate MA plots based on these log values
{
  ma_plot_TvSM_ND1.34 <- ggplot(TvSM_vs_ND1.34,aes(A,M))+
    geom_point(aes(colour = "red"))+
    #scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_light()+
    xlim(0,20)+
    ylim(-25,25)+
    geom_label_repel(data = TvSM_vs_ND1.34_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    geom_label_repel(data = TvSM_vs_ND1.34_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.34', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.34 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  ma_plot_TvSM_ND1.37 <- ggplot(TvSM_vs_ND1.37,aes(A,M))+
    geom_point(aes(colour = "red"))+
    #scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_light()+
    xlim(0,20)+
    ylim(-25,25)+
    geom_label_repel(data = TvSM_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    geom_label_repel(data = TvSM_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  

  ma_plot_ND1.34_ND1.37 <- ggplot(ND1.34_vs_ND1.37,aes(A,M))+
    geom_point(aes(colour = "red"))+
    #scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_light()+
    xlim(0,20)+
    ylim(-25,25)+
    geom_label_repel(data = ND1.34_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    geom_label_repel(data = ND1.34_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of ND1.34, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to ND1.34')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

plot(ma_plot_TvSM_ND1.34)
plot(ma_plot_TvSM_ND1.37)
plot(ma_plot_ND1.34_ND1.37)

write.csv(TvSM_vs_ND1.34, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.34_twice_mapped.csv')
write.csv(TvSM_vs_ND1.37, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.37_twice_mapped.csv')
write.csv(ND1.34_vs_ND1.37, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/ND1.34_vs_ND1.37_twice_mapped.csv')

# highlight VSGs
TvY486_LIV26_lookup <- read_csv("C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvY486_LIV26_lookup.csv")
TvY486_LIV26_lookup_list <- split(TvY486_LIV26_lookup$Gene,seq(nrow(TvY486_LIV26_lookup)))

ND1.34_vs_ND1.37_vsg <- ND1.34_vs_ND1.37
TvSM_vs_ND1.34_vsg <- TvSM_vs_ND1.34
TvSM_vs_ND1.37_vsg <- TvSM_vs_ND1.37

ND1.34_vs_ND1.37_vsg$VSG <- ND1.34_vs_ND1.37_vsg$Gene %in% TvY486_LIV26_lookup_list
TvSM_vs_ND1.34_vsg$VSG <- TvSM_vs_ND1.34_vsg$Gene %in% TvY486_LIV26_lookup_list
TvSM_vs_ND1.37_vsg$VSG <- TvSM_vs_ND1.37_vsg$Gene %in% TvY486_LIV26_lookup_list

# plots points in the order the file runs in, hence the arrange to put the highlighted points on top
{
  ma_plot_TvSM_ND1.34_vsg <- ggplot(TvSM_vs_ND1.34_vsg %>% arrange(VSG),aes(A,M))+
    geom_point(aes(colour = VSG))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = TvSM_vs_ND1.34_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = TvSM_vs_ND1.34_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.34', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.34 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  ma_plot_TvSM_ND1.37_vsg <- ggplot(TvSM_vs_ND1.37_vsg %>% arrange(VSG),aes(A,M))+
    geom_point(aes(colour = VSG))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = TvSM_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = TvSM_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  
  ma_plot_ND1.34_ND1.37_vsg <- ggplot(ND1.34_vs_ND1.37_vsg %>% arrange(VSG),aes(A,M))+
    geom_point(aes(colour = VSG))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = ND1.34_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = ND1.34_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of ND1.34, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to ND1.34')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

plot(ma_plot_TvSM_ND1.34_vsg)
plot(ma_plot_TvSM_ND1.37_vsg)
plot(ma_plot_ND1.34_ND1.37_vsg)

write.csv(TvSM_vs_ND1.34_vsg, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.34_vsg.csv')
write.csv(TvSM_vs_ND1.37_vsg, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.37_vsg.csv')
write.csv(ND1.34_vs_ND1.37_vsg, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/ND1.34_vs_ND1.37_vsg.csv')

# highlight RNA-assoc genes
RNA_assoc_lookup <- read_table("C:/Users/oscar/Downloads/Trypanosome_MSc_project/RNA_assoc_gene.tab.txt")
RNA_assoc_lookup_list <- split(RNA_assoc_lookup$Sequence,seq(nrow(RNA_assoc_lookup)))

ND1.34_vs_ND1.37_rna <- ND1.34_vs_ND1.37
TvSM_vs_ND1.34_rna <- TvSM_vs_ND1.34
TvSM_vs_ND1.37_rna <- TvSM_vs_ND1.37

ND1.34_vs_ND1.37_rna$RNA <- ND1.34_vs_ND1.37_rna$Gene %in% RNA_assoc_lookup_list
TvSM_vs_ND1.34_rna$RNA <- TvSM_vs_ND1.34_rna$Gene %in% RNA_assoc_lookup_list
TvSM_vs_ND1.37_rna$RNA <- TvSM_vs_ND1.37_rna$Gene %in% RNA_assoc_lookup_list

{
  ma_plot_TvSM_ND1.34_rna <- ggplot(TvSM_vs_ND1.34_rna %>% arrange(RNA),aes(A,M))+
    geom_point(aes(color = RNA))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = TvSM_vs_ND1.34_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = TvSM_vs_ND1.34_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.34', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.34 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  ma_plot_TvSM_ND1.37_rna <- ggplot(TvSM_vs_ND1.37_rna %>% arrange(RNA),aes(A,M))+
    geom_point(aes(colour = RNA))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = TvSM_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = TvSM_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -5, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of TvSM samples, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to TvSM')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  
  ma_plot_ND1.34_ND1.37_rna <- ggplot(ND1.34_vs_ND1.37_rna %>% arrange(RNA),aes(A,M))+
    geom_point(aes(colour = RNA))+
    scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
    theme_bw()+
    xlim(0,17.5)+
    ylim(-20,20)+
    #geom_label_repel(data = ND1.34_vs_ND1.37_up_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = 2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #geom_label_repel(data = ND1.34_vs_ND1.37_down_genes, max.overlaps = Inf, box.padding = 0.5, point.padding = 0.3, nudge_y = -2, size = 3, max.time = 300000, max.iter = 600000000, aes(label = Gene))+
    #labs(title = 'MA plot showing relative expression profile of ND1.34, compared with relative expression profile of ND1.37', subtitle = 'x axis shows log2 of the geometric mean of the read counts, y axis shows log2 expression of ND1.37 genes relative to ND1.34')+
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

plot(ma_plot_TvSM_ND1.34_rna)
plot(ma_plot_TvSM_ND1.37_rna)
plot(ma_plot_ND1.34_ND1.37_rna)

write.csv(TvSM_vs_ND1.34_rna, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.34_rna.csv')
write.csv(TvSM_vs_ND1.37_rna, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/TvSM_vs_ND1.37_rna.csv')
write.csv(ND1.34_vs_ND1.37_rna, file = 'C:/Users/oscar/Downloads/Trypanosome_MSc_project/ND1.34_vs_ND1.37_rna.csv')


# Plot heat map showing differential gene expression
norm_merged_data_cleaned_heatmap <- as.matrix(norm_merged_data_cleaned)
heatmap(norm_merged_data_cleaned_heatmap[,1:34], Rowv = NA)

# Plot heatmap for vsg genes
norm_merged_data_cleaned_heatmap_vsg <- norm_merged_data_cleaned_heatmap[row.names(norm_merged_data_cleaned_heatmap) %in% TvY486_LIV26_lookup_list,]
heatmap(norm_merged_data_cleaned_heatmap_vsg[,1:34], Rowv = NA)

# Plot heatmap for RNA assoc genes
norm_merged_data_cleaned_heatmap_rna <- norm_merged_data_cleaned_heatmap[row.names(norm_merged_data_cleaned_heatmap) %in% RNA_assoc_lookup_list,]
heatmap(norm_merged_data_cleaned_heatmap_rna[,1:34], Rowv = NA)

RBP6.10 <- list("TvY486_LIV26_0039900","TvY486_LIV26_0032910")
norm_merged_data_cleaned_heatmap_rbp10.6 <- norm_merged_data_cleaned_heatmap[row.names(norm_merged_data_cleaned_heatmap) %in% RBP6.10,]
heatmap(norm_merged_data_cleaned_heatmap_rbp10.6[,1:34], Rowv = NA)

# Plot mmplot based on ND1 vs TvsM expression and Induced vs Noninduced expression
Noninduced <- as.data.frame(rowMeans(norm_merged_data_cleaned[,c(13,16,19,22)]))
Induced <- as.data.frame(rowMeans(norm_merged_data_cleaned[,c(14:15,17:18,20:21,23:24)]))
rm(Induced_vs_noninduced); Induced_vs_noninduced <- log2((Induced+1)/(Noninduced+1)); names(Induced_vs_noninduced)[1] <- 'M'
mmplot_induced_noninduced_TvsM_ND1.34 <- merge(TvSM_vs_ND1.34, Induced_vs_noninduced, by = 0); rownames(mmplot_induced_noninduced_TvsM_ND1.34)=mmplot_induced_noninduced_TvsM_ND1.34$Row.names
mmplot_induced_noninduced_TvsM_ND1.34$RNA <- mmplot_induced_noninduced_TvsM_ND1.34$Row.names %in% RNA_assoc_lookup_list
names(mmplot_induced_noninduced_TvsM_ND1.34)[2] <- '<- TvSM vs ND1.34 ->' 
names(mmplot_induced_noninduced_TvsM_ND1.34)[6] <- '<- NonInduced vs Induced ->'

ggplot(mmplot_induced_noninduced_TvsM_ND1.34 %>% arrange(RNA), aes(`<- TvSM vs ND1.34 ->`,`<- NonInduced vs Induced ->`)) +
  geom_point(aes(color = RNA))+
  scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
  theme_bw()+
  xlim(-20,20)+
  ylim(-15,15)

# Plot mmplot based on ND1 vs TvsM expression and BSF vs Epi expression
Epi <- as.data.frame(rowMeans(norm_merged_data_cleaned[,c(29,30)]))
BSF <- as.data.frame((norm_merged_data_cleaned[,c(34)]))
rm(BSF_vs_Epi); BSF_vs_Epi <- log2((BSF+1)/(Epi+1)); names(BSF_vs_Epi)[1] <- 'M'
mmplot_BSF_Epi_TvsM_ND1.34 <- merge(TvSM_vs_ND1.34, BSF_vs_Epi, by = 0); rownames(mmplot_BSF_Epi_TvsM_ND1.34)=mmplot_BSF_Epi_TvsM_ND1.34$Row.names
mmplot_BSF_Epi_TvsM_ND1.34$RNA <- mmplot_BSF_Epi_TvsM_ND1.34$Row.names %in% RNA_assoc_lookup_list
names(mmplot_BSF_Epi_TvsM_ND1.34)[2] <- '<- TvSM vs ND1.34 ->' 
names(mmplot_BSF_Epi_TvsM_ND1.34)[6] <- '<- Epi vs BSF ->'

ggplot(mmplot_BSF_Epi_TvsM_ND1.34 %>% arrange(RNA), aes(`<- TvSM vs ND1.34 ->`,`<- Epi vs BSF ->`)) +
  geom_point(aes(color = RNA))+
  scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
  theme_bw()+
  xlim(-20,20)+
  ylim(-15,15)


heatmap_index <- as.matrix(rowMeans(norm_merged_data_cleaned))
heatmap_index <- cbind(heatmap_index, heatmap_index)
heatmap_index <- cbind(heatmap_index, rownames(heatmap_index))
heatmap_index_vsg <- as.matrix(heatmap_index[row.names(heatmap_index) %in% TvY486_LIV26_lookup_list,])
heatmap_index_rna <- as.matrix(heatmap_index[row.names(heatmap_index) %in% RNA_assoc_lookup_list,])
#heatmap_index_plot_vsg <- pheatmap(heatmap_index_vsg, cluster_rows = FALSE, cluster_cols = FALSE, show_rownames = FALSE)
#heatmap_index_plot_rna <- pheatmap(heatmap_index_rna, cluster_rows = FALSE, cluster_cols = FALSE, show_rownames = FALSE)


#Import quast statistics dataset, then create a table from it
QUAST_statistics <- read_delim("C:/Users/oscar/Downloads/Trypanosome_MSc_project/QUAST statistics.txt", 
                      delim = "\t", escape_double = FALSE, 
                      trim_ws = TRUE)
QUAST_statistics <- as.data.frame(QUAST_statistics)
rownames(QUAST_statistics) <- QUAST_statistics[,1]
QUAST_statistics[,1] <- NULL
QUAST_statistics_plot <- grid.table(QUAST_statistics)

#Generate a grid of the MA plots
grid.arrange(ma_plot_ND1.34_ND1.37_rna, ma_plot_ND1.34_ND1.37_vsg, ma_plot_TvSM_ND1.34_rna, ma_plot_TvSM_ND1.34_vsg, ma_plot_TvSM_ND1.37_rna, ma_plot_TvSM_ND1.37_vsg, nrow = 3)

cor.test(mmplot_BSF_Epi_TvsM_ND1.34[,2], mmplot_BSF_Epi_TvsM_ND1.34[,6], method = 'spearman')
cor.test(mmplot_induced_noninduced_TvsM_ND1.34[,2], mmplot_induced_noninduced_TvsM_ND1.34[,6], method = 'spearman')

mmplot_TvSM_ND1 <- merge(TvSM_vs_ND1.34, TvSM_vs_ND1.37, by = 0); rownames(mmplot_TvSM_ND1)=mmplot_TvSM_ND1$Row.names
mmplot_TvSM_ND1$RNA <- mmplot_TvSM_ND1$Row.names %in% RNA_assoc_lookup_list
names(mmplot_TvSM_ND1)[2] <- '<- TvSM vs ND1.34 ->' 
names(mmplot_TvSM_ND1)[6] <- '<- TvSM vs ND1.37 ->'

ggplot(mmplot_TvSM_ND1 %>% arrange(RNA), aes(`<- TvSM vs ND1.34 ->`,`<- TvSM vs ND1.37 ->`)) +
  geom_point(aes(color = RNA))+
  scale_color_manual(values = c("FALSE" = "darkgray", "TRUE" = "red"))+
  theme_bw()+
  xlim(-20,20)+
  ylim(-20,20)

cor.test(mmplot_TvSM_ND1[,2], mmplot_TvSM_ND1[,6], method = 'spearman')
cor.test(mmplot_induced_noninduced_TvsM_ND1.34[,2], mmplot_induced_noninduced_TvsM_ND1.34[,6], method = 'spearman')

