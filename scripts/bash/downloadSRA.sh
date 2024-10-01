#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o downloadSRA

#load modules
module load anaconda3/2022.10
conda activate braker

#export path to sratoolkit
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/sratoolkit.3.1.1-centos_linux64/bin

#prefetch reads
prefetch SRR13349693 -O ../data/rawSeq/rna
prefetch SRR13349692 -O ../data/rawSeq/rna
prefetch SRR13349691 -O ../data/rawSeq/rna
prefetch SRR629509 -O ../data/rawSeq/rna
prefetch SRR629511 -O ../data/rawSeq/rna
prefetch SRR629518 -O ../data/rawSeq/rna
prefetch SRR629505 -O ../data/rawSeq/rna
prefetch SRR629502 -O ../data/rawSeq/rna
prefetch SRR629501 -O ../data/rawSeq/rna
prefetch SRR629508 -O ../data/rawSeq/rna
prefetch SRR629514 -O ../data/rawSeq/rna
prefetch SRR629510 -O ../data/rawSeq/rna
prefetch SRR629503 -O ../data/rawSeq/rna
prefetch SRR629512 -O ../data/rawSeq/rna


#extract reads
cd ../data/rawSeq/rna
fasterq-dump SRR13349693 --include-technical -S --outdir ./SRR13349693 --outfile ovary
fasterq-dump SRR13349692 --include-technical -S --outdir ./SRR13349692 --outfile liver
fasterq-dump SRR13349691 --include-technical -S --outdir ./SRR13349691 --outfile brain
fasterq-dump SRR629509 --include-technical -S --outdir ./SRR629509 --outfile unk1
fasterq-dump SRR629511 --include-technical -S --outdir ./SRR629511 --outfile unk2
fasterq-dump SRR629518 --include-technical -S --outdir ./SRR629518 --outfile unk3
fasterq-dump SRR629505 --include-technical -S --outdir ./SRR629505 --outfile unk4
fasterq-dump SRR629502 --include-technical -S --outdir ./SRR629502 --outfile unk5
fasterq-dump SRR629501 --include-technical -S --outdir ./SRR629501 --outfile unk6
fasterq-dump SRR629508 --include-technical -S --outdir ./SRR629508 --outfile unk7
fasterq-dump SRR629514 --include-technical -S --outdir ./SRR629514 --outfile unk8
fasterq-dump SRR629510 --include-technical -S --outdir ./SRR629510 --outfile unk9
fasterq-dump SRR629503 --include-technical -S --outdir ./SRR629503 --outfile unk10
fasterq-dump SRR629512 --include-technical -S --outdir ./SRR629512 --outfile unk11


