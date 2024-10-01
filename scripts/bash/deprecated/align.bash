#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=128
#SBATCH -o align

#activate conda env
module load bedtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#export minimap path
export PATH=$PATH:/ocean/projects/bio230047p/mchin/hifiAssembly/minimap2

#get into right directory
cd ../data/trimmedSeq

for i in  $(ls -d */); do
(
	#get current sample
	curSamp=${i::-1}

	#enter current wd
	cd ./$i

	#do alignment
	minimap2 -ax map-hifi \
		-t 127 \
		../../contigAssembly/Sch01Primary.fna $curSamp\Filt.fastq.gz > ../../alignedGenomes/$curSamp\/$curSamp\.sam

'	bwa-mem2 mem -t 96 \
		../../contigAssembly/Sch01Primary.fna \
		Sch01Filt.fastq > ../../alignedGenomes/$curSamp\/$curSamp\.sam
'
	#convert sam to bam
	gatk SamFormatConverter -I ../../alignedGenomes/$curSamp/$curSamp\.sam \
		-O ../../alignedGenomes/$curSamp/$curSamp\.bam
	
	
	#samtools view -o ../../alignedGenomes/$curSamp\/$curSamp\.bam ../../alignedGenomes/$curSamp\/$curSamp\.sam

	#add read groups to bam
	gatk AddOrReplaceReadGroups \
        I=../../alignedGenomes/$curSamp/$curSamp\.bam \
        O=../../alignedGenomes/$curSamp/$curSamp\Sorted.bam \
        RGID=group$curSamp \
        RGLB= lib$curSamp \
        RGPL=illumina \
        RGPU=unit$curSamp \
        RGSM=$curSamp \
        SORT_ORDER=coordinate \
    	CREATE_INDEX=true	

	#remove unzipped files
	#rm -r ../../alignedGenomes/$curSamp/*.sam
	#rm -r ../../alignedGenomes/$curSamp/$curSamp\.bam

	cd ..
)
done
