#!/bin/bash

# m_matschiner Thu Nov 22 16:28:45 CET 2018

# Job name:
#SBATCH --job-name=XXXXXX
#
# Project:
#SBATCH --account=nn9244k
#
# Wall clock limit:
#
#SBATCH --time=144:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=8
#SBATCH --nodes=1
#SBATCH --partition=accel
#SBATCH --gres=gpu:2
#SBATCH --mem-per-cpu=5G
#
# Outfile:
#SBATCH --output=YYYYYY.out

## Set up job environment:
source /cluster/bin/jobsetup
module load beagle-lib/2.1.2
module load beagle_gpu/1.0

## Run or resume beast analysis.
if [ ! -f YYYYYY.log ]
then
    java -jar -Dbeast.load.jars=true -Dbeast.user.package.dir=. beast.jar -threads 5 -seed ${RANDOM} -beagle -beagle_GPU YYYYYY.xml
else
    java -jar -Dbeast.load.jars=true -Dbeast.user.package.dir=. beast.jar -threads 5 -seed ${RANDOM} -beagle -beagle_GPU -resume YYYYYY.xml
fi
