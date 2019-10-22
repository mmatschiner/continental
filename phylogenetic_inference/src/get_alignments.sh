# m_matschiner Thu Nov 22 14:00:00 CET 2018

# Make the data directory.
mkdir -p ../data/alignments

# Copy the alignments in nexus format from the ortholog_identification directory.
for mode in strict permissive
do
    cp -r ../../ortholog_identification/res/alignments/nuclear/${mode} ../data/alignments/${mode}
done