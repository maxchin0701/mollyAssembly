#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o pairOmniC

#load modules
module load samtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#pair bam files
perl arimaOmniCPipeline/two_read_bam_combiner.pl ../data/filteredOmniC/poeFor-2_S10_L002_R1_001.bam ../data/filteredOmniC/poeFor-2_S10_L002_R2_001.bam samtools 10 | \
	samtools view -bS -t ../data/contigAssembly/Sch01Primary.fna.fai - | \
	samtools sort -@ 32 -o ../data/pairedOmniC/poeFor2.bam -

#add read groups
gatk AddOrReplaceReadGroups \
	INPUT=../data/pairedOmniC/poeFor2.bam \
	OUTPUT=../data/pairedOmniC/poeFor2RG.bam \
	ID=poeFor2 LB=poeFor2 \
	SM=poeFor2 \
	PL=ILLUMINA PU=none
