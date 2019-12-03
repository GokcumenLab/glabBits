# GLab Bits

In this repository we listed small script programmes (bits) that we have been using in our lab mostly to data mine or manipulate large -omics datasets.


### LD Calculation

We modified VCFtools (0.1.16) (Danecek et al. 2011) to calculate the R2 between a target duplication and other variants in a genome-wide manner. We first made a custom genome-wide VCF file from 1000 Genomes phase 3 dataset for CEU, YRI and CHB population. We conducted population-specific analyses to increase the sensitivity of linkage disequilibrium. To reduce file size, we omitted variants which were not observed in the population of interest. Then we calculated the R2 between a target duplication and other variants in a genome-wide manner with VCFtools (0.1.16). We visualized linkage disequilibrium by using R qqman package (fig. 1B).


### Gnomad Merger

Gnomad Merger script, retrieves data from gnomAD database for interested genes and merges them into a single file. 

[Gnomad Merger](./gnomad)

