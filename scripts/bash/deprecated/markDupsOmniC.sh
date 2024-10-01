#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o markDupsOmniC

#load modules
module load samtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#mark duplicates
gatk MarkDuplicates INPUT=../data/pairedOmniC/poeFor2RG.bam \
	OUTPUT=../data/finalOmniC/poeFor2.bam \
	METRICS_FILE=../data/finalOmniC/metrics.poeFor2.txt \
	TMP_DIR=../data/finalOmniC/deprecated \
	ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE

samtools index ../data/finalOmniC/poeFor2.bam

perl arimaOmniCPipeline/get_stats.pl ../data/finalOmniC/poeFor2.bam > ../data/finalOmniC/poeFor2.bam.stats

