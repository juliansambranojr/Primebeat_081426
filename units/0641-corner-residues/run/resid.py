"""pi(2^m) modulo small primes and the harmonic structure (after unit 0617). EXPLORATORY.
 1. Do the residues of pi(2^m) and of the rows a(m) = pi(2^m) - pi(2^(m-1)), m <= 92, modulo 2, 3, 5, 7 depend on
    the harmonic structure? Predictors at each row, from Odlyzko's first 100000 zeros: the sign of the whole zero
    sum, the sign of the near-harmonic part (zeros with cos(gamma log 2) < 0), the parity of m, and the leader's
    phase gamma_1 m log 2 in p bins. Chi-square of the contingency table, p-value by 20000 row permutations.
 2. The precision a residue needs: Riemann's explicit formula pi(x) = R(x) - sum_rho R(x^rho) - 1/log x
    + arctan(pi/log x)/pi, with R(x^rho) truncated to its first five Moebius terms, at K = 2000, 10000, 100000
    zeros. Up to which row does it round to the exact pi(2^m), and how does its error grow with the row.
 3. One exact identity for pi(x) mod 2: 2^omega(n) is 1 at n = 1, 2 at a prime power, divisible by 4 otherwise,
    so S(x) = sum_{n<=x} 2^omega(n) = 1 + 2 Pi(x) mod 4, Pi the count of prime powers; and
    S(x) = sum_{e<=sqrt x} mu(e) D(x/e^2), D(y) = sum_{n<=y} tau(n) = 2 sum_{k<=sqrt y} floor(y/k) - floor(sqrt y)^2,
    a lattice count under hyperbolas in about sqrt(x) log x steps. Checked against the pi list for every row it
    can reach here, timed, and its remainder after the main term measured against x^(1/4) and x^(1/2)."""
import json, math, time
import numpy as np
from scipy.special import exp1
from mpmath import mp, mpf, riemannr, zeta, euler, log as mlog, diff
L2 = math.log(2)
pi = [int(x) for x in open('pi_2pow.txt')]; M = 92
a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
g = np.loadtxt('../../../imported/twin_count/zeros1.txt')
near = np.cos(g * L2) < 0
ms = np.arange(1, M + 1)
MU = {1: 1, 2: -1, 3: -1, 4: 0, 5: -1}
# explicit-formula pieces per row, accumulated by zero count
KS = (2000, 10000, 100000)
zsum = {K: np.zeros(M) for K in KS}; zn = np.zeros(M); zall = np.zeros(M)
for k0 in range(0, len(g), 5000):
    gg = g[k0:k0 + 5000]; rho = 0.5 + 1j * gg
    T = np.zeros((M, len(gg)))
    for nn, mu in MU.items():
        if mu == 0: continue
        z = ms[:, None] * rho[None, :] * L2 / nn
        T += (mu / nn) * 2 * (-exp1(-z) + 1j * math.pi).real     # R(x^rho) + R(x^conj rho)
    for K in KS:
        if k0 < K: zsum[K] += T[:, :max(0, min(5000, K - k0))].sum(1)
    zn += T[:, near[k0:k0 + 5000]].sum(1); zall += T.sum(1)
mp.dps = 50
# the smooth part less the exact count, formed in high precision: pi(2^92) is not a float
smooth_less_pi = np.array([float(riemannr(mpf(2) ** m) - 1 / (m * mlog(2)) + mp.atan(mp.pi / (m * mlog(2))) / mp.pi - pi[m]) for m in ms])
out = {}
# 2. the precision bar
prec = {}
for K in KS:
    err = smooth_less_pi - zsum[K]                # model less pi(2^m); row 1 is x = 2, a prime, where the formula gives 1/2
    exact = np.abs(err) < 0.5
    bad = ms[(~exact) & (ms >= 2)]
    big = ms >= 30
    sl = float(np.polyfit(ms[big], np.log2(np.abs(err[big])), 1)[0])
    prec[f"K{K}"] = {"exact_from_row2_through": int(bad[0] - 1) if len(bad) else M, "exact_rows_2_92": int(exact[1:].sum()),
        "abs_err_row40": float('%.3g' % abs(err[39])), "abs_err_row92": float('%.3g' % abs(err[91])),
        "log2_err_slope_rows30_92": round(sl, 3),
        "parity_right_rows41_92": int(((np.round(err[40:]) % 2) == 0).sum())}
prec["rows41_92"] = M - 40
out["precision"] = prec
# 1. residues against harmonic predictors
rng = np.random.default_rng(20261127)
osc_model = -zall
pred = {"sign_zero_sum": (osc_model > 0).astype(int), "sign_near_harmonic": (-zn > 0).astype(int), "parity_m": ms % 2}
def chi2(x, y):
    tab = np.zeros((x.max() + 1, y.max() + 1))
    np.add.at(tab, (x, y), 1)
    e = tab.sum(1, keepdims=True) * tab.sum(0, keepdims=True) / tab.sum()
    ok = e > 0
    return float((((tab - e) ** 2)[ok] / e[ok]).sum())
