#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 24:00:00
#SBATCH --ntasks-per-node=48
#SBATCH -o eggnogPFor

#activate conda env
module load anaconda3/2022.10
conda activate eggnogMapper

#export variables and software to path
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/eggnog-mapper

#run eggnog
emapper.py -m diamond --itype CDS --translate \
	-i ../data/strucAnnotate/braker/braker.codingseq \
	--sensmode very-sensitive \
	--dmnd_db ../../software/eggnog-mapper/data/actinopterygii.dmnd \
	--tax_scope Actinopterygii \
	-o funcAnnotatePFor \
	--decorate_gff ../data/strucAnnotate/braker/braker.gff3 \
	--decorate_gff_ID_field ID \
	--output_dir ../data/funcAnnotate \
	--temp_dir ../data/tmp \
	--cpu 48



