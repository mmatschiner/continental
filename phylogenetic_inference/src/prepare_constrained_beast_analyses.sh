# m_matschiner Thu Nov 22 14:48:32 CET 2018

# Load modules if necessary.
ruby_available=`which ruby 2> /dev/null | wc -l | tr -d " "`
if [[ ${ruby_available} == 0 ]]
then
    module load Ruby/2.7.1-GCCcore-8.3.0
fi
# If rscript is not available try loading it as a module.
rscript_available=`which Rscript 2> /dev/null | wc -l | tr -d " "`
if [[ ${rscript_available} == 0 ]]
then
    module load R/3.6.2-foss-2019b
fi

# Make the results directories.
mkdir -p ../res/beast/strict/constrained/xml
mkdir -p ../res/beast/permissive/constrained/xml

# Convert the mcc tree from the unconstrained analyses of the permissive data set to newick format.
Rscript convert_nexus_tree_to_newick.r ../res/beast/permissive/unconstrained/combined/permissive_unconstrained.tre ../data/trees/starting.tre

# Make beast input files.
for mode in strict permissive
do
    if [ ! -f ../res/beast/${mode}/constrained/xml/${mode}_constrained.xml ]
    then
        ruby beauti.rb -id ${mode}_constrained -n ../res/beast/${mode}/alignments -o ../res/beast/${mode}/constrained/xml -l 100000000 -c ../data/constraints/all.xml -t ../data/trees/starting.tre -i 50 -m GTR -g -bd -e -u -usd 0.5
    fi
done

# Make beast input files for robustness analyses with different outgroup relationships.
for robustness_mode in ostclu ostelo
do
    if [ ! -f ../res/beast/strict/${robustness_mode}/xml/strict_${robustness_mode}.xml ]
    then
        ruby beauti.rb -id strict_${robustness_mode} -n ../res/beast/strict/alignments -o ../res/beast/strict/${robustness_mode}/xml -l 100000000 -c ../data/constraints/all.xml -t ../data/trees/starting_${robustness_mode}.tre -i 50 -m GTR -g -bd -e -u -usd 0.5
    fi
done

# Make beast input files for robustness analyses with different fossil settings or cladeage settings.
for robustness_mode in nocifo lowpsi higpsi lowndr higndr
do
    if [ ! -f ../res/beast/strict/${robustness_mode}/xml/strict_${robustness_mode}.xml ]
    then
        ruby beauti.rb -id strict_${robustness_mode} -n ../res/beast/strict/alignments -o ../res/beast/strict/${robustness_mode}/xml -l 100000000 -c ../data/constraints/${robustness_mode}.xml -t ../data/trees/starting.tre -i 50 -m GTR -g -bd -e -u -usd 0.5
    fi
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

# Add loggers for clade ages to the xml of robustness analyses.
for robustness_mode in ostclu ostelo nocifo lowpsi higpsi lowndr higndr
do
    xml=../res/beast/strict/${robustness_mode}/xml/strict_${robustness_mode}.xml
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

# Remove tree topology operators from xml files of robustness analyses.
for robustness_mode in ostclu ostelo nocifo lowpsi higpsi lowndr higndr
do
    xml=../res/beast/strict/${robustness_mode}/xml/strict_${robustness_mode}.xml
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
    cat run_beast.slurm | sed "s/XXXXXX/${mode:0:2}_con/g" | sed "s/YYYYYY/${mode}_constrained/g" > ../res/beast/${mode}/constrained/replicates/r0${n}/run_beast.slurm
    done
done

# Prepare replicate directories for robustness analyses.
for robustness_mode in ostclu ostelo nocifo lowpsi higpsi lowndr higndr
do
    for n in `seq -w 1 4`
    do
    mkdir -p ../res/beast/strict/${robustness_mode}/replicates/r0${n}
    cp ../res/beast/strict/${robustness_mode}/xml/strict_${robustness_mode}.xml ../res/beast/strict/${robustness_mode}/replicates/r0${n}
    cat run_beast.slurm | sed "s/XXXXXX/${robustness_mode}/g" | sed "s/YYYYYY/strict_${robustness_mode}/g" > ../res/beast/strict/${robustness_mode}/replicates/r0${n}/run_beast.slurm
    done
done
