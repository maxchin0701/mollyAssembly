#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=1
#SBATCH -o collectPhasedScaffAssemblyMetrics

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#generate hap list
hapList=("Hap1" "Hap2")

#enter data directory
cd ../data

for hap in ${hapList[@]}; do 

	#enter scaffold assembly directory
	cd scaffAssembly$hap 

	#run quast
	python ../../../software/quast/quast.py scaffolds_FINAL.fasta -o ../scaffAssemblyMetrics/$hap

	#move back to data dir
	cd ..

done
