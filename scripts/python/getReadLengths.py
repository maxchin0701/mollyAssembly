#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 19 11:56:18 2024

@author: maxchin
"""

#import module
from Bio import SeqIO

#take in user inputs
inFile = str(input("Input .fasta/.fna file: "))
#outFile = str(input("output .tsv file: "))


#variables to store scaff names and length
seqL = []
seqN = []

#keep scaffolds above 100kb
for record in SeqIO.parse(inFile, "fasta"):
    #seqL.append(len(record.seq))
    #seqN.append(record.id)
    print(record.id + "\t" + str(len(record.seq)) + "\n")


#write file
"""
print("Writing .tsv file")
out = open(outFile, 'w')

for i in range(0,len(seqL)):
    out.write(str(i) + "\t" + str(seqN[i]) + "\t" + str(seqL[i]) + "\n")

out.close()

print("Done")
"""