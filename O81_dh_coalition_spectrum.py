#!/usr/bin/env python3
"""O81 — PREREGISTERED. preregs/dh_coalition_spectrum_v1_20260825.md
(locked, sha256 9f500ecd2eb81ce7b9615a62c2db94e4e5d2ad51775548e87af8d9d6c1f044d7).

Does the DH-weighted prime residual carry L(s,chi)'s zeros, or DH's own?

Entry 163's factoring, recorded before this test existed:
    psi_DH(x) = sum_n Lambda(n) a(n mod 5)
              = c * psi(x, chi) + conj(c) * psi(x, conj chi),
    c = (1 - i tau)/2, chi the order-4 character mod 5.
Each term is governed by the zeros of L(s, chi). DH's own zeros are
where the COMBINATION vanishes and should be absent from prime data.
If the factoring is wrong the spectrum will show peaks at 5.0941598
and its companions, and the prereg's H1 is refuted.

Every locked parameter is in the prereg's table and is re-derived
here; the two target lists are recomputed and must reproduce the
locked values to 1e-4 or the run exits `compromised`. This script
applies the decision rule mechanically and prints its output. It does
NOT stamp a verdict — that line is Julian's.

HOW IT WAS RUN
--------------
    .venv/bin/python O81_dh_coalition_spectrum.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "dh_coalition_spectrum.json")
PREREG = os.path.join(_HERE, "preregs",
                      "dh_coalition_spectrum_v1_20260825.md")

LOCKED_A = [6.183578, 8.457229, 12.674946, 14.825026, 17.337802,
            18.998588, 22.487585, 24.365280, 25.531187, 27.982757,
            30.463641, 32.195160, 34.457229, 35.490893, 37.271951]
LOCKED_B = [5.0941598, 8.9399144, 12.133545, 14.404003, 17.130239,
            19.308800, 22.159708, 23.345370]


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def _sha(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def psi_dh_on_ladder(xs, tau):
    """psi_DH(x) = sum_{p^k <= x} log p * a(p^k mod 5), exact over a
    segmented sieve; evaluated at every rung."""
    a = {0: 0.0, 1: 1.0, 2: float(tau), 3: -float(tau), 4: -1.0}
    top = int(math.floor(xs[-1]))
    lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)

    # prime powers p^k <= top with k >= 2 are few; handle them directly
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(p)))
            v *= int(p)
    extra.sort()

    vals = np.zeros(len(xs))
    cum = 0.0
    seg = 1 << 24
    lo = 2
    ci = 0
    ex_i = 0
    checkpoints = [int(math.floor(x)) for x in xs]
    while lo <= top:
        hi = min(lo + seg, top + 1)
        block = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi:
                break
            start = max(p * p, ((lo + p - 1) // p) * p)
            block[start - lo::p] = False
        idx = (np.flatnonzero(block) + lo).astype(np.int64)
        w = np.array([a[int(v) % 5] for v in idx]) * np.log(idx)
        order = np.argsort(idx)
        idx = idx[order]
        w = w[order]
        csum = np.cumsum(w)
        while ci < len(checkpoints) and checkpoints[ci] < hi:
            cp = checkpoints[ci]
            k = int(np.searchsorted(idx, cp, side="right"))
            partial = cum + (csum[k - 1] if k > 0 else 0.0)
            while ex_i < len(extra) and extra[ex_i][0] <= cp:
                partial += a[extra[ex_i][0] % 5] * extra[ex_i][1]
                ex_i += 1
            vals[ci] = partial
            ci += 1
        cum += float(csum[-1]) if len(csum) else 0.0
        lo = hi
    while ci < len(checkpoints):
        vals[ci] = cum
        ci += 1
    # extras already folded at each checkpoint in order; recompute tail
    return vals


def main():
    ap = argparse.ArgumentParser(
        description=("O81 - PREREGISTERED. Does the DH-weighted prime "
                     "residual carry L(s,chi)'s zeros or DH's own? "
                     "Applies the locked decision rule mechanically; "
                     "does not stamp a verdict."))
    ap.add_argument("--rmax", type=int, default=30,
                    help="ladder top: x = 2^(j/4) up to 2^RMAX "
                         "(locked 30)")
    ap.add_argument("--sub", type=int, default=4,
                    help="rungs per doubling (locked 4)")
    ap.add_argument("--gamma-max", type=float, default=40.0)
    ap.add_argument("--gamma-step", type=float, default=0.01)
    ap.add_argument("--surrogates", type=int, default=200)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--dps", type=int, default=20)
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    started = datetime.now(timezone.utc)
    mp.mp.dps = args.dps
    rng = np.random.default_rng(args.seed)
    compromised = []

    print("O81 — the coalition's spectrum.  PREREGISTERED.")
    print(f"  prereg {os.path.basename(PREREG)}  sha256 {_sha(PREREG)[:16]}…\n")

    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    resid = tau ** 2 + (1 + mp.sqrt(5)) * tau - 1
    print(f"GATE — tau = {mp.nstr(tau, 12)}, residual "
          f"{mp.nstr(resid, 4)}")
    if abs(resid) > mp.mpf('1e-20'):
        compromised.append("tau gate")

    chi = {1: mp.mpc(1, 0), 2: mp.mpc(0, 1),
           3: mp.mpc(0, -1), 4: mp.mpc(-1, 0)}

    def L(s):
        return 5 ** (-s) * sum(chi[j] * mp.zeta(s, mp.mpf(j) / 5)
                               for j in (1, 2, 3, 4))

    def absL(t):
        return abs(L(mp.mpf('0.5') + 1j * t))

    A = []
    t = mp.mpf('0.2')
    prev = absL(t)
    prev2 = None
    while t < args.gamma_max:
        t += mp.mpf('0.05')
        cur = absL(t)
        if prev2 is not None and prev < prev2 and prev < cur and prev < 0.35:
            tm = mp.findroot(absL, t - mp.mpf('0.05'), solver='secant',
                             tol=mp.mpf('1e-12'))
            if absL(tm) < 1e-8:
                A.append(float(tm))
        prev2, prev = prev, cur
    A = sorted(set(round(v, 6) for v in A))
    ok_A = (len(A) == len(LOCKED_A)
            and all(abs(x - y) < 1e-4 for x, y in zip(A, LOCKED_A)))
    print(f"GATE — list A recomputed: {len(A)} zeros, matches locked: "
          f"{ok_A}")
    if not ok_A:
        compromised.append("list A mismatch")
    B = LOCKED_B
    print(f"        list B (entry 162, O80): {len(B)} zeros\n")

    n_r = args.rmax * args.sub
    xs = np.array([2.0 ** (j / args.sub) for j in range(1, n_r + 1)])
    print(f"building psi_DH on {len(xs)} rungs to 2^{args.rmax} "
          f"(exact segmented sieve)...")
    psi = psi_dh_on_ladder(xs, tau)
    e = np.diff(psi)
    xj = xs[:-1]
    ehat = e / np.sqrt(xj)
    logx = np.log(xj)
    n = len(ehat)
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    span = float(logx[-1] - logx[0])
    band = max(0.6, 2 * np.pi / span)
    print(f"   {n} blocks, log-x span {span:.3f}, band half-width "
          f"{band:.4f}")

    gam = np.arange(0.0, args.gamma_max + args.gamma_step / 2,
                    args.gamma_step)
    def project(v):
        return np.abs((w * v)[None, :]
                      @ np.exp(-1j * gam[:, None] * logx[None, :]).T).ravel() \
            if False else np.abs(np.exp(-1j * np.outer(gam, logx)) @ (w * v))
    P = project(ehat)
    med = float(np.median(P))
    print(f"   median(P) = {med:.6g}")
    if med == 0.0:
        compromised.append("degenerate surrogate band")

    sur = np.empty(args.surrogates)
    for k in range(args.surrogates):
        Ps = project(rng.permutation(ehat))
        sur[k] = float(Ps.max() / np.median(Ps))
    print(f"   surrogate P_max/median: med {np.median(sur):.3f}  "
          f"p95 {np.percentile(sur, 95):.3f}  max {sur.max():.3f}")

    # local maxima
    loc = [(gam[i], P[i]) for i in range(1, len(P) - 1)
           if P[i] > P[i - 1] and P[i] > P[i + 1]]

    def hits(targets, others):
        out = []
        amb = 0
        for tg in targets:
            near = [(g, p) for g, p in loc if abs(g - tg) <= band]
            if not near:
                continue
            g, p = max(near, key=lambda gp: gp[1])
            if any(abs(g - o) <= band for o in others):
                amb += 1
                continue
            if p / med > 5:
                out.append((tg, float(g), float(p / med)))
        return out, amb

    hA, ambA = hits(A, B)
    hB, ambB = hits(B, A)
    print(f"\nHITS on list A (L(s,chi) zeros), P/median > 5: {len(hA)} "
          f"of {len(A)}   ambiguous {ambA}")
    for tg, g, r in hA:
        print(f"     target {tg:>9.5f}  peak {g:>8.3f}  P/med {r:>8.3f}")
    print(f"HITS on list B (DH's own zeros), P/median > 5: {len(hB)} "
          f"of {len(B)}   ambiguous {ambB}")
    for tg, g, r in hB:
        print(f"     target {tg:>9.5f}  peak {g:>8.3f}  P/med {r:>8.3f}")

    if len(A) < 8:
        compromised.append("fewer than 8 A-targets in grid")
    if compromised:
        out_rule = "compromised"
    elif len(hA) >= 5 and len(hB) <= 1:
        out_rule = "coalition_silent"
    elif len(hB) >= 3 and len(hA) >= 5:
        out_rule = "both"
    elif len(hB) >= 3:
        out_rule = "coalition_heard"
    else:
        out_rule = "null"
    print(f"\nDECISION RULE OUTPUT (mechanical): {out_rule}")
    if compromised:
        print(f"   compromised by: {compromised}")
    print("   The verdict line is Julian's to write.")

    ended = datetime.now(timezone.utc)
    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O81_dh_coalition_spectrum.py",
            "generated_utc": ended.isoformat(),
            "exploratory": False,
            "prereg": "preregs/dh_coalition_spectrum_v1_20260825.md",
            "prereg_sha256": _sha(PREREG),
            "params": {"code_version": _code_version(), "rmax": args.rmax,
                       "sub": args.sub, "gamma_max": args.gamma_max,
                       "gamma_step": args.gamma_step,
                       "surrogates": args.surrogates, "seed": args.seed,
                       "dps": args.dps, "tau": float(tau),
                       "n_blocks": int(n), "band_halfwidth": float(band)},
            "run_start_at": started.isoformat(),
            "run_end_at": ended.isoformat(),
            "list_A_recomputed": A, "list_A_matches_locked": bool(ok_A),
            "list_B": B,
            "median_P": med,
            "surrogate_max_over_median": {"median": float(np.median(sur)),
                                          "p95": float(np.percentile(sur, 95)),
                                          "max": float(sur.max())},
            "hits_A": [{"target": t_, "peak": g, "P_over_median": r}
                       for t_, g, r in hA],
            "hits_B": [{"target": t_, "peak": g, "P_over_median": r}
                       for t_, g, r in hB],
            "ambiguous_A": ambA, "ambiguous_B": ambB,
            "decision_rule_output": out_rule,
            "compromised_by": compromised,
            "verdict": None}
        try:
            with open(args.out, "w") as fh:
                json.dump(payload, fh, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
