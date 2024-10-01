#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o ploidyAll

#activate conda env
module load anaconda3/2022.10
conda activate gatk

#take in argurment for fixed or variable ploidy prior table
prior=$1;

#export path to local GATK version
export PATH=$PATH:/ocean/projects/bio230047p/mchin/introgress/gatk-4.1.9.0

gatk DetermineGermlineContigPloidy \
  --input ../data/readCounts/Amm087/Amm087Counts1kb.hdf5 \
  --input ../data/readCounts/Amm090/Amm090Counts1kb.hdf5 \
  --input ../data/readCounts/Amm092/Amm092Counts1kb.hdf5 \
  --input ../data/readCounts/Amm105/Amm105Counts1kb.hdf5 \
  --input ../data/readCounts/San114/San114Counts1kb.hdf5 \
  --input ../data/readCounts/V129/V129Counts1kb.hdf5 \
  --input ../data/readCounts/Wes109/Wes109Counts1kb.hdf5 \
  --input ../data/readCounts/Wes123/Wes123Counts1kb.hdf5 \
  --output ../data/ploidy \
  --contig-ploidy-priors ../data/ploidy/ploidyProbs$prior\.tsv \
  -L ../data/contigAssembly/Sch01_1kb.interval_list \
  --interval-merging-rule OVERLAPPING_ONLY \
  --output-prefix ploidy$prior

