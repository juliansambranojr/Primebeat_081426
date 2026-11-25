import numpy as np, json
from scipy.optimize import minimize
exec(open('kappa_orig.py').read().split('import json')[0])
th=0.49
out={}
for dp,dq in [(1,3),(3,3)]:
    best=(-9,None)
    for s in range(12):
        rng=np.random.default_rng(s); n=(dp-1)+2
        x0=np.r_[0.5+1.5*rng.random(),0.3*rng.standard_normal(n)]
        x0[dp]=0.5+0.1*rng.standard_normal()
        r=minimize(lambda x:-kappa(x,th,dp,dq),x0,method='Nelder-Mead',options={'maxiter':20000,'xatol':1e-10,'fatol':1e-12})
        if -r.fun>best[0]: best=(-r.fun,r.x)
    x=best[1]; a=list(x[1:dp]); pc=[0]+a+[1-sum(a)]; qc=qpoly(x[dp],x[dp+1])
    print(dp,dq,best[0],'R',x[0],'pc',pc,'qc',qc)
