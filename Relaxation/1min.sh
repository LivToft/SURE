#!/bin/bash
#SBATCH --ntasks=8 
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4000 
#SBATCH --time=1:00:00
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 ambertools/21 
source $EBROOTAMBERTOOLS/amber.sh 
srun sander.quick.cuda.MPI -O -i 1min.in -o 1min.out -p TXS_GGPP_ion.prmtop -c TXS_GGPP_ion.inpcrd -r 1min.rst7 -inf 1min.info -ref TXS_GGPP_ion.inpcrd -x mdcrd.1min
