# m_matschiner Wed Feb 20 00:31:01 CET 2019

# Load the python3 module.
module load python3/3.5.0
module load beast2/2.5.0

# Combine log and trees files for the analyses with no fossil data.
for mode in strict permissive
do
    if [ ! -f ../res/beast/${mode}/unconstrained/combined/${mode}_unconstrained.log ]
    then
	mkdir -p ../res/beast/${mode}/unconstrained/combined
	ls ../res/beast/${mode}/unconstrained/replicates/r0{1,2,4}/${mode}_unconstrained.log > ../res/beast/${mode}/unconstrained/combined/logs.txt
	ls ../res/beast/${mode}/unconstrained/replicates/r0{1,2,4}/${mode}_unconstrained.trees > ../res/beast/${mode}/unconstrained/combined/trees.txt
	python3 logcombiner.py -n 2000 -b 10 ../res/beast/${mode}/unconstrained/combined/logs.txt ../res/beast/${mode}/unconstrained/combined/${mode}_unconstrained.log
	python3 logcombiner.py -n 2000 -b 10 ../res/beast/${mode}/unconstrained/combined/trees.txt ../res/beast/${mode}/unconstrained/combined/${mode}_unconstrained.trees
	treeannotator -burnin 0 -heights mean ../res/beast/${mode}/unconstrained/combined/${mode}_unconstrained.trees ../res/beast/${mode}/unconstrained/combined/${mode}_unconstrained.tre
    fi
done
