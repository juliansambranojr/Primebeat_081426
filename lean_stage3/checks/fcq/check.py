import sympy as sp, numpy as np
from numpy.polynomial import polynomial as Pn
a,b=sp.symbols('a b')

def young(pc,qc,R,th,n=60):
    g,w=np.polynomial.legendre.leggauss(n); g=(g+1)/2; w=w/2
    U,V=np.meshgrid(g,g,indexing='ij'); W=np.outer(w,w)
    P=Pn.polyval(U,pc); dP=Pn.polyval(U,Pn.polyder(pc))
    Q=Pn.polyval(V,qc); dQ=Pn.polyval(V,Pn.polyder(qc))
    d=R*th*P*Q+dP*Q+th*P*dQ
    return 1+(1/th)*np.sum(W*np.exp(2*R*V)*d**2)

def ABC(pc):
    x=sp.symbols('x'); P=sum(sp.Rational(c)*x**i for i,c in enumerate(pc)); dP=sp.diff(P,x)
    return [sp.integrate(e,(x,0,1)) for e in (dP*dP,dP*P,P*P)]

def kfl_sympy(pc,qc,R,th):
    A,B,C=ABC(pc)
    f=lambda a,b:(A+(a+b)*th*B+a*b*th**2*C)/((a+b)*th)
    F=f(a,b)+sp.exp(-(a+b))*f(-b,-a)
    tot=0
    for k,qk in enumerate(qc):
        for l,ql in enumerate(qc):
            d=F
            if k: d=sp.diff(d,a,k)
            if l: d=sp.diff(d,b,l)
            tot+=sp.Rational(qk)*sp.Rational(ql)*(-1)**(k+l)*d.subs({a:-R,b:-R})
    return sp.nsimplify(tot) if False else tot

def kfl_closed(pc,qc,R,th):
    """returns (r, c) with KflQ = r + c e^{2R}"""
    A,B,C=ABC(pc); R=sp.Rational(R); th=sp.Rational(th)
    N=2*(len(qc)-1)
    ph=[]  # (alpha, beta)
    for n in range(N+1):
        al=(1 if n==0 else 0) - (n*ph[n-1][0] if n else 0)
        be=-(-1)**n - (n*ph[n-1][1] if n else 0)
        ph.append((al/(-2*R), be/(-2*R)))
    r=0; c=0
    P=lambda n:ph[n] if n>=0 else (0,0)
    for k,qk in enumerate(qc):
        for l,ql in enumerate(qc):
            s=sp.Rational(qk)*sp.Rational(ql)*(-1)**(k+l)
            n=k+l
            X=[0,0]
            X[0]+=B*(1 if n==0 else 0); X[1]+=B*(-1)**n
            for i in (0,1):
                X[i]+=A/th*P(n)[i]+th*C*(R**2*P(n)[i]-R*n*P(n-1)[i]+k*l*P(n-2)[i])
            r+=s*X[0]; c+=s*X[1]
    return sp.nsimplify(r), sp.nsimplify(c)

if __name__=='__main__':
    for pc,qc,R,th in [([0,1],[1,-1],'13/10','1/2'),([0,1],[1,-1],'13/10','49/100'),
                       ([0,'1/2','1/4','1/4'],[1,'-1/3','1/2','-1/3'],'6/5','49/100')]:
        Rf=float(sp.Rational(R)); thf=float(sp.Rational(th))
        y=young([float(sp.Rational(x)) for x in pc],[float(sp.Rational(x)) for x in qc],Rf,thf)
        ks=float(kfl_sympy(pc,qc,sp.Rational(R),sp.Rational(th)))
        r,c=kfl_closed(pc,qc,R,th)
        kc=float(r+c*sp.exp(2*sp.Rational(R)))
        print(pc,qc,R,th,'young',y,'sympy',ks,'closed',kc)
