#!/bin/bash
#SBATCH -N 1
#SBATCH -p EM
#SBATCH -t 10:00:00
#SBATCH --ntasks-per-node=96
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mzchin@ucdavis.edu
#SBATCH -o assembleHiFi

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#export path to hifiasm
export PATH=$PATH:/ocean/projects/bio230047p/mchin/hifiAssembly/hifiasm

#create general output directory
if [ -d ../data/contigAssembly ]; then
	rm -r ../data/contigAssembly
fi

mkdir ../data/contigAssembly

#get into right directory
cd ../data/trimmedSeq/Sch01

#run HiFiasm
hifiasm -o ../../contigAssembly/Sch01.asm -t 96 Sch01Filt.fastq.gz \
	--h1 ../../rawSeq/Sch01/omniC/poeFor-2_S10_L002_R1_001.fastq.gz \
	--h2 ../../rawSeq/Sch01/omniC/poeFor-2_S10_L002_R2_001.fastq.gz
	
	

