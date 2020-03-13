PROJECT 0 - CANAVAR

1. Validating the chromosome 21 calls
2. Running iti for the other chromosomes.

##################

PROJECT 1 - LINKAGE DISEQUILIBRIUM
1. Search for SNPs in LD with all SVs of interest (not just duplications)
2. Search only 50kb downstream and upstream of the SV, not the whole genome (as is currently done in Marie's code
3. Please make a new GitHub entry for more generic LD calculation by copying and editing the existing code - https://github.com/GokcumenLab/glabBits/blob/master/ld-calculation/codes_dup_LD.sh

The paper https://academic.oup.com/gbe/article/11/6/1679/5498151

##################

PROJECT 2 - PHEWAS
1. It would be great if we can do something similar to the GNOMAD with https://atlas.ctglab.nl/PheWAS 
2. The ideal situation would be that we give a bunch of SNP names (e.g., rs182549) and get the output table as CSV for the top hits (i.e.,, p-value < 10-5)
3. If you feel ambitious, we can also make an option to create a similar table but this time for the input with genes (e.g., MUC7)

##################

PROJECT 3 - DATING THE GENOMIC VARIANTS
1. To run this script - https://github.com/pkalbers/geva for a given number of SNPs (rs182549)
2. The output for this script is done for many SNPs - https://human.genome.dating/snp/rs182549
3. And the paper on it is here - https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3000586
