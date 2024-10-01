#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=1
#SBATCH -o makeParentBlastDB

#activate modules/conda env
module load anaconda3/2022.10
conda activate genomics

#export paths
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/ncbi-blast-2.16.0+/bin/

#make db
makeblastdb -in ../data/parentRef/parentSeq.fasta -parse_seqids -blastdb_version 5 \
	-taxid_map ../data/parentRef/parentTaxMap.txt -title "Poecilia latipinna/mexicana" \
	-dbtype nucl
