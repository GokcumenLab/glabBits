setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")
library (ggplot2)
library (reshape2)
require("gplots")
require("RColorBrewer")
library(ggrepel)

input <- read.csv("tissue_differences.csv")
cn <- c("PAR", "SM", "SL", "par", "sm", "sl")


genes <- read.csv("genes.csv")
genes <- genes[!duplicated(genes$name2),]
all <- merge(input, genes, by.x="gene", by.y="name2")


head(all)



##############IDENTIFYING Glyco - get all the glycosylation guys GO:0006486 -
##lots of manual curation to get the gene names and get rid of redundant gene names

glyco <- read.csv("glycosylation.csv")
Olinked <- read.csv("O-linked.csv")
Nlinked <- read.csv("n-linked.csv")
names (glyco) <- c("uniprot", "gene")
head(glyco)

glyco <- subset (all, all$hgnc_symbol %in% glyco$gene)


##############glyco's with retention in adult tissues
#no abundant retention ones are found

############## glyco abundant
hist (glyco$PAR)

quantile (glyco$PAR, 0.1)
quantile (glyco$SL, 0.1)
quantile (glyco$SM, 0.1)

abundant <- subset (glyco, glyco$SL>1000 | glyco$PAR>1000 |  glyco$SM>1000 |
                      glyco$sl>1000 | glyco$par>1000 |  glyco$sm>1000)

a <- subset (abundant, abundant$hgnc_symbol %in% Olinked$Genes & abundant$hgnc_symbol!="PGM3")
a$type <- "O-linked"
b <- subset (abundant, abundant$hgnc_symbol=="PGM3")
b$type <- "both"
a <- rbind (a, b)
b <- subset (abundant, abundant$hgnc_symbol %in% Nlinked$Genes& abundant$hgnc_symbol!="PGM3")
b$type <- "N-linked"
a <- rbind (a, b)

mat_data <- a
row.names(mat_data) <- mat_data$hgnc_symbol

mat_data <- as.matrix(mat_data[, 12:17])

my_palette <- rev(brewer.pal (8,"RdBu"))

png ("glycosylation.png",  width = 10, height = 15, units = 'in', res = 200)

heatmap.2 (mat_data, density.info="none", trace="none", col=my_palette, scale="row",
           sepwidth=c(0.001,0.001), sepcolor="black", colsep=1:ncol(mat_data), rowsep=1:nrow(mat_data),       
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = F, Colv=F, cexRow=1.2, cexCol=2.5, main="")
           #RowSideColors=rowCols)
write.csv(a, "glcyo.csv")

dev.off()

