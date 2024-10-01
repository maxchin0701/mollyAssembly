#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=1
#SBATCH -o collectMetrics

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#get into right director
cd ../data/contigAssembly/

#get three assemblies
awk '/^S/{print ">"$2;print $3}' Sch01.asm.hic.p_ctg.gfa > Sch01Primary.fna
awk '/^S/{print ">"$2;print $3}' Sch01.asm.hic.hap1.p_ctg.gfa > Sch01Hap1.fna
awk '/^S/{print ">"$2;print $3}' Sch01.asm.hic.hap2.p_ctg.gfa > Sch01Hap2.fna

#move hifiasm outputs into separate directory
mkdir rawOut
mv *.asm.* rawOut

#get metrics for primary assembly
python ../../../quast/quast.py Sch01Primary.fna -o ../contigAssemblyMetrics/primary
python ../../../quast/quast.py Sch01Hap1.fna -o ../contigAssemblyMetrics/hap1
python ../../../quast/quast.py Sch01Hap2.fna -o ../contigAssemblyMetrics/hap2

