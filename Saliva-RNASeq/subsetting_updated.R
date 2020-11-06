####### Data Prep

setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")
setwd("~/Dropbox/Sharing/Salivary glands/ForMarie&Omer/")

all <- read.csv("TableS2_updated.csv")
names(all)

###subsetting


All_up <- subset (all, all$SMpadj<0.0001 & all$PARpadj<0.0001 & all$SLpadj<0.0001)
All_up <- subset (All_up, All_up$SMlog2FoldChange>0 &
                    All_up$PARlog2FoldChange>0 & All_up$SLlog2FoldChange>0)

All_up$GlandularExpr <- "All Upregulated"

All_down <- subset (all, all$SMpadj<0.0001 & all$PARpadj<0.0001 & all$SLpadj<0.0001)
All_down <- subset (All_down, All_down$SMlog2FoldChange<0 &
                      All_down$PARlog2FoldChange<0 & All_down$SLlog2FoldChange<0)

All_down$GlandularExpr <- "All Downregulated"


SM_all <- subset (all, all$SMpadj<0.0001 & all$PARpadj>0.0001 & all$SLpadj>0.0001)
SM_up <- subset (SM_all, SM_all$SMlog2FoldChange>0)
SM_down <- subset (SM_all, SM_all$SMlog2FoldChange<0)

SM_up$GlandularExpr <- "SM Upregulated"
SM_down$GlandularExpr <- "SL&PAR Retained"



SL_all <- subset (all, all$SMpadj>0.0001 & all$PARpadj>0.0001 & all$SLpadj<0.0001)
SL_up <- subset (SL_all, SL_all$SLlog2FoldChange>0)
SL_down <- subset (SL_all, SL_all$SLlog2FoldChange<0)

SL_up$GlandularExpr <- "SL Upregulated"
SL_down$GlandularExpr <- "SM&PAR Retained"


PAR_all <- subset (all, all$SMpadj>0.0001 & all$PARpadj<0.0001 & all$SLpadj>0.0001)
PAR_up <- subset (PAR_all, PAR_all$PARlog2FoldChange>0)
PAR_down <- subset (PAR_all, PAR_all$PARlog2FoldChange<0)

PAR_up$GlandularExpr <- "PAR Upregulated"
PAR_down$GlandularExpr <- "SM&SL Retained"


SM_SL <- subset (all, all$SMpadj<0.0001 & all$PARpadj>0.0001 & all$SLpadj<0.0001)
SM_SL_down <- subset (SM_SL, SM_SL$SMlog2FoldChange<0 & SM_SL$SLlog2FoldChange<0)
SM_SL_up <- subset (SM_SL, SM_SL$SMlog2FoldChange>0 & SM_SL$SLlog2FoldChange>0)

SM_SL_up$GlandularExpr <- "SM&SL Up"
SM_SL_down$GlandularExpr <- "PAR Retained"


SM_PAR <- subset (all, all$SMpadj<0.0001 & all$PARpadj<0.0001 & all$SLpadj>0.0001)
SM_PAR_down <- subset (SM_PAR, SM_PAR$SMlog2FoldChange<0 & SM_PAR$PARlog2FoldChange<0)
SM_PAR_up <- subset (SM_PAR, SM_PAR$SMlog2FoldChange>0 & SM_PAR$PARlog2FoldChange>0)

SM_PAR_up$GlandularExpr <- "SM&PAR Up"
SM_PAR_down$GlandularExpr <- "SL Retained"


SL_PAR <- subset (all, all$SMpadj>0.0001 & all$PARpadj<0.0001 & all$SLpadj<0.0001)
SL_PAR_down <- subset (SL_PAR, SL_PAR$SLlog2FoldChange<0 & SL_PAR$PARlog2FoldChange<0)
SL_PAR_up <- subset (SL_PAR, SL_PAR$SLlog2FoldChange>0 & SL_PAR$PARlog2FoldChange>0)

SL_PAR_up$GlandularExpr <- "SL&PAR Up"
SL_PAR_down$GlandularExpr <- "SM Retained"


retained <- subset (all, all$SMpadj>0.0001 & all$PARpadj>0.0001 & all$SLpadj>0.0001)
retained <- subset (retained, retained$PAR>100 | retained$SM>100 | retained$SL>100)


retained$GlandularExpr <- "Globally Expressed"

TableS3 <-rbind (All_up, All_down, SM_up, SM_down,
                  SL_up, SL_down, PAR_up, PAR_down,
                 SM_SL_down, SM_PAR_up, SM_PAR_down,
                 retained, SL_PAR_up, SL_PAR_down, SM_SL_up)

write.csv(TableS3, "TableS3.csv")
                 

###### upload curated dataset for parallel set
#install.packages("ggforce")

library (ggforce)

df <- read.csv("input_parallelSets_2_updated.csv")
df
df <- subset (df, df$Status!="allmixed")


df <- gather_set_data(df, c(6, 5))
df

df$x <- factor(df$x, c("Status", "Multiple"))
unique (df$y)
df$y
df$x
png("Parallel_set.png", width = 10, height = 8, units = 'in', res = 200)

require("RColorBrewer")

my_palette <- brewer.pal(7,"RdYlBu")

ggplot(df, aes(x, id = id, split = y, value = X..Genes)) +
  geom_parallel_sets(aes(fill = Status), alpha = 0.3, axis.width = 0.1) +
  geom_parallel_sets_axes(axis.width = 0.1) +
  geom_parallel_sets_labels(colour = 'white') +  theme_void() + theme(legend.position="none")+
  scale_fill_manual(values=c("gray54", "firebrick3"))
  
  dev.off()
