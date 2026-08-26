#!/usr/bin/env python3
"""O87 — EXPLORATORY. No prereg, no verdict.

The character sweep: ask the primes which weighting they answer to,
instead of telling them which one to answer.

WHY THIS EXISTS. Entry 176's cross-character matrix had two rows and
was built to test a named hypothesis. Entry 177 records that an
assistant then called the method "a confirmation instrument, not a
discovery instrument" — an invented category, withdrawn — and that the
foreclosure hid a real instrument: the method needs a CHARACTER, not a
list of zeros, and characters are enumerable. Sweep them and the
question stops being "are these zeros there" and becomes "which
spectrum is this data carrying". That is a search.

WHAT IT DOES. Sieve ONCE. Accumulate, per orbit rung and per modulus,
the von Mangoldt mass in each residue class. Every character mod q is
then a reweighting of those class sums, so the whole family costs one
sieve. For each character chi:

  residual   e_j = psi(x_{j+1}, chi) - psi(x_j, chi), normalised by
             sqrt(x_j). No smooth term for a non-principal chi, whose L
             has no pole. The PRINCIPAL character is the exception —
             L(s, chi_0) = zeta(s)(1 - q^-s) has a pole, psi(x, chi_0)
             ~ x, and its main term must be subtracted or it buries the
             signal (measured: rms 404.8 against 0.29, score 0.224
             against 5.520)
  targets    the on-line zeros of L(s, chi), computed from chi

and then score EVERY residual against EVERY target list. The diagonal
is the claim; the off-diagonal is the control; and no gamma-trend,
window, grid or normalisation artifact can produce a difference
between cells, because all of those are identical across the matrix.

THE GROUND-TRUTH ROW. For prime q the principal character gives
L(s, chi_0) = zeta(s)(1 - q^{-s}), whose on-line zeros ARE zeta's. So
one row of the sweep is a check against a spectrum nobody in this tree
disputes: if the instrument works, the principal residual lights at
14.1347, 21.0220, 25.0109, ... That row is not a result. It is the
calibration.

SIGNIFICANCE is against RANGE-MATCHED random frequency sets — random
lists of the same size drawn from the same span — never against a
permutation of the residual. Entry 175's correction records why:
permuting flattens the spectrum by construction and cannot see a
gamma-trend.

The psi construction uses the CUMULATIVE prime-power form (entry 176's
fix), not the defective one shared by O83/O84/O85.

Reads with: notes/lab_notebook_2.md entries 163, 175, 176, 177;
O86_character_discrimination.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O87_character_sweep.py
"""
import argparse, cmath, hashlib, math, os, sys
from datetime import datetime, timezone
import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_OUT = os.path.join(_HERE, "results", "character_sweep.json")


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
                new.append(w); w *= g
        pts = new
    return sorted(set(p for p in pts if 2 <= p <= xmax))


def primitive_root(q):
    from sympy import primitive_root as pr
    return pr(q)


def characters(q):
    """All Dirichlet characters mod prime q, as dicts on residues."""
    g = primitive_root(q)
    ind, v = {}, 1
    for m in range(q - 1):
        ind[v] = m; v = (v * g) % q
    out = []
    for k in range(q - 1):
        chi = {0: 0j}
        for a in range(1, q):
            chi[a] = cmath.exp(2j * math.pi * k * ind[a] / (q - 1))
        out.append((k, chi))
    return out


