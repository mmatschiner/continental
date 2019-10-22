#!/bin/bash

# m_matschiner Wed Feb 6 13:03:29 CET 2019

#SBATCH --job-name=iqtree
#SBATCH --time=100:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=5

# Set up.
source /cluster/bin/jobsetup
module load iqtree/1.6.8

# Get the command-line arguments.
align=`readlink -f ${1}`
align_base=`basename ${align}`
tree=`readlink -f ${2}`
log=`readlink -f ${3}`

# Change to the temporary directory.
cd ${SCRATCH}

# Copy the alignment to the temporary directory.
cp ${align} ${align_base}

# Run iqtree.
iqtree -nt 5 -s ${align_base} -m TEST --runs 2

# Return the resulting tree and log file.
cp ${align_base}.treefile ${tree}
cp ${align_base}.iqtree ${log}