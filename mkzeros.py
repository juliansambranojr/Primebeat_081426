"""
mkzeros.py — CACHE GENERATOR: compute the imaginary parts of the first 600
      non-trivial zeta zeros at dps 25 and write them to `zeros600.json`.

Supporting script, not an O-numbered test.  It produces the cache read by
O36_weil_calibration.py, O37_weil_form_on_stencil.py, O37_weil_form_balance.py and
tail.py.  Those scripts read `zeros600.json`; none of them regenerate it.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.  It is a cache builder, not a measurement.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree, run there, and
moved into the tree afterwards under its original name.  The code logic is unchanged
from the scratch version; only this docstring was added.  The `zeros600.json` now at
the project root is the output of that scratch run.

WHAT THIS MEASURES
------------------
Nothing.  It calls `mpmath.zetazero(n).imag` for n = 1..600, stores each as a
decimal string, prints a progress line with elapsed seconds every 100 zeros, and
dumps the list to `zeros600.json`.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
No CLI flags.  The count 600, mp.dps = 25 and the output filename are inline.  It
writes `zeros600.json` in the CURRENT WORKING DIRECTORY and OVERWRITES any file of
that name without asking — run it from the project root, and only when the cache is
to be rebuilt.  Deviation from house convention (CONTEXT.md § "Output schema" and
its `_HERE` anchoring rule); an open NOTEPAD thread already records the same
deviation for O30/O31/O32.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python mkzeros.py

No flags, no arguments.  Run from the project root.

REQUIREMENTS
------------
    pip install mpmath
"""
from mpmath import mp, zetazero
import json, time
mp.dps = 25
t0=time.time(); out=[]
for n in range(1, 601):
    out.append(str(zetazero(n).imag))
    if n%100==0: print(n, time.time()-t0, flush=True)
json.dump(out, open("zeros600.json","w"))
