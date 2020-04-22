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
#SBATCH --mem-per-cpu=5G
#
# Outfile:
#SBATCH --output=YYYYYY.out

## Set up job environment:
## Set up the job environment
set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error
module --quiet purge  # Reset the modules to the system default
java_available=`which java | wc -l | tr -d " "`
if [[ ${java_available} == 0 ]]
then
    module load beagle-lib/3.1.2-GCC-8.2.0-2.31.1
fi

# Download and install beast.
if [ ! -f beast/bin/beast ]
then
    wget https://github.com/CompEvol/beast2/releases/download/v2.6.2/BEAST.v2.6.2.Linux.tgz
    tar -xzf BEAST.v2.6.2.Linux.tgz
    rm -f BEAST.v2.6.2.Linux.tgz
fi

# Make sure the cladeage package is installed with version >= 2.
ca_installed=`beast/bin/packagemanager -list | grep CA | cut -d "|" -f 2 | tr -d " " | cut -d "." -f 1`
if [[ ${ca_installed} == "NA" ]]
then
    beast/bin/packagemanager -add CA
elif [[ ${ca_installed} == "1" ]]
then
    beast/bin/packagemanager -updatenow
fi

## Run or resume beast analysis.
if [ ! -f YYYYYY.log ]
then
    beast/bin/beast -threads 8 -seed ${RANDOM} -beagle YYYYYY.xml
else
    beast/bin/beast -threads 8 -seed ${RANDOM} -beagle -resume YYYYYY.xml
fi

# Clean up.
rm -r beast
