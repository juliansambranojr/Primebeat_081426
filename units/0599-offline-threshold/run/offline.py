"""Exploratory. (1) Move one zero off the line to 1/2 +- delta and count the cells in rows
12..92 where the change beats the residual left by the first 2000 zeros (unit 0597's model),
by region. (2) The accidental-zero count sum 1/(2|T|+1) by rows, and the cells' residues."""
import json, math, collections
from mpmath import mp, mpf, mpc, ei, riemannr, log
mp.dps=30
pi=[int(x) for x in open("pi_2pow.txt")]
a=[0]+[pi[m]-pi[m-1] for m in range(1,len(pi))]
g=[float(x) for x in open("../../../imported/twin_count/zeros1.txt").read().split()[:2000]]
L2=log(2)
def table(row):
    T={}
    for r in range(0,93): T[(r,0)]=row[r] if r>=1 else 0
    for d in range(1,93):
        for r in range(0,93): T[(r,d)]=T[(r,d-1)]-(T[(r-1,d-1)] if r>=1 else 0)
    return T
def zrow(rho):
    f=lambda mm: ei(mm*rho*L2) if mm>0 else 0
    return [0]+[2*(f(m)-f(m-1)).real for m in range(1,93)]
reg=lambda r,d: "shallow" if 6*d<r else ("middle" if 2*r>=7*d else "corner")
Rrow=[0]+[riemannr(mpf(2)**m)-riemannr(mpf(2)**(m-1)) for m in range(1,93)]
acc=[mpf(0)]*93
for gam in g:
    z=zrow(mpc(0.5,gam))
    for m in range(1,93): acc[m]+=z[m]
Ttrue=table(a)
cells=[(r,d) for r in range(12,93) for d in range(1,r)]
Tm=table([0]+[float(Rrow[m]-acc[m]) for m in range(1,93)])
resid={c:abs(Tm[c]-Ttrue[c]) for c in cells}
out={"threshold":{},"regions":{},"accidental":{},"residues":{}}
tot=collections.Counter(reg(*c) for c in cells)
out["regions"]["cells"]=dict(tot)
for k in (0,1,5,20):
    gam=g[k]; on=zrow(mpc(0.5,gam))
    for delta in (0.001,0.01,0.03):
        lo=zrow(mpc(0.5+delta,gam)); hi=zrow(mpc(0.5-delta,gam))
        Toff=table([0]+[float(0.5*(lo[m]+hi[m])-on[m]) for m in range(1,93)])
        hit=[c for c in cells if abs(Toff[c])>resid[c]]
        out["threshold"][f"z{k}_d{int(delta*1000)}"]=len(hit)
        if k==0 and delta==0.01:
            out["regions"]["hits"]=dict(collections.Counter(reg(*c) for c in hit))
    out["threshold"][f"z{k}_gamma"]=gam
nz=lambda rows: sum(1/(2*abs(Ttrue[(r,d)])+1) for r in rows for d in range(1,r) if Ttrue[(r,d)]!=0)
out["accidental"]={"rows_1_20":nz(range(1,21)),"rows_21_40":nz(range(21,41)),"rows_41_92":nz(range(41,93)),
    "row_92":nz([92]),"actual_zeros_1_20":sum(1 for r in range(1,21) for d in range(1,r) if Ttrue[(r,d)]==0)}
for p in (2,3):
    c=collections.defaultdict(lambda:[0]*p)
    for r in range(20,93):
        for d in range(1,r): c[reg(r,d)][Ttrue[(r,d)]%p]+=1
    out["residues"][f"mod{p}"]={k:[x/sum(v) for x in v] for k,v in c.items()}
json.dump(out,open("offline.json","w"),indent=1); print(json.dumps(out,indent=1))
