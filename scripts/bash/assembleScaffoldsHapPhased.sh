#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 16:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o assembleScaffoldsHapPhased

#activate conda env
module load samtools
module load bedtools
module load anaconda3/2022.10
conda activate salsa

#export path to salsa
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/SALSA

#generate hap list
hapList=("Hap1" "Hap2")

for hap in ${hapList[@]}; do 

	bedtools bamtobed -i ../data/finalOmniC/dovetail/poeFor1$hap\OmniCRG.bam > ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bed
	sort -k 4 ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bed > ../data/finalOmniC/dovetail/tmp$hap && \
	mv ../data/finalOmniC/dovetail/tmp$hap ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bed

	#run SALSA2 pipeline
	python ../../software/SALSA/run_pipeline.py \
		-a ../data/contigAssembly/Sch01$hap\.fna \
		-l  ../data/contigAssembly/Sch01$hap\.fna.fai \
		-b ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bed \
		-e DNASE \
		-c 50000 \
		-o ../data/scaffAssembly$hap \
		-m yes

	rm -r ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bed
done



