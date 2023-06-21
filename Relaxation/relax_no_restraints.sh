#!/bin/bash
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-node=1 
#SBATCH --mem-per-cpu=2000 
#SBATCH --time=10:0:0  
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 amber/20.12-20.15

echo "starting 9md"

pmemd.cuda -O -i 9md.in -o 9md.out -p TXS_GGPP_ion.prmtop -c 8md.rst7 -r 9md.rst7 -inf 9md.info -ref 8md.inpcrd -x mdcrd.9md

echo "ending 9md"
echo "Done with relaxation"
