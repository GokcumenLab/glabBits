#######INSTALLING Gviz package

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install()

#BiocManager::install("Gviz")

#nBiocManager::install("OmicCircos")


#############

library(GenomicRanges)
library (OmicCircos)

## input hg19 cytogenetic band data
data ( UCSC.hg19.chr )
head ( UCSC.hg19.chr)


####### Data Prep

#setwd("~/Box/GokcumenLab/Projects/SalivaryRNAseq/omer_saliva_CR_working")

genes <- read.csv("genes.csv")
genes <- genes[!duplicated(genes$name2),]
all <- read.csv("TableS2_updated.csv")
all <- merge(all, genes, by.x="gene", by.y="name2")
head(all)
###GTEX database cleaned for alternative chromosomes
gtex <- read.csv("GTEX_chrCleaned.csv")
quantile (gtex$Total, 0.1)
gtex <- subset (gtex, gtex$Total<10)
head(gtex)
all <- subset (all, all$gene %in% gtex$Name)
all <- subset (all, all$PAR>100 | all$SM>100 | all$SL>100 | all$sl>100 | all$sm>100 | all$par>100)
#all <- subset (all, all$PAR>100 | all$SM>100 | all$SL>100)
head(all)

write.csv(all, "saliva_specific_conservative2.csv")
####gene names

names(all)
genes <- read.csv("genes.csv")
genes <- genes[!duplicated(genes$name2),]
all <- merge(all, genes, by.x="gene", by.y="name2")


####input files for circos plot
names (all)
df <- all [, c(3, 4, 2, 27:32)]
head(df)
names (df) <- c("chr", "po", "NAME", "SM", "PAR", "SL", "sm", "par", "sl")
df <- subset (df, df$chr!="chrY")

df$SM <- log(1+df$SM, 10)
df$sm <- log(1+df$sm, 10)
df$SL <- log(1+df$SL, 10)
df$sl <- log(1+df$sl, 10)
df$PAR <- log(1+df$PAR, 10)
df$par <- log(1+df$par, 10)

df_pos <- df[,1:3]
#df_pos

#df_adult <- df [, c(1:6)]
#head(df_adult)
#df_fetal <- df [, c(1:3, 7:9)]

#df_adult$SMratio <- df$SM/df$sm
#df_adult$PARratio <- df$PAR/df$par
#df_adult$SLratio <- df$SL/df$sl
#head(df_adult)
#df_adult <- df_adult [1:3, 7:9]

#head(df)

####draw the circos plot
#png ("circos.png",  width = 20, height = 16, units = 'in', res = 200)
library (RColorBrewer)
my_palette <- rev(brewer.pal (8,"RdBu"))
head(df)
par(mar=c(0, 0, 0, 0));
plot(c(1,800), c(1,800), type="n", axes=FALSE, xlab="", ylab="", main="");
circos(R=400, cir="Hg19", type="chr", print.chr.lab=TRUE, W=10, scale=FALSE,  cex=10);
circos(R=300, cir="Hg19", cex=2, W=100, col.v = 4, mapping=df, type="heatmap2",  
       B=TRUE, lwd=1, scale=FALSE, col.bar=TRUE, cutoff=20, cluster=TRUE, col="red");
circos(R=200, cir="Hg19", cex=0.5, W=100, mapping=df_pos, col=my_palette, type="h",B=FALSE, lwd=2, scale=TRUE, col.bar=TRUE);


df
?circos
dev.off()

df

