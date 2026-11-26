# Exploratory: the defect count D(T) = (all zeros with 0 < t <= T) - (sign
# changes of the Hardy-type Z on the line up to T), for the Davenport-Heilbronn
# function f and, as the control, for zeta, at T = 5, 10, ..., 130.
# f and Z are those of O80_dh_zeros.py (repo root): f(s) = 5^{-s} sum_j a_j
# zeta(s, j/5), a = (1, tau, -tau, -1), completed by (5/pi)^{s/2} Gamma((s+1)/2).
# "All zeros" by the argument principle: the winding of the completed function
# around [-0.6, 1.6] x [0.5, T], each edge subdivided until the change of
# argument per segment is below 0.3, edges started at spacing 0.05, counted
# strip by strip (height 5) and summed. O80 found off-line zeros of f near
# t = 85.70 and t = 114.16; the defect should jump there by 2 each.
import json, math
import mpmath as mp

mp.mp.dps = 20
TAU = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
A = {1: mp.mpf(1), 2: TAU, 3: -TAU, 4: mp.mpf(-1)}

def f_dh(s):
    return 5 ** (-s) * sum(A[j] * mp.zeta(s, mp.mpf(j) / 5) for j in (1, 2, 3, 4))

def xi_dh(s):
    return (5 / mp.pi) ** (s / 2) * mp.gamma((s + 1) / 2) * f_dh(s)

def Z_dh(t):
    s = mp.mpf(0.5) + 1j * t
    th = mp.arg((5 / mp.pi) ** (s / 2) * mp.gamma((s + 1) / 2))
    return mp.re(mp.exp(1j * th) * f_dh(s))

def xi_z(s):
    return s * (s - 1) / 2 * mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.zeta(s)

def Z_z(t):
    return mp.siegelz(t)

def seg(F, a, b, Fa, Fb, depth=0):
    d = float(mp.arg(Fb / Fa))
    if abs(d) < 0.3 or depth > 18:
        return d
    m = (a + b) / 2; Fm = F(m)
    return seg(F, a, m, Fa, Fm, depth + 1) + seg(F, m, b, Fm, Fb, depth + 1)

def winding(F, x0, x1, y0, y1, h=0.05):
    """Winding of F around the rectangle; each edge starts at spacing <= h, so
    no edge segment can hide a full turn (the first run's 40 points per edge
    were about 3 apart at height 130 and lost whole turns)."""
    c = [mp.mpc(x0, y0), mp.mpc(x1, y0), mp.mpc(x1, y1), mp.mpc(x0, y1), mp.mpc(x0, y0)]
    tot = 0.0
    for i in range(4):
        n = max(8, math.ceil(abs(complex(c[i + 1] - c[i])) / h))
        pts = [c[i] + (c[i + 1] - c[i]) * k / n for k in range(n + 1)]
        vals = [F(p) for p in pts]
        for k in range(n):
            tot += seg(F, pts[k], pts[k + 1], vals[k], vals[k + 1])
    return tot / (2 * math.pi)

def sign_changes(Z, t0, t1, step):
    out, t, prev = [], mp.mpf(t0), Z(mp.mpf(t0))
    while t < t1:
        t2 = t + step; cur = Z(t2)
        if prev * cur < 0:
            out.append(float(mp.findroot(Z, (t, t2), solver="bisect", tol=1e-12)))
        t, prev = t2, cur
    return out

res = {"tau": float(TAU), "x0": -0.6, "x1": 1.6, "y0": 0.5, "zstep": 0.01}
for name, xi, Z in (("dh", xi_dh, Z_dh), ("zeta", xi_z, Z_z)):
    line = sign_changes(Z, 0.5, 130, mp.mpf("0.01"))
    res[f"{name}_line_zeros"] = line
    # strips [y, y + 5] summed: the shared horizontal edges cancel
    allc, wsum, y = 0, 0.0, 0.5
    for T in range(5, 131, 5):
        w_strip = winding(xi, -0.6, 1.6, y, T)
        y = T
        wsum += w_strip
        res[f"{name}_T{T}_strip_winding"] = w_strip
        w = wsum
        allc = round(w)
        lc = sum(1 for g in line if g <= T)
        res[f"{name}_T{T}_winding"] = w
        res[f"{name}_T{T}_all"] = allc
        res[f"{name}_T{T}_line"] = lc
        res[f"{name}_T{T}_defect"] = allc - lc
        print(name, T, round(w, 4), allc, lc, allc - lc, flush=True)
json.dump(res, open("results.json", "w"), indent=1)
