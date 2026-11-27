# Exploratory: for the closest pairs of real zeros at lam = 0, the time lam at
# which the pair collides and leaves the real axis, by bisection in lam on the
# count of sign changes of H_lam in a window of width 4 about the pair.
# Uses heatflow.py's G (imported without rerunning its scan).
import json, numpy as np
src = open("heatflow.py").read().split("gam = [float")[0]
exec(src)
Z0 = np.array(json.load(open("zeros_by_lam.json"))["0.0"])
gaps = np.diff(Z0)
order = np.argsort(gaps)[:5]
def changes(lam, c):
    xs = np.arange(c - 2, c + 2, 0.002)
    g = G(lam, xs)
    return int(np.sum(np.sign(g[:-1]) * np.sign(g[1:]) < 0))
out = {}
for r, j in enumerate(order):
    c = (Z0[j] + Z0[j + 1]) / 2
    base = changes(0.0, c)
    lo, hi = -0.4, 0.0                     # changes(hi) == base, look for the loss
    if changes(lo, c) == base:
        out[f"pair{r}"] = {"x": float(c), "gap0": float(gaps[j]), "collides_above": lo}
        continue
    while hi - lo > 1e-4:
        m = (lo + hi) / 2
        if changes(m, c) == base: hi = m
        else: lo = m
    out[f"pair{r}"] = {"x": float(c), "t": float(c / 2), "gap0": float(gaps[j]), "lam_collide": (lo + hi) / 2}
    print(r, out[f"pair{r}"], flush=True)
json.dump(out, open("collisions.json", "w"), indent=1)
