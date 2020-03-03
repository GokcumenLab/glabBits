## Common Scripts

Common scripts and libraries are stored in this directory


### Download a file by using the cluster

If you want to download a big file using cluster computing resources you can use the download script.

All you need to do is fetch the this folder and use [slurm_download.conf](./slurm_download.conf) file to submit a download file job to the cluster.

Make sure to edit `slurm_download.conf` file and change the download.py's argument to the URI location of the file that you want to download.


```
python download_file.py <file_url_to_be_downloaded>
```

```
python download_file.py http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
```


Also make sure to the email address to the `##SBATCH --mail-user=cdc@buffalo.edu
` line so that, the script notifies you when the download started and completed. The downloaded file will be ready inside the same directory that you submit the task.



----------------------
The following content belongs to the file following file /omergokc/ogshared/README.md
Which is stored in the CCR cluster
----------------------

## Gokcumen Lab Shared Folder

This is a shared storage for lab's common files and software packages.

Directory has the following structure


### Hg
BAM, BED files; 1000 Human Genomes Project

### Ancient

Stores ancient species BAM, BED files


### Software

Common software binaries are stored here
