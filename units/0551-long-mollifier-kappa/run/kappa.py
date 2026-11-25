# B2 with Feng's Lemma 1 condition Q'(x) = Q'(1-x): Q(x) = q0 + d1(1-2x) + d3(1-2x)^3, Q(0) = 1.
import numpy as np
from scipy.optimize import minimize
from numpy.polynomial import polynomial as Pn
g, w = np.polynomial.legendre.leggauss(40); g=(g+1)/2; w=w/2
U,V=np.meshgrid(g,g,indexing='ij'); W=np.outer(w,w)
def c(pc,qc,R,th):
    P=Pn.polyval(U,pc); dP=Pn.polyval(U,Pn.polyder(pc))
    Q=Pn.polyval(V,qc); dQ=Pn.polyval(V,Pn.polyder(qc))
    d=R*th*P*Q+dP*Q+th*P*dQ
    return 1+(1/th)*np.sum(W*np.exp(2*R*V)*d**2)
def qpoly(q0,d3):
    d1=1-q0-d3
    # (1-2x) = [1,-2]; (1-2x)^3 = [1,-6,12,-8]
    return [q0+d1+d3, -2*d1-6*d3, 12*d3, -8*d3]
def kappa(x,th,dp,dq):
    R=abs(x[0])+1e-6
    a=list(x[1:dp]); pc=[0]+a+[1-sum(a)]
    if dq==1: qc=qpoly(0.5,0.0)          # Levinson's 1 - x
    elif dq==2: qc=qpoly(x[dp],0.0)      # q0 free, linear
    else: qc=qpoly(x[dp],x[dp+1])
    cc=c(pc,qc,R,th); return 1-np.log(cc)/R if cc>0 else -9
import json; res={"levinson_shift": 1.3, "levinson_check": kappa([1.3],0.5,1,1)}
for th in [0.5,4/7,1,2,4,8,16]:
    for dp,dq in [(1,1),(3,1),(3,3)]:
        best=-9
        for s in range(8):
            rng=np.random.default_rng(s); n=(dp-1)+(0 if dq==1 else (1 if dq==2 else 2))
            x0=np.r_[0.5+1.5*rng.random(),0.3*rng.standard_normal(n)]
            if dq==3: x0[dp]=0.5+0.1*rng.standard_normal()
            r=minimize(lambda x:-kappa(x,th,dp,dq),x0,method='Nelder-Mead',options={'maxiter':8000,'xatol':1e-9,'fatol':1e-11})
            best=max(best,-r.fun)
        res[f'theta_{th:.4f}_{"linear" if dp==1 else "cubicP"}_{"Qlin" if dq==1 else "Qcubic"}']=round(best,4)
json.dump(res,open('results.json','w'),indent=1)
