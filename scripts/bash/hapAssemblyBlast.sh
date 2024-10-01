#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o hapAssemblyBlast

#activate modules/conda env
module load anaconda3/2022.10
conda activate genomics

#export paths
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/ncbi-blast-2.16.0+/bin/

#blast for hap1
blastn -db ../data/parentRef/parentSeq.fasta -query ../data/contigAssembly/Sch01Hap1.fna \
	-outfmt "6 qseqid stitle evalue bitscore staxids" -num_alignments 5 -out ../data/hapBlastOut/hap1BLAST.tsv \
	-num_threads 10 

#blast for hap2
blastn -db ../data/parentRef/parentSeq.fasta -query ../data/contigAssembly/Sch01Hap2.fna \
	-outfmt "6 qseqid stitle evalue bitscore staxids" -num_alignments 5 -out ../data/hapBlastOut/hap2BLAST.tsv \
	-num_threads 10 