res = {}; pmin = 1.0; ntests = 0
for p in (2, 3, 5, 7):
    for name_s, seq in (("pi", np.array(pi[1:])), ("row", np.array(a[1:]))):
        x = np.array([int(v) % p for v in seq])
        preds = dict(pred); preds["leader_phase_bin"] = (((g[0] * ms * L2) % (2 * math.pi)) / (2 * math.pi) * p).astype(int)
        for pn, y in preds.items():
            c = chi2(x, y)
            perm = np.array([chi2(x, rng.permutation(y)) for _ in range(20000)])
            pv = float((perm >= c).mean()); pmin = min(pmin, pv); ntests += 1
            res[f"{name_s}_mod{p}.{pn}"] = round(pv, 4)
out["residue_pvalues"] = res; out["residue_tests"] = ntests; out["residue_pvalue_min"] = round(pmin, 4)
out["residue_pvalue_below_0.05"] = int(sum(v < 0.05 for v in res.values()))
# uniformity of the residues themselves
out["pi_mod3_counts"] = [int(sum(1 for v in pi[1:] if v % 3 == j)) for j in range(3)]
out["pi_mod2_counts"] = [int(sum(1 for v in pi[1:] if v % 2 == j)) for j in range(2)]
# 3. the exact parity identity
def mobius_upto(N):
    mu = np.ones(N + 1, dtype=np.int8); isc = np.zeros(N + 1, dtype=bool)
    for q in range(2, N + 1):
        if not isc[q]:
            isc[q * q::q] = True; mu[q::q] *= -1; mu[q * q::q * q] = 0
    mu[0] = 0; return mu
def primes_upto(N):
    s = np.ones(N + 1, dtype=bool); s[:2] = False
    for q in range(2, int(N ** 0.5) + 1):
        if s[q]: s[q * q::q] = False
    return s
def D(y):
    if y <= 0: return 0
    s = math.isqrt(y); k = np.arange(1, s + 1, dtype=np.int64); q = y // k
    tot = 0
    for c in range(0, len(q), 1 << 20): tot += int(q[c:c + (1 << 20)].sum())
    return 2 * tot - s * s
MMAX = 46
sq = math.isqrt(2 ** MMAX)
mu_all = mobius_upto(sq); isp = primes_upto(sq); pcum = np.cumsum(isp)
def S_of(x):
    s = math.isqrt(x); c = int(round(x ** (1 / 3))) + 2
    tot = 0
    for e in range(1, min(c, s) + 1):
        if mu_all[e]: tot += int(mu_all[e]) * D(x // (e * e))
    if s > c:
        Y = x // ((c + 1) ** 2) + 1
        tau = np.zeros(Y + 1, dtype=np.int64)
        for k in range(1, Y + 1): tau[k::k] += 1
        Dt = np.cumsum(tau)
        e = np.arange(c + 1, s + 1, dtype=np.int64); y = x // (e * e)
        tot += int((mu_all[c + 1:s + 1].astype(np.int64) * Dt[y]).sum())
    return tot
def iroot(x, k):
    y = int(round(x ** (1.0 / k)))
    while y ** k > x: y -= 1
    while (y + 1) ** k <= x: y += 1
    return y
def pi_small(y): return int(pcum[y]) if y >= 2 else 0
ident = {}; agree = 0; times = {}
zeta2 = zeta(2); dz2 = diff(zeta, 2)
for m in range(2, MMAX + 1):
    x = 2 ** m
    t0 = time.time(); Sx = S_of(x); t1 = time.time() - t0
    Pi_par = ((Sx - 1) // 2) % 2
    higher = sum(pi_small(iroot(x, k)) for k in range(2, m + 1))
    par = (Pi_par - higher) % 2
    agree += int(par == pi[m] % 2)
    main = float(mpf(x) / zeta2 * (mlog(x) + 2 * euler - 1 - 2 * dz2 / zeta2))
    rem = Sx - main
    if m % 2 == 0: times[m] = round(t1, 3)
    ident[m] = {"rem_over_x14": round(rem / 2 ** (m / 4), 3), "rem_over_x12": round(rem / 2 ** (m / 2), 4)}
out["parity_identity"] = {"rows": MMAX - 1, "rows_agree": agree, "rows_checked": [2, MMAX], "seconds": times}
tt = np.array([[m, s] for m, s in times.items() if m >= 30 and s > 0])
slope = float(np.polyfit(tt[:, 0], np.log2(tt[:, 1]), 1)[0])
out["parity_identity"]["log2_time_slope_per_row"] = round(slope, 3)
out["parity_identity"]["extrapolated_log10_seconds_row93"] = round(float((math.log2(times[MMAX]) + slope * (93 - MMAX)) * math.log10(2)), 1)
r14 = np.array([ident[m]["rem_over_x14"] for m in range(20, MMAX + 1)]); r12 = np.array([ident[m]["rem_over_x12"] for m in range(20, MMAX + 1)])
out["parity_identity"]["remainder_over_x14_rows20_46"] = {"median_abs": round(float(np.median(np.abs(r14))), 3), "max_abs": round(float(np.abs(r14).max()), 3)}
out["parity_identity"]["remainder_over_x12_rows20_46"] = {"median_abs": round(float(np.median(np.abs(r12))), 4), "max_abs": round(float(np.abs(r12).max()), 4)}
out["parity_identity"]["remainder_row46"] = float('%.4g' % (ident[46]["rem_over_x14"] * 2 ** (46 / 4)))
json.dump(out, open("resid.json", "w"), indent=1); print(json.dumps(out, indent=1))
