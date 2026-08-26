#!/usr/bin/env python3
"""O89 — PREREGISTERED. preregs/character_sweep_q11_q13_v1_20260826.md
(locked, sha256 8347ec9a88ea7356d68de848457b8ee665d5b0be5c05cbc262ec07ea7a663b60).

Does each character's residual score highest against its OWN
L-function's zeros, on two moduli this tree has never swept?

R = the count of non-principal rows whose diagonal cell is the maximum
of its row. Ordinal, self-normalising, and needing no per-cell
p-values, no control calibration and no multiple-comparison
correction — rows share a residual and columns share a target list, so
per-cell testing cannot settle its own degrees of freedom, and this
statistic sidesteps them.

Construction per entry 179: the detrend is a UNIFORM per-row OLS fit of
the main-term coefficient, with no knowledge of which character it is
looking at, so the design has no branch and no free parameter. The null
is a residue-class shuffle computed IN the run — it preserves psi(x),
the rung grid, the window and the |F|-versus-t trend exactly, and
destroys only the arithmetic.

Power, measured before the prereg was locked (O88,
results/rowmax_null.json): 8 of 8 on q = 5, 7 against a shuffle null of
mean 0.730 that never exceeded 3 in 300 draws; per-row rate 1.000 with
a 95% lower bound of 0.688, so a 20-row sweep expects ~13.8 hits.

Applies the locked decision rule mechanically. Does NOT stamp a
verdict.

HOW IT WAS RUN
--------------
    .venv/bin/python O89_sweep_q11_q13.py
"""
import argparse, hashlib, json, os, sys, types
from datetime import datetime, timezone
import numpy as np

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_OUT = os.path.join(_HERE, "results", "sweep_q11_q13.json")
PREREG = os.path.join(_HERE, "preregs",
                      "character_sweep_q11_q13_v1_20260826.md")
FROZEN = os.path.join(_HERE, "results", "frozen_targets_q11_q13.json")


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


