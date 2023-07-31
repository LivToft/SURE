#!/bin/bash
#SBATCH --ntasks=8 
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4000 
#SBATCH --time=30:00:00

module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 ambertools/21

source $EBROOTAMBERTOOLS/amber.sh

deltaC10=$(echo "0.034" | bc)
C10ini=$(echo "1.10" | bc)

deltaC6=$(echo "0.05" | bc)
C6ini=$(echo "5.15" | bc)

limit=81
n = 1

while [$n -le $limit]
do
	C10r1=$(echo "$C10ini + $deltaC10*($n - 1)" | bc)		# center of window r2=r3
	C10r1min=$(echo "$C10r1 - 0.20" | bc) 		# r1 for C10
	C10r1max=$(echo "$C10r1 + 0.20" | bc) 		# r4 for C10

	C6r1=$(echo "$C6ini - $deltaC6*($n - 1)" | bc)          # center of window r2=r3
        C6r1min=$(echo "$C6r1 - 0.20" | bc)           # r1 for C06
        C6r1max=$(echo "$C6r1 + 0.20" | bc)           # r4 for C06

	[ -e md$n.in ] && rm md$n.in
	[ -e distance$n1.dat] && rm distance$n.dat


	# Create md.in file
	echo Umbrella run >> md$n.in
	echo  \&cntrl >> md$n.in
	echo   imin = 0              ! Not minimization >> md$n.in
	echo   irest = 1             ! Simulation is restarted from a previous simulation >> md$n.in
	echo   ntx = 5               ! Coordinates, velocities, and box information is read from a prev simulation >> md$n.in
	echo   ntb = 2               ! Periodic Boundary Conditions in the NPT ensemble >> md$n.in
	echo   ntp = 1               ! Isotropic scaling of column >> md$n.in
	echo   barostat = 1          ! Berendsen barostat >> md$n.in
	echo   pres0 = 1.0           ! Pressure in bars >> md$n.in
	echo   taup = 2.0            ! Relaxation time in ps >> md$n.in
	echo   cut = 9.0             ! Cutoff for Lennard-Jones and real-space Ewald interaction >> md$n.in
	echo   ntc = 2               ! Bonds involving hydrogen atoms are constrained >> md$n.in
	echo   ntf = 2               ! Bond interactions involving hydrogen are not computed >> md$n.in
	echo   tempi = 300.0         ! Initial temperature >> md$n.in
	echo   temp0 = 300.0         ! Final temperature >> md$n.in
	echo   ntt = 3               ! Langevin thermostat >> md$n.in
	echo   gamma_ln = 1.0        ! Collision frequency in ps-1 >> md$n.in
	echo   ig = -1               ! Default for Langevin thermostat >> md$n.in
	echo   nstlim = 35000        ! Number of time steps >> md$n.in
	echo   dt = 0.002            ! Time step in ps >> md$n.in
	echo   ntpr = 100            ! Energy printed every N steps >> md$n.in
	echo   ntwx = 100            ! Energy is printed every N steps >> md$n.in
	echo   ntwr = 100            ! Restart file is printed every N steps >> md$n.in
	echo   ntxo = 2              ! NetCDF format for final coordinates >> md$n.in
	echo   ioutfm = 1            ! Binary NetCDF trajectory format of coordinate and velocity trajectory files >> md$n.in
	echo   iwrap = 1             ! Coordinates written to the restart and traj files will be "wrapped" into a primary box >> md$n.in
	echo   ifqnt = 1             ! QM/MM >> md$n.in
	echo   nmropt = 1            ! Restraints, e.g., umbrella sampling >> md$n.in
	echo  / >> md$n.in
	echo  \&qmmm >> md$n.in
	echo   qmmask = \':785-789\'   ! Residues in the QM region >> md$n.in
	echo   qmcharge = 3          ! Charge on the QM system >> md$n.in
	echo   qm_theory = \'DFTB\'    ! Density functional theory used for QM region >> md$n.in
	echo   qmshake = 1           ! Shake QM H atoms >> md$n.in
	echo   qm_ewald = 1          ! Use PME or an Ewald sum to calculate long range QM-QM OR QM-MM electrostatic interactions >> md$n.in
	echo   qm_pme = 1            ! Use a QM compatible PME approach to calculate the long range QM-MM electrostatic energies and forces and the long range QM-QM forces
	echo  / >> md$n.in
	echo  \&wt type = \'DUMPFREQ\', istep1 = 100 / >> md$n.in
	echo  \&wt type = \'END\' / >> md$n.in
	echo  DISANG = distance$n.dat >> md$n.in
	echo  DUMPAVE = distance$n.out >> md$n.in


	# Create distance.dat file
	echo Harmonic distances for C10-H13=$C10r1 and C06-H13=$C6r1 >> distance$n.dat
	echo  \&rst >> distance$n.dat
	echo  iat=12568,12591, >> distance$n.dat
	echo  r1= $C10r1min, r2=$C10r1, r3=$C10r1, r4=$C10r1max, >> distance$n.dat
	echo  rk2=500.0, rk3=500.0, >> distance$n.dat
	echo  / >> distance$n.dat
	echo \&rst >> distance$n.dat
	echo  iat=12564,12591, >> distance$n.dat
	echo  r1=$C6r1min, r2=$C6r1, r3=$C6r1, r4=$C6r1max, >> distance$n.dat
	echo  rk2=500.0, rk3=500.0, >> distance$n.dat
	echo  / >> distance$n.dat

	rnext=$(echo "$n + 1" | bc)


	# Run simulation
	#srun sander.quick.cuda.MPI -O -i md$n.in -o md$n.out -p TXS_vert12_ion.prmtop -c ini$n.rst7 -r ini$n.rst7 -x md$n.mdcrd

	#cp md$n.rst ini$rnext.rst
	(( n++ ))
	done
