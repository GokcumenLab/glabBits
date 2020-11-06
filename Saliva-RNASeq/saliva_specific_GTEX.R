#####Data Prep
#setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")
#setwd("/Users/saitoumarie/Dropbox/Buffalo/saliva/Salivary glands/ForMarie&Omer")
setwd("~/Dropbox/Sharing/Salivary glands/ForMarie&Omer/")


library (ggplot2)
library (reshape2)
require("gplots")
require("RColorBrewer")
library(ggrepel)
library("biomaRt")


input <- read.csv("TableS2_updated.csv")
cn <- c("PAR", "SM", "SL", "par", "sm", "sl")

###GTEX database cleaned for alternative chromosomes
gtex <- read.csv("GTEX_chrCleaned.csv")
head(gtex)

mean(gtex$Total)/50
input$total <- input$SL+input$SM+input$PAR
mean(input$total)/3
308.2253/21.49252

names(input)
sum (input[, 12:15])

gtex <- subset (gtex, gtex$Total<10)

all <- subset (input, input$gene %in% gtex$Name)
all <- subset (all, all$PAR>100 | all$SM>100 | all$SL>100 | all$sl>100 | all$sm>100 | all$par>100)

#all <- subset (all, all$PAR>100 | all$SM>100 | all$SL>100)

gtex_specific <- subset (gtex, gtex$Name %in% all$gene)

write.csv(all, "salivaSpecific.csv")
write.csv(gtex_specific, "gtex_specific.csv")


#### I manually curated the input file from the top two written csv's (also replaced NAs)

#heatmap for the Gtex

all <- read.csv("salivaSpecific_manual3.csv")
#all <- subset (all, all$PAR>300 | all$SM>300 | all$SL>300)

all$SL_norm <- all$SL/21.49
all$SM_norm <- all$SM/21.49
all$PAR_norm <- all$PAR/21.49

names(all)

#mat_data <- all [, c(6:59, 103:105)]
mat_data <- all [, c(3:55, 63:65)]

row.names(mat_data) <- all$gene
mat_data <- as.matrix(mat_data)

my_palette <- rev(brewer.pal (8,"RdBu"))

png ("saliva_spec_gtex.test.png",  width = 20, height = 16, units = 'in', res = 200)
heatmap.2 (mat_data, density.info="none", trace="none", col=my_palette, scale="row",
           sepwidth=c(0.001,0.001), sepcolor="black", colsep=1:ncol(mat_data), rowsep=1:nrow(mat_data),       
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = T, Colv=T, cexRow=0.8, cexCol=1, main="")


heatmap.2 (mat_data, density.info="none", trace="none", col=my_palette, scale="row",
           sepwidth=c(0.001,0.001), sepcolor="black",  dendrogram = c("none"), rowsep=1:nrow(mat_data) ,    
           Rowv = T, Colv=T, cexRow=0.4, cexCol=1, main="")

x  <- as.matrix(mat_data)
heatmap.2 (mat_data, density.info="none", trace="none", col=my_palette, scale="row",
           sepwidth=c(0.001,0.001), sepcolor="black",  dendrogram = c("none") ,    
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = F, Colv=F, cexRow=0.4, cexCol=0.8, main="")
dev.off()

#### get protein-coding status

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl", host="grch37.ensembl.org"))
df <- read.csv("tissue_differences.csv", header = T, sep = ",") 
gene <- df$gene
G_list <- getBM(filters= "ensembl_gene_id", attributes=c('ensembl_gene_id','gene_biotype'),mart= mart,values=gene)
G_list2<-merge(df,G_list,by.x="gene",by.y="ensembl_gene_id",all.x=T)
write.csv(G_list2, file = "tissue_differences2.csv")
