#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 13:31:44 2024

@author: maxchin
"""

#import modules
from Bio import SeqIO
from readpaf import parse_paf
import pandas

#take in user inputs
inFasta = input("Input fasta file: ")
inPAF = input("Input PAF file: ")
outFile = input("Output file: ")

#create list
fastaDat=[]
newFastaDat=[]
chromScaffs=[]

#read in fasta
for record in SeqIO.parse(inFasta, "fasta"):
    fastaDat.append({'id':record.id,'seq':record.seq})

#read in paf data
with open(inPAF, "r") as paf:
    pafRaw = parse_paf(paf, dataframe=True)

#get unique scaffs from paf
pRetScaffs=pafRaw.query_name.unique()

#loop through and get counts
for i in pRetScaffs:
    curScaffAlignments=pafRaw[pafRaw['query_name']==i]
    alignCounts=curScaffAlignments['target_name'].value_counts()
    corrOldScaff=alignCounts.idxmax()
    oldFastaRecord=[d for d in fastaDat if d['id'] == corrOldScaff]
    curSeq=oldFastaRecord[0]['seq']
    scaffName=i.split('_')[0]
    chrName="chr" + scaffName[2:]
    newFastaDat.append({'newScaffName':chrName,'seq':curSeq})
    chromScaffs.append(oldFastaRecord[0]['id'])
    #print(i)
    #print(corrOldScaff)

#set counter
unScaffN=1
#loop through and name unplaced scaffs
for i in fastaDat:
    if i['id'] not in chromScaffs:
        curSeq=i['seq']
        newFastaDat.append({'newScaffName':'unplacedScaff'+str(unScaffN),'seq':curSeq})
        unScaffN+=1
            
    
#write new fasta
out = open(outFile, 'w')
for i in range(0,len(newFastaDat)):
    out.write(">" + newFastaDat[i]['newScaffName'] + "\n" + str(newFastaDat[i]['seq']) + "\n")
out.close()

