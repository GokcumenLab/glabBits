#setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")
library (ggplot2)
library (reshape2)
require("gplots")
require("RColorBrewer")
library(ggrepel)

setwd("~/Dropbox/Sharing/Salivary glands/ForMarie&Omer/")

input <- read.csv("TableS2_updated.csv")
cn <- c("PAR", "SM", "SL", "par", "sm", "sl")

genes <- read.csv("genes.csv")
genes <- genes[!duplicated(genes$name2),]
all <- merge(input, genes, by.x="gene", by.y="name2")




##############IDENTIFYING TFs
TF <- read.csv("DatabaseExtract_v_1.01.csv")
TF <- TF [, 1:5]
TF <- subset (TF, TF$Is.TF.=="Yes")
head(TF)

TF <- subset (all, all$hgnc_symbol %in% TF$HGNC.symbol)


##############TF's with differential retention in adult tissues
all <- subset (TF, TF$sl>100 | TF$par>100 |  TF$sm>100 |
                 TF$SM>100  |  TF$SL>100 | TF$PAR>100)

all <- subset (TF, TF$sl>100 & TF$par>100 &  TF$sm>100 & TF$SM>100  &  TF$SL>100 & TF$PAR>100)
a <- subset (all, all$SL>100)

SL_retain <- subset (all, all$SLpadj>0.0001 & all$PARpadj<0.0001 & all$SMpadj<0.0001 & 
                       all$SMlog2FoldChange<(-2) & (all$PARlog2FoldChange)<(-2))

#PAR_retain <- subset (all, all$PARpadj>0.0001 & all$SMpadj<0.0001 & all$SLpadj<0.0001 & 
 #                       (all$SLlog2FoldChange)<(-2) &  (all$SMlog2FoldChange)<(-2))

#SM_retain <- subset (all, all$SMpadj>0.0001 & all$PARpadj<0.0001 & all$SLpadj<0.0001 & 
  #                     (all$SLlog2FoldChange)<(-2) & (all$PARlog2FoldChange)<(-2))

#df <- rbind (SL_retain, PAR_retain, SM_retain)

#df$TFtype = "retained"

##############TF's with differential expression in adult tissues

differential <- subset (TF, (TF$SL.PAR.padj<0.0001 & abs(TF$SL.PAR.log2FoldChange)>1.5) | 
                               (TF$SM.SL.padj<0.0001 & abs(TF$SM.SL.log2FoldChange)>1.5) | 
                                (TF$PAR.SM.padj<0.0001 & abs(TF$PAR.SM.log2FoldChange)>1.5))
                        
differential$TFtype <- "differential"

############## Abundant TFs

quantile (TF$PAR, 0.95)
quantile (TF$SL, 0.95)
quantile (TF$SM, 0.95)

abundant <- subset (TF, (TF$SL>2000 | TF$PAR>2000 |  TF$SM>2000) & !(TF$gene %in% differential$gene))
abundant$TFtype <- "abundant"
df <- rbind (differential, abundant)
df



########### Sarah's TF's

all <- TF
TF_Sarah <- subset (all, all$hgnc_symbol=="SOX9" | 
                         all$hgnc_symbol=="SOX10" |
                        
                         all$hgnc_symbol=="ETV5" | all$hgnc_symbol=="SPDEF" |
                         all$hgnc_symbol=="RUNX1" | all$hgnc_symbol=="RUNX2" |
                         all$hgnc_symbol=="RUNX3" | all$hgnc_symbol=="ZNF225" |
                         all$hgnc_symbol=="ASCL3" |
                         all$hgnc_symbol=="EN1" | all$hgnc_symbol=="SIX1" |
                      
                         all$hgnc_symbol=="YAP1" | all$hgnc_symbol=="NR4A3" |
                         all$hgnc_symbol=="PPARG" | all$hgnc_symbol=="TP63" |
                         all$hgnc_symbol=="MYB" | all$hgnc_symbol=="ZEB1" |
                         all$hgnc_symbol=="NFKB1" |
                         all$hgnc_symbol=="STAT1" | all$hgnc_symbol=="STAT5A" |
                         all$hgnc_symbol=="ATF6" | all$hgnc_symbol=="ATF3" |
                         all$hgnc_symbol=="STAT5B")

TF_Sarah$TFtype <- "known"
df <- rbind (df, TF_Sarah)

#additional known TFs

a <- c("FOXD3", "CBX2",  "SOX11")
TF_Sarah <- subset (all, all$hgnc_symbol %in% a )
TF_Sarah$TFtype <- "known"
df <- rbind (df, TF_Sarah)


######## saliva_specific ones

###GTEX database cleaned for alternative chromosomes
gtex <- read.csv("GTEX_chrCleaned.csv")
head(gtex)

gtex <- subset (gtex, gtex$Total<10)
all <- TF
specific <- subset (all, all$PAR>100 | all$SM>100 | all$SL>100 | all$sl>100 | all$sm>100 | all$par>100)
specific <- subset (specific, specific$gene %in% gtex$Name)

specific$TFtype <- "Saliva_specific"

head(gtex)
df <- rbind (df, specific)

#### duplication check and writing

df [duplicated (df$hgnc_symbol),]

write.csv (df, "transcription.csv")


######## manually curate the database  to get  the unique guys

df$hgnc_symbol
mat_data <- df

row.names(mat_data) <- df$hgnc_symbol

mat_data <- as.matrix(mat_data[, 27:32])
df$TFtype
rowCols <- ifelse(df$TFtype=="retained", "dark blue",
                  (ifelse(df$TFtype=="specific", "lightblue", ifelse(df$TFtype=="abundant","gray", "red"))))
rowCols

my_palette <- rev(brewer.pal (8,"RdBu"))

png ("TFs.png",  width = 20, height = 16, units = 'in', res = 200)

heatmap.2 (mat_data, density.info="none", trace="none", col=my_palette, scale="row",
           sepwidth=c(0.001,0.001), sepcolor="black", colsep=1:ncol(mat_data), rowsep=1:nrow(mat_data),       
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = F, Colv=F, cexRow=0.5, cexCol=0.5, main="")



dev.off()

