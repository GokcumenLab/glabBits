'''
Izzy Starr
istarr@buffalo.edu
12/9/2019
Code for RNAseq 

Workflow:
-MultiQC on RNAseq data
-RNAseq paired in TrimGalore
-Kallisto on paired reads & Downloaded as entired folder system
-Creation of tx2gene file (using ensembldb)
-Deseq2 to find normalized counts across samples

'''


# INSTALL PACKAGES --------------------------------------------------------
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("DESeq2")
# BiocManager::install("IHW")
# BiocManager::install("vsn")
# BiocManager::install("hexbin")
# BiocManager::install("rhdf5")
# install.packages("devtools", "ggplot2", "pheatmap", "magrittr")
# githubinstall::gh_install_packages("stephens999/ashr")
# BiocManager::install("apeglm")
# install.packages("tidyverse")
# BiocManager::install("tximport")
# BiocManager::install("tximportData")
# install.packages("RColorBrewer")

# PACKAGES ----------------------------------------------------------------
library(DESeq2)
library(IHW)
library(devtools)
library(ashr)
library(tidyverse)
library(ggplot2)
library(vsn)
library(pheatmap)
library(rhdf5)
library(apeglm)
library(tximport)
library(tximportData)
library(RColorBrewer)

# EXAMPLE CODE --------------------------------------------------------------------
set.seed(420)
options(scipen = 999)
#directory <- "/Volumes/Backup/Izzy/skin_RNAseq/R_primates/"

#directory <- "/where/to/save/files/"
setwd(directory)
samples_prim <- read.table(file.path(directory, "sample_anno_primates.txt"), header = TRUE)

samples <- samples_prim %>%
  filter(individual != "gorilla1")

#directory for kallisto output
hdir <- "/Volumes/Backup/Izzy/skin_RNAseq/kallisto.out_human"

h_files <- file.path(hdir, samples$sample, "abundance.h5")
names(h_files) <- samples$sample

homo_tx2gene <- read.table(file.path(directory, "homo_tx2gene.csv"), 
                           header = TRUE, sep = ",")

#kallisto-specific import
txi.kallisto_h <- tximport(h_files, type = "kallisto", tx2gene = homo_tx2gene)
head(txi.kallisto_h$counts)
raw_txi_h <- as.data.frame(txi.kallisto_h$counts)
# write.table(raw_txi_h, file="h_raw_txi.txt", sep="\t", quote=F, col.names=NA)

#by all samples (then set up for each project)
colData_h <- data.frame(samples) %>% 
  mutate(ref = "human") %>%
  column_to_rownames("sample")
#pasted in other document and changed to save all colData
# write.table(colData_h, file="h_colData.txt", sep="\t", quote=F, col.names=NA, row.names = T)

dds_h <- DESeqDataSetFromTximport(txi.kallisto_h,
                                  colData = colData_h,
                                  design = ~ mammal)
#View(counts(dds_h))

#GENERATE NORMALIZED COUNTS
nm_h <- assays(dds_h)[["avgTxLength"]]
#estimate size factors
sf_h <- estimateSizeFactorsForMatrix(counts(dds_h)/nm_h)
sf_h
dds_h <- estimateSizeFactors(dds_h)
normalized_counts_h <- counts(dds_h, normalized=TRUE)
# write.table(normalized_counts_h, file="h_normalized_counts.txt", sep="\t", quote=F, col.names=NA, row.names = T)

#QUALITY CONTROL
### Transform counts for data visualization
rld_h <- rlog(dds_h, blind=TRUE)
#blind=TRUE; transformation unbiased to sample condition information
rld_mat_h <- assay(rld_h) 
## assay() is function from the "SummarizedExperiment" package 

### Plot PCA
human_pca <- plotPCA(rld_h, intgroup="mammal") +
  ggtitle("Human-Mapped")
#ntop, default=top 500 most variable genes
# ggsave("gor1_human_pca.png", plot = human_pca, dpi = "retina")
human_pca

pca_h <- prcomp(t(rld_mat_h))
# Create data frame with metadata and PC2 and PC3/PC3 and PC4 values for input to ggplot
df_h <- cbind(colData_h, pca_h$x)
ggplot(df_h) + geom_point(aes(x=PC2, y=PC3, color = mammal))
ggplot(df_h) + geom_point(aes(x=PC3, y=PC4, color = mammal))


