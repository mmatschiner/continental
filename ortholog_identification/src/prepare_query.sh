# m_matschiner Thu Sep 13 20:52:47 CEST 2018

# This script has the following dependencies:
# remove_empty_seqs_from_fasta.rb
# remove_problematic_seqs_from_fasta.rb

# Load the ruby module.
module load ruby/2.1.5

# Make the queries directory.
mkdir -p ../data/queries

# Copy the zebrafish exons in amino-acid format.
cp ../../nuclear_queries_selection/res/queries/danrer_exons_miss2_databases14.fasta tmp.fasta
cp ../../nuclear_queries_selection/res/tables/nuclear_queries_exons_miss2_databases14.txt ../data/tables

# Remove empty sequences from the fasta file.
ruby remove_empty_seqs_from_fasta.rb tmp.fasta tmp2.fasta

# Remove one problematic sequence from the query file that has massively delayed blast in preliminary analyses.
ruby remove_problematic_seqs_from_fasta.rb tmp2.fasta ../data/tables/problematic_seqs.txt ../data/queries/danrer_exons.fasta

# Count and report the number of exons in the fasta file.
count=`cat ../data/queries/danrer_exons.fasta | grep ">" | wc -l`
echo "Fasta file contains ${count} sequences."

# Clean up.
rm -f tmp.fasta
rm -f tmp2.fasta