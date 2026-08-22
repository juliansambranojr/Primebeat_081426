#!/usr/bin/env python3
"""O50 — EXPLORATORY. No prereg, no verdict.

O17's method at 667x its extent. Nothing about the statistic is new; the only
change is that pi(x) comes from primecount instead of a numpy sieve, which is
what capped O17 at xmax = 1.5e8.

WHY. O17 is the bench's first detection: disjoint value-interval blocks on a
ratio-1.1 ladder recovered gamma_1, gamma_2, gamma_3 at 14.08 / 20.97 / 24.98,
all inside one resolution element, while the dyadic control on the same primes
and the same code returned NULL. It ran on 125 blocks over 8.41e6 primes.

CONTEXT.md line 250 states the limit that stopped it going further:
"the block runs N -> 2N, so over 8.4M primes there are only ~16 disjoint blocks
however the ladder is sampled."  That limit is a sieve limit, not a
mathematical one. primecount evaluates pi(1e11) in 4 ms.

Entries 75/76 established why depth is the wrong axis: the gain saturates at
the C2 ceiling by d = 1 or 2, so differencing destroys mode identity almost
immediately. Every success on this bench -- O17, O18, O34/O35's 94% -- probed
at DEPTH 0 and varied the ladder instead. This does that, with the resolution
the sieve was withholding.

THE STATISTIC, unchanged from O17:
    x_j = x0 * ratio^j          value ladder, blocks DISJOINT and tiling
    c_j = pi(x_{j+1}) - pi(x_j) exact prime count in (x_j, x_{j+1}]
    L_j = li(x_{j+1}) - li(x_j) smooth prediction
    e_j = c_j - L_j             the residual, CONTEXT.md core quantity
    ehat_j = e_j / sqrt(x_j)*log(x_j)   normalised
    P(gamma) = |sum_j w_j ehat_j exp(-i gamma log x_j)|^2   w = Hann

Reported per arm: the ten largest peaks, their P/median, and the distance from
each to the nearest zeta zero. Nothing is fitted.

Reads with: O17_disjoint_block_residual.py, O15_fine_ladder_residual.py,
CONTEXT.md core quantities, notes/lab_notebook_2.md entries 75, 76
"""
import json, math, pathlib, sys
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30

ZEROS = ([float(z) for z in json.load(open(_HERE / "zeros600.json"))]
         if (_HERE / "zeros600.json").exists() else [])

ARMS = [
    ("replicate_1.1", 1.1,   1000.0, 40.0),    # O17's ladder, new ceiling
    ("fine_1.002",    1.002, 1e5,    120.0),   # Nyquist 1572, 6914 blocks
    ("dyadic_control", 2.0,  2.0,    40.0),    # the aliased control O17 used
]
XMAX = 10 ** 11


def ladder(x0, ratio, xmax):
    n = int(math.log(xmax / x0) / math.log(ratio))
    return np.array([x0 * ratio ** j for j in range(n + 1)])


def run_arm(name, ratio, x0, gmax):
    xs = ladder(x0, ratio, XMAX)
    counts = np.array([prime_pi(int(xs[j + 1])) - prime_pi(int(xs[j]))
                       for j in range(len(xs) - 1)], dtype=float)
    smooth = np.array([float(mp.li(mp.mpf(xs[j + 1])) - mp.li(mp.mpf(xs[j])))
                       for j in range(len(xs) - 1)])
    e = counts - smooth
    xm = xs[:-1]
    ehat = e / (np.sqrt(xm) / np.log(xm))
    w = np.hanning(len(ehat))
    z = (ehat - ehat.mean()) * w
    lx = np.log(xm)
    gam = np.arange(0.5, gmax, 0.01)
    P = np.array([abs(np.sum(z * np.exp(-1j * g * lx))) ** 2 for g in gam])
    med = float(np.median(P))
    # local maxima, top ten by height
    loc = [i for i in range(1, len(P) - 1) if P[i] > P[i - 1] and P[i] > P[i + 1]]
    top = sorted(loc, key=lambda i: -P[i])[:10]
    peaks = []
    for i in sorted(top, key=lambda i: gam[i]):
        g = float(gam[i])
        near = min(ZEROS, key=lambda z0: abs(z0 - g)) if ZEROS else None
        peaks.append({"gamma": g, "P_over_median": float(P[i] / med),
                      "nearest_zero": near,
                      "dist": (abs(near - g) if near is not None else None)})
    # PRIMARY: amplitude at the zeta zeros vs at exact midpoints between them.
    # A top-ten peak list is selection; this is a fixed comparison on a fixed grid.
    #
    # run 2: the separation test runs to the arm's OWN Nyquist rather than to
    # the peak grid's gmax, and is reported in bands so the question is not
    # "does it separate" but "up to what gamma". The peak grid stays where it
    # was; it is descriptive and the paper says so.
    amp = lambda g: abs(np.sum(z * np.exp(-1j * g * lx)))
    nyq = math.pi / math.log(ratio)
    sep_gmax = min(nyq, max(ZEROS) if ZEROS else gmax)
    bands = []
    edges = [14.0, 120.0, 300.0, 500.0, 700.0, 940.0]
    for i in range(len(edges) - 1):
        lo_e, hi_e = edges[i], min(edges[i + 1], sep_gmax)
        if hi_e <= lo_e:
            continue
        bz = [g for g in ZEROS if lo_e < g < hi_e]
        if len(bz) < 3:
            continue
        bm = [(bz[j] + bz[j + 1]) / 2 for j in range(len(bz) - 1)]
        A = np.array([amp(g) for g in bz]); B = np.array([amp(g) for g in bm])
        bands.append({"lo": lo_e, "hi": hi_e, "n_zeros": len(bz),
                      "amp_at_zeros_min": float(A.min()),
                      "amp_at_zeros_median": float(np.median(A)),
                      "amp_between_max": float(B.max()),
                      "amp_between_median": float(np.median(B)),
                      "complete_separation": bool(A.min() > B.max()),
                      "n_zeros_below_max_midpoint": int((A < B.max()).sum())})
    zs = [g for g in ZEROS if 14.0 < g < gmax]
    mids = [(zs[i] + zs[i + 1]) / 2 for i in range(len(zs) - 1)]
    A = np.array([amp(g) for g in zs]) if zs else np.array([])
    B = np.array([amp(g) for g in mids]) if mids else np.array([])
    sep = None
    if len(A) and len(B):
        sep = {"n_zeros": len(A), "n_midpoints": len(B),
               "amp_at_zeros_median": float(np.median(A)),
               "amp_at_zeros_min": float(A.min()),
               "amp_between_median": float(np.median(B)),
               "amp_between_max": float(B.max()),
               "median_ratio": float(np.median(A) / np.median(B)),
               "n_zeros_below_max_midpoint": int((A < B.max()).sum()),
               "complete_separation": bool(A.min() > B.max())}

    return {"arm": name, "ratio": ratio, "x0": x0, "n_blocks": len(ehat),
            "separation": sep, "separation_bands": bands, "sep_gmax": sep_gmax,
            "total_primes": int(counts.sum()),
            "nyquist_gamma": math.pi / math.log(ratio),
            "resolution_dgamma": 2 * math.pi / math.log(XMAX / x0),
            "block_min": int(counts.min()), "block_max": int(counts.max()),
            "peaks": peaks}


