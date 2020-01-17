## Read-depth Script

The Read-depth Script downloads the specified BAM file from the repository such as http://cdna.eva.mpg.de/neandertal/altai/AltaiNeandertal/bam/ and converts it to a BED file if it hasn't done before. Then it intersects the given manual input file with the converted BED file to find overlaps.

## Required Libs

```
python/py37-anaconda-2019.03
bedtools/2.23.0
```
