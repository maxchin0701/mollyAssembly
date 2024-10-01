#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o generateHiCFinal-%j

#load modules
module load anaconda3/2022.10
conda activate salsa

JUICER_JAR=../juicer_tools_1.22.01.jar
SALSA_OUT_DIR=$1
SCRIPT_PATH=../SALSA/alignments2txt.py
SCRIPT_PATH=`dirname $SCRIPT_PATH`

samtools faidx ${SALSA_OUT_DIR}/scaffolds_FINAL_FIXED.fasta

cut -f 1,2 ${SALSA_OUT_DIR}/scaffolds_FINAL_FIXED.fasta.fai > ${SALSA_OUT_DIR}/chromosome_sizes_FIXED.tsv

awk '{if ($2 > $6) {print $1"\t"$6"\t"$7"\t"$8"\t"$5"\t"$2"\t"$3"\t"$4} else {print}}'  ${SALSA_OUT_DIR}/alignments_FIXED.txt | sort -k2,2d -k6,6d -T $PWD --parallel=16 | awk 'NF'  > ${SALSA_OUT_DIR}/alignments_sorted_FIXED.txt

java -jar ${JUICER_JAR} pre ${SALSA_OUT_DIR}/alignments_sorted_FIXED.txt ${SALSA_OUT_DIR}/salsa_scaffolds_FINAL.hic ${SALSA_OUT_DIR}/chromosome_sizes_FIXED.tsv
