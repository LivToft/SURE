#!/bin/bash
#SBATCH --ntasks=8 
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4000 
#SBATCH --time=1:00:00
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 ambertools/21 
source $EBROOTAMBERTOOLS/amber.sh 
srun sander.quick.cuda.MPI -O -i simple_min.in -o TXS_GGPP_min.out -p TXS_GGPP_ion.prmtop -c TXS_GGPP_ion.rst7 -r TXS_GGPP_min.ncrst &
