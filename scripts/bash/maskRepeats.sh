#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 2:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o maskRepeats

#load conda env
module load anaconda3/2022.10
conda activate repeatMasker

#get into wd
cd ../../software/RepeatMasker

#run repeat masker for pFor
./RepeatMasker -dir ../../hifiAssembly/data/maskAssembly/PForMask \
	-lib  ../../circosSyntenyAnalysis/data/repeatDatabases/PForFTEDBLib.fasta \
	-pa 32 -e rmblast --xsmall ../../hifiAssembly/outputs/PForSch01.fasta 
