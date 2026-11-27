"""Exploratory check of ParityCell on the data: at depth p^k the cell is congruent mod p to
a(r) + (-1)^(p^k) a(r - p^k); count the cells whose two rows already keep them off zero."""
import json, sympy
pi=[int(x) for x in open("pi_2pow.txt")]
a=[0]+[pi[m]-pi[m-1] for m in range(1,len(pi))]
A=lambda m: a[m] if m>=1 else 0
T={}
for r in range(0,93): T[(r,0)]=A(r)
for d in range(1,93):
    for r in range(0,93): T[(r,d)]=T[(r,d-1)]-(T[(r-1,d-1)] if r>=1 else 0)
ppd={}
for p in sympy.primerange(2,92):
    q=p
    while q<92: ppd.setdefault(q,p); q*=p
out={"depths":len(ppd),"cells":0,"settled":0,"congruence_holds":0,"by_depth":{}}
for d,p in sorted(ppd.items()):
    s=(-1)**d; cells=range(d+1,93)
    h=sum(1 for r in cells if (A(r)+s*A(r-d))%p!=0)
    ok=sum(1 for r in cells if (T[(r,d)]-(A(r)+s*A(r-d)))%p==0)
    out["cells"]+=len(cells); out["settled"]+=h; out["congruence_holds"]+=ok
    out["by_depth"][str(d)]={"cells":len(cells),"settled":h}
json.dump(out,open("ppcells.json","w"),indent=1); print({k:v for k,v in out.items() if k!="by_depth"})
