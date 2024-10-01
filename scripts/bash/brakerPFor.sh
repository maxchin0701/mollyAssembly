#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 72:00:00
#SBATCH --ntasks-per-node=48
#SBATCH -o brakerPFor

#activate conda env
module load anaconda3/2022.10
conda activate braker

#export variables and software to path
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/BRAKER/scripts
export PERL5LIB=/jet/home/mchin/.conda/envs/braker/lib/site_perl/5.26.2
export GENEMARK_PATH=/ocean/projects/bio230047p/mchin/software/GeneMark-ETP/bin
export AUGUSTUS_CONFIG_PATH=/ocean/projects/bio230047p/mchin/software/Augustus/config
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/ProtHint/bin
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/TSEBRA/bin
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/compleasm_kit
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/Augustus/bin
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/Augustus/scripts
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/bamtools/bamtools_install/bin
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/diamond
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/brakerTools/stringtie2
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/brakerTools/bedtools/bedtools2/bin
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/brakerTools/gffRead/gffread-0.12.7.Linux_x86_64
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/brakerTools/cdbfasta
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/brakerTools/GUSHR
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software/ucscUtil
export MAKEHUB_PATH=/ocean/projects/bio230047p/mchin/software/brakerTools/MakeHub

#unzip OrthoDB
#gunzip ../data/OrthoDB/Vertebrata.fa.gz

#run braker
braker.pl --genome=../data/maskAssembly/PForSch01.fasta.masked \
	--prot_seq=../data/OrthoDB/Vertebrata.fa \
	--bam=../data/alignedRNA/alignedRNAAll.bam \
	--threads=48 \
	--gff3

#move braker directory to data
mv braker ../data/strucAnnotate



