library(eulerr)

venn <- euler(c('Jackson&Abbas&TriTryp' = 6214, 'Jackson&TriTryp' = 1612, 'Jackson&Abbas' = 1030, 'Abbas' = 837, 'Abbas&TriTryp' = 548, 'Jackson' = 388, 'TriTryp' = 155), shape = "ellipse")
plot(venn, quantities = TRUE, legend = TRUE, fill=c('coral','steelblue','palegreen'))
