from modeller import *
from modeller.automodel import *

env = Environ()
env.io.hetatm = True
a = AutoModel(env, alnfile='TXS-mult.ali',
              knowns=('3P5RA','1N23A'), sequence='querysequence',
              assess_methods=(assess.DOPE,
                              assess.GA341)
	      )
a.starting_model = 1
a.ending_model = 5
a.make()
