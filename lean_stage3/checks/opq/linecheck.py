import mpmath as mp
mp.mp.dps = 30
def GR(s): return mp.pi**(-s/2)*mp.gamma(s/2)
def zd(s,k): return mp.diff(mp.zeta, s, k)
def V(s, q, L):  # q = coefficients of Q in x; V = sum q_k (-1/L)^k zeta^(k)
    return sum(qk*(-1/L)**k*zd(s,k) for k,qk in enumerate(q))
def Lam(s): return GR(s)*mp.zeta(s)
def W(s, b, L):  # b = Taylor coeffs of Q at 1/2; W = sum b_k (-1/L)^k Lam^(k)
    return sum(bk*(-1/L)**k*mp.diff(Lam, s, k) for k,bk in enumerate(b))
L = mp.log(1000)
for gamma in [mp.zetazero(1).imag, mp.zetazero(5).imag]:
    s = mp.mpf(1)/2 + 1j*gamma
    for name,q,b in [("linear 1-x",[1,-1],[mp.mpf(1)/2,-1]),
                     ("cubic c=2", [1,-1+2*mp.mpf(3)/4, -3*2*mp.mpf(1)/2, 2],  # 1-x+2((x-1/2)^3+1/8) expanded
                                   [mp.mpf(1)/2+2*mp.mpf(1)/8, -1, 0, 2])]:
        F = (GR(s)*V(s,q,L)).real
        print(name, "gamma=%.6f" % gamma, "Re(GR*V) at zeta zero:", mp.nstr(F,8),
              " Re W at zero:", mp.nstr(W(s,b,L).real,8), " |GR*zeta'|:", mp.nstr(abs(GR(s)*zd(s,1)),6))
