## Read-depth Script


THE SCRIPT USES THE FOLLOWING INPUTS:
1) A BED file containing the start and end position of each polymorphic deletion window from the 1000 Genomes data present in a certain chromosome.
2) A BAM file for the same chromosome.

THE SCRIPT PERFORMS THE FOLLOWING PROCEDURES:
1) It Checks if a BED file corresponding to the input BAM file is present in the directory.
2) If such a BED file is not present, the script uses the input BAM file to create a BED file which contains the start and end positions of each read. Let us call this reads-BED file
3) The script counts the number of reads (using the reads-BED file) thats overlaps with each deletion window.

THE SCRIPT PRODUCES THE FOLLOWING OUTPUTS:
1) A CSV file containing the start and end positions of each deletion window with an additional column that contains the number of reads (corresponding to the input BAM file) that overlapped the deletion window.


## Required Libs

```
python/py37-anaconda-2019.03
bedtools/2.23.0
```
