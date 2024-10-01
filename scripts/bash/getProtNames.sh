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
cd ../data/funcAnnotate

#move output files to new folder
mkdir eMapperOut
mv funcAnnotatePFor* eMapperOut

#create trimmed tsv and get NR
awk '{FS = "\t"} ; NR>=5 && NR<=27730 {print $1 "\t" $9 "\t" $21}' ./eMapperOut/funcAnnotatePFor.emapper.annotations > hits.tsv
nRows=$(awk 'END{print NR}' hits.tsv)

#set array for new protein names
finalProtNames=()
finalProtNames+=("newName")

#loop through rows
for i in $(seq 2 $nRows); do
	#get current row
	curOldNames=($(awk -v row="$i" '{FS = "\t"} ; NR==row {print }' hits.tsv))
	IFS=',' read -ra names <<< ${curOldNames[2]}
	curOldPFAM=${names[0]}
	#set variable to check if fetch worked
	fetchPass=FALSE
	#set variable to track ncbi fails
	nNCBIFail=0
	#set variable to track pfam fails 
	nPFAMFail=0
	while [ $fetchPass == "FALSE" ];
	do
		#check if row has NCBI Symbol/PFAM shortname
		if [ "${curOldNames[1]}" != "-" ] &&
		   [ $nNCBIFail -le 2 ] ; 
		then
			finalProtNames[${#finalProtNames[@]}]=$(datasets summary gene symbol ${curOldNames[1]} --as-json-lines | \
				dataformat tsv gene --fields symbol,description | \
				awk '{FS = "\t"} ; NR==2 {print $2}')
			#check if ncbi fetch failed
			if [ "${finalProtNames[((${#finalProtNames[@]} - 1))]}" == "" ] ; 
				then
				#increment fail counter 
				nNCBIFail=$((nNCBIFail+1))
			else
				echo "NCBI symbol present"
			fi 
		elif [ "${curOldNames[2]}" != "-" ] && 
			[ $nPFAMFail -le 2 ] ;
		then	
			finalProtNames[${#finalProtNames[@]}]=$(hmmfetch ../pfam/Pfam-A.hmm $curOldPFAM | \
				awk '{FS = "  "} ; NR==4 {print $2}')
			#check if pfam fetch failed
			if [ "${finalProtNames[((${#finalProtNames[@]} - 1))]}" == "" ] ; 
				then
				#increment fail counter 
				nPFAMFail=$((nPFAMFail+1))
			else 
				echo "NCBI symbol not present, using PFAM short name"
			fi 
		else
			echo "No protein identifiers present, protein is uncharacterized"
			finalProtNames[${#finalProtNames[@]}]="hypothetical protein"
		fi

		if [ "${finalProtNames[((${#finalProtNames[@]} - 1))]}" != "" ] ; 
			then
			#set to pass 
			fetchPass=TRUE
		else 
			unset finalProtNames[-1]
		fi 
	done
	echo ${finalProtNames[$((${#finalProtNames[@]} - 1))]}     ${curOldNames[0]}     $i     $nNCBIFail     $nPFAMFail
done

#save to temporary file
(IFS=$'\n'; echo "${finalProtNames[*]}") > temp.txt

#append temp file as new column
awk 'NR==FNR{a[NR]=$0;next}{print a[FNR] "\t" $0}' hits.tsv temp.txt > hitsNew.tsv

