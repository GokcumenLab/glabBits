#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --job-name="introgressed"
#SBATCH --output=introgressed.out
#SBATCH --mail-user=yenlungl@buffalo.edu
#SBATCH --mail-type=END

echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

echo "working directory = "$SLURM_SUBMIT_DIR
#
module load python



# Running a python file

#python block_bootstrap/block_bootstrap.py -1 exon.bed -2 ancientDel.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > ancient_cc_002_1000_output
#python block_bootstrap/block_bootstrap.py -1 exon.bed -2 ancient-shuffled.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > ancient-shuffled_cc_002_1000_output
python block_bootstrap/block_bootstrap.py -1 exon.bed -2 introgressed.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > introgressed_cc_002_1000_output
#python block_bootstrap/block_bootstrap.py -1 exon.bed -2 introgressed-shuffled.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > introgressed-shuffled_cc_002_1000_output
#python block_bootstrap/block_bootstrap.py -1 exon.bed -2 human-specificDel.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > human_cc_002_1000_output
#python block_bootstrap/block_bootstrap.py -1 exon.bed -2 human-shuffled.bed -d domain.bed -r 0.02 -n 1000 -v -t cc > human-shuffled_cc_002_1000_output



echo "All done!"
#

