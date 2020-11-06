
### Vidualize transcriptomic differenciation between tissues (PCA, clusterinng analysis annd Heatmap)
# We basically followed "Analyzing RNA-seq data with DESeq2"
# by Michael I. Love, Simon Anders, and Wolfgang Huber
# 01/07/2020
# http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html


library(ggplot2)
library(ggrepel)

## Volcano plot (Figure)
df1  <- read.csv(file.choose(), header = T, sep = ",")
sp<-ggplot(df1, aes(x=Submandibular_FC, y=-log10(Submandibular_padj), color=Submandibular_color)) + geom_point()+ scale_color_manual(values=c("azure4","brown3")) + xlim(-50, 50) + ylim(0, 300)
sp+ geom_hline(yintercept = 4, linetype="dashed",  color = "black", size=0.7)

sp1<-ggplot(df1, aes(x=Adult_Sublingual_Parotid_FC, y=log10Adult_Sublingual_Parotid_padj, color=log10Adult_Sublingual_Parotid_color)) + geom_point()+ scale_color_manual(values=c("azure4","brown3")) + xlim(-10, 10) + ylim(0, 150) 
sp2<-sp1+ geom_hline(yintercept = 4, linetype="dashed",  color = "black", size=0.7)+ geom_vline(xintercept = 0, linetype="dashed",  color = "black", size=0.7)
sp3<-sp2+ geom_text_repel(aes(df1$Adult_Sublingual_Parotid_FC, df1$log10Adult_Sublingual_Parotid_padj,label=df1$Adult_Sublingual_Parotid_hgnc_symbol))


## Scatter plot with labels (Figure 4, S2)
input <- read.csv("saliva_RNAseqvsWiki2.csv", header = TRUE)
c2 <- subset (input, Adult_Sublingual>4507.628  & Wiki_sm.sl2>44.49) 

ggplot(input, aes(x =log(Adult_Sublingual+1, 10), y = log(Wiki_sm.sl2+1, 10)))+
  geom_point(aes(color=factor(Abundant_in_saliva), alpha=0.9)) + 
  scale_color_manual(values=c("#999999","#0019EA"))+
  xlab("RNAseq SL") + ylab("Proteome Wiki SM+SL")+
  theme_bw(base_size = 12) + theme(legend.position = "bottom")+ geom_vline(xintercept=log(4507.628+1,10), linetype="dashed")+
  geom_hline(yintercept=log(44.49+1,10), linetype="dashed")+
  geom_label_repel(data=c2,aes(label = hgnc_symbol), color = 'black',
                   size = 3,
                   box.padding = unit(0.35, "lines"),
                   point.padding = unit(0.3, "lines")) + 
  scale_fill_manual(values=c("#ffffc6"))

## Correlation heatmap (Figure S1)

ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0.85, limit = c(0.7,1), space = "Lab", 
                       name="Peason\nCorrelation") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text( vjust = 1, 
                                    size = 12, hjust = 1))+
  coord_fixed()
# Print the heatmap
print(ggheatmap)


## Box plot with dots (Figure S3)

e <- ggplot(input, aes(x=Gland, y=Secreted.All, fill=Development))

e+  geom_boxplot( aes(color = Development), width = 0.5, size = 0.4,
                  position = position_dodge(0.8) ) +
  geom_dotplot(
    aes(fill = Development), trim = FALSE,
    binaxis='y', stackdir='center', dotsize = 0.8,
    position = position_dodge(0.8)
  )+
  scale_fill_manual(values = c("#ffee7d", "#60588c"))+
  scale_color_manual(values = c("#ffee7d", "#60588c"))+ 
  coord_cartesian(ylim = c(0.1, 0.4))+ theme_classic()
