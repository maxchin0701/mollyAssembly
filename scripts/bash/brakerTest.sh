#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 24:00:00
#SBATCH --ntasks-per-node=24
#SBATCH -o brakerTest

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

#run test braker
braker.pl --genome=../../software/BRAKER/example/genome.fa \
	--prot_seq=../../software/BRAKER/example/proteins.fa \
	--threads=24

