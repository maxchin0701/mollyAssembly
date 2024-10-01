#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 25 12:02:54 2024

@author: maxchin
"""

#import modules
from Bio import SeqIO

#take in user input
fastaFiles=[item for item in input("Enter fasta files: ").split()]
taxIDs=[item for item in input("Enter taxIDs: ").split()]
outFile=input("Output file: ")

#create lists to store seq names and associated taxids
seqName=[]
taxID=[]

#loop through fasta files
for i in range(0,len(fastaFiles)):
    for record in SeqIO.parse(fastaFiles[i], "fasta"):
        seqName.append(record.description)
        taxID.append(taxIDs[i])
        
#write output
out = open(outFile, 'w')
for i in range(0,len(seqName)):
    out.write(seqName[i] + "\t" + taxID[i] + "\n")
out.close()
