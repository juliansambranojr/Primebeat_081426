import mpmath as mp, math
mp.mp.dps = 20
def qpoly(q0, d3):
    d1 = 1 - q0 - d3
    return [q0 + d1 + d3, -2 * d1 - 6 * d3, 12 * d3, -8 * d3]
QS = {"lev":[1.0,-1.0], "Q0":[1.0,-0.54,-1.44,0.96], "m02":qpoly(0.5,-0.2), "p02":qpoly(0.5,0.2), "q03":qpoly(0.3,0.0)}
def taylor_half(q):
    # coefficients b_k of Q(1/2 + y)
    n=len(q); b=[0.0]*n
    for i,c in enumerate(q):
        for k in range(i+1):
            b[k]+= c*math.comb(i,k)*0.5**(i-k)
    return b
def zd(s,k): return mp.zeta(s,derivative=k)
def V_script(q,L):
    def V(s): return mp.fsum(q[k]*(-1.0/L)**k*zd(s,k) for k in range(len(q)))
    return V
def V_lean(q,L):
    b=taylor_half(q)
    def V(s):
        w=s/2
        g=-mp.log(mp.pi)/2+mp.digamma(w)/2
        g1=mp.polygamma(1,w)/4; g2=mp.polygamma(2,w)/8
        Gr=[1,g,g*g+g1,g**3+3*g*g1+g2]  # G^(j)/G
        z=[zd(s,k) for k in range(len(q))]
        tot=0
        for k in range(len(b)):
            lk=sum(math.comb(k,j)*Gr[j]*z[k-j] for j in range(k+1))
            tot+=b[k]*(-1.0/L)**k*lk
        return tot
    return V
def seg_wind(f,a,b,fa=None,fb=None,depth=0):
    fa=f(a) if fa is None else fa; fb=f(b) if fb is None else fb
    d=float(mp.arg(fb/fa))
    if abs(d)<0.3 or depth>14: return d
    m=(a+b)/2; fm=f(m)
    return seg_wind(f,a,m,fa,fm,depth+1)+seg_wind(f,m,b,fm,fb,depth+1)
def winding(f,x0,x1,y0,y1,n=6):
    c=[mp.mpc(x0,y0),mp.mpc(x1,y0),mp.mpc(x1,y1),mp.mpc(x0,y1),mp.mpc(x0,y0)]
    tot=0
    for i in range(4):
        pts=[c[i]+(c[i+1]-c[i])*k/n for k in range(n+1)]
        for k in range(n): tot+=seg_wind(f,pts[k],pts[k+1])
    return tot/(2*math.pi)
