###Data Prep
setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")
setwd("/Users/saitoumarie/Dropbox/Buffalo/saliva/Salivary glands/ForMarie&Omer")
setwd("~/Dropbox/Sharing/Salivary glands/ForMarie&Omer/")

library (ggplot2)
library (reshape2)
require("gplots")
require("RColorBrewer")
library(ggrepel)

input <- read.csv("TableS2_updated.csv")
cn <- c("PAR", "SM", "SL", "par", "sm", "sl")


####abundant fetal genes that are retained
all <- subset (input, input$sl>1000 & input$par>1000 &  input$sm>1000)

SL_retain <- subset (all, all$SLpadj>0.0001 & all$PARpadj<0.0001 & all$SMpadj<0.0001 & 
                       all$SMlog2FoldChange<(-2) & (all$PARlog2FoldChange)<(-2))
SL_retain$Retention <- "SL"

PAR_retain <- subset (all, all$PARpadj>0.0001 & all$SMpadj<0.0001 & all$SLpadj<0.0001 & 
                        (all$SLlog2FoldChange)<(-2) &  (all$SMlog2FoldChange)<(-2))
PAR_retain$Retention <- "PAR"

SM_retain <- subset (all, all$SMpadj>0.0001 & all$PARpadj<0.0001 & all$SLpadj<0.0001 & 
                       (all$SLlog2FoldChange)<(-2) & (all$PARlog2FoldChange)<(-2))
SM_retain$Retention <- "SM"


All_retain <- subset (all, all$SMpadj>0.0001& all$PARpadj>0.0001 & all$SLpadj>0.0001 )

Any_retain <- subset (all, all$SMpadj>0.0001 | all$PARpadj>0.0001 | all$SLpadj>0.0001 )

All_retain$Retention <- "All"

df <- rbind (SL_retain, PAR_retain, SM_retain)
df$hgnc_symbol

?RColorBrewer
####heatmap for retained

#Heatmap

#df <- subset (df, df$Retention=="SL" & df$SL>500)

names(df)
mat_data <- df [, 27:32]
row.names(mat_data) <- df$hgnc_symbol
mat_data <- as.matrix(mat_data)

my_palette <- rev(brewer.pal (10,"RdBu"))
                          
png("figure1.png", width = 10, height = 8, units = 'in', res = 200)
heatmap.2 (log(mat_data[,cn], 10), density.info="none", col=my_palette, trace="none",scale="none",
           sepwidth=c(0.001,0.001), sepcolor="black", colsep=1:ncol(mat_data), rowsep=1:nrow(mat_data),       
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = T, Colv=F,  keysize = 1, cexRow=1, key=T, cexCol=1, 
           main="") + scale_colour_manual(values = rev(brewer.pal(3,"BuPu")))

dev.off()

input <- read.csv("contami.check.matrix.csv",row.names = 1, header = T)
library(reshape2)
melted_cormat <- melt(input )
head(melted_cormat)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()
pheatmap(input, scale = "row",cluster_rows = FALSE,
         cluster_cols = FALSE)


heatmap.2 (input, density.info="none",  trace="none",scale="none",
           sepwidth=c(0.001,0.001), sepcolor="black", colsep=1:ncol(mat_data), rowsep=1:nrow(mat_data),       
           ## if you don't want to seperate the cells with line, just delete the above line
           Rowv = T, Colv=F,  keysize = 1, cexRow=1, cexCol=1, 
           main="") + scale_colour_manual(values = rev(brewer.pal(3,"BuPu")))



