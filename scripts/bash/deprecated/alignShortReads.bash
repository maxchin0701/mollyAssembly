#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 36:00:00
#SBATCH --ntasks-per-node=128
#SBATCH -o alignShort

#activate conda env
module load bedtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../../introgress/data/trimmedSeq

for i in  $(ls -d */); do
(	
	#skip poor quality samples
	if [ "$i" = "San114N/" || "$i" = "San026/" || "$i" = "V088/" ] ; then
		continue
    fi

	#get current sample
	curSamp=${i::-1}

	#enter current wd
	cd ./$i

	rm -r *.fq

	#unzip .gz files
	gzip -dk *_paired.fq.gz

	#do alignment
	bwa-mem2 mem -t 128 \
		../../../../hifiAssembly/data/contigAssembly/Sch01Primary.fna \
		*_forward_paired.fq \
		*_reverse_paired.fq > ../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\.sam

	#convert sam to bam
	gatk SamFormatConverter -I ../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\.sam \
		-O ../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\.bam

	#add read groups to bam
	gatk AddOrReplaceReadGroups \
        I=../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\.bam \
        O=../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\Sorted.bam \
        RGID=group$curSamp \
        RGLB= lib$curSamp \
        RGPL=illumina \
        RGPU=unit$curSamp \
        RGSM=$curSamp \
        SORT_ORDER=coordinate \
    	CREATE_INDEX=true	

	#remove unzipped files
	rm -r ../../../../hifiAssembly/data/alignedGenomes/$curSamp/*.sam
	rm -r ../../../../hifiAssembly/data/alignedGenomes/$curSamp/$curSamp\.bam
	rm -r *.fq

	cd ..
)
done
