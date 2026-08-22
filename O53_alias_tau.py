#!/usr/bin/env python3
"""O53 — EXPLORATORY. No prereg, no verdict.

RUN 2 CHANGES ONE THING. Run 1 folded the first 60 zeta zeros, which packs the
fundamental domain [0, tau/2] tight enough that a random frequency sits 0.013
from a folded zero at base 9. The target was nearly a continuum. Run 2 sweeps
the number of folded zeros from 6 upward and reports the chance level beside the
observation at every setting, so the test has room to fail.

Is the torus's modular parameter the alias spacing?

`lean/Transform.lean` puts the strip on the torus `C* / b^Z` via z = b^(-s).
Its modular parameter, after the S-transform tau -> -1/tau, is

    tau = 2*pi / log b

and O18 recorded the dyadic alias comb as "eight peaks of identical height
spaced 2*pi/log 2". Same number. This checks it on data, across bases.

WHAT IS TAUTOLOGICAL AND SKIPPED. The spectrum of a ladder sampled uniformly in
log x is exactly periodic with period 2*pi/log b. Measuring that periodicity
confirms the sampling and nothing else.

WHAT IS TESTED. Where the peaks sit INSIDE one period. If the signal is the zeta
zeros seen through the ladder, every peak must land on a zeta zero folded by
tau. The fold is  g -> min(g mod tau, tau - g mod tau),  since |P| is even in
gamma and tau-periodic, so the fundamental domain is [0, tau/2].

That is a real test: the folded zero positions are fixed by gamma_n and log b
with no data, and the peaks come from the primes.

Reads with: lean/Transform.lean, CONTEXT.md O18, notes entry 84
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
ZEROS = [float(z) for z in json.load(open(_HERE / "zeros600.json"))]
CEIL, FLOOR = 10 ** 15, 10 ** 4
BASES = [2, 3, 4, 6, 8, 9]


def fold(g, tau):
    m = g % tau
    return min(m, tau - m)


NZ = 10          # set per sweep in main()


def arm(b):
    tau = 2 * math.pi / math.log(b)
    r0 = math.ceil(math.log(FLOOR) / math.log(b))
    r1 = math.floor(math.log(CEIL) / math.log(b))
    rs = list(range(r0, r1 + 1))
    e = []
    for r in rs:
        hi, lo = b ** r, b ** (r - 1)
        c = prime_pi(hi) - prime_pi(lo)
        s = float(mp.li(mp.mpf(hi)) - mp.li(mp.mpf(lo)))
        e.append(c - s)
    e = np.array(e); lx = np.array([r * math.log(b) for r in rs])
    eh = e / (np.sqrt(np.exp(lx)) / lx)
    w = np.hanning(len(eh)); z = (eh - eh.mean()) * w
    gam = np.arange(0.02, tau / 2, 0.002)
    P = np.array([abs(np.sum(z * np.exp(-1j * g * lx))) ** 2 for g in gam])
    loc = [i for i in range(1, len(P) - 1) if P[i] > P[i - 1] and P[i] > P[i + 1]]
    top = sorted(loc, key=lambda i: -P[i])[:5]
    peaks = sorted(float(gam[i]) for i in top)
    folded = sorted({round(fold(g, tau), 4) for g in ZEROS[:NZ]})
    out = []
    for pk in peaks:
        near = min(folded, key=lambda f: abs(f - pk))
        which = [n for n, g in enumerate(ZEROS[:NZ], 1)
                 if abs(fold(g, tau) - near) < 1e-4][:3]
        out.append({"peak": pk, "nearest_folded_zero": near,
                    "dist": abs(near - pk), "zeta_index": which})
    return {"base": b, "tau": tau, "n_rungs": len(rs),
            "fundamental_domain": tau / 2, "peaks": out}


def chance(b, tau, nz, rng):
    """mean distance from a RANDOM frequency to the nearest folded zero."""
    F = sorted({round(fold(g, tau), 6) for g in ZEROS[:nz]})
    q = rng.uniform(0.02, tau / 2, 40000)
    return float(np.mean([min(abs(f - x) for f in F) for x in q])), len(F)


def main():
    global NZ
    print("O53 run 2 - tau vs the alias comb.  EXPLORATORY, no prereg, no verdict.")
    print("ceiling 1e15, floor 1e4.  Sweeping how many zeros are folded, with")
    print("the chance level reported beside every observation.\n")
    rng = np.random.default_rng(2026)
    rows = []
    print(f"{'base':>5} {'rungs':>6} {'tau':>8} | " +
          "  ".join(f"nz={n:<3}" for n in (6, 10, 20, 40, 60)))
    print(f"{'':>5} {'':>6} {'':>8} | " +
          "  ".join(f"{'obs/chance':<7}" for _ in (6, 10, 20, 40, 60)))
    for b in BASES:
        line, detail = [], {}
        for nz in (6, 10, 20, 40, 60):
            NZ = nz
            r = arm(b)
            ch, npts = chance(b, r["tau"], nz, rng)
            obs = float(np.mean([p["dist"] for p in r["peaks"]])) if r["peaks"] else float("nan")
            line.append(f"{obs/ch:<7.2f}")
            detail[str(nz)] = {"observed": obs, "chance": ch,
                               "ratio": obs / ch, "n_folded_points": npts,
                               "peaks": r["peaks"]}
            if nz == 10:
                rows.append({"base": b, "tau": r["tau"], "n_rungs": r["n_rungs"],
                             "fundamental_domain": r["fundamental_domain"],
                             "sweep": detail})
        print(f"{b:>5} {rows[-1]['n_rungs']:>6} {rows[-1]['tau']:>8.4f} | " +
              "  ".join(line))
    for r in rows:
        r["sweep"] = r["sweep"]
    print("\n  ratio below 1: peaks sit closer to folded zeros than chance.")
    print("  ratio near 1:  the fold explains nothing at that setting.")
    print()
    print("  detail at nz = 6, the sparsest target:")
    for r in rows:
        d6 = r["sweep"]["6"]
        print(f"    base {r['base']:<2} domain [0,{r['fundamental_domain']:.3f}] "
              f"{d6['n_folded_points']} folded pts  obs {d6['observed']:.4f}  "
              f"chance {d6['chance']:.4f}  ratio {d6['ratio']:.2f}")
    p = _HERE / "results" / "alias_tau_run2.json"
    p.write_text(json.dumps({"schema_version": "1", "script": "O53_alias_tau.py",
                             "exploratory": True, "prereg": None,
                             "params": {"ceiling": CEIL, "floor": FLOOR,
                                        "bases": BASES, "n_zeros_folded_sweep": [6,10,20,40,60]},
                             "rows": rows}, indent=2))
    print(f"wrote {p}")


if __name__ == "__main__":
    main()
