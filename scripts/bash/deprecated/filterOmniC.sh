#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 3:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o filterOmniC

#load modules
module load samtools
module load anaconda3/2022.10
conda activate genomics

#filter first group of reads
samtools view -@ 10 -h ../data/alignedOmniC/poeFor-2_S10_L002_R1_001.bam | \
	perl arimaOmniCPipeline/filter_five_end.pl | \
	samtools view -@ 10 -Sb - > ../data/filteredOmniC/poeFor-2_S10_L002_R1_001.bam

#filter second group of reads
samtools view -@ 10 -h ../data/alignedOmniC/poeFor-2_S10_L002_R2_001.bam | \
	perl arimaOmniCPipeline/filter_five_end.pl | \
	samtools view -@ 10 -Sb - > ../data/filteredOmniC/poeFor-2_S10_L002_R2_001.bam