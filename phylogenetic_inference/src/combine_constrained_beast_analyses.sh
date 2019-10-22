# m_matschiner Wed Feb 20 00:31:01 CET 2019

# Load the python3 module.
module load python3/3.5.0
module load beast2/2.5.0

# Combine log and trees files for the analyses with no fossil data.
for mode in strict permissive
do
    rm -r ../res/beast/${mode}/constrained/combined
    mkdir -p ../res/beast/${mode}/constrained/combined
    ls ../res/beast/${mode}/constrained/replicates/r0?/${mode}_constrained.log > ../res/beast/${mode}/constrained/combined/logs.txt
    ls ../res/beast/${mode}/constrained/replicates/r0?/${mode}_constrained.trees > ../res/beast/${mode}/constrained/combined/trees.txt
    python3 logcombiner.py -n 2000 -b 10 ../res/beast/${mode}/constrained/combined/logs.txt ../res/beast/${mode}/constrained/combined/${mode}_constrained.log
    python3 logcombiner.py -n 2000 -b 10 ../res/beast/${mode}/constrained/combined/trees.txt ../res/beast/${mode}/constrained/combined/${mode}_constrained.trees
    treeannotator -burnin 0 -heights mean ../res/beast/${mode}/constrained/combined/${mode}_constrained.trees ../res/beast/${mode}/constrained/combined/${mode}_constrained.tre
done
