#!/usr/bin/env python3
"""O85 — PREREGISTERED. preregs/dh_aggregate_spectrum_v1_20260825.md
(locked, sha256 1179f867d80d562b2bc7a3a2994f78a6edad87dc625c2619215fe863e603335e).

Does the DH-weighted prime residual track L(s,chi)'s zeros in
aggregate, rather than DH's own?

D = mean over list A of P(gamma)/median, minus the same over list B, on
the pooled incommensurate orbit {2^m 3^n}. Entry 163's factoring
predicts D > 0. The design's power was measured BEFORE this prereg was
written (O84, results/aggregate_power.json): 0.720 at the amplitude the
explicit formula gives a single zero, so a null here is a weak negative
with a stated ~28% miss rate rather than a non-measurement — which is
the defect entry 171 recorded in O81.

Aliasing is handled by construction: lean/Nyquist.lean proves a b-adic
ladder cannot identify a frequency past pi/log b, and O81 sampled
2^(j/4) (Nyquist 18.129) against targets to 40. The pooled orbit is
unevenly spaced and has no such wall — O18's escape.

Construction copied verbatim from O84_aggregate_power.py, which copied
O83's, which copied O81's, which copied O18's ladder design. This
script applies the locked decision rule mechanically and prints its
output. It does NOT stamp a verdict.

HOW IT WAS RUN
--------------
    .venv/bin/python O85_dh_aggregate.py
"""
import argparse
import hashlib
import math
import os
import sys
from datetime import datetime, timezone

import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "dh_aggregate.json")
PREREG = os.path.join(_HERE, "preregs",
                      "dh_aggregate_spectrum_v1_20260825.md")

LIST_A = [6.183578, 8.457229, 12.674946, 14.825026, 17.337802, 18.998588,
          22.487585, 24.365280, 25.531187, 27.982757, 30.463641, 32.195160,
          34.457229, 35.490893, 37.271951]
LIST_B = [5.0941598, 8.9399144, 12.133545, 14.404003, 17.130239, 19.308800,
          22.159708, 23.345370]


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def orbit(gens, xmax):
    pts = [1]
    for g in gens:
        new = []
        for v in pts:
            w = v
            while w <= xmax:
                new.append(w)
                w *= g
        pts = new
    return sorted(set(p for p in pts if 2 <= p <= xmax))


