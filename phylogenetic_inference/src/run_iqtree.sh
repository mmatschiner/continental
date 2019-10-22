# m_matschiner Wed Feb 6 12:55:43 CET 2019

# Load the ruby module.
module load ruby/2.1.5

# Set the account.
acct=nn9244k

# Launch iqtree for each partition.
for mode in strict permissive
do
    mkdir -p ../res/iqtree/${mode}/alignments
    mkdir -p ../res/iqtree/${mode}/trees
    mkdir -p ../log/iqtree/${mode}
    for align in ../res/beast/${mode}/alignments/subset*.nex
    do
	cp -f ${align} ../res/iqtree/${mode}/alignments
	align_id=`basename ${align%.nex}`
	tree=../res/iqtree/${mode}/trees/${align_id}.tre
	log=../log/iqtree/${mode}/${align_id}.log
	out=../log/iqtree/${mode}/${align_id}.out
	rm -f ${out}
	sbatch --account=${acct} -o ${out} run_iqtree.slurm ${align} ${tree} ${log}
    done
done

# Launch iqtree for each concatenated set of partitions.
for mode in strict permissive
do
    concatenated_align=../res/iqtree/${mode}/alignments/concatenated.nex
    rm -f ${concatenated_align}
    ruby concatenate.rb -i ../res/iqtree/${mode}/alignments/subset*.nex -o ${concatenated_align} -f nexus
    tree=../res/iqtree/${mode}/trees/concatenated.tre
    log=../log/iqtree/${mode}/concatenated.log
    out=../log/iqtree/${mode}/concatenated.out
    rm -f ${out}
    sbatch --account=${acct} -o ${out} run_iqtree.slurm ${concatenated_align} ${tree} ${log}
done