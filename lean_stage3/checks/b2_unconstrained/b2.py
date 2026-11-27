# B2: Young's (1.3) c(P,Q,R,theta) and kappa = 1 - log(c)/R, optimized over P, Q, R.
import numpy as np
from scipy.optimize import minimize
from numpy.polynomial import polynomial as Pn
g, w = np.polynomial.legendre.leggauss(40); g=(g+1)/2; w=w/2
U,V=np.meshgrid(g,g,indexing='ij'); W=np.outer(w,w)
def c(pc,qc,R,th):
    # pc: coefficients of P (constant first), qc: of Q
    P=Pn.polyval(U,pc); dP=Pn.polyval(U,Pn.polyder(pc))
    Q=Pn.polyval(V,qc); dQ=Pn.polyval(V,Pn.polyder(qc))
    d=R*th*P*Q+dP*Q+th*P*dQ
    return 1+(1/th)*np.sum(W*np.exp(2*R*V)*d**2)
def Kfl(A,B,C,t,R):
    import math
    return B-A/(2*R*t)-R*t*C/2+t*C/2-A/(2*R**2*t)-t*C/(4*R)-A/(4*R**3*t)+math.exp(2*R)*(t*C/(4*R)+A/(4*R**3*t))
print('check Young (1.3) vs Kfl, P=x, Q=1-x, th=.5, R=1.3:', c([0,1],[1,-1],1.3,.5), Kfl(1,.5,1/3,.5,1.3))
def kappa(x,th,dp,dq):
    R=abs(x[0])+1e-6
    a=list(x[1:1+dp-1]); pc=[0]+a+[1-sum(a)]          # P(0)=0, P(1)=1
    b=list(x[dp:dp+dq-1]); qc=[1]+b+[-1-sum(b)] if dq>1 else [1,-1]  # Q(0)=1; Q(1)=0 shape kept free below
    if dq>1: qc=[1]+list(x[dp:dp+dq])
    cc=c(pc,qc,R,th)
    return 1-np.log(cc)/R if cc>0 else -9
for th in [0.5,4/7,1,2,4,8]:
    best=-9
    for dp,dq in [(1,1),(3,1),(3,3)]:
        for s in range(6):
            rng=np.random.default_rng(s); x0=np.r_[1.0+rng.random(),0.3*rng.standard_normal(dp-1+(dq if dq>1 else 0))]
            r=minimize(lambda x:-kappa(x,th,dp,dq),x0,method='Nelder-Mead',options={'maxiter':6000,'xatol':1e-8,'fatol':1e-10})
            if -r.fun>best: best=-r.fun; arg=(dp,dq,np.round(r.x,4))
    print(f'theta={th:.4f} kappa={best:.4f} degP,degQ,x={arg}')
