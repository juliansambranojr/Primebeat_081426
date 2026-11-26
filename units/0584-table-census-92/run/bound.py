# Exploratory, written by the adversary review of 2026-11-26 and copied here as run:
# where a bound on |pi - Li| makes every depth-d cell of the dyadic table provably
# positive. The li-model cell must exceed the budget sum_k C(d+1,k) eps(2^(r-k)) 2^(r-k)/((r-k) ln 2).
# FKS2 Table 6 row 1 is PNT+ IEANTN/FKS2.lean (stated there with sorry); Trudgian's
# constants are from memory; Schoenfeld's bound assumes RH.
import json
import mpmath as mp
from math import comb
mp.mp.dps=60
ln2=mp.log(2); Rr=mp.mpf('5.5666305')
def Li(j): return mp.li(mp.mpf(2)**j)
def licell(r,d): return mp.fsum((-1)**k*comb(d+1,k)*Li(r-k) for k in range(d+2))
B={
 'FKS2cor22 9.2211L^1.5e^-.8476sqrtL':lambda L: 9.2211*L**1.5*mp.exp(-0.8476*mp.sqrt(L)),
 'Trudgian16 (memory) .2795L^.25e^-sqrt(L/6.455)':lambda L: 0.2795*L**0.25*mp.exp(-mp.sqrt(L/6.455)),
 'FKS2 table6 row1':lambda L: (0.000120*(L/Rr)**0.25*mp.exp(-mp.sqrt(L/Rr))) if L>=22.955 else mp.inf,
 'RH Schoenfeld L^2/(8pi sqrt x)':lambda L: L**2/(8*mp.pi*mp.sqrt(mp.e**L)),
}
def ok(r,d,eps):
    err=mp.fsum(comb(d+1,k)*eps((r-k)*ln2)*mp.mpf(2)**(r-k)/((r-k)*ln2) for k in range(d+2))
    return licell(r,d)>err, licell(r,d)/err
out={}
for name,eps in B.items():
    for d in [0,3,6,9,12]:
        # last failing r up to 3000
        last=None
        for r in range(d+3,3001,1 if d<7 else 1):
            if not ok(r,d,eps)[0]: last=r
        m=float(ok(63,d,eps)[1])
        out[f"{name.split()[0]}_d{d}_last_failing"]=last; out[f"{name.split()[0]}_d{d}_margin63"]=m
        print(f"{name:48s} d={d:2d} last failing r<=3000: {last}  margin@r=63: {m:.4g}")
json.dump(out,open("bound.json","w"),indent=1)
