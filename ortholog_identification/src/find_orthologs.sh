# m_matschiner Tue Nov 6 23:51:52 CET 2018

# Make the output directory.
mkdir -p ../res/alignments/nuclear/01

# Make the log directory.
mkdir -p ../log/misc/

# Set the account.
acct=nn9244k # cees

# Generate a list of all subject sequence fasta files
# (use readlink and -d so that the absolute paths are specified).
#ls -d `readlink -f ../data/subjects/combined/`/danrer.fasta > ../data/subjects/combined/subjects.txt
#ls -d `readlink -f ../data/subjects/combined/`/*.fasta | grep -v "danrer" >> ../data/subjects/combined/subjects.txt

# Split the query file into a suitable number of files.
split -a 3 -l 50 -d ../data/queries/danrer_exons.fasta danrer_exons_
for i in danrer_exons_*
do
    mv -f ${i} ../data/queries/${i}.fasta
done

# Search for orthologs to all queries in all subject sequences.
for i in ../data/queries/danrer_exons_*.fasta
do
    exon_set_id=`basename ${i%.fasta}`
    out=../log/misc/find_orthologs.${exon_set_id}.out
    rm -f ${out}
    sbatch -o ${out} --account ${acct} find_orthologs.slurm ${i} ../data/subjects/combined/subjects.txt ../res/alignments/nuclear/01/
done