### Hierarchical Clustering
### Compute pairwise correlation values
rld_cor_h <- cor(rld_mat_h)    ## cor() is a base R function
head(rld_cor_h)   ## check the output of cor(), make note of the rownames and colnames
### Plot heatmap
human_pairwise <- pheatmap(rld_cor_h, main = "Human-Mapped", 
                           treeheight_col = 20, treeheight_row = 20)
# ggsave("gor1_human_pairwise.png", plot = human_pairwise, dpi = "retina")
heat.colors <- brewer.pal(6, "Blues")
pheatmap(rld_cor_h, color = heat.colors, border_color=NA, fontsize = 10, 
         fontsize_row = 10, height=20)



# INSERT YOUR VARIABLES HERE -------------------------------------------------------
set.seed(3)
options(scipen = 999)

#directory <- "/where/to/save/files/"
setwd(directory)

samples <- read.table(file.path(directory, "samples.txt"), header = TRUE)

#directory for kallisto output
dir <- "/where/I/put/data/RNAseq/kallisto.out"

files <- file.path(dir, samples$sample, "abundance.h5")
names(files) <- samples$sample

tx2gene <- read.table(file.path(directory, "tx2gene.csv"), 
                           header = TRUE, sep = ",")

#kallisto-specific import
txi.kallisto <- tximport(files, type = "kallisto", tx2gene = tx2gene)
head(txi.kallisto$counts)
raw_txi <- as.data.frame(txi.kallisto$counts)
#make a file of raw txi counts if you want
# write.table(raw_txi, file="raw_txi.txt", sep="\t", quote=F, col.names=NA)

#by all samples (set up for each project if you have multiple projects)
colData <- data.frame(samples) %>% 
  mutate(ref = "your_reference") %>%
  column_to_rownames("sample")
# write.table(colData, file="colData.txt", sep="\t", quote=F, col.names=NA, row.names = T)

#SET UP DDS for deseq2
dds <- DESeqDataSetFromTximport(txi.kallisto,
                                  colData = colData,
                                  design = ~ MYVARIABLE)
#View(counts(dds_))

#GENERATE NORMALIZED COUNTS
nm <- assays(dds)[["avgTxLength"]]
#estimate size factors
sf <- estimateSizeFactorsForMatrix(counts(dds)/nm)
sf
dds <- estimateSizeFactors(dds)
normalized_counts <- counts(dds, normalized=TRUE)
#save normalized counts file
# write.table(normalized_counts, file="normalized_counts.txt", sep="\t", quote=F, col.names=NA, row.names = T)

#QUALITY CONTROL
### Transform counts for data visualization
rld <- rlog(dds, blind=TRUE)
#blind=TRUE; transformation unbiased to sample condition information
rld_mat <- assay(rld) 
## assay() is function from the "SummarizedExperiment" package 

### Plot PCA
pca <- plotPCA(rld, intgroup="MY VARIABLE") +
  ggtitle("Reads Mapped By Variable")
#save pca image
# ggsave("pca.png", plot = pca, dpi = "retina")
pca

#visualize comparisons of other pcs
pca <- prcomp(t(rld_mat))
# Create data frame with metadata and PC2 and PC3/PC3 and PC4 values for input to ggplot
df <- cbind(colData, pca$x)
ggplot(df) + geom_point(aes(x=PC2, y=PC3, color = myvariable))
ggplot(df) + geom_point(aes(x=PC3, y=PC4, color = myvariable))


### Hierarchical Clustering
### Compute pairwise correlation values
rld_cor <- cor(rld_mat)    ## cor() is a base R function
head(rld_cor)   ## check the output of cor(), make note of the rownames and colnames
### Plot heatmap
pairwise <- pheatmap(rld_cor, main = "Mapped by MYVARIABLE", 
                           treeheight_col = 20, treeheight_row = 20)
#save pairwise mapping if you want
# ggsave("pairwise.png", plot = pairwise, dpi = "retina")
heat.colors <- brewer.pal(6, "Blues") #change colors
pheatmap(rld_cor, color = heat.colors, border_color=NA, fontsize = 10, 
         fontsize_row = 10, height=20)