def _sha(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def main():
    ap = argparse.ArgumentParser(
        description=("O89 - PREREGISTERED sweep of q=11 and q=13. "
                     "Applies the locked decision rule mechanically; "
                     "does not stamp a verdict."))
    ap.add_argument("--moduli", type=str, default="11,13")
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--tmax", type=float, default=40.0)
    ap.add_argument("--shuffles", type=int, default=200)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    started = datetime.now(timezone.utc)
    o = _load_o87()
    rng = np.random.default_rng(args.seed)
    moduli = [int(m) for m in args.moduli.split(",")]
    compromised = []

    print("O89 - the preregistered sweep, q = 11 and 13.  PREREGISTERED.")
    print(f"  prereg character_sweep_q11_q13_v1_20260826.md  sha256 "
          f"{_sha(PREREG)[:16]}...\n")

    xs = np.array(o.orbit([int(g) for g in args.generators.split(",")],
                          1 << args.rmax), dtype=float)
    lx = np.log(xs[:-1]); n = len(lx)
    if n < 300:
        compromised.append(f"only {n} blocks")
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))

    frozen = json.load(open(FROZEN))
    print(f"GATE - frozen targets sha256 {_sha(FROZEN)[:16]}...")

    C = {q: o.class_sums(xs, q) for q in moduli}
    labels, cvecs, targets, principal = [], [], [], []
    for q in moduli:
        for k, chi in o.characters(q):
            lab = f"q={q} k={k}" + (" (principal)" if k == 0 else "")
            z = o.zeros_of(chi, q, args.tmax)
            fz = frozen.get(lab)
            if fz is None or len(fz) != len(z) or any(
                    abs(a - b) > 1e-4 for a, b in zip(z, fz)):
                compromised.append(f"target mismatch {lab}")
            labels.append(lab); cvecs.append((q, np.array(
                [chi[a] for a in range(q)])))
            targets.append(np.array(z)); principal.append(k == 0)
    m = len(labels); n_np = m - sum(principal)
    print(f"GATE - {m} characters recomputed, {n_np} non-principal; "
          f"target lists match frozen: {not any('mismatch' in c for c in compromised)}")
    print(f"  {n} blocks on the orbit\n")

    def rowmax(tables, report=False):
        hits, coefs = 0, []
        for i, (q, cv) in enumerate(cvecs):
            e, c = detrend_uniform(tables[q] @ cv, xs)
            coefs.append(c)
            if principal[i]:
                continue
            vw = w * e
            sc = [float(np.abs(np.exp(-1j * np.outer(t, lx)) @ vw).mean())
                  for t in targets]
            if int(np.argmax(sc)) == i:
                hits += 1
            if report:
                d = sc[i]; off = max(v for j, v in enumerate(sc) if j != i)
                print(f"   {labels[i]:>20}  diagonal {d:>10.4f}   best "
                      f"rival {off:>10.4f}   {'MAX' if d > off else '-'}")
        return hits, coefs

    print("PER-ROW RESULT (non-principal):")
    R, coefs = rowmax(C, report=True)
    if not all(np.isfinite(coefs)):
        compromised.append("non-finite main-term coefficient")
    print(f"\n  fitted main-term coefficients: principal "
          f"{[round(c,6) for i,c in enumerate(coefs) if principal[i]]}, "
          f"others max |c| "
          f"{max(abs(c) for i,c in enumerate(coefs) if not principal[i]):.2e}")
    print(f"\n  R = {R} of {n_np}")

    print(f"\nNULL - residue-class shuffle, {args.shuffles} draws, "
          f"computed on these same moduli:")
    null = []
    for s in range(args.shuffles):
        Cs = {}
        for q in moduli:
            base = C[q]
            inc = np.diff(np.vstack([np.zeros(q), base]), axis=0)
            perm = np.empty_like(inc)
            for j in range(inc.shape[0]):
                perm[j] = inc[j][rng.permutation(q)]
            Cs[q] = np.cumsum(perm, axis=0)
        null.append(rowmax(Cs)[0])
        if (s + 1) % 50 == 0:
            print(f"   {s+1}/{args.shuffles}, running mean "
                  f"{np.mean(null):.3f}", flush=True)
    null = np.array(null)
    print(f"\n  null mean {null.mean():.3f}  sd {null.std():.3f}  "
          f"max {null.max()}   draws reaching R: "
          f"{int((null >= R).sum())}/{args.shuffles}")

    if compromised:
        out = "compromised"
    elif R >= 10 and (null < R).all():
        out = "carries_own"
    else:
        out = "null"
    print(f"\nDECISION RULE OUTPUT (mechanical): {out}")
    if compromised:
        print(f"   compromised by: {compromised}")
    print("   The verdict line is Julian's to write.")

    ended = datetime.now(timezone.utc)
    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O89_sweep_q11_q13.py",
            "generated_utc": ended.isoformat(), "exploratory": False,
            "prereg": "preregs/character_sweep_q11_q13_v1_20260826.md",
            "prereg_sha256": _sha(PREREG),
            "frozen_targets_sha256": _sha(FROZEN),
            "params": {"code_version": _code_version(), "moduli": moduli,
                       "generators": args.generators, "rmax": args.rmax,
                       "tmax": args.tmax, "shuffles": args.shuffles,
                       "seed": args.seed, "n_blocks": int(n)},
            "run_start_at": started.isoformat(),
            "run_end_at": ended.isoformat(),
            "labels": labels, "n_non_principal": int(n_np),
            "R": int(R),
            "main_term_coefficients": [float(c) for c in coefs],
            "null": {"mean": float(null.mean()), "sd": float(null.std()),
                     "max": int(null.max()), "counts": null.tolist()},
            "decision_rule_output": out, "compromised_by": compromised,
            "verdict": None}, args.out)


if __name__ == "__main__":
    main()
