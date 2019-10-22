# m_matschiner Thu Nov 22 14:48:32 CET 2018

# Load modules.
module load ruby/2.1.5
module load R/3.4.4

cat ../res/beast/strict/constrained/xml/strict_constrained.xml | sed "s/spec=\"MCMC\"/spec=\"MCMC\" sampleFromPrior=\"true\"/g" > ../res/beast/prior/constrained/xml/strict_constrained.xml

# Prepare replicate directories.
for n in `seq -w 1 4`
do
    rm -f ../res/beast/prior/constrained/replicates/r0${n}
    mkdir -p ../res/beast/prior/constrained/replicates/r0${n}
    cp ../res/beast/prior/constrained/xml/strict_constrained.xml ../res/beast/prior/constrained/replicates/r0${n}
    cp ../bin/beast.jar ../res/beast/prior/constrained/replicates/r0${n}
    cp -r ../bin/cladeage ../res/beast/prior/constrained/replicates/r0${n}
    cat run_own_beast_accelerated.slurm | sed "s/XXXXXX/pri_con/g" | sed "s/YYYYYY/strict_constrained/g" > ../res/beast/prior/constrained/replicates/r0${n}/run_own_beast_accelerated.slurm
done