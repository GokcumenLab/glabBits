## Read-depth Script

Given a BAM file (reads mapped to a reference), this script calculates the read depth in windows of the genome that were identified as being polymorphically deleted in modern humans in the 1000 genomes data.


The script uses the following inputs;
1) A BED file containing the start and end position of each polymorphic deletion window from the 1000 Genomes data present in a certain chromosome.
2) A BAM file for the same chromosome.

The read-depth script generates a BED file, which contains start and end positions of each read, with regards to the given BAM file if it hasn't already generated. Then, it counts the number of reads (using BED file) that's overlap with each deletion window. And it produces, a CSV file containing start and end positions of each deletion window with an additional column that contains the number of reads (corresponding to the input BAM file) that overlapped the deletion window.


## Required Libs

```
python/py37-anaconda-2019.03
bedtools/2.23.0
```
