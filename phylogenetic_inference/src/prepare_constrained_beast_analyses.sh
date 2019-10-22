# m_matschiner Thu Nov 22 14:48:32 CET 2018

# Load modules.
module load ruby/2.1.5
module load R/3.4.4

# Make the results directories.
mkdir -p ../res/beast/strict/constrained/xml
mkdir -p ../res/beast/permissive/constrained/xml

# Convert the mcc tree from the unconstrained analyses of the permissive data set to newick format.
Rscript convert_nexus_tree_to_newick.r ../res/beast/permissive/unconstrained/combined/permissive_unconstrained.tre ../data/trees/starting.tre

# Make beast XML input files.
for mode in strict permissive
do
    ruby beauti.rb -id ${mode}_constrained -n ../res/beast/${mode}/alignments -o ../res/beast/${mode}/constrained/xml -l 100000000 -c ../data/constraints/all.xml -t ../data/trees/starting.tre -i 50 -m GTR -g -bd -e -u -usd 0.5
done

# Add loggers for clade ages to the xml.
for mode in strict permissive
do
    xml=../res/beast/${mode}/constrained/xml/${mode}_constrained.xml
    last_line_part1=`cat ${xml} | grep -n "beast.evolution.tree.TreeHeightLogger" | cut -d ":" -f 1`
    first_line_part2=$(( ${last_line_part1} + 1 ))
    cat ${xml} | head -n ${last_line_part1} > tmp.xml
    clade_ids=`cat ../data/constraints/all.xml | grep -v "totalgroup" | grep "\.prior" | cut -d "=" -f 2 | cut -d " " -f 1`
    for clade_id in ${clade_ids}
    do
	echo -e "\t\t\t<log idref=${clade_id}/>" >> tmp.xml
    done
    cat ${xml} | tail -n +${first_line_part2} >> tmp.xml
    mv -f tmp.xml ${xml}
done

# Remove tree topology operators from xml files.
for mode in strict permissive
do
    xml=../res/beast/${mode}/constrained/xml/${mode}_constrained.xml
    cat ${xml} | grep -v treeSubtreeSlide:Species | grep -v treeExchange:Species | grep -v treeNarrowExchange:Species | grep -v treeWilsonBalding:Species > tmp.xml
    mv -f tmp.xml ${xml}
done

# Prepare replicate directories.
for mode in strict permissive
do
    for n in `seq -w 1 4`
    do
	mkdir -p ../res/beast/${mode}/constrained/replicates/r0${n}
	cp ../res/beast/${mode}/constrained/xml/${mode}_constrained.xml ../res/beast/${mode}/constrained/replicates/r0${n}
	cp ../bin/beast.jar ../res/beast/${mode}/constrained/replicates/r0${n}
	cp -r ../bin/cladeage ../res/beast/${mode}/constrained/replicates/r0${n}
	cat run_own_beast_accelerated.slurm | sed "s/XXXXXX/${mode:0:2}_con/g" | sed "s/YYYYYY/${mode}_constrained/g" > ../res/beast/${mode}/constrained/replicates/r0${n}/run_own_beast_accelerated.slurm
    done
done