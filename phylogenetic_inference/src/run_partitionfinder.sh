# m_matschiner Sat Nov 24 11:49:26 CET 2018

# Load modules.
module load ruby/2.1.5
module load partitionfinder/2.1.1

# Make the log directory.
mkdir -p ../log/partitionfinder

# Set the accout.
acct=nn9244k

# Split alignments by codon position.
for mode in strict permissive
do
    mkdir -p ../res/partitionfinder/${mode}/alignments
    for nex in ../data/alignments/${mode}/*.nex
    do
	gene_id=`basename ${nex%.nex}`
	ruby split_by_cp.rb -i ${nex}
	rm ../data/alignments/${mode}/${gene_id}_3.nex
	mv ../data/alignments/${mode}/${gene_id}_1.nex ../res/partitionfinder/${mode}/alignments
	mv ../data/alignments/${mode}/${gene_id}_2.nex ../res/partitionfinder/${mode}/alignments
    done
done

# Prepare the partitionfinder analyses.
for mode in strict permissive
do
    # Make the analysis directory.
    mkdir -p ../res/partitionfinder/${mode}/analysis

    # Write the concatenated alignment file and a partitions file.
    ruby concatenate.rb -i ../res/partitionfinder/${mode}/alignments/*.nex -o tmp.align_with_parts.phy -f phylip -p &> /dev/null
    n_tax=`head -n 1 tmp.align_with_parts.phy | cut -d " " -f 1`
    n_lines=$(( ${n_tax} + 1 ))
    head -n ${n_lines} tmp.align_with_parts.phy > ../res/partitionfinder/${mode}/analysis/${mode}.phy
    n_lines=$(( ${n_lines} + 2 ))
    tail -n +${n_lines} tmp.align_with_parts.phy | sed "s/DNA, //g" | sed "s/=/ = /g" | sed 's/$/;/' > tmp.parts.phy

    # Write the partitionfinder configuration file.
    cfg=../res/partitionfinder/${mode}/analysis/partition_finder.cfg
    echo "# ALIGNMENT FILE #" > ${cfg}
    echo "alignment = ${mode}.phy;" >> ${cfg}
    echo "" >> ${cfg}
    echo "# BRANCHLENGTHS #" >> ${cfg}
    echo "branchlengths = linked;" >> ${cfg}
    echo "" >> ${cfg}
    echo "# MODELS OF EVOLUTION #" >> ${cfg}
    echo "models = GTR+G;" >> ${cfg}
    echo "model_selection = aic;" >> ${cfg}
    echo "" >> ${cfg}
    echo "# DATA BLOCKS #" >> ${cfg}
    echo "[data_blocks]" >> ${cfg}
    cat tmp.parts.phy >> ${cfg}
    echo "" >> ${cfg}
    echo "# SCHEMES #" >> ${cfg}
    echo "[schemes]" >> ${cfg}
    echo "search = rcluster;" >> ${cfg}
done

# Run partitionfinder.
for mode in strict permissive
do
    out=../log/partitionfinder/${mode}.out
    rm -f ${out}
    sbatch --account=${acct} -o ${out} run_partitionfinder.slurm ../res/partitionfinder/${mode}/analysis
done
