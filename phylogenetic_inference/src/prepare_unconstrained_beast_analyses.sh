# m_matschiner Thu Nov 22 14:48:32 CET 2018

# Load modules.
module load ruby/2.1.5

# Make the results directories.
mkdir -p ../res/beast/strict/unconstrained/xml
mkdir -p ../res/beast/permissive/unconstrained/xml

# Concatenate alignments according to partitionfinder results.
for mode in strict permissive
do
    mkdir -p ../res/beast/${mode}/alignments
    rm -f ../res/beast/${mode}/alignments/*
    cat ../res/partitionfinder/${mode}/analysis/analysis/best_scheme.txt | grep ENS | grep -v Scheme_cleaned_scheme | cut -d "|" -f 5 | tr -d " " > tmp.pf.txt
    count=0
    while read line
    do
	(( count = ${count} + 1 ))
	mkdir -p tmp
	partition_ids=`echo ${line} | tr "," "\n"`
	for partition_id in ${partition_ids}
	do
	    cp ../res/partitionfinder/${mode}/alignments/${partition_id}.nex tmp
	done
	ruby concatenate.rb -i tmp/*.nex -o ../res/beast/${mode}/alignments/subset_${count}.nex -f nexus
	rm -r tmp
    done < tmp.pf.txt
    rm -f tmp.pf.txt
done

# Make beast XML input files.
for mode in strict permissive
do
    ruby beauti.rb -id ${mode}_unconstrained -n ../res/beast/${mode}/alignments -o ../res/beast/${mode}/unconstrained/xml -l 100000000 -c ../data/constraints/root.xml -t ../data/trees/starting.tre -m GTR -g -bd -e -u -usd 0.5
done

# Prepare replicate directories.
for mode in strict permissive
do
    for n in `seq -w 1 4`
    do
	mkdir -p ../res/beast/${mode}/unconstrained/replicates/r0${n}
	cp ../res/beast/${mode}/unconstrained/xml/${mode}_unconstrained.xml ../res/beast/${mode}/unconstrained/replicates/r0${n}
	cat run_beast.slurm | sed "s/XXXXXX/${mode:0:2}_unc/g" | sed "s/YYYYYY/${mode}_unconstrained/g" > ../res/beast/${mode}/unconstrained/replicates/r0${n}/run_beast.slurm
    done
done