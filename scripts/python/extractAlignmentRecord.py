#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  5 12:15:44 2024

@author: maxchin
"""

#import modules
import csv

#take in user inputs
inDir = input("Input .bed file: ")
#tarScaff = input("Target scaffold: ")
#start = input("Begin: ")
#end = input("End: ")

with open(inDir) as f:
    reader = csv.reader(f, delimiter="\t")
    d = list(reader)
print(d[0][0])





