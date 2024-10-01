#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=20
#SBATCH -o downloadBioShare

#download fastq
rsync -vrt bioshare@bioshare.bioinformatics.ucdavis.edu:/dld51njlnhvm3s2/PB1050_PFOSCH1A_AmazonMolly_HiFiv3_Revio_cell1/ExportReads_fasta_fastq_7123/outputs/m84066_231223_041857_s3_fastq.zip \
	../data/rawSeq/Sch01
