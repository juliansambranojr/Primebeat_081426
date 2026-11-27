"""The rows the Lean census rests on: pi(2^n) for n <= 20, the table's zeros in rows 1..20,
and the two depth-5 cells that make (20,6) a repeat. Exploratory check of the numbers the
Lean files state; the proofs are in lean/ (Census20, PiRow20 and the files they import)."""
import json, sympy
pi=[int(sympy.primepi(2**n)) for n in range(21)]
a=[0]+[pi[m]-pi[m-1] for m in range(1,21)]
T={}
for r in range(0,21): T[(r,0)]=a[r] if r>=1 else 0
for d in range(1,21):
    for r in range(0,21): T[(r,d)]=T[(r,d-1)]-(T[(r-1,d-1)] if r>=1 else 0)
zeros=[[r,d] for r in range(1,21) for d in range(1,r) if T[(r,d)]==0]
out={"pi_2_20":pi[20],"pi_2_19":pi[19],"pi_2_16":pi[16],"zeros":zeros,"n_zeros":len(zeros),
     "cell_20_5":T[(20,5)],"cell_19_5":T[(19,5)],"cells_checked":sum(1 for r in range(1,21) for d in range(1,r))}
json.dump(out,open("census.json","w"),indent=1); print(out)
