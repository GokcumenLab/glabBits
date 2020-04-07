#! /bin/sh

for num in $(seq 1 100)
do
	   cp "$1" "${num}_002.slurm"
 	   sed -i -e "s/1_002/${num}_002/g" -e "s/output_1/output_${num}/g" "${num}_002.slurm"
           sbatch "${num}_002.slurm"
done
