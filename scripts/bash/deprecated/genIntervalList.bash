#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 2:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o genIntervalList

module load GATK

bedFile=$1;

gatk BedToIntervalList I=../data/contigAssembly/$bedFile\.bed \
	O=../data/contigAssembly/$bedFile\.interval_list \
	SD=../data/contigAssembly/Sch01Primary.dict


