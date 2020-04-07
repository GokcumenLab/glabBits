# GLab Bits

In this repository we listed small script programmes (bits) that we have been using in our lab mostly to data mine or manipulate large -omics datasets.


### [Gnomad Merger](./gnomad)

GnomAD merger is used for retrieving data from GnomAD (genome aggregation database). The script searches all the listed genes of interest and returns a merged CSV file that contains specific columns in it. This script uses https://gnomad.broadinstitute.org/api backend API.


### [Saliva RNA Seq](./Saliva-RNASeq)

This is the R codes which were used to generate figures in our manuscript,
"Integrative analysis of transcriptome and proteome sheds light on functional differences between human salivary glands".


### [Read-depth Script](./read-depth)

Given a BAM file (reads mapped to a reference), this script calculates the read depth in windows of the genome that were identified as being polymorphically deleted in modern humans in the 1000 genomes data.


###  [LD Calculation](./ld-calculation)

We modified VCFtools (0.1.16) (Danecek et al. 2011) to calculate the R2 between a target duplication and other variants in a genome-wide manner. We first made a custom genome-wide VCF file from 1000 Genomes phase 3 dataset for CEU, YRI and CHB population. We conducted population-specific analyses to increase the sensitivity of linkage disequilibrium. To reduce file size, we omitted variants which were not observed in the population of interest. Then we calculated the R2 between a target duplication and other variants in a genome-wide manner with VCFtools (0.1.16). We visualized linkage disequilibrium by using R qqman package (fig. 1B).


###  [Genome Structure Correction (GSC) tool](./GSC)

The working directory of performing simulations using the Genome Structure Correction (GSC) tool.
