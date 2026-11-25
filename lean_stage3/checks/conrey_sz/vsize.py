import mpmath as mp
mp.mp.dps = 30
def Lam(s): return mp.pi**(-s/2)*mp.gamma(s/2)*mp.zeta(s)
def GR(s): return mp.pi**(-s/2)*mp.gamma(s/2)
# Q as coefficient list in x; taylor coefficients at 1/2
def taylor(Qc, x0=mp.mpf(1)/2):
    n=len(Qc); b=[]
    for k in range(n):
        # k-th derivative /k!
        s=0
        for j in range(k,n):
            s+= Qc[j]*mp.binomial(j,k)*x0**(j-k)
        b.append(s)
    return b
def V(Qc,L,s):
    b=taylor(Qc)
    W=0
    for k,bk in enumerate(b):
        if bk==0: continue
        W+= bk*(-1/L)**k*mp.diff(Lam,s,k)
    return W/GR(s)
Qs={'lev':[1,-1],'cubic':[1,mp.mpf(1)/2,-3,2]}
for name,Qc in Qs.items():
  for T in [1e2,1e3,1e4,1e6]:
    L=mp.log(T)
    vals=[]
    for f in [0.25,0.5,1,1.5,2]:
        s=mp.mpc(3,f*T)
        v=V(Qc,L,s); vals.append(v)
    print(name,T,[ (mp.nstr(v.real,4),mp.nstr(abs(v),4)) for v in vals])
