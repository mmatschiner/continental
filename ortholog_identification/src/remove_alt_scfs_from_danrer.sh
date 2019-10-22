# m_matschiner Thu Nov 8 09:13:05 CET 2018

# Use the fastagrep script to remove alternative scaffolds from the danrer assembly.
/projects/cees/scripts/fastagrep -t -p REF ../data/subjects/combined/danrer.fasta > tmp.fasta
rm -f ../data/subjects/combined/danrer.fasta
mv tmp.fasta ../data/subjects/combined/danrer.fasta
