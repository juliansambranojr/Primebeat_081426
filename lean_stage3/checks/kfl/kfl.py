import sympy as sp, mpmath as mp
a,b,A,B,C,th,R=sp.symbols('a b A B C theta R')
f=lambda a,b: (A+(a+b)*th*B+a*b*th**2*C)/((a+b)*th)
F=f(a,b)+sp.exp(-(a+b))*f(-b,-a)
D=F+sp.diff(F,a)+sp.diff(F,b)+sp.diff(F,a,b)
Dv=sp.simplify(D.subs({a:-R,b:-R}))
mine=B-A/(2*R*th)-R*th*C/2+th*C/2-A/(2*R**2*th)-th*C/(4*R)-A/(4*R**3*th)+sp.exp(2*R)*(th*C/(4*R)+A/(4*R**3*th))
print(sp.simplify(Dv-mine))
mp.mp.dps=30
K=lambda th,R: float(mine.subs({A:1,B:sp.Rational(1,2),C:sp.Rational(1,3),'theta':th,'R':R}))
for t in [0.5,0.49]:
  for r in [1.3]:
    k=K(t,r); print(t,r,k,1-mp.log(k)/r)
# optimum over R at theta=0.5
best=max(((1-mp.log(K(0.5,r))/r),r) for r in [1+i/1000 for i in range(600)]); print(best)
