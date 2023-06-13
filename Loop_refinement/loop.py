# Run this script with something like
#    python loop.py N > N.log
# where N is an integer from 1 to the number of models.
#
# ModLoop does this for N from 1 to 300 (it runs the tasks in parallel on a
# compute cluster), then returns the single model with the best (lowest)
# value of the Modeller objective function.

from modeller import *
from modeller.automodel import * 
import sys

# to get different starting models for each task
taskid = int(sys.argv[1])
env = Environ(rand_seed=-1000-taskid)

# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']
env.io.hetatm = True

class MyLoop(LoopModel):
    def select_loop_atoms(self):
        rngs = (
	   self.residue_range('753:A', '761:A'),
           self.residue_range('-4:A', '0:A')
	)
        for rng in rngs:
            if len(rng) > 40:
                raise ModellerError("loop too long")
        s = Selection(rngs)
        if len(s.only_no_topology()) > 0:
            raise ModellerError("some selected residues have no topology")
        return s

m = MyLoop(env, inimodel='input.pdb',
           sequence='loop')
m.set_output_model_format('PDB')
m.loop.md_level = refine.slow
m.loop.starting_model = m.loop.ending_model = taskid

m.make()
