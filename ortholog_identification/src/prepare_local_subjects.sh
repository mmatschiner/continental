# m_matschiner Tue Nov 6 11:53:01 CET 2018

# Copy kollector and atram assemblies.
for file_lists in ../data/subjects/local/*/REQUIRED_FILES
do
	dir=`dirname ${file_lists}`
	cat ${file_lists} | tr -s " " | cut -d " " -f 9 > tmp.txt
	while read line
	do
		fasta=${dir}/${line}
		if [ ! -f ${fasta} ]
		then
			echo "ERROR: File ${fasta} can not be found. Note that atram and celera files must be placed in the corresponding directories in ../data/subjects/local."
			exit
		fi
	done < tmp.txt
done

# Merge kollector and atram assemblies with celera assemlies.
mkdir -p ../data/subjects/local/merged
while read line
do
    specimen=`echo ${line} | tr -s " " | cut -d " " -f 2`
    species=`echo ${line} | tr -s " " | cut -d " " -f 1`
    cat ../data/subjects/local/*/${specimen}*.fasta > ../data/subjects/local/merged/${species}.fasta
done < ../data/tables/cichlid_specimens.txt