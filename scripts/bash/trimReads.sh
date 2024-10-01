#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=8
#SBATCH -o trimReads

#activate conda env
module load BLAST
module load anaconda3/2022.10
conda activate genomics

#export hifiadapterfilt scripts
export PATH=$PATH:/ocean/projects/bio230047p/mchin/hifiAssembly/HiFiAdapterFilt
export PATH=$PATH:/ocean/projects/bio230047p/mchin/hifiAssembly/HiFiAdapterFilt/DB

#create general output directory
if [ -d ../data/trimmedSeq ]; then
	rm -r ../data/trimmedSeq
fi

mkdir ../data/trimmedSeq

#get into right directory
cd ../data/rawSeq

#run hifi adapter filt

for i in  $(ls -d */); do
(
	#enter current wd
	cd ./$i

	#get current sample
	curSamp=${i::-1}

	#make sample specific output directory
	mkdir ../../trimmedSeq/$curSamp

	#run hifi adapter filt
	bash hifiadapterfilt.sh -p m84066_231223_041857_s3 -m 95 -o ../../trimmedSeq/$curSamp

	mv ../../trimmedSeq/$curSamp\/m84066_231223_041857_s3.filt.fastq.gz ../../trimmedSeq/$curSamp\/$curSamp\Filt.fastq.gz

)
done

