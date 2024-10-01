#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 36:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o getProtNames

#activate conda env
module load anaconda3/2022.10
conda activate ncbiTools

#export paths
export PATH=$PATH:/ocean/projects/bio230047p/mchin/software//hmmer-3.4/src/

#get into right wd
cd ../data/funcAnnotate/

#move output files to new folder
mkdir eMapperOut
mv funcAnnotatePFor* eMapperOut

#create trimmed tsv and get NR
awk '{FS = "\t"} ; NR>=5 && NR<=27730 {print $1 "\t" $2 "\t" $9 "\t" $21}' ./eMapperOut/funcAnnotatePFor.emapper.annotations > hits.tsv
nRows=$(awk 'END{print NR}' hits.tsv)

#set array for new protein names
finalProtNames=()
finalProtNames+=("newName")
pfamFetchIdentifier=()
finalProtNames+=("pfamFetchIdentifier")
numTotalFail=0
numPFAMFail=0
numSymbolFail=0
numAccessionFail=0
#loop through rows
for i in $(seq 2 $nRows); do
	#get current row
	curOldNames=($(awk -v row="$i" '{FS = "\t"} ; NR==row {print }' hits.tsv))
	#retreive accession and PFAM identifier
	IFS='.' read -ra seedOrth <<< ${curOldNames[1]}
	curAccession=${seedOrth[1]}
	IFS=',' read -ra names <<< ${curOldNames[3]}
	curOldPFAM=${names[0]}
	#set variable to check if fetch worked
	fetchPass=FALSE
	nSymbolFailInternal=0
	nPFAMFailInternal=0
	while [ $fetchPass == "FALSE" ];
	do
		#run NCBI
		fetchMethod=accession
		newName=$(datasets summary gene accession $curAccession --as-json-lines | \
			dataformat tsv gene --fields symbol,description | \
			awk '{FS = "\t"} ; NR==2 {print $2}')
		#check if fetch failed
		if [ "$newName" == "" ] &&
		   [ "${curOldNames[2]}" != "-" ] &&
		   [ $nSymbolFailInternal -le 2 ] ;
		then
			fetchMethod=symbol
			newName=$(datasets summary gene symbol ${curOldNames[2]} --as-json-lines | \
				dataformat tsv gene --fields symbol,description | \
				awk '{FS = "\t"} ; NR==2 {print $2}')
			if [ "$newName" == "" ] ;
			then
				nSymbolFailInternal=$((nSymbolFailInternal+1))
			else
				echo "Accession failed, using NCBI symbol"
			fi
		elif [ "$newName" == "" ] &&
		     [ "${curOldNames[3]}" != "-" ] &&
		     [ $nPFAMFailInternal -le 2 ] ;
		then
			fetchMethod=pfam
			newName=$(hmmfetch ../pfam/Pfam-A.hmm $curOldPFAM | \
				awk '{FS = "  "} ; NR==4 {print $2}')
			if [ "$newName" == "" ] ;
			then
				nPFAMFailInternal=$((nPFAMFailInternal+1))
			else
				echo "Accession and NCBI symbol failed, using PFAM short name"
			fi
		elif [[ "$newName" == "" ]] ;
		then
			fetchMethod=none
			newName="hypothetical protein"
			echo "No protein identifiers present, protein is uncharacterized"
		fi
		#check if field still empty
		if [ "$newName" != "" ] ;
		then
			fetchPass=TRUE
		else
			fetchPass=FALSE
		fi
	done
	#check which method was used to retreive name
	if [ "$fetchMethod" == "symbol" ] ;
	then
		numAccessionFail=$((numAccessionFail+1))
	elif [ "$fetchMethod" == "pfam" ] ;
	then
		numAccessionFail=$((numAccessionFail+1))
		numSymbolFail=$((numSymbolFail+1))
	elif [ "$fetchMethod" == "none" ] ;
	then
		numAccessionFail=$((numAccessionFail+1))
		numSymbolFail=$((numSymbolFail+1))
		numPFAMFail=$((numPFAMFail+1))
		numTotalFail=$((numTotalFail+1))
	fi
	#print
	echo $newName ${curOldNames[0]} $i $numAccessionFail $numSymbolFail $numPFAMFail $numTotalFail
done




