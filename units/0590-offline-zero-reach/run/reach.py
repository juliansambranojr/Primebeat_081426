# Exploratory: where would a zero off the line, rho = beta + i gamma, first show in Julian's table?
# Its mode in cell (r, d) is about 2 * 2^(r beta) |1 - 2^-rho|^(d+1) / (|rho| r ln 2) (units 0425-0426:
# the mode times the symbol once per depth); the on-line zeros' background about 2^(r/2) 1.707^(d+1) / r.
# Order-of-magnitude constants. Writes reach.json.
import math, json
def first_row(beta, gam, rmax=2000):
    rho = complex(beta, gam); f = abs(1 - 2 ** (-rho))
    for r in range(10, rmax):
        for d in range(0, r):
            if 2 * 2 ** (r * beta) * f ** (d + 1) / (abs(rho) * r * math.log(2)) > 2 ** (r / 2) * 1.707 ** (d + 1) / r:
                return r, d
    return None, None
out = {"first_row": {}, "least_beta_by_row_92": {}}
for beta in (0.99, 0.95, 0.9, 0.75, 0.6):
    r, d = first_row(beta, 3.0e12)
    out["first_row"][str(beta)] = {"row": r, "depth": d}
for g in (3e12, 1e13, 1e15):
    lo = None
    for b in [0.5 + k / 1000 for k in range(1, 501)]:
        r, d = first_row(b, g, 93)
        if r is not None: lo = b; break
    out["least_beta_by_row_92"][f"{g:.0e}"] = lo
json.dump(out, open("reach.json", "w"), indent=1); print(out)
