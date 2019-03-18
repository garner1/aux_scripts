# -*- coding: utf-8 -*-

import sys
import numpy as np
from scipy.stats import entropy
import fileinput

count = len(open(sys.argv[1]).readlines(  ))
p = np.zeros(count)
ind = 0
for line in fileinput.input():
    p[ind] = line
    ind += 1
print entropy(p,base=2)

