"""The corner of the true dyadic table (cells with 2r < 7d, rows 12..92) rebuilt from the explicit
formula: each row as Riemann R(2^m) - R(2^(m-1)) less 2 Re of li(2^(m rho)) - li(2^((m-1) rho)) over the
first K zeros, then differenced like the table. EXPLORATORY."""
# Rebuild the corner from the zeros: a_model(m) = R-row(m) - 2 Re sum_{k<=K} [li(2^{m rho}) - li(2^{(m-1) rho})]
import math, sys, json
from mpmath import mp, mpf, mpc, ei, riemannr, log
mp.dps=30
pi=[int(x) for x in open('pi_2pow.txt')]
a=[0]+[pi[m]-pi[m-1] for m in range(1,len(pi))]
g=[float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]]
L2=log(2)
def table(row):
    T={}
    for r in range(0,93): T[(r,0)]=row[r] if r>=1 else 0
    for d in range(1,93):
        for r in range(0,93): T[(r,d)]=T[(r,d-1)]-(T[(r-1,d-1)] if r>=1 else 0)
    return T
Ttrue=table(a)
Rrow=[0]+[riemannr(mpf(2)**m)-riemannr(mpf(2)**(m-1)) for m in range(1,93)]
# zero part per row, cumulative in K
Z={}
for m in range(1,93):
    Z[m]=[mpf(0)]
def zterm(m,gam):
    rho=mpc(0.5,gam)
    f=lambda mm: ei(mm*rho*L2) if mm>0 else 0
    return 2*(f(m)-f(m-1)).real
for K in (0,10,100,1000,2000):
    pass
cells=[(r,d) for r in range(12,93) for d in range(1,r) if 2*r<7*d]
res={}
acc=[mpf(0)]*93
done=0
for K in (10,100,1000,2000):
    for gam in g[done:K]:
        for m in range(1,93): acc[m]+=zterm(m,gam)
    done=K
    model=[0]+[float(Rrow[m]-acc[m]) for m in range(1,93)]
    Tm=table(model)
    agree=sum(1 for c in cells if (Tm[c]>0)==(Ttrue[c]>0))
    rel=sorted(abs(Tm[c]-Ttrue[c])/max(abs(Ttrue[c]),1) for c in cells)
    res[K]=(agree,len(cells),float(rel[len(rel)//2]))
    print("K",K,"sign agreement",agree,"of",len(cells),"median rel err",rel[len(rel)//2],flush=True)
model0=[0]+[float(Rrow[m]) for m in range(1,93)]; T0=table(model0)
res[0]=(sum(1 for c in cells if (T0[c]>0)==(Ttrue[c]>0)),len(cells),None)
json.dump({f"K{k}":{"sign_agree":v[0],"cells":v[1],"median_rel_err":v[2]} for k,v in res.items()},open("recon.json","w"),indent=1)