def class_sums(xs, q):
    """Per-rung cumulative von Mangoldt mass by residue class mod q.
    One sieve serves every character mod q. Prime powers CUMULATIVE."""
    top = int(xs[-1]); lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool); s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]: s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(int(p)))); v *= int(p)
    extra.sort()
    out = np.zeros((len(xs), q)); cum = np.zeros(q); ecum = np.zeros(q)
    cps = [int(x) for x in xs]; lo, ci, ex = 2, 0, 0; seg = 1 << 24
    while lo <= top:
        hi = min(lo + seg, top + 1)
        blk = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi: break
            st = max(p * p, ((lo + p - 1) // p) * p)
            blk[st - lo::p] = False
        idx = (np.flatnonzero(blk) + lo).astype(np.int64)
        lg = np.log(idx); res = idx % q
        order = np.argsort(idx); idx, lg, res = idx[order], lg[order], res[order]
        csum = np.zeros((len(idx) + 1, q))
        np.add.at(csum, (np.arange(1, len(idx) + 1), res), lg)
        csum = np.cumsum(csum, axis=0)
        while ci < len(cps) and cps[ci] < hi:
            k = int(np.searchsorted(idx, cps[ci], side="right"))
            while ex < len(extra) and extra[ex][0] <= cps[ci]:
                ecum[extra[ex][0] % q] += extra[ex][1]; ex += 1
            out[ci] = cum + csum[k] + ecum
            ci += 1
        cum = cum + csum[-1]; lo = hi
    while ci < len(cps):
        while ex < len(extra) and extra[ex][0] <= cps[ci]:
            ecum[extra[ex][0] % q] += extra[ex][1]; ex += 1
        out[ci] = cum + ecum; ci += 1
    return out


def zeros_of(chi, q, tmax, step=0.05):
    """On-line zeros of L(s,chi), 0 < t < tmax.

    Scan |L| on the critical line for local minima, then root-find on
    the COMPLEX L seeded there — not on |L|, which is non-negative and
    non-smooth at its own zeros and stalls a secant solver on any local
    minimum that is not a zero. That is how the first version of this
    script died, on the principal character mod 5, whose |L| has such
    minima between zeta's zeros. O80_dh_zeros.py locates off-line zeros
    the same way, for the same reason. A candidate is accepted only if
    the root lands on the line and L really vanishes there."""
    cm = {a: mp.mpc(chi[a].real, chi[a].imag) for a in chi}
    def L(s):
        return q ** (-s) * sum(cm[a] * mp.zeta(s, mp.mpf(a) / q)
                               for a in range(1, q))
    def aL(t): return abs(L(mp.mpf('0.5') + 1j * t))
    out = []; t = mp.mpf('0.2'); prev = aL(t); prev2 = None
    while t < tmax:
        t += mp.mpf(str(step)); cur = aL(t)
        if prev2 is not None and prev < prev2 and prev < cur and prev < 0.4:
            seed = mp.mpc(mp.mpf('0.5'), t - mp.mpf(str(step)))
            try:
                root = mp.findroot(L, seed)
            except Exception:
                prev2, prev = prev, cur
                continue
            if (abs(mp.re(root) - mp.mpf('0.5')) < mp.mpf('1e-6')
                    and abs(L(root)) < mp.mpf('1e-8')
                    and mp.im(root) > mp.mpf('0.3')
                    and mp.im(root) < tmax):
                out.append(float(mp.im(root)))
        prev2, prev = prev, cur
    return sorted(set(round(v, 6) for v in out))


def main():
    ap = argparse.ArgumentParser(
        description=("O87 - sweep every character mod q and ask which "
                     "weighting the prime data answers to. EXPLORATORY: "
                     "no prereg, no decision rule, no verdict."))
    ap.add_argument("--moduli", type=str, default="5,7")
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--tmax", type=float, default=40.0)
    ap.add_argument("--controls", type=int, default=800)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    rng = np.random.default_rng(args.seed); mp.mp.dps = 20
    moduli = [int(m) for m in args.moduli.split(",")]
    xs = np.array(orbit([int(g) for g in args.generators.split(",")],
                        1 << args.rmax), dtype=float)
    lx = np.log(xs[:-1]); n = len(lx)
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    grid = np.linspace(0.5, args.tmax, 1600)

    print("O87 — the character sweep.  EXPLORATORY.")
    print(f"  moduli {moduli}   orbit {args.generators} to 2^{args.rmax}"
          f"   {n} blocks\n")

    labels, resids, targets = [], [], []
    for q in moduli:
        print(f"  sieving once for q = {q} ...", flush=True)
        C = class_sums(xs, q)
        for k, chi in characters(q):
            cvec = np.array([chi[a] for a in range(q)])
            psi = C @ cvec
            # The PRINCIPAL character is the one case with a pole:
            # L(s, chi_0) = zeta(s)(1 - q^-s), so psi(x, chi_0) ~ x and
            # the raw difference is dominated by that main term. Run 2
            # of this script left it in and the calibration row read
            # 0.224 at p = 0.999 with residual rms 404.8 against 0.29
            # elsewhere — the signal buried under three orders of
            # magnitude of linear growth. Subtracting x restores it to
            # 5.520 at p = 0.0000. Every non-principal L has no pole and
            # needs no subtraction; this branch is the exception, not a
            # tuning knob.
            if k == 0:
                e = (np.diff(psi) - np.diff(xs)) / np.sqrt(xs[:-1])
            else:
                e = np.diff(psi) / np.sqrt(xs[:-1])
            lab = f"q={q} k={k}" + (" (principal)" if k == 0 else "")
            z = zeros_of(chi, q, args.tmax)
            if len(z) < 4:
                print(f"     {lab}: only {len(z)} zeros found, skipped")
                continue
            labels.append(lab); resids.append(e); targets.append(z)
            print(f"     {lab}: {len(z)} zeros, "
                  f"{z[0]:.4f} .. {z[-1]:.4f}", flush=True)

    m = len(labels)
    print(f"\n  {m} characters carried forward\n")
    print("SCORE MATRIX — rows are the WEIGHTING applied to the primes,")
    print("columns are the TARGET zero list. Cell = mean P/median.")
    print("Range-matched one-sided p in brackets.\n")
    hdr = "".join(f"{lab.split(' (')[0]:>16}" for lab in labels)
    print(f"{'weighting':>18}{hdr}")
    matrix = {}
    for i, lab in enumerate(labels):
        vw = w * np.real(resids[i]) if np.iscomplexobj(resids[i]) else w * resids[i]
        vwc = w * resids[i]
        med = float(np.median(np.abs(np.exp(-1j * np.outer(grid, lx)) @ vwc)))
        row, cells = {}, []
        for j, tl in enumerate(targets):
            arr = np.array(tl)
            score = float(np.abs(np.exp(-1j * np.outer(arr, lx)) @ vwc).mean()
                          / med)
            lo, hi, k = arr.min(), arr.max(), len(arr)
            r = rng.uniform(lo, hi, (args.controls, k))
            ctrl = np.abs(np.exp(-1j * np.outer(r.ravel(), lx)) @ vwc)
            ctrl = (ctrl.reshape(args.controls, k).mean(axis=1) / med)
            pv = float((ctrl >= score).mean())
            row[labels[j]] = {"score": score, "p": pv}
            mark = "*" if pv < 0.01 else (":" if pv < 0.05 else " ")
            cells.append(f"{score:>7.3f}{mark}[{pv:<5.3f}]")
        matrix[lab] = row
        print(f"{lab:>18}" + "".join(f"{c:>16}" for c in cells))

    print("\n  * p < 0.01   : p < 0.05")
    print("\n  READ. The diagonal is the claim, the off-diagonal is the")
    print("  control, and the principal rows are the calibration — for")
    print("  prime q, L(s,chi_0) = zeta(s)(1-q^-s), so those targets are")
    print("  zeta's own zeros. Everything but the weight vector is")
    print("  identical across every cell.")

    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O87_character_sweep.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "moduli": moduli,
                       "generators": args.generators, "rmax": args.rmax,
                       "tmax": args.tmax, "controls": args.controls,
                       "seed": args.seed, "n_blocks": int(n),
                       "control": "range-matched random frequency sets"},
            "characters": labels,
            "zeros": {labels[i]: targets[i] for i in range(m)},
            "matrix": matrix}, args.out)


if __name__ == "__main__":
    main()
