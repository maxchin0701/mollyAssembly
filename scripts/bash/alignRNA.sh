#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 12:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o alignRNA

#load modules
module load anaconda3/2022.10
conda activate braker

#export path to local star
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/STAR/source

#Run STAR index
STAR --runThreadN 32 \
	--runMode genomeGenerate \
	--genomeDir ../data/maskAssembly \
	--genomeFastaFiles ../data/maskAssembly/PForSch01.fasta.masked \
	--genomeSAindexNbases 13


#Run STAR align
STAR --runThreadN 32 --genomeDir ../data/maskAssembly \
	--readFilesIn ../data/rawSeq/rna/SRR13349691/brain_1.fastq,../data/rawSeq/rna/SRR13349692/liver_1.fastq,../data/rawSeq/rna/SRR13349693/ovary_1.fastq,../data/rawSeq/rna/SRR629509/unk1_1.fastq,../data/rawSeq/rna/SRR629511/unk2_1.fastq,../data/rawSeq/rna/SRR629518/unk3_1.fastq,../data/rawSeq/rna/SRR629505/unk4_1.fastq,../data/rawSeq/rna/SRR629502/unk5_1.fastq,../data/rawSeq/rna/SRR629501/unk6_1.fastq,../data/rawSeq/rna/SRR629508/unk7_1.fastq,../data/rawSeq/rna/SRR629514/unk8_1.fastq,../data/rawSeq/rna/SRR629510/unk9_1.fastq,../data/rawSeq/rna/SRR629503/unk10_1.fastq,../data/rawSeq/rna/SRR629512/unk11_1.fastq \
	../data/rawSeq/rna/SRR13349691/brain_2.fastq,../data/rawSeq/rna/SRR13349692/liver_2.fastq,../data/rawSeq/rna/SRR13349693/ovary_2.fastq,../data/rawSeq/rna/SRR629509/unk1_2.fastq,../data/rawSeq/rna/SRR629511/unk2_2.fastq,../data/rawSeq/rna/SRR629518/unk3_2.fastq,../data/rawSeq/rna/SRR629505/unk4_2.fastq,../data/rawSeq/rna/SRR629502/unk5_2.fastq,../data/rawSeq/rna/SRR629501/unk6_2.fastq,../data/rawSeq/rna/SRR629508/unk7_2.fastq,../data/rawSeq/rna/SRR629514/unk8_2.fastq,../data/rawSeq/rna/SRR629510/unk9_2.fastq,../data/rawSeq/rna/SRR629503/unk10_2.fastq,../data/rawSeq/rna/SRR629512/unk11_2.fastq \
	--outSAMattrRGline ID:brain , ID:liver , ID:ovary , ID:unk1 , ID:unk2 , ID:unk3 , ID:unk4 , ID:unk5 , ID:unk6 , ID:unk7 , ID:unk8 , ID:unk9 , ID:unk10 , ID:unk11 \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ../data/alignedRNA/alignedRNAAll \
	--outSAMstrandField intronMotif \
	--limitBAMsortRAM 18680541600

