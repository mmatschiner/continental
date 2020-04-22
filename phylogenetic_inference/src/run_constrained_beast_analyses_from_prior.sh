# m_matschiner Thu Nov 22 16:32:32 CET 2018

# Launch all constrained beast analyses.
for dir in ../res/beast/prior/constrained/replicates/r??
do
    cd ${dir}
    sbatch run_beast.slurm
    sleep 1 # To avoid multiple replicates having the same seed.
    cd -
done