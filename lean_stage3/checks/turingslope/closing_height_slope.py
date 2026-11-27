"""Copy of checks/littlewoodsharp/closing_height_sharp.py with the slope of
`TuringSlope.theta_sub_le_sharp80` (Stage3/TuringSlope.lean) in place of the 97/t of
`Turing.theta_sub_le`:

    old  K = (log((T1+1+h)/2) - log pi + 97/T1)/2
    new  K = log((T1+1+h)/(2 pi))/2 + c/T1,     c = 4/5 (T1 >= 80), c = 1 (T1 >= 5)

and the constants of `LittlewoodSharp.littlewood_sharp`:
    a = (3/2 + 113/4)/pi,   b = (2 + (3/2) log 9 + 128)/pi.
Only K, the bisection brackets (the crossing is now below 500) and the output name changed.

Part 0 checks the sizes behind the proof before proving: the pointwise bound
    Re psi(1/4 + iv/2) <= log(v/2) + pi/(2v) + 17/(8v^2)         (v >= 1, `phasePoint_le`)
and the slope constants pi/4 + 17/(16 t) <= c at t = 5 (c = 1) and t = 80 (c = 4/5).

The certificate closes at T1 when, for some h > 0 and sign data t_0 < ... < t_k <= T1 and
T1 < s_0 < ... < s_m <= T1 + h,
    hnum':  theta(T1)/pi + 1 + E' < k + 2,
    E'    = (a log(T1+1+h) + b - sum_{j<m} (T1 + h - s_{j+1}))/h + h K/(2 pi).
Data models as in the original (ideal: every zero found; Gram: T1 = g_n, s_j = g_{n+j}).
Output saved beside it as closing_height_slope.out.
"""
import os
import sys
import mpmath as mp

mp.mp.dps = 20
pi = mp.pi
a = (mp.mpf(3) / 2 + mp.mpf(113) / 4) / pi
b = (2 + mp.mpf(3) / 2 * mp.log(9) + 128) / pi
C = mp.mpf(sys.argv[1]) if len(sys.argv) > 1 else mp.mpf(4) / 5


def theta(t):
    return mp.siegeltheta(t)


def K(T1, h):
    return mp.log((T1 + 1 + h) / (2 * pi)) / 2 + C / T1


def E_of(T1, h, S):
    return (a * mp.log(T1 + 1 + h) + b - S) / h + h * K(T1, h) / (2 * pi)


def ideal_margin(T1, h):
    th1 = theta(T1)
    S = mp.quad(lambda u: (theta(u) - th1) / pi, [T1, T1 + h])
    return 2 - E_of(T1, h, S)


def gram_margin(n, h):
    T1 = mp.grampoint(n)
    S = 0
    j = 1
    while True:
        g = mp.grampoint(n + j)
        if g > T1 + h:
            break
        S += T1 + h - g
        j += 1
    return 2 - E_of(T1, h, S), j - 1


def best_h(f, lo, hi, steps=40):
    best = None
    for i in range(steps + 1):
        h = lo + (hi - lo) * i / steps
        m = f(h)
        if best is None or m > best[0]:
            best = (m, h)
    m0, h0 = best
    w = (hi - lo) / steps
    for i in range(21):
        h = h0 - w + 2 * w * i / 20
        if h <= 0:
            continue
        m = f(h)
        if m > best[0]:
            best = (m, h)
    return best


def Nsm(t):
    return theta(t) / pi + 1


