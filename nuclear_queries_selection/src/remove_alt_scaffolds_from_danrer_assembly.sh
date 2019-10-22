# m_matschiner Wed Oct 3 15:37:17 CEST 2018

# Use the fastagrep script to remove alternative scaffolds from the danrer assembly.
fastagrep -t -p REF ../data/subjects/danrer.fasta > tmp.fasta
rm -f ../data/subjects/danrer.fasta
mv tmp.fasta ../data/subjects/danrer.fasta

# Also remove alternative scaffolds from the biomart export file.
mart=../data/tables/mart_export.txt
if [ -f ${mart} ]
then
    cat ${mart} | grep -v CHR_ALT > tmp.txt
    rm -f ${mart}
    mv tmp.txt ${mart}
else
    echo "ERROR: The biomart export file ${mart} could not be found!"
    exit
fi