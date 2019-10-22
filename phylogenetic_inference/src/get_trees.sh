# m_matschiner Thu Nov 22 14:00:00 CET 2018

# Make the data directory.
mkdir -p ../data/trees

# Copy the gene trees from the ortholog_identification directory.
for mode in strict permissive
do
    cp -r ../../ortholog_identification/res/trees/nuclear/${mode} ../data/trees/${mode}
done