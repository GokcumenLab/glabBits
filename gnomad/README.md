### GnomAD Download

GnomAD merger is used for retrieving data from gnomAD database. The script searches all the listed genes and returns a merged CSV file that contains interested columns in it. This script uses https://gnomad.broadinstitute.org/api backend API

A biref description is avaialble at `gnomAD.pdf`.


### Installation

Clone the repository to your local.

Install the libraries via,

`pip3 install -r requirements.txt`

### Usage

Iterested genes are listed in the `interested_genes.csv` as comma separated values. An example of, `interested_genes.csv` is shown below.

```
OR52M1, OR51B5, OR52N4, OR11H1, OR4K15, OR6S1, OR5AP2, OR5H1, OR13C2, OR2K2, OR8G5, OR1L3, OR2T27
```

Please make sure that, the interested genes are available through the web call at https://gnomad.broadinstitute.org/.

After you have listed interested genes, run the script as follows;

`python3 gnomad_merger.py`

While script is running, downloaded CSV gene data is saved in `./data` folder. You can browse them individually if you are interested in seperate genes.

When the script finished running, the final merged CSV output is saved in `./output/genes_merged.csv` file. Please make sure to copy and save this file before running the script agaian with different gene input list.
