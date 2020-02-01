#!/bin/sh
#SBATCH --partition=skylake
#SBATCH --qos=skylake
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --mem=187000
#SBATCH --job-name="R_make_bedfiles"
#SBATCH --output=script.out
#SBATCH --mail-user=maqil@buffalo.edu
#SBATCH --mail-type=ALL
##SBATCH --requeue
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.

echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURMTMPDIR="$SLURMTMPDIR

echo "working directory = "$SLURM_SUBMIT_DIR
#
module load R/3.5.3
module list
which R
#
R CMD BATCH make_bedfiles.r
#
echo "All Done!"
