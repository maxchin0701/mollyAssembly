#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 8:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o assembleScaffolds

#activate conda env
module load samtools
module load bedtools
module load anaconda3/2022.10
conda activate salsa

#export path to salsa
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/SALSA

#change bam file to bed file
bedtools bamtobed -i ../data/finalOmniC/dovetail/poeFor1OmniCRG.bam > ../data/finalOmniC/dovetail/poeFor1OmniC.bed
sort -k 4 ../data/finalOmniC/dovetail/poeFor1OmniC.bed > ../data/finalOmniC/dovetail/tmp && \
mv ../data/finalOmniC/dovetail/tmp ../data/finalOmniC/dovetail/poeFor1OmniC.bed

#run SALSA2 pipeline
python ../SALSA/run_pipeline.py \
	-a ../data/contigAssembly/Sch01Primary.fna \
	-l  ../data/contigAssembly/Sch01Primary.fna.fai \
	-b ../data/finalOmniC/dovetail/poeFor1OmniC.bed \
	-e DNASE \
	-c 50000 \
	-o ../data/scaffAssembly \
	-m yes



