# Exploratory, long stretch for the transfer between basins: Levinson's V = zeta + zeta'/L times Young's mollifier psi (P(x) = x),
# on sigma0 = 1/2 - R/L, measured per Gram interval ("basin") on [T, T + H].
import mpmath as mp, json, math
mp.mp.dps = 15
T, H, R = 5000.0, 470.0, 1.3
L = math.log(T)
s0 = 0.5 - R / L
THETAS = [0.5]
SAMP = 24          # points per basin on the left side
SIDE = 24          # points per side of the rectangle for the winding count
def mu(n):
    r, p, m = 1, 2, n
    while p * p <= m:
        if m % p == 0:
            m //= p
            if m % p == 0: return 0
            r = -r
        p += 1
    return -r if m > 1 else r
def make_psi(theta):
    M = int(T ** theta)
    lM = math.log(M)
    coef = [(h, mu(h) * (math.log(M / h) / lM)) for h in range(1, M + 1) if mu(h) != 0]
    def psi(s):
        return mp.fsum(c * mp.power(h, -(s + 0.5 - s0)) for h, c in coef)
    return psi, M
def V(s):
    return mp.zeta(s) + mp.zeta(s, derivative=1) / L
# Gram points covering [T, T + H]
n0 = 0
while float(mp.grampoint(n0)) < T: n0 += 50
while float(mp.grampoint(n0)) > T: n0 -= 1
grams = []
n = n0
while True:
    g = float(mp.grampoint(n)); grams.append(g)
    if g > T + H: break
    n += 1
basins = list(zip(grams[:-1], grams[1:]))
Vleft = {}
for (a, b) in basins:
    for j in range(SAMP):
        t = a + (b - a) * (j + 0.5) / SAMP
        Vleft[t] = V(mp.mpc(s0, t))
res = {"T": T, "H": H, "R": R, "basins": len(basins)}
def winding(f, a, b):
    pts = ([mp.mpc(s0 + (3 - s0) * k / SIDE, a) for k in range(SIDE)] +
           [mp.mpc(3, a + (b - a) * k / SIDE) for k in range(SIDE)] +
           [mp.mpc(3 - (3 - s0) * k / SIDE, b) for k in range(SIDE)] +
           [mp.mpc(s0, b - (b - a) * k / SIDE) for k in range(SIDE)])
    vals = [f(z) for z in pts] + [f(pts[0])]
    tot = sum(float(mp.arg(vals[k + 1] / vals[k])) for k in range(len(vals) - 1))
    return round(tot / (2 * math.pi))
for theta in THETAS:
    psi, M = make_psi(theta)
    floors = []
    for (a, b) in basins:
        vals = []
        for j in range(SAMP):
            t = a + (b - a) * (j + 0.5) / SAMP
            vals.append(float(abs(Vleft[t] * psi(mp.mpc(s0, t))) ** 2))
        floors.append(sum(vals) / SAMP)
    mean = sum(floors) / len(floors)
    dev = [f - mean for f in floors]
    var = sum(d * d for d in dev) / len(dev)
    corr = sum(dev[i] * dev[i + 1] for i in range(len(dev) - 1)) / ((len(dev) - 1) * var) if var > 0 else 0.0
    zeros = []
    k = f"theta_{theta}"
    res[k + "_M"] = M
    res[k + "_floor_mean"] = mean
    res[k + "_floor_min"] = min(floors)
    res[k + "_floor_max"] = max(floors)
    res[k + "_neighbour_corr"] = corr
    for lag in (1, 2, 3, 5):
        res[k + f"_corr_lag{lag}"] = sum(dev[i] * dev[i + lag] for i in range(len(dev) - lag)) / ((len(dev) - lag) * var)
    sums = [floors[i] + floors[i + 1] for i in range(len(floors) - 1)]
    ms = sum(sums) / len(sums)
    res[k + "_pair_rel_spread"] = (sum((x - ms) ** 2 for x in sums) / len(sums)) ** 0.5 / ms
    res[k + "_single_rel_spread"] = var ** 0.5 / mean
json.dump(res, open("results.json", "w"), indent=1)
