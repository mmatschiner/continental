# m_matschiner Thu Nov 22 16:32:32 CET 2018

# Launch all constrained beast analyses.
for mode in strict permissive
do
    for dir in ../res/beast/${mode}/constrained/replicates/r??
    do
	    cd ${dir}
	    sbatch run_beast.slurm
	    sleep 1 # To avoid multiple replicates having the same seed.
	    cd - &> /dev/null
    done

done

# Launch all constrained analyses of robustness.
for robustness_mode in ostclu ostelo nocifo lowpsi higpsi lowndr higndr
do
    for dir in ../res/beast/strict/${robustness_mode}/replicates/r??
    do
        cd ${dir}
        sbatch run_beast.slurm
        sleep 1 # To avoid multiple replicates having the same seed.
        cd - &> /dev/null
    done
done
