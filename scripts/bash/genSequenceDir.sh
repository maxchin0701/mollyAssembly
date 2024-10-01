#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o genSeqDir

module load GATK

#primary assembly
gatk CreateSequenceDictionary \
		R=../data/contigAssembly/Sch01Primary.fna \
		O=../data/contigAssembly/Sch01Primary.dict

#hap1
gatk CreateSequenceDictionary \
		R=../data/contigAssembly/Sch01Hap1.fna \
		O=../data/contigAssembly/Sch01Hap1.dict

#hap2
gatk CreateSequenceDictionary \
		R=../data/contigAssembly/Sch01Hap2.fna \
		O=../data/contigAssembly/Sch01Hap2.dict