# m_matschiner Wed Oct 3 16:00:56 CEST 2018

# Downloadsubject fasta files from ensembl.
bash get_subjects.sh

# Remove all alternative scaffolds from the zebrafish assembly.
bash remove_alt_scaffolds_from_danrer_assembly.sh

# Make blast databases for each cdna fasta file.
bash make_blast_dbs.sh

# Download the gene tree file from ensembl.
bash get_gene_tree_file.sh

# Identiy nuclear markers for phylogenetic inference.
bash identify_markers.sh