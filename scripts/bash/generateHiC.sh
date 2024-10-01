#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=32
#SBATCH -o generateHiC-%j

module load anaconda3/2022.10
conda activate salsa

JUICER_JAR=../../software/juicer_tools_1.22.01.jar
SALSA_OUT_DIR=$1
SCRIPT_PATH=../../software/SALSA/alignments2txt.py
SCRIPT_PATH=`dirname $SCRIPT_PATH`

samtools faidx ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta

cut -f 1,2 ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta.fai > ${SALSA_OUT_DIR}/chromosome_sizes.tsv

python ${SCRIPT_PATH}/alignments2txt.py -b ${SALSA_OUT_DIR}/alignment_iteration_1.bed  -a ${SALSA_OUT_DIR}/scaffolds_FINAL.agp -l ${SALSA_OUT_DIR}/scaffold_length_iteration_1 > ${SALSA_OUT_DIR}/alignments.txt

awk '{if ($2 > $6) {print $1"\t"$6"\t"$7"\t"$8"\t"$5"\t"$2"\t"$3"\t"$4} else {print}}'  ${SALSA_OUT_DIR}/alignments.txt | sort -k2,2d -k6,6d -T $PWD --parallel=16 | awk 'NF'  > ${SALSA_OUT_DIR}/alignments_sorted.txt

java -jar ${JUICER_JAR} pre ${SALSA_OUT_DIR}/alignments_sorted.txt ${SALSA_OUT_DIR}/salsa_scaffolds.hic ${SALSA_OUT_DIR}/chromosome_sizes.tsv

mv ${SALSA_OUT_DIR}/salsa_scaffolds {SALSA_OUT_DIR}/$2
