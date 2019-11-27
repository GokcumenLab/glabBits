### GnomAD Download

`download_gnomad_data.py` is used for retrieving data from gnomAD database

Iterested genes are listed in the `interested_genes.txt` as comma separated values.

The script searches all the listed genes and returns a merged CSV file that contains interested columns in it.


### Usage

Downloaded CSV gene data is saved in `./data` folder. The final merged CSV output is saved in `./output.csv` file. Please make sure to copy and save this file before re-running the script with different gene input list.