if __name__ == "__main__":
    out = []
    out.append("0. sizes before proving")
    out.append("   v      Re psi(1/4+iv/2) - log(v/2)    bound pi/(2v) + 17/(8v^2)")
    worst = None
    for v in [1, 1.5, 2, 3, 5, 10, 20, 50, 100, 1000]:
        v = mp.mpf(v)
        lhs = mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * v / 2)) - mp.log(v / 2)
        rhs = pi / (2 * v) + mp.mpf(17) / (8 * v ** 2)
        assert lhs <= rhs, v
        out.append(f"{float(v):7.1f}   {float(lhs):+.6e}                  {float(rhs):.6e}")
    for t0, c in [(5, 1), (80, mp.mpf(4) / 5)]:
        val = pi / 4 + mp.mpf(17) / (16 * t0)
        out.append(f"   slope constant at t = {t0}: pi/4 + 17/(16 t) = {mp.nstr(val, 8)} <= c = {mp.nstr(c, 3)}: {val <= c}")
    out.append(f"   with pi < 3.1416: 3.1416/4 + 17/80 = {3.1416/4 + 17/80:.6f}, 3.1416/4 + 17/1280 = {3.1416/4 + 17/1280:.6f}")
    out.append("")
    out.append(f"slope c = {mp.nstr(C, 6)}   a = {mp.nstr(a, 12)}   b = {mp.nstr(b, 12)}")
    out.append("ideal data (zeros found exactly, s_(j+1) just right of each zero):")
    out.append("      T1      best h    margin   N(T1)   N(T1+h)-N(T1)")
    for T1 in [100, 200, 300, 400, 450, 500, 1000, 2000, 5000, 10000]:
        T1 = mp.mpf(T1)
        m, h = best_h(lambda h: ideal_margin(T1, h), 20, 3 * mp.sqrt(T1) + 100)
        out.append(f"{float(T1):9.0f}  {float(h):9.1f}  {float(m):8.4f}  {float(Nsm(T1)):8.0f}  "
                   f"{float(Nsm(T1 + h) - Nsm(T1)):8.0f}")
    lo, hi = mp.mpf(100), mp.mpf(2000)
    for _ in range(20):
        mid = (lo + hi) / 2
        m, h = best_h(lambda h: ideal_margin(mid, h), 20, 3 * mp.sqrt(mid) + 100, steps=30)
        if m > 0:
            hi = mid
        else:
            lo = mid
    m, h = best_h(lambda h: ideal_margin(hi, h), 20, 3 * mp.sqrt(hi) + 100)
    out.append(f"ideal crossing: T1 ~ {float(hi):.0f}, h ~ {float(h):.0f}, margin {float(m):.4f}, "
               f"sign points ~ {float(Nsm(hi)):.0f} below + {float(Nsm(hi + h) - Nsm(hi)):.0f} above")
    out.append("")
    out.append("Gram data (T1 = g_n, s_j = g_(n+j)):")
    out.append("        n          g_n    best h   margin  Gram pts above")
    for n in [200, 500, 800, 900, 1000, 2000, 5000]:
        T1 = mp.grampoint(n)
        m, h = best_h(lambda h: gram_margin(n, h)[0], 20, 3 * mp.sqrt(T1) + 100, steps=20)
        out.append(f"{n:9d}  {float(T1):11.1f}  {float(h):8.1f}  {float(m):7.4f}  "
                   f"{gram_margin(n, h)[1]:6d}")
    lo, hi = 100, 5000
    while hi - lo > 5:
        mid = (lo + hi) // 2
        T1 = mp.grampoint(mid)
        m, h = best_h(lambda h: gram_margin(mid, h)[0], 20, 3 * mp.sqrt(T1) + 100, steps=16)
        if m > 0:
            hi = mid
        else:
            lo = mid
    T1 = mp.grampoint(hi)
    m, h = best_h(lambda h: gram_margin(hi, h)[0], 20, 3 * mp.sqrt(T1) + 100)
    out.append(f"Gram crossing: n ~ {hi}, T1 = g_n ~ {float(T1):.0f}, h ~ {float(h):.0f}, "
               f"margin {float(m):.4f}, sign points ~ {hi + 1} below + {gram_margin(hi, h)[1] + 1} above")
    text = "\n".join(out)
    print(text)
    name = "closing_height_slope.out" if len(sys.argv) <= 1 else f"closing_height_slope_c{sys.argv[1]}.out"
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), name), "w") as fh:
        fh.write(text + "\n")
