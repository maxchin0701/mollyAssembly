#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 24:00:00
#SBATCH --ntasks-per-node=64
#SBATCH -o processOmniCHapPhased

#load modules
module load GATK
module load anaconda3/2022.10
conda activate dovetailOmniC
module load samtools

#generate hap list
hapList=("Hap1" "Hap2")

for hap in ${hapList[@]}; do 
	#generate reference for index
	samtools faidx ../data/contigAssembly/Sch01$hap\.fna

	#generate genome file
	cut -f1,2 ../data/contigAssembly/Sch01$hap\.fna.fai > ../data/contigAssembly/Sch01$hap\.genome

	#initial alignment
	bwa-mem2 mem -5SP -T0 -t64 ../data/contigAssembly/Sch01$hap\.fna \
		../data/rawSeq/Sch01/omniC/poeFor-1_S9_L002_R1_001.fastq.gz \
		../data/rawSeq/Sch01/omniC/poeFor-1_S9_L002_R2_001.fastq.gz | samtools view -@ 64 -Sb - \
		> ../data/alignedOmniC/dovetail/poeFor1$hap\Aligned.bam

	#convert to pairsam, sort, remove duplicates
	pairtools parse --min-mapq 40 --walks-policy 5unique \
		--max-inter-align-gap 30 --nproc-in 64 --nproc-out 64 \
		--chroms-path ../data/contigAssembly/Sch01$hap\.genome \
		../data/alignedOmniC/dovetail/poeFor1$hap\Aligned.bam | \
		pairtools sort --nproc 64 --tmpdir=../data/tmp | \
		pairtools dedup --nproc-in 64 --nproc-out 64 --mark-dups \
		--output-stats ../data/filteredOmniC/dovetail/stats$hap\.txt \
		--output ../data/filteredOmniC/dovetail/poeFor1$hap\Dedup.pairsam

	#split pairsam, sort bam
	pairtools split ../data/filteredOmniC/dovetail/poeFor1$hap\Dedup.pairsam --nproc-in 64 --nproc-out 64 \
		--output-pairs ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.pairs \
		--output-sam - | \
		samtools view -bS -@64 | \
		samtools sort -@64 -T ../data/tmp -o ../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bam

	#add read groups
	gatk AddOrReplaceReadGroups \
		INPUT=../data/finalOmniC/dovetail/poeFor1$hap\OmniC.bam \
		OUTPUT=../data/finalOmniC/dovetail/poeFor1$hap\OmniCRG.bam \
		ID=poeFor1$hap LB=poeFor1$hap \
		SM=poeFor1$hap \
		PL=ILLUMINA PU=none

	#index bam
	samtools index ../data/finalOmniC/dovetail/poeFor1$hap\OmniCRG.bam
done