def main():
    print("O50 — deep ladder spectrum.  EXPLORATORY, no prereg, no verdict.")
    print(f"xmax = {XMAX:.0e}   pi(xmax) = {prime_pi(XMAX):,}")
    print(f"O17 for comparison: 125 blocks, 8,407,584 primes, xmax 1.5e8\n")
    out = []
    for name, ratio, x0, gmax in ARMS:
        r = run_arm(name, ratio, x0, gmax)
        out.append(r)
        print(f"--- {name}:  ratio {ratio}  x0 {x0:g}  "
              f"{r['n_blocks']} blocks  {r['total_primes']:,} primes")
        print(f"    Nyquist gamma {r['nyquist_gamma']:.1f}   "
              f"resolution dgamma {r['resolution_dgamma']:.3f}   "
              f"block size {r['block_min']}..{r['block_max']:,}")
        sp = r.get("separation")
        if sp:
            print(f"    SEPARATION at {sp['n_zeros']} zeros vs {sp['n_midpoints']} midpoints:")
            print(f"      at zeros   median {sp['amp_at_zeros_median']:.3f}  min {sp['amp_at_zeros_min']:.3f}")
            print(f"      between    median {sp['amp_between_median']:.3f}  max {sp['amp_between_max']:.3f}")
            print(f"      ratio {sp['median_ratio']:.1f}x   complete separation: {sp['complete_separation']}"
                  f"   ({sp['n_zeros_below_max_midpoint']} of {sp['n_zeros']} zeros below the max midpoint)")
        bd = r.get("separation_bands") or []
        if bd:
            print(f"    SEPARATION BY BAND, to this arm's Nyquist "
                  f"({r['sep_gmax']:.1f}):")
            print(f"      {'band':>14} {'zeros':>6} {'min@zero':>10} "
                  f"{'max@mid':>10} {'sep':>6}  below")
            for x in bd:
                label = f"{int(x['lo'])}-{int(x['hi'])}"
                print(f"      {label:>14} {x['n_zeros']:>6} "
                      f"{x['amp_at_zeros_min']:>10.4f} "
                      f"{x['amp_between_max']:>10.4f} "
                      f"{str(x['complete_separation']):>6}  "
                      f"{x['n_zeros_below_max_midpoint']}")
        print(f"    {'gamma':>9} {'P/median':>9}  nearest zeta zero   dist")
        for p in r["peaks"]:
            nz = f"{p['nearest_zero']:.4f}" if p["nearest_zero"] else "n/a"
            dd = f"{p['dist']:.4f}" if p["dist"] is not None else ""
            hit = "  <--" if (p["dist"] is not None
                              and p["dist"] < r["resolution_dgamma"]) else ""
            print(f"    {p['gamma']:>9.3f} {p['P_over_median']:>9.2f}  {nz:>17}  {dd}{hit}")
        print()
    p = _HERE / "results" / "deep_ladder_spectrum_run2.json"
    p.write_text(json.dumps({"schema_version": "1",
                             "script": "O50_deep_ladder_spectrum.py",
                             "exploratory": True, "prereg": None,
                             "params": {"xmax": XMAX, "arms": [a[0] for a in ARMS],
                                        "dps": 30, "pi_backend": "primecountpy"},
                             "constants": {"n_zeros_loaded": len(ZEROS)},
                             "rows": out}, indent=2))
    print(f"wrote {p}")


if __name__ == "__main__":
    main()
