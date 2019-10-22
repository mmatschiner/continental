# m_matschiner Mon Nov 12 13:11:13 CET 2018

# Load the ruby module.
module load ruby/2.1.5

for mode in strict permissive
do

    # Make the output directory.
    mkdir -p ../res/alignments/${mode}_no_missing

    for nex in ../data/alignments/${mode}/*.nex
    do
	echo ${nex}
	exit
    done
done