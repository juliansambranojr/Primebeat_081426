import sympy as sp
from fractions import Fraction as Fr
from math import factorial
x=sp.symbols('x')
P=sp.Rational(7,50)*x**3-sp.Rational(1,100)*x**2+sp.Rational(87,100)*x
dP=sp.diff(P,x)
for name,e in [('A',dP*dP),('B',dP*P),('C',P*P)]:
    F=sp.integrate(sp.expand(e),x); print(name, sp.Poly(F,x).all_coeffs()[::-1], 'val', F.subs(x,1))
R=sp.Rational(3,2); E=sp.symbols('E')
q=[1,sp.Rational(-27,50),sp.Rational(-36,25),sp.Rational(24,25)]
ph=[]
for n in range(7):
    al=(1 if n==0 else 0)-(n*ph[n-1] if n else 0)-(-1)**n*E
    ph.append(sp.expand(al/(-2*R)))
P_=lambda n: ph[n]
SB=SA=SC=0
for k in range(4):
    for l in range(4):
        c=q[k]*q[l]*(-1)**(k+l)
        n=l+k
        SB+=c*((1 if n==0 else 0)+(-1)**n*E)
        SA+=c*ph[n]
        km1=max(k-1,0); lm1=max(l-1,0)
        SC+=c*((-R)*((-R)*ph[l+k]+k*ph[l+km1])+l*((-R)*ph[lm1+k]+k*ph[lm1+km1]))
for nm,v in [('SB',SB),('SA',SA),('SC',SC)]:
    v=sp.expand(v); print(nm, v.coeff(E,0), v.coeff(E,1))
A=sp.Rational(152147,150000);B=sp.Rational(1,2);C=sp.Rational(89707,300000);th=sp.Rational(49,100)
K=sp.expand(B*SB+A/th*SA+th*C*SC); r=K.coeff(E,0); c=K.coeff(E,1); print('r',r,'c',c)
k0=Fr(224,625); y=Fr(3,2)*(1-k0); print('y',y)
lo2=sum(y**m/factorial(m) for m in range(12)); xh=Fr(1,2); n=8
up=sum(xh**m/factorial(m) for m in range(n))+xh**n*(n+1)/(factorial(n)*n); lo=sum(xh**m/factorial(m) for m in range(n))
rF=Fr(int(sp.numer(r)),int(sp.denom(r))); cF=Fr(int(sp.numer(c)),int(sp.denom(c)))
print('Kup',float(rF+cF*up**6),'lo2',float(lo2), rF+cF*up**6<lo2, rF+cF*lo**6>0)
print('rem', xh**n*(n+1)/(factorial(n)*n))
