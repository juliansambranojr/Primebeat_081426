import sympy as sp
from fractions import Fraction as Fr
from math import factorial
from check import ABC, kfl_closed
pc=[0,'87/100','-1/100','7/50']; qc=[1,'-27/50','-36/25','24/25']; R=sp.Rational(3,2); th=sp.Rational(49,100)
A,B,C=ABC(pc); print('A B C',A,B,C)
# ph values
ph=[]
for n in range(7):
    al=(1 if n==0 else 0)-(n*ph[n-1][0] if n else 0); be=-(-1)**n-(n*ph[n-1][1] if n else 0)
    ph.append((sp.nsimplify(al/(-2*R)),sp.nsimplify(be/(-2*R))))
for n,p in enumerate(ph): print('ph',n,p)
r,c=kfl_closed(pc,qc,'3/2','49/100'); print('r',r,'c',c, float(r), float(c))
K=r+c*sp.exp(3); print('K',sp.N(K,20),'kappa',sp.N(1-sp.log(K)/R,20))
x=Fr(1,2); n=8
up=sum(x**m/factorial(m) for m in range(n))+x**n*(n+1)/(factorial(n)*n)
lo=sum(x**m/factorial(m) for m in range(n))
y=Fr(963,1000); lo2=sum(y**m/factorial(m) for m in range(12))
rF=Fr(int(sp.numer(r)),int(sp.denom(r))); cF=Fr(int(sp.numer(c)),int(sp.denom(c)))
print('up^6',float(up**6),'lo^6',float(lo**6),'e3',float(sp.exp(3)))
print('K upper',float(rF+cF*up**6),'e^.963 lower',float(lo2), 'ok', rF+cF*up**6<lo2, 'pos', rF+cF*lo**6>0)
print('up',up,'lo',lo)
