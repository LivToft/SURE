#!/bin/bash
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-node=1 
#SBATCH --mem-per-cpu=2000 
#SBATCH --time=10:0:0  
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 amber/20.12-20.15

echo "starting 1min"

pmemd.cuda -O -i 1min.in -o 1min.out -p TXS_GGPP_ion.prmtop -c relaxed.rst7 -r 1min.rst7 -inf 1min.info -ref TXS_GGPP_ion.inpcrd -x mdcrd.1min

echo "ending 1min"
echo "starting 2mdheat"

pmemd.cuda -O -i 2mdheat.in -o 2mdheat.out -p TXS_GGPP_ion.prmtop -c 1min.rst7 -r 2mdheat.rst7 -inf 2mdheat.info -ref 1min.rst7 -x mdcrd.2mdheat

echo "ending 2mdheat"
echo "starting 3md"

pmemd.cuda -O -i 3md.in -o 3md.out -p TXS_GGPP_ion.prmtop -c 2mdheat.rst7 -r 3md.rst7 -inf 3md.info -ref 2mdheat.rst7 -x mdcrd.3md

echo "ending 3md"
echo "starting 4md"

pmemd.cuda -O -i 4md.in -o 4md.out -p TXS_GGPP_ion.prmtop -c 3md.rst7 -r 4md.rst7 -inf 4md.info -ref 3md.rst7 -x mdcrd.4md

echo "ending 4md"
echo "Finished with solute relaxation"
