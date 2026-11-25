"""Spot check of the reduction V = W/Gammaℝ = Q(-D/L) zeta + E, |E| = O(1/L)."""
import mpmath as mp
mp.mp.dps = 40

# Q = 1 + x/2 - 3x^2 + 2x^3 (OperatorQ.Qcubic)
q = [mp.mpf(1), mp.mpf(1)/2, mp.mpf(-3), mp.mpf(2)]
d = len(q) - 1
def Qev(x): return sum(q[k]*x**k for k in range(d+1))
# Taylor coefficients at 1/2
b = [mp.diff(Qev, mp.mpf(1)/2, k)/mp.factorial(k) for k in range(d+1)]
print("b (taylor at 1/2):", [mp.nstr(x, 8) for x in b])
# Taylor shift identity: q_j = sum_k b_k C(k,j) (-1/2)^(k-j)
for j in range(d+1):
    s = sum(b[k]*mp.binomial(k, j)*(mp.mpf(-1)/2)**(k-j) for k in range(j, d+1))
    print("j", j, "q_j", q[j], "shift", mp.nstr(s, 12))

def Gr(s): return mp.pi**(-s/2)*mp.gamma(s/2)
def Lam(s): return Gr(s)*mp.zeta(s)

def check(T, R=mp.mpf('1.3'), tf=mp.mpf('0.8')):
    L = mp.log(T)
    t = tf*T
    s = mp.mpf(1)/2 - R/L + 1j*t
    # W = sum_k b_k (-1/L)^k Lam^(k)
    lamd = [mp.diff(Lam, s, k) for k in range(d+1)]
    W = sum(b[k]*(-1/L)**k*lamd[k] for k in range(d+1))
    V = W/Gr(s)
    zd = [mp.diff(mp.zeta, s, j) for j in range(d+1)]
    grd = [mp.diff(Gr, s, i)/Gr(s) for i in range(d+1)]
    # exact reduction V = sum_j A_j (-1/L)^j zeta^(j)
    A = [sum(b[k]*mp.binomial(k, j)*(-1/L)**(k-j)*grd[k-j] for k in range(j, d+1)) for j in range(d+1)]
    Vred = sum(A[j]*(-1/L)**j*zd[j] for j in range(d+1))
    Vq = sum(q[j]*(-1/L)**j*zd[j] for j in range(d+1))
    E = V - Vq
    scale = sum(abs(zd[j])/L**j for j in range(d+1))
    # the Gammaℝ ratio: L * |(-1/L)^i Gr^(i)/Gr - (-1/2)^i|
    ratio = [L*abs((-1/L)**i*grd[i] - (mp.mpf(-1)/2)**i) for i in range(d+1)]
    print(f"T={mp.nstr(T,6)} L={mp.nstr(L,5)} |V-Vred|={mp.nstr(abs(V-Vred),3)} |V|={mp.nstr(abs(V),5)} "
          f"|E|={mp.nstr(abs(E),5)} L|E|/scale={mp.nstr(L*abs(E)/scale,5)} ratio*L={[mp.nstr(x,4) for x in ratio]}")

for T in [mp.mpf(10)**3, mp.mpf(10)**5, mp.mpf(10)**8, mp.mpf(10)**12]:
    check(T)
for tf in ['0.25', '1', '2']:
    check(mp.mpf(10)**6, tf=mp.mpf(tf))