def psi_dh(xs, tau):
    a = {0: 0.0, 1: 1.0, 2: float(tau), 3: -float(tau), 4: -1.0}
    top = int(xs[-1])
    lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(int(p))))
            v *= int(p)
    extra.sort()
    vals = np.zeros(len(xs))
    cum, lo, ci, ex = 0.0, 2, 0, 0
    cps = [int(x) for x in xs]
    seg = 1 << 24
    while lo <= top:
        hi = min(lo + seg, top + 1)
        blk = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi:
                break
            st = max(p * p, ((lo + p - 1) // p) * p)
            blk[st - lo::p] = False
        idx = (np.flatnonzero(blk) + lo).astype(np.int64)
        w = np.array([a[int(v) % 5] for v in idx]) * np.log(idx)
        cs = np.cumsum(w)
        while ci < len(cps) and cps[ci] < hi:
            k = int(np.searchsorted(idx, cps[ci], side="right"))
            part = cum + (cs[k - 1] if k > 0 else 0.0)
            while ex < len(extra) and extra[ex][0] <= cps[ci]:
                part += a[extra[ex][0] % 5] * extra[ex][1]
                ex += 1
            vals[ci] = part
            ci += 1
        cum += float(cs[-1]) if len(cs) else 0.0
        lo = hi
    while ci < len(cps):
        vals[ci] = cum
        ci += 1
    return vals



def _sha(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def main():
    import argparse, json
    ap = argparse.ArgumentParser(
        description=("O85 - PREREGISTERED. Applies the locked decision "
                     "rule mechanically; does not stamp a verdict."))
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--nperm", type=int, default=400)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    started = datetime.now(timezone.utc)
    rng = np.random.default_rng(args.seed)
    mp.mp.dps = 20
    compromised = []

    print("O85 - the aggregate test.  PREREGISTERED.")
    print(f"  prereg dh_aggregate_spectrum_v1_20260825.md  sha256 "
          f"{_sha(PREREG)[:16]}...\n")

    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    resid = tau ** 2 + (1 + mp.sqrt(5)) * tau - 1
    print(f"GATE - tau residual {mp.nstr(resid, 4)}")
    if abs(resid) > mp.mpf("1e-20"):
        compromised.append("tau gate")

    chi = {1: mp.mpc(1, 0), 2: mp.mpc(0, 1), 3: mp.mpc(0, -1),
           4: mp.mpc(-1, 0)}

    def L(s):
        return 5 ** (-s) * sum(chi[j] * mp.zeta(s, mp.mpf(j) / 5)
                               for j in (1, 2, 3, 4))

    def absL(t):
        return abs(L(mp.mpf("0.5") + 1j * t))

    A_re = []
    t = mp.mpf("0.2"); prev = absL(t); prev2 = None
    while t < 40:
        t += mp.mpf("0.05"); cur = absL(t)
        if prev2 is not None and prev < prev2 and prev < cur and prev < 0.35:
            tm = mp.findroot(absL, t - mp.mpf("0.05"), solver="secant",
                             tol=mp.mpf("1e-12"))
            if absL(tm) < 1e-8:
                A_re.append(float(tm))
        prev2, prev = prev, cur
    A_re = sorted(set(round(v, 6) for v in A_re))
    ok_A = (len(A_re) == len(LIST_A)
            and all(abs(x - y) < 1e-4 for x, y in zip(A_re, LIST_A)))
    print(f"GATE - list A recomputed: {len(A_re)} zeros, matches frozen: "
          f"{ok_A}")
    if not ok_A:
        compromised.append("list A mismatch")

    gens = [int(g) for g in args.generators.split(",")]
    xs = np.array(orbit(gens, 1 << args.rmax), dtype=float)
    psi = psi_dh(xs, tau)
    ehat = np.diff(psi) / np.sqrt(xs[:-1])
    lx = np.log(xs[:-1]); n = len(ehat)
    if n < 300:
        compromised.append(f"only {n} blocks")
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    grid = np.linspace(0.5, 40.0, 1600)
    EA = np.exp(-1j * np.outer(np.array(LIST_A), lx))
    EB = np.exp(-1j * np.outer(np.array(LIST_B), lx))
    EG = np.exp(-1j * np.outer(grid, lx))

    def D_of(v):
        vw = w * v
        med = np.median(np.abs(EG @ vw))
        if med <= 0:
            return None
        return float(np.abs(EA @ vw).mean() / med
                     - np.abs(EB @ vw).mean() / med)

    D = D_of(ehat)
    if D is None:
        compromised.append("median(P) <= 0")
        D = 0.0
    null = np.array([D_of(rng.permutation(ehat)) for _ in range(args.nperm)])
    p5, p95 = float(np.percentile(null, 5)), float(np.percentile(null, 95))
    print(f"\n  {n} blocks, residual rms "
          f"{np.sqrt((ehat**2).mean()):.4f}")
    print(f"  D (observed)      {D:+.4f}")
    print(f"  null  mean {null.mean():+.4f}  sd {null.std():.4f}  "
          f"p5 {p5:+.4f}  p95 {p95:+.4f}   ({args.nperm} draws)")
    pct = float((null < D).mean() * 100)
    print(f"  D sits at percentile {pct:.1f} of the null")

    if compromised:
        out = "compromised"
    elif D > p95:
        out = "tracks_L"
    elif D < p5:
        out = "tracks_DH"
    else:
        out = "null"
    print(f"\nDECISION RULE OUTPUT (mechanical): {out}")
    if compromised:
        print(f"   compromised by: {compromised}")
    print("   Power at the true amplitude is 0.720 (O84), so a null here")
    print("   carries a ~28% miss rate. The verdict line is Julian's.")

    ended = datetime.now(timezone.utc)
    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O85_dh_aggregate.py",
            "generated_utc": ended.isoformat(), "exploratory": False,
            "prereg": "preregs/dh_aggregate_spectrum_v1_20260825.md",
            "prereg_sha256": _sha(PREREG),
            "params": {"code_version": _code_version(), "generators": gens,
                       "rmax": args.rmax, "nperm": args.nperm,
                       "seed": args.seed, "n_blocks": int(n)},
            "run_start_at": started.isoformat(),
            "run_end_at": ended.isoformat(),
            "list_A_recomputed": A_re, "list_A_matches": bool(ok_A),
            "D": D, "null": {"mean": float(null.mean()),
                             "sd": float(null.std()), "p5": p5, "p95": p95},
            "D_percentile_of_null": pct,
            "power_at_true_amplitude": 0.720,
            "decision_rule_output": out, "compromised_by": compromised,
            "verdict": None}, args.out)


if __name__ == "__main__":
    main()
