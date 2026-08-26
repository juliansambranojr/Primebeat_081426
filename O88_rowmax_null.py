#!/usr/bin/env python3
"""O88 — EXPLORATORY. No prereg, no verdict.

The null and the power for the row-max statistic, measured on already
unblinded data so a successor prereg can quote them.

WHY. Entry 179's second reader established two things that change the
design of any preregistered sweep: the `if k == 0` branch can be
replaced by a UNIFORM per-row OLS fit of the main-term coefficient,
removing the construction's only degree of freedom; and the sharpest
control is a RESIDUE-CLASS SHUFFLE, which permutes per rung which class
each block's von Mangoldt mass lands in — preserving psi(x) exactly,
the rung grid, the window and the |F|-versus-t trend, and destroying
only the arithmetic.

THE STATISTIC. Per-cell p-values invite a multiple-comparison argument
the cells cannot settle, because rows share a residual and columns
share a target list. Ask instead, per row, ONE question: is the
diagonal cell the maximum of its row? Under any null in which a
residual bears no special relation to its own character's zeros that
happens with probability about 1/n_cols. The count over rows is then a
single statistic with an assumption-free null and no control
calibration at all.

WHAT IS MEASURED HERE, on q = 5 and 7 only — data already seen, so
nothing about q = 11 or 13 is touched:
  NULL   the row-max count under the residue-class shuffle
  ALT    the row-max count on the real residuals
and from the pair, the power a successor prereg must quote.

Reads with: notes/lab_notebook_2.md entries 176, 178, 179;
O87_character_sweep.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O88_rowmax_null.py
"""
import argparse, hashlib, json, os, sys, types
from datetime import datetime, timezone
import numpy as np

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_OUT = os.path.join(_HERE, "results", "rowmax_null.json")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def _load_o87():
    src = open(os.path.join(_HERE, "O87_character_sweep.py")).read()
    src = src.split("def main():")[0]
    m = types.ModuleType("o87n")
    m.__file__ = os.path.join(_HERE, "O87_character_sweep.py")
    exec(compile(src, "o87n", "exec"), m.__dict__)
    return m


def detrend_uniform(psi, xs):
    """Entry 179's uniform rule: OLS-fit the main-term coefficient per
    row, with no knowledge of which character this is. Recovers
    c ~ 1 for principal rows and c ~ 1e-5 for the rest, by itself."""
    dpsi = np.diff(psi); dx = np.diff(xs)
    c = float(np.real(np.vdot(dx, dpsi)) / np.vdot(dx, dx))
    return (dpsi - c * dx) / np.sqrt(xs[:-1]), c


def main():
    ap = argparse.ArgumentParser(
        description=("O88 - null and power for the row-max statistic, "
                     "measured on unblinded q=5,7 data. EXPLORATORY: no "
                     "prereg, no decision rule, no verdict."))
    ap.add_argument("--moduli", type=str, default="5,7")
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--tmax", type=float, default=40.0)
    ap.add_argument("--shuffles", type=int, default=300)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    o = _load_o87()
    rng = np.random.default_rng(args.seed)
    moduli = [int(m) for m in args.moduli.split(",")]
    xs = np.array(o.orbit([int(g) for g in args.generators.split(",")],
                          1 << args.rmax), dtype=float)
    lx = np.log(xs[:-1]); n = len(lx)
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    E = {}

    print("O88 — the row-max null, measured.  EXPLORATORY.\n")
    C = {q: o.class_sums(xs, q) for q in moduli}
    labels, cvecs, targets, principal = [], [], [], []
    for q in moduli:
        for k, chi in o.characters(q):
            z = o.zeros_of(chi, q, args.tmax)
            if len(z) < 4:
                continue
            labels.append(f"q={q} k={k}")
            cvecs.append((q, np.array([chi[a] for a in range(q)])))
            targets.append(np.array(z)); principal.append(k == 0)
    m = len(labels)
    print(f"  {m} characters, {sum(principal)} principal, "
          f"{m - sum(principal)} non-principal; {n} blocks\n")

    def rowmax_count(class_tables):
        """How many NON-PRINCIPAL rows have their diagonal as row max."""
        hits = 0
        for i, (q, cv) in enumerate(cvecs):
            if principal[i]:
                continue
            e, _c = detrend_uniform(class_tables[q] @ cv, xs)
            vw = w * e
            sc = [float(np.abs(np.exp(-1j * np.outer(t, lx)) @ vw).mean())
                  for t in targets]
            if int(np.argmax(sc)) == i:
                hits += 1
        return hits

    obs = rowmax_count(C)
    n_np = m - sum(principal)
    print(f"OBSERVED (real residuals): {obs} of {n_np} non-principal rows "
          f"have their diagonal as row max")

    print(f"\nNULL — residue-class shuffle, {args.shuffles} draws.")
    print("  Permutes per rung which class each block's mass lands in:")
    print("  psi(x), the grid, the window and the trend are preserved")
    print("  exactly; only the arithmetic is destroyed.\n")
    null = []
    for s in range(args.shuffles):
        Cs = {}
        for q in moduli:
            base = C[q]
            inc = np.diff(np.vstack([np.zeros(q), base]), axis=0)
            perm = np.empty_like(inc)
            for j in range(inc.shape[0]):
                idx = rng.permutation(q)
                perm[j] = inc[j][idx]
            Cs[q] = np.cumsum(perm, axis=0)
        null.append(rowmax_count(Cs))
        if (s + 1) % 50 == 0:
            print(f"   {s+1}/{args.shuffles} draws, running mean "
                  f"{np.mean(null):.3f}", flush=True)
    null = np.array(null)
    print(f"\n  null mean {null.mean():.3f}   sd {null.std():.3f}   "
          f"max {null.max()}   (analytic expectation under "
          f"exchangeability: {n_np / m:.3f})")
    print(f"  draws reaching the observed {obs}: "
          f"{int((null >= obs).sum())} of {args.shuffles}  "
          f"-> p <= {max(1, int((null >= obs).sum())) / args.shuffles:.4f}")

    p_hat = obs / n_np
    lo = 0.0 if obs == 0 else (0.05 ** (1.0 / obs) if obs == n_np else None)
    print(f"\nPOWER for a successor sweep. Per-row hit rate here: "
          f"{p_hat:.3f} ({obs}/{n_np}).")
    if obs == n_np:
        lb = 0.05 ** (1.0 / n_np)
        print(f"  One-sided 95% lower bound on the per-row rate: "
              f"{lb:.3f}")
        for R in (20,):
            exp_hits = lb * R
            print(f"  At that lower bound, a {R}-row sweep expects "
                  f"{exp_hits:.1f} hits against a null mean of "
                  f"{null.mean() * R / n_np:.2f}.")

    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O88_rowmax_null.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "moduli": moduli,
                       "generators": args.generators, "rmax": args.rmax,
                       "tmax": args.tmax, "shuffles": args.shuffles,
                       "seed": args.seed, "n_blocks": int(n),
                       "detrend": "uniform per-row OLS fit of the main "
                                  "term; no branch, no character "
                                  "knowledge",
                       "control": "residue-class shuffle"},
            "labels": labels, "n_non_principal": int(n_np),
            "observed_rowmax": int(obs),
            "null": {"mean": float(null.mean()), "sd": float(null.std()),
                     "max": int(null.max()),
                     "counts": null.tolist()}}, args.out)


if __name__ == "__main__":
    main()
