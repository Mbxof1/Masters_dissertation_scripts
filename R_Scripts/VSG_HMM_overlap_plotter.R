library(tidyverse)
library(eulerr)
library(ggplot2)
library(grid)
library(gridExtra)

VSG_A_list <- read.csv("C:/Users/oscar/Downloads/Trypanosome_MSc_project/VSG_A_list.txt", sep="")
VSG_B_list <- read.csv("C:/Users/oscar/Downloads/Trypanosome_MSc_project/VSG_B_list.txt", sep="")

# Get length of the different VSG lists

VSG_A <- as.numeric(length(VSG_A_list$Sequence))

VSG_B <- as.numeric(length(VSG_B_list$Sequence))

VSG_AJ <- as.numeric(length(TvY486_LIV26_lookup$Gene))


# Calculate overlap between the groups

VSG_A_VSG_AJ_overlap <- as.numeric(length(intersect(VSG_A_list$Sequence, TvY486_LIV26_lookup$Gene)))

VSG_B_VSG_AJ_overlap <- as.numeric(length(intersect(VSG_B_list$Sequence, TvY486_LIV26_lookup$Gene)))

VSG_A_VSG_B_overlap <- as.numeric(length(intersect(VSG_A_list$Sequence, VSG_B_list$Sequence)))


# As there is no overlap between A and B, the following is appropriate

VSG_A_Unique <- VSG_A - VSG_A_VSG_AJ_overlap

VSG_B_Unique <- VSG_B - VSG_B_VSG_AJ_overlap

VSG_AJ_Unique <- VSG_AJ - (VSG_A_VSG_AJ_overlap + VSG_B_VSG_AJ_overlap)


# Plot venn diagram, default eulerr.plot functions are limited so hack bits together using grid.arrange
{
VSG_venn <- euler(c('VSG A HMM' = VSG_A_Unique, 'VSG B HMM' = VSG_B_Unique, 'Jackson dataset VSGs' = VSG_AJ_Unique, 'VSG A HMM&Jackson dataset VSGs' = VSG_A_VSG_AJ_overlap, 'VSG B HMM&Jackson dataset VSGs' = VSG_B_VSG_AJ_overlap))

plot(VSG_venn, 
     quantities = TRUE, 
     fill = c('coral','steelblue','palegreen'), 
     )

venn_title <- textGrob('Clustering of genes identified\nas coding for VSG A and B proteins within two\nHMM searches and a .GFF file provided with\nthe TvY486_LIV26 assembly',
                       gp = gpar(fontface='bold'))

grid.arrange(venn_title, VSG_venn_plot, heights = c(0.1, 0.6))
}

