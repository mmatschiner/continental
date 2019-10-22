# m_matschiner Thu Nov 22 16:32:32 CET 2018

# Launch all constrained beast analyses.
for mode in strict permissive
do
    for dir in ../res/beast/${mode}/constrained/replicates/r??
    do
	cd ${dir}
	sbatch run_own_beast_accelerated.slurm
	sleep 1 # To avoid multiple replicates having the same seed.
	cd -
    done
done