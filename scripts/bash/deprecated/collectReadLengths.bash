#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 12:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o collectReadLengths

#load conda env
module load anaconda3/2022.10
conda activate genomics

#run read length script
python getReadLengths.py


