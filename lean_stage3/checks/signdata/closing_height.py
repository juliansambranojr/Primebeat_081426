"""Closing height of Turing's certificate `Turing.defect_zero_of_signs` (Stage3/TuringCert.lean)
with the constants of `TuringLW.littlewood_holds`:
    a = (3/2 + 102)/pi,   b = (2 + (3/2) log 9 + 500)/pi.

The certificate closes at T1 when, for some h > 0 and sign data t_0 < ... < t_k <= T1 and
T1 < s_0 < ... < s_m <= T1 + h,

    hnum:  theta(T1)/pi + 1 + E < k + 2,
    E    = (a log(T1+1+h) + b - sum_{j<m} (T1 + h - s_{j+1}))/h + h K/(2 pi),
    K    = (log((T1+1+h)/2) - log pi + 97/T1)/2.

Two data models, both with every zero below T1 found (k = N(T1)):
  ideal : s_{j+1} just right of the j-th zero above T1; the sum is int_{T1}^{T1+h}(N(u)-N(T1)),
          N replaced by its smooth part theta/pi + 1 (the mean of S is 0); margin = 2 - E.
  gram  : T1 = g_n (theta(g_n) = n pi), k = n + 1 (Gram's law at g_n, S(g_n) = 0), and the s_j
          the Gram points g_{n+j}, j >= 1 (a sign change in each Gram interval); margin = 2 - E.
The script reports, per T1, the best h and the margin, and the crossing heights; and the number
of sign evaluations the certificate then needs: about N(T1) below and N(T1+h) - N(T1) above.
Output saved beside it as closing_height.out.
"""
import mpmath as mp

mp.mp.dps = 20
pi = mp.pi
a = (mp.mpf(3) / 2 + 102) / pi
b = (2 + mp.mpf(3) / 2 * mp.log(9) + 500) / pi


def theta(t):
    return mp.siegeltheta(t)


def K(T1, h):
    return (mp.log((T1 + 1 + h) / 2) - mp.log(pi) + 97 / T1) / 2


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
    # refine
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
    out.append(f"a = {mp.nstr(a, 12)}   b = {mp.nstr(b, 12)}")
    out.append("ideal data (zeros found exactly, s_(j+1) just right of each zero):")
    out.append("      T1      best h    margin   N(T1)   N(T1+h)-N(T1)")
    rows = []
    for T1 in [100, 1000, 3000, 5000, 8000, 10000, 12000, 14000, 16000, 20000, 30000, 50000, 100000]:
        T1 = mp.mpf(T1)
        m, h = best_h(lambda h: ideal_margin(T1, h), 20, 3 * mp.sqrt(T1) + 100)
        rows.append((T1, m, h))
        out.append(f"{float(T1):9.0f}  {float(h):9.1f}  {float(m):8.4f}  {float(Nsm(T1)):8.0f}  "
                   f"{float(Nsm(T1 + h) - Nsm(T1)):8.0f}")
    # crossing by bisection
    lo, hi = mp.mpf(5000), mp.mpf(30000)
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
    for n in [1000, 5000, 10000, 20000, 30000, 50000, 70000, 100000]:
        T1 = mp.grampoint(n)
        m, h = best_h(lambda h: gram_margin(n, h)[0], 20, 3 * mp.sqrt(T1) + 100, steps=20)
        out.append(f"{n:9d}  {float(T1):11.1f}  {float(h):8.1f}  {float(m):7.4f}  "
                   f"{gram_margin(n, h)[1]:6d}")
    lo, hi = 10000, 200000
    while hi - lo > 500:
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
    import os
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "closing_height.out"), "w") as fh:
        fh.write(text + "\n")
