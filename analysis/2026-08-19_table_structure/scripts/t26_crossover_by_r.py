"""
TEST 26 - the crossover, resolved in r.

t2_crossover measures d* once per base, over the whole row. CHAIN.md section 4
then fits `d* ~ 1.1 + 8.1*ln b` to those eight numbers, treating d* as a
per-base constant.

papers/Depth-as-Time.md D2 says it is not one: "It is not fixed per base. It
grows linearly in r, because the base state runs as b^r and the mode as
b^(r/2), so the gap to close grows." Measured slopes 0.3031 (b=2), 0.7353
(b=3), from O33's turnaround series d=3 (r=8), d=6 (r=20), d=12 (r=32).

And C3/C4 say the critical ratio is 1: below it the oscillation NEVER
overtakes, "at any depth, at any r", making b = 4, 6, 9 subcritical. Yet t2
reports family k=4 crossing at d* = 5 on a ratio of 0.555.

Both cannot hold. This measures d* as a function of r, on the same statistic
t2 uses, so the two claims are tested rather than argued.

METHOD. For each base, truncate the depth-0 row to its first r rungs, build
the difference table on that prefix, and find the first depth at which
oscillation carries more than half the spectral power. That is d*(r). Sweep r.

If D2 holds, d*(r) rises with r and its slope is the reported one.
If C4 holds, subcritical bases produce no d* at any r.
"""
import math
import numpy as np
from primecountpy import prime_pi

from _paths import tee

tee(__file__)

GAMMA1 = 14.134725141734693
V = 2 ** 32
MIN_N = 10                       # same floor t2 uses

BASES = [("dyadic", 2.0), ("triadic", 3.0),
         ("family k=1", math.exp(math.pi * 1 / (2 * GAMMA1))),
         ("family k=2", math.exp(math.pi * 2 / (2 * GAMMA1))),
         ("family k=3", math.exp(math.pi * 3 / (2 * GAMMA1))),
         ("family k=4", math.exp(math.pi * 4 / (2 * GAMMA1))),
         ("2^(1/2)", 2 ** 0.5), ("2^(1/3)", 2 ** (1 / 3))]


def seed_row(b):
    rmax = int(math.floor(math.log(V) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(0, rmax + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)]


def osc_fraction(row, d, b):
    """Fraction of spectral power away from DC. Identical to t2's statistic."""
    N = len(row)
    if N < MIN_N:
        return None
    lnb = math.log(b)
    u = np.empty(N)
    for i, v in enumerate(row):
        r = i + d + 1
        mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
        win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (N - 1))
        u[i] = math.copysign(mag, v) * win
    F = np.abs(np.fft.rfft(u)) ** 2
    tot = F[0] + F[1:].sum()
    return (F[1:].sum() / tot) if tot > 0 else None


def d_star(prefix, b):
    """First depth whose oscillation fraction exceeds 1/2, on this prefix."""
    rows, d = [list(prefix)], 0
    while True:
        f = osc_fraction(rows[-1], d, b)
        if f is None:
            return None                      # ran out of points before crossing
        if f > 0.5:
            return d
        p = rows[-1]
        if len(p) < 2:
            return None
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
        d += 1


def ratio(b):
    return abs(1 - complex(b) ** (-complex(0.5, GAMMA1))) / ((b - 1) / b)


print("d*(r): first depth where oscillation carries >1/2 the power, on the")
print("       depth-0 row truncated to its first r rungs.\n")
print(f"{'base':12}{'b':>9}{'ratio':>8}{'crit':>6}  d*(r) as r grows")
summary = {}
for name, b in BASES:
    row = seed_row(b)
    R = ratio(b)
    pts = []
    for r in range(MIN_N, len(row) + 1):
        ds = d_star(row[:r], b)
        if ds is not None:
            pts.append((r, ds))
    shown = ", ".join(f"{r}:{d}" for r, d in pts[::max(1, len(pts) // 8)][:8]) or "never crosses"
    print(f"{name:12}{b:>9.4f}{R:>8.4f}{'super' if R > 1 else 'sub':>6}  {shown}")
    summary[name] = (b, R, pts)

print("\n" + "=" * 78)
print("1. DOES d* GROW IN r?  (Depth-as-Time D2: yes, linearly)")
print("=" * 78)
for name, (b, R, pts) in summary.items():
    if len(pts) < 3:
        print(f"  {name:12} too few crossing points to fit")
        continue
    r = np.array([p[0] for p in pts], float)
    d = np.array([p[1] for p in pts], float)
    slope, intercept = np.polyfit(r, d, 1)
    const = "CONSTANT" if d.max() == d.min() else f"slope {slope:+.4f}"
    print(f"  {name:12} d* from {int(d.min())} to {int(d.max())} over r "
          f"{int(r.min())}..{int(r.max())}   {const}")

print("\n" + "=" * 78)
print("2. DO SUBCRITICAL BASES CROSS?  (Depth-as-Time C4: never, at any r)")
print("=" * 78)
for name, (b, R, pts) in summary.items():
    if R > 1:
        continue
    if pts:
        print(f"  {name:12} ratio {R:.4f} < 1 but CROSSES: d* = {pts[0][1]} "
              f"first at r = {pts[0][0]}   <-- contradicts C4")
    else:
        print(f"  {name:12} ratio {R:.4f} < 1, never crosses          <-- consistent with C4")

print("\n" + "=" * 78)
print("3. SLOPE AGAINST O33")
print("=" * 78)
print("  Depth-as-Time D3 reports 0.3031 (b=2) and 0.7353 (b=3) from O33's")
print("  turnaround series. O33 measures the turnaround of a different")
print("  quantity; agreement would be a check, disagreement is not by itself")
print("  a refutation of either.")
for name in ("dyadic", "triadic"):
    b, R, pts = summary[name]
    if len(pts) >= 3:
        r = np.array([p[0] for p in pts], float)
        d = np.array([p[1] for p in pts], float)
        s, _ = np.polyfit(r, d, 1)
        print(f"  {name:12} this statistic: {s:+.4f}")
