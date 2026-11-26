# Exploratory: Julian's seal as the order in which the sediment is added.
# On the line the section's terms are real: e^{i theta} B_n(1/2+it) = n^{-1/2} cos(theta(t) - t log n)
# (Jerby 2021, 2405.12557). Add the terms n = 1..M, M = floor(t/2) (Spira's length), one at a time,
# in two orders: natural (n ascending) and sieve (grouped by largest prime factor, primes ascending,
# n ascending inside a group, n = 1 first). After each prefix count the sign changes of the partial
# sum on a window holding exactly zeta's zeros 725 and 726 (midpoints to 724 and 727). The pair is
# on the line at a prefix when the count is 2; a count below 2 is a collision (the pair has left).
import json, math
import numpy as np, mpmath as mp
g = {k: float(mp.im(mp.zetazero(k))) for k in (724, 725, 726, 727)}
a, b = (g[724] + g[725]) / 2, (g[726] + g[727]) / 2
t = np.linspace(a, b, 4001)
th = np.array([float(mp.siegeltheta(x)) for x in t])
M = int(math.floor(t.mean() / 2))
def lpf(n):
    p, m, q = 1, n, 2
    while q * q <= m:
        while m % q == 0: p, m = q, m // q
        q += 1
    return max(p, m) if m > 1 else p
natural = list(range(1, M + 1))
sieve = sorted(natural, key=lambda n: (lpf(n), n))
def run(order):
    S = np.zeros_like(t); counts = []
    for n in order:
        S += n ** -0.5 * np.cos(th - t * math.log(n))
        counts.append(int(np.sum(np.sign(S[:-1]) * np.sign(S[1:]) < 0)))
    return counts
out = {"zeros": g, "window": [a, b], "M": M, "grid": len(t)}
for name, order in (("natural", natural), ("sieve", sieve)):
    c = run(order)
    below = [k + 1 for k, x in enumerate(c) if x < 2]
    out[f"{name}_final_count"] = c[-1]
    out[f"{name}_prefixes_below_two"] = len(below)
    out[f"{name}_first_below_two"] = below[0] if below else None
    out[f"{name}_last_below_two"] = below[-1] if below else None
    out[f"{name}_min_count"] = min(c)
    print(name, "final", c[-1], "prefixes with the pair off the line", len(below), "first", out[f"{name}_first_below_two"], flush=True)
json.dump(out, open("results.json", "w"), indent=1)
