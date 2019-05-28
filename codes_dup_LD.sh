##Codes for LD calculation##


We modified VCFtools (0.1.16) (Danecek et al. 2011) to calculate the R2 between a target duplication and other variants in a genome-wide manner. We first made a custom genome-wide VCF file from 1000 Genomes phase 3 dataset for CEU, YRI and CHB population. We conducted population-specific analyses to increase the sensitivity of linkage disequilibrium. To reduce file size, we omitted variants which were not observed in the population of interest. Then we calculated the R2 between a target duplication and other variants in a genome-wide manner with VCFtools (0.1.16). We visualized linkage disequilibrium by using R qqman package (fig. 1B).



## 1. Make a custom genome-wide VCF file from 1000 Genomes phase 3 dataset for CEU, YRI and CHB population.
## !The output file can be more than 10GB!

## 1-1. Subset populations

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
do
 wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
 gzip -d ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
 vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf --keep CHB.txt --phased --recode --out t_CHB
 vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf --keep CEU.txt --phased --recode --out t_CEU
 vcftools --gzvcf ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf --keep YRI.txt --phased --recode --out t_YRI
 rename t chr$i *.recode.vcf
 rm ALL.chr$i.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf
done

## 1-2.

cat chr1_YRI.recode.vcf chr2_YRI.recode.vcf chr3_YRI.recode.vcf chr4_YRI.recode.vcf chr5_YRI.recode.vcf chr6_YRI.recode.vcf chr7_YRI.recode.vcf chr8_YRI.recode.vcf chr9_YRI.recode.vcf chr10_YRI.recode.vcf chr11_YRI.recode.vcf chr12_YRI.recode.vcf chr13_YRI.recode.vcf chr14_YRI.recode.vcf chr15_YRI.recode.vcf chr16_YRI.recode.vcf chr17_YRI.recode.vcf chr18_YRI.recode.vcf chr19_YRI.recode.vcf chr20_YRI.recode.vcf chr21_YRI.recode.vcf chr22_YRI.recode.vcf > chrALL_YRI.1recode.vcf
grep -e "1|1" -e "0|1" -e "1|0" chrALL_YRI.1recode.vcf >chrALL_YRI.clean0.vcf
cat YRI.header.vcf chrALL_YRI.clean0.vcf> chrALL_YRI.clean1.vcf



cat chrALL_CEU.clean0.vcf | grep -v "," > chrALL_CEU.clean.bi.vcf
cat chrALL_CHB.clean0.vcf | grep -v "," > chrALL_CHB.clean.bi.vcf
cat chrALL_YRI.clean0.vcf | grep -v "," > chrALL_YRI.clean.bi.vcf


awk 'BEGIN {FS="\t";OFS="\t"}{$1="1"}1' chrALL_CEU.clean.bi.vcf> chrALL_CEU.replaced.vcf
awk 'BEGIN { FS = "\t" } ; { print $1 }'  chrALL_CEU.clean.bi.vcf>CEU.bi.chromeNumber.vcf
cat CEU.header.vcf chrALL_CEU.replaced.vcf> chrALL_CEU.replacedwithhead.vcf

awk 'BEGIN {FS="\t";OFS="\t"}{$1="1"}1' chrALL_YRI.clean.bi.vcf> chrALL_YRI.replaced.vcf
awk 'BEGIN { FS = "\t" } ; { print $1 }'  chrALL_YRI.clean.bi.vcf>YRI.bi.chromeNumber.vcf
cat YRI.header.vcf chrALL_YRI.replaced.vcf> chrALL_YRI.replacedwithhead.vcf

awk 'BEGIN {FS="\t";OFS="\t"}{$1="1"}1' chrALL_CHB.clean.bi.vcf> chrALL_CHB.replaced.vcf
awk 'BEGIN { FS = "\t" } ; { print $1 }'  chrALL_CHB.clean.bi.vcf>CHB.bi.chromeNumber.vcf
cat CHB.header.vcf chrALL_CHB.replaced.vcf> chrALL_CHB.replacedwithhead.vcf




## 2. Calculate LD.
# vcftools  hap-r2 cannot be used for different chromosomes
# Here, we need to replace all chromosomes to chromosome one, keeping chromosome information in another file
# Then, combine the true chromosome file and output of hap-r2
awk 'BEGIN {FS="\t";OFS="\t"}{$1="1"}1' file.vcf> file.replaced.vcf
awk 'BEGIN { FS = "\t" } ; { print $1 }'  file.vcf>file.chrnumber.vcf



## make position file ##############
# We need position files for vcftools hap-r2 function
# Here is an example code to make these files

tr \\r \\n <dups_3pop.csv >dups_3pop.unix.csv
csvfile=dups_3pop.unix.csv
for line in `cat ${csvfile} | grep -v ^#`
do
  first=`echo ${line} | cut -d ',' -f 1`
  second=`echo ${line} | cut -d ',' -f 2`
  echo -e "chr\\tpos" >  "chr${first}_${second}_pos".txt
  echo -e "${first}\\t${second}" >>  "chr${first}_${second}_pos".txt
done


## Let's calculate the LD! ##############
vcftools --vcf chrALL_CEU.replacedwithhead.vcf --hap-r2-positions chr14_101461351_pos.txt --out chr14_101461351_CEU


# In the output file, you lose one row of the target SV site compared to the input file
# We need to remove one row of the original chromosome location (number) from the chromosome location file
#!!! When multiple variants are reported to the same site (Note that we now converted all the chromosomes to chromosome one), we need to change the target site location into something else in both position file and input vcd file, because vcftools gets confused otherwise.


## restore the chromosome information
paste CEU.clean0.chromeNumber.vcf chr14_101461351.list.hap.ld > CEU_r_chr14_101461351.list.hap.ld

## subset the site with LD > 0.05
awk '$7 > 0.05' chr_r_chr14_101461351_CEU.list.hap.ld
