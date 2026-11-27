"""Size budget for sharper Littlewood constants (PINS 2026-11-25, Turing at scale, goal (b)).

Exploratory sizing, run before any Lean is written. Nothing here is a proof.

The lower side `Turing.StmtHorizLower a2 b2` (Stage3/TuringLWHoriz*.lean) is built from, per
unit of M = log(K_R T) (K_R T bounds |jensenF T| on |z| <= R; K = 84 at R = 15/16):

  * Borel-Caratheodory on the Blaschke quotient, outer radius r (zeros removed in |z| <= r):
      uniform   : (3/2) * 2 r'/(r - r'),  r' = 3/4                     (today: 12 * 3/2 = 18)
      pointwise : int_{1/2}^{2} 2|z(x)|/(r - |z(x)|) dx = 4 (r log(r/(r - 3/4)) - 3/4)
  * the zero count  N <= M / log(R/r)                                   (today: 15, R/r = 15/14)
  * per zero, c_z = -min_beta int log|x - beta| + (3/2) log 2 + (3/2) log(numerator bound):
      int: crude 7/2 (today), sharp (3/2)(1 - log(3/4)) = 1.9315
      numerator |R - z conj(rho)/R| <= 2 (today), or R + (3/4) r / R
  * a2 = C_BC + c_z / log(R/r),  b2 = a2 log K + (3/2) log 3.

Littlewood: a = (3/2 + a2)/pi, b = (2 + (3/2) log 9 + b2)/pi (TuringLWSplit.littlewood_of_lower).
Closing height: the model of checks/signdata/closing_height.py (ideal data and Gram data),
with theta from its asymptotic series (float; the original uses mpmath.siegeltheta; the two
agree to 1e-6 at t >= 100, checked in the first lines of the output).
"""
import math
import mpmath as mp

PI = math.pi


def theta(t):
    return t / 2 * math.log(t / (2 * PI)) - t / 2 - PI / 8 + 1 / (48 * t) + 7 / (5760 * t ** 3)


def gram(n, guess=None):
    # theta(g) = n pi, Newton on the asymptotic theta
    g = guess if guess else max(20.0, 2 * PI * n / max(1.0, math.log(n + 2)))
    for _ in range(60):
        f = theta(g) - n * PI
        d = 0.5 * math.log(g / (2 * PI))
        g2 = g - f / d
        if abs(g2 - g) < 1e-12 * g:
            g = g2
            break
        g = g2
    return g


def K(T1, h, k97):
    return (math.log((T1 + 1 + h) / 2) - math.log(PI) + k97 / T1) / 2


def E_of(a, b, T1, h, S, k97):
    return (a * math.log(T1 + 1 + h) + b - S) / h + h * K(T1, h, k97) / (2 * PI)


def ideal_margin(a, b, T1, h, k97, steps=200):
    th1 = theta(T1)
    # Simpson for int_{T1}^{T1+h} (theta(u) - theta(T1))/pi du
    n = steps
    w = h / n
    s = 0.0
    for i in range(n + 1):
        u = T1 + i * w
        c = 1 if i in (0, n) else (4 if i % 2 else 2)
        s += c * (theta(u) - th1)
    S = s * w / 3 / PI
    return 2 - E_of(a, b, T1, h, S, k97)


def best_h(f, lo, hi, steps=60):
    best = None
    for i in range(steps + 1):
        h = lo + (hi - lo) * i / steps
        m = f(h)
        if best is None or m > best[0]:
            best = (m, h)
    m0, h0 = best
    w = (hi - lo) / steps
    for i in range(41):
        h = h0 - w + 2 * w * i / 40
        if h <= 0:
            continue
        m = f(h)
        if m > best[0]:
            best = (m, h)
    return best


def ideal_crossing(a, b, k97=97.0, lo=5.0, hi=1e7):
    def ok(T1):
        m, _ = best_h(lambda h: ideal_margin(a, b, T1, h, k97), 1, 3 * math.sqrt(T1) + 100)
        return m > 0
    if ok(lo):
        return lo
    for _ in range(60):
        mid = math.sqrt(lo * hi)
        if ok(mid):
            hi = mid
        else:
            lo = mid
        if hi / lo < 1.001:
            break
    return hi


_gcache = {}


def g_(n):
    if n not in _gcache:
        _gcache[n] = gram(n)
    return _gcache[n]


def gram_margin(a, b, n, h, k97):
    T1 = g_(n)
    S = 0.0
    j = 1
    while True:
        g = g_(n + j)
        if g > T1 + h:
            break
        S += T1 + h - g
        j += 1
    return 2 - E_of(a, b, T1, h, S, k97)


def gram_crossing(a, b, k97=97.0):
    def ok(n):
        T1 = g_(n)
        m, _ = best_h(lambda h: gram_margin(a, b, n, h, k97), 1, 3 * math.sqrt(T1) + 100, steps=40)
        return m > 0
    lo, hi = 10, 2_000_000
    if ok(lo):
        return lo, g_(lo)
    while hi - lo > max(5, lo // 400):
        mid = (lo + hi) // 2
        if ok(mid):
            hi = mid
        else:
            lo = mid
    return hi, g_(hi)


def lower_consts(I_z=3.5, numer=2.0, r=7 / 8, R=15 / 16, Kc=84.0, pointwise=False, Ncoef=None):
    rp = 3 / 4
    if pointwise:
        C_BC = 4 * (r * math.log(r / (r - rp)) - rp)
    else:
        C_BC = 1.5 * 2 * rp / (r - rp)
    if numer is None:
        numer = R + rp * r / R
    c_z = I_z + 1.5 * math.log(2) + 1.5 * math.log(numer)
    Nc = Ncoef if Ncoef is not None else 1 / math.log(R / r)
    a2 = C_BC + c_z * Nc
    b2 = a2 * math.log(Kc) + 1.5 * math.log(3)
    return a2, b2, C_BC, c_z, Nc


def littlewood(a2, b2, up_a=1.5, up_b=1.5 * math.log(9), c0=2.0):
    return (up_a + a2) / PI, (c0 + up_b + b2) / PI


if __name__ == "__main__":
    out = []
    # theta check against mpmath
    for t in [100, 1000, 14000]:
        out.append(f"theta check t={t}: asymptotic - siegeltheta = "
                   f"{theta(t) - float(mp.siegeltheta(t)):.2e}")
    a0, b0 = (1.5 + 102) / PI, (2 + 1.5 * math.log(9) + 500) / PI
    out.append(f"baseline a={a0:.4f} b={b0:.4f}: ideal crossing T1 ~ {ideal_crossing(a0, b0):.0f}"
               f" (closing_height.out: 14063); Gram n, g_n ~ {gram_crossing(a0, b0)}"
               f" (closing_height.out: 42284, 34860)")
    out.append("")
    out.append("1. one constant at a time, everything else as today (a, b of Littlewood):")
    out.append(f"{'change':58s} {'a':>8s} {'b':>8s} {'T1 ideal':>9s} {'g_n Gram':>9s}")

    def row(name, a, b, k97=97.0):
        Ti = ideal_crossing(a, b, k97)
        n, g = gram_crossing(a, b, k97)
        out.append(f"{name:58s} {a:8.3f} {b:8.2f} {Ti:9.0f} {g:9.0f}")
        return Ti, g

    row("today (a2 = 102, b2 = 500)", a0, b0)
    a2, b2, *_ = lower_consts()
    row(f"today's route, b2 as computed ({a2:.1f}, {b2:.1f})", *littlewood(a2, b2))
    row("97/t term -> 0", *littlewood(a2, b2), k97=0.0)
    row("upper side 3/2 -> 0 and (3/2) log 9 -> 0", *littlewood(a2, b2, up_a=0, up_b=0))
    row("Osc c0 = 2 -> 0", *littlewood(a2, b2, c0=0))
    x = lower_consts(I_z=1.9315)
    row(f"per-zero int 7/2 -> 1.9315 (a2 {x[0]:.1f})", *littlewood(x[0], x[1]))
    x = lower_consts(numer=None)
    row(f"numerator 2 -> R + 3r/(4R) (a2 {x[0]:.1f})", *littlewood(x[0], x[1]))
    x = lower_consts(pointwise=True)
    row(f"BC pointwise in |z| (a2 {x[0]:.1f})", *littlewood(x[0], x[1]))
    x = lower_consts(Ncoef=1 / math.log(15 / 14))
    row(f"count 15 -> 1/log(15/14) = {1/math.log(15/14):.3f} (a2 {x[0]:.1f})", *littlewood(x[0], x[1]))
    out.append("")
    out.append("2. radii: r optimized at R = 15/16, with sharp int + numerator + pointwise BC:")
    best = None
    for i in range(1, 200):
        r = 0.75 + (15 / 16 - 0.75) * i / 200
        a2, b2, cbc, cz, nc = lower_consts(I_z=1.9315, numer=None, r=r, pointwise=True)
        if best is None or a2 < best[0]:
            best = (a2, b2, r, cbc, cz, nc)
    out.append(f"  best r = {best[2]:.4f}: a2 = {best[0]:.2f} (BC {best[3]:.2f}, c_z {best[4]:.3f},"
               f" count {best[5]:.3f}), b2 = {best[1]:.1f}")
    for r in [0.76, 0.77, 0.78, 0.79, 0.8, 0.8125, 0.8333, 0.875]:
        a2, b2, cbc, cz, nc = lower_consts(I_z=1.9315, numer=None, r=r, pointwise=True)
        u = lower_consts(I_z=1.9315, numer=None, r=r, pointwise=False)
        out.append(f"  r = {r:.4f}: pointwise a2 = {a2:6.2f} b2 = {b2:6.1f}   uniform BC a2 = {u[0]:6.2f}")
    out.append("")
    out.append("3. cumulative (closing height after each):")
    steps = [
        ("today's route", dict()),
        ("+ sharp per-zero int", dict(I_z=1.9315)),
        ("+ numerator R + 3r/(4R)", dict(I_z=1.9315, numer=None)),
        ("+ pointwise BC, r = 7/8", dict(I_z=1.9315, numer=None, pointwise=True)),
        ("+ r = 4/5", dict(I_z=1.9315, numer=None, pointwise=True, r=0.8)),
        ("+ r = 25/32", dict(I_z=1.9315, numer=None, pointwise=True, r=25 / 32)),
    ]
    for name, kw in steps:
        a2, b2, *_ = lower_consts(**kw)
        a, b = littlewood(a2, b2)
        Ti = ideal_crossing(a, b)
        n, g = gram_crossing(a, b)
        out.append(f"  {name:32s} a2 = {a2:6.2f} b2 = {b2:6.1f}  a = {a:6.3f} b = {b:6.2f}"
                   f"  T1 ideal {Ti:7.0f}  Gram n {n:6d} g_n {g:7.0f}")
    out.append("")
    out.append("4. what is left after section 3, each set to zero alone (from r = 25/32 line):")
    a2, b2, *_ = lower_consts(I_z=1.9315, numer=None, pointwise=True, r=25 / 32)
    for name, kw, k97 in [("97/t -> 0", {}, 0.0), ("upper 3/2 -> 0", dict(up_a=0, up_b=0), 97.0),
                          ("c0 -> 0", dict(c0=0), 97.0)]:
        a, b = littlewood(a2, b2, **kw)
        out.append(f"  {name:20s} T1 ideal {ideal_crossing(a, b, k97):7.0f}")
    a, b = littlewood(a2, a2 * math.log(24) + 1.5 * math.log(3))
    out.append(f"  K = 84 -> 24 (|zeta| <= 8T + 40, T large) T1 ideal {ideal_crossing(a, b):7.0f}")
    out.append("")
    out.append("5. literature size (from memory, Trudgian 2011: a ~ 0.059, b ~ 2.07):")
    out.append(f"  T1 ideal {ideal_crossing(0.059, 2.067):.0f}, Gram {gram_crossing(0.059, 2.067)}")
    out.append("")
    out.append("6. after the proof: the constants of LittlewoodSharp.littlewood_sharp (a2 = 113/4, b2 = 128),")
    out.append("   and what the slope term of Turing.theta_sub_le (97/t, goal (a)) would still give:")
    a, b = littlewood(113 / 4, 128)
    for k97 in [97.0, 10.0, 1.0, 0.0]:
        out.append(f"  a = {a:.4f} b = {b:.4f}, slope term {k97:5.1f}/t: T1 ideal "
                   f"{ideal_crossing(a, b, k97):6.0f}, Gram {gram_crossing(a, b, k97)}")
    text = "\n".join(out)
    print(text)
    import os
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "budget.out"), "w") as fh:
        fh.write(text + "\n")
