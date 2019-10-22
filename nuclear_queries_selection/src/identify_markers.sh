# m_matschiner Mon Oct 8 20:01:11 CEST 2018

# Make the output directories.
mkdir -p ../res/tables
mkdir -p ../res/queries
mkdir -p ../res/dump

# Make the log directory.
mkdir -p ../log/misc

# Set the input files.
mart_export=../data/tables/mart_export.txt
gene_trees=../data/misc/Compara.94.protein_default.nhx.emf
ref=../data/subjects/danrer.fasta
database_list=../data/subjects/databases.txt
taxon_assignment_table=../data/tables/taxa.txt

# Set the account.
acct=nn9244k # cees

# Identify markers for different combinations of databases and missingness thresholds.
for database_list in ../data/subjects/databases*.txt
do
    databases_id=`basename ${database_list%.txt}`
    for n_orthologs_allowed_missing in 4 2 0
    do
	# Set the result file names.
	dump=../res/dump/miss${n_orthologs_allowed_missing}_${databases_id}.dmp
	res_genes_table=../res/tables/nuclear_queries_genes_miss${n_orthologs_allowed_missing}_${databases_id}.txt
	res_exons_table=../res/tables/nuclear_queries_exons_miss${n_orthologs_allowed_missing}_${databases_id}.txt
	res_exons_file=../res/queries/danrer_exons_miss${n_orthologs_allowed_missing}_${databases_id}.fasta

	# Set the log file.
	out=../log/misc/identify.miss${n_orthologs_allowed_missing}_${databases_id}.txt
	rm -f ${out}

	# Identify markers.
	sbatch --account ${acct} -o ${out} identify_markers.slurm ${mart_export} ${gene_trees} ${ref} ${database_list} ${taxon_assignment_table} ${n_orthologs_allowed_missing} ${dump} ${res_genes_table} ${res_exons_table} ${res_exons_file}

    done
done