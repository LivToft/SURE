#!/bin/bash
#SBATCH --ntasks=8 
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4000 
#SBATCH --time=1:00:00
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 ambertools/21
source $EBROOTAMBERTOOLS/amber.sh
srun sander.quick.cuda.MPI -O -i min_qmmm.in -o min_qmmm.out -p 3p5r_FGP_ion.prmtop -c 3p5r_FGP_ion.inpcrd -r min_qmmm.rst7 -inf min_qmmm.info -ref 3p5r_FGP_ion.inpcrd -x mdcrd.min_qmmm -r restart.rst7
