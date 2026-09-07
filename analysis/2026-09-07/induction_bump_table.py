#!/usr/bin/env python3
"""
induction_bump_table.py -- the loss curve as a difference table across
doublings, and the decision rule of
preregs/induction_bump_difference_table_v1_20260907.md.

Reads the per-step eval losses written by induction_bump_train.py for the
locked seeds and both layer counts. For each run:

  dyadic samples   L_r = eval_loss at step 2^r, r = 0..R
  overlay          f(u) = a + b*2^(-c*u) - A*sigmoid((u - mu)/w), u = log2(step),
                   least squares on every step (the smooth curve with a smooth
                   bump; A is free to vanish, which is the one-layer shape)
  residual         e_r = L_r - f(r)
  tables           cell(r,0) = x_r, cell(r,d+1) = cell(r,d) - cell(r-1,d),
                   the bench's recurrence, for x = L (the arithmetic) and
                   x = e (what the overlay leaves)

THE RULE (fit-free). Plateau rows P run from row 8 to two rows before the
median two-layer bump row r*. On P the overlay is a slow monotone decline,
so every cell of its table at depth d has sign (-1)^d. A cell is a unanimous
anomaly when every seed's sign is the other one. N = the count of such cells
at depths 1..4; the rule reads the two-layer N against the one-layer N on
the same rows. Independent seeds make a unanimous anomaly a 2^(-S) event per
cell under "overlay plus SGD noise"; a shared deterministic fine structure
makes it common. The one-layer runs calibrate whatever the plateau itself
does without induction.

SECONDARY (fit-based, reported, never deciding). Across the S seeds of one
layer count, a cell of the residual table is
UNANIMOUS when every seed gives it the same sign. U_d = the number of
unanimous cells at depth d over rows r >= d. Under "the overlay is all",
residual signs are seed noise and a cell is unanimous with probability
2^(1-S). Under the posit, the discrete structure survives the fit and is the
same across seeds. The one-layer runs, fitted by the same family, calibrate
what a shared misfit alone produces; the rule reads the two-layer excess over
the one-layer count.

Also reported: the raw-loss anomaly count A_d (cells whose sign differs from
(-1)^d, the sign a completely monotone overlay gives at every cell), the bump
row r* (first dyadic row where the copied-position loss is under half its
step-1 value), and every table.

--power runs the rule on synthetic curves before the lock: the null is
the overlay plus iid noise at the smoke run's residual scale; the
alternative adds one fixed dyadic residual pattern shared across seeds at
amplitude k times that scale. It reports the firing rate of each label.
"""
import argparse
import json
import os
import sys
from datetime import datetime, timezone

import numpy as np
from scipy.optimize import least_squares

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, ROOT)
from utilities.resultsguard import guarded_write  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))


def overlay(params, u):
    """two smooth steps in log2(step): the unigram phase and the induction
    phase; a = the floor, A_i the drop, mu_i the centre, w_i the width."""
    a, A1, mu1, w1, A2, mu2, w2 = params
    return (a + A1 / (1.0 + np.exp((u - mu1) / w1))
              + A2 / (1.0 + np.exp((u - mu2) / w2)))


def fit_overlay(y):
    """least squares of the overlay on every step; deterministic starts."""
    n = len(y)
    u = np.log2(np.arange(1, n + 1))
    drop = y[0] - y[-1]
    best = None
    for mu1 in (4.0, 6.0):
        for mu2 in (10.0, 12.0, 14.0):
            p0 = [y[-1], 0.7 * drop, mu1, 0.5, 0.3 * drop, mu2, 0.5]
            lo = [-np.inf, 0.0, 0.0, 0.05, 0.0, 0.0, 0.05]
            hi = [np.inf, np.inf, np.log2(n) + 2, 5.0, np.inf, np.log2(n) + 2, 5.0]
            r = least_squares(lambda p: overlay(p, u) - y, p0, bounds=(lo, hi), max_nfev=4000)
            if best is None or r.cost < best.cost:
                best = r
    return best.x


def table(x):
    """cell(r, d) for d <= r; NaN above the diagonal."""
    R = len(x)
    T = np.full((R, R), np.nan)
    T[:, 0] = x
    for d in range(1, R):
        T[d:, d] = T[d:, d - 1] - T[d - 1:-1, d - 1]
    return T


def unanimous_counts(tables, dmax):
    """U_d over rows r >= d: every seed's cell has the same nonzero sign."""
    S = len(tables)
    signs = np.sign(np.stack(tables))  # S x R x R
    out = {}
    cells = {}
    for d in range(1, dmax + 1):
        col = signs[:, d:, d]
        agree = np.all(col == col[0:1], axis=0) & (col[0] != 0)
        out[d] = int(agree.sum())
        cells[d] = [int(r) for r in np.nonzero(agree)[0] + d]
    return out, cells, S


def anomaly_counts(tables, dmax):
    """A_d: unanimous cells whose sign differs from (-1)^d."""
    signs = np.sign(np.stack(tables))
    out = {}
    for d in range(1, dmax + 1):
        col = signs[:, d:, d]
        agree = np.all(col == col[0:1], axis=0) & (col[0] != 0)
        anom = agree & (col[0] != (-1) ** d)
        out[d] = int(anom.sum())
    return out


def plateau_anomalies(tables, rows, dmax):
    """N_d: cells at depth d, rows in `rows`, where every seed's sign differs
    from (-1)^d, the sign a completely monotone overlay gives. Fit-free."""
    signs = np.sign(np.stack(tables))  # S x R x R
    out, cells = {}, {}
    for d in range(1, dmax + 1):
        rr = [r for r in rows if r >= d]
        col = signs[:, rr, d]  # S x len(rr)
        anom = np.all(col == -((-1) ** d), axis=0)
        out[d] = int(anom.sum())
        cells[d] = [int(rr[i]) for i in np.nonzero(anom)[0]]
    return out, cells


def bump_row(copy_loss, R):
    """first dyadic row r with copy loss at step 2^r under half its step-1 value."""
    c0 = copy_loss[0]
    for r in range(R + 1):
        if copy_loss[2 ** r - 1] < 0.5 * c0:
            return r
    return None


def analyse_runs(runs, R, dmax, fit=True):
    """runs: list of dicts with eval_loss, eval_copy_loss. Returns per-layer
    stats. fit=False skips the secondary overlay fit (the rule needs none)."""
    Ltabs, Etabs, rows, fits = [], [], [], []
    for run in runs:
        y = np.asarray(run["eval_loss"], dtype=float)
        n = 2 ** R
        y = y[:n]
        rr = np.arange(R + 1)
        L = y[2 ** rr - 1]
        if fit:
            p = fit_overlay(y)
            e = L - overlay(p, rr.astype(float))
        else:
            p = np.zeros(7)
            e = np.zeros_like(L)
        Ltabs.append(table(L))
        Etabs.append(table(e))
        rows.append(bump_row(np.asarray(run["eval_copy_loss"], dtype=float), R))
        fits.append([float(v) for v in p])
    U, cells, S = unanimous_counts(Etabs, dmax)
    A = anomaly_counts(Ltabs, dmax)
    return dict(U=U, U_cells=cells, A=A, seeds=S, bump_rows=rows, fits=fits, Ltabs=Ltabs,
                L_tables=[np.nan_to_num(t, nan=0.0).tolist() for t in Ltabs],
                E_tables=[np.nan_to_num(t, nan=0.0).tolist() for t in Etabs],
                residual_sd=float(np.mean([np.nanstd(t[6:, 0]) for t in Etabs])))


def decide(two, one, dmax_rule, excess_fire, excess_null, plateau_lo, plateau_gap):
    """the locked rule, fit-free. Plateau rows P = plateau_lo .. r* - plateau_gap
    with r* the median two-layer bump row. N = sum over depths 1..dmax_rule of
    the unanimous-anomaly cells on P; the rule reads the two-layer N against the
    one-layer N on the same rows."""
    rows2 = [r for r in two["bump_rows"] if r is not None]
    bump_present = len(rows2) == two["seeds"]
    if not bump_present:
        return "compromised", dict(reason="induction bump absent in a two-layer seed",
                                   bump_rows=two["bump_rows"])
    rstar = int(round(np.median(rows2)))
    P = list(range(plateau_lo, rstar - plateau_gap + 1))
    if len(P) < 2:
        return "compromised", dict(reason="plateau shorter than two rows", rstar=rstar, P=P)
    N2, cells2 = plateau_anomalies(two["Ltabs"], P, dmax_rule)
    N1, cells1 = plateau_anomalies(one["Ltabs"], P, dmax_rule)
    n2, n1 = sum(N2.values()), sum(N1.values())
    excess = n2 - n1
    detail = dict(rstar=rstar, P=P, N2=N2, N1=N1, n2=n2, n1=n1, excess=excess,
                  cells2=cells2, cells1=cells1)
    if excess >= excess_fire:
        return "structure_beyond_overlay", detail
    if excess <= excess_null:
        return "overlay_only", detail
    return "ambiguous", detail


def synth_curve(rng, n, R, noise_sd, pattern=None, amp=0.0, bump=True):
    u = np.log2(np.arange(1, n + 1))
    p = [3.7, 1.4, 5.5, 0.3, 0.6 if bump else 0.0, 13.5, 0.3]
    y = overlay(p, u) + rng.normal(0, noise_sd, size=n)
    if pattern is not None:
        for r in range(R + 1):
            y[2 ** r - 1] += amp * noise_sd * pattern[r]
    copy = np.where(np.arange(1, n + 1) < 2 ** 13, 5.0, 0.2) if bump else np.full(n, 5.0)
    return dict(eval_loss=y.tolist(), eval_copy_loss=copy.tolist())


def power(args):
    rng = np.random.default_rng(2026)
    n, R = 2 ** args.R, args.R
    pattern = rng.choice([-1.0, 1.0], size=R + 1)
    out = {}
    for amp in [0.0] + args.power_amps:
        labels = {}
        for trial in range(args.power_trials):
            two = [synth_curve(rng, n, R, args.noise_sd, pattern, amp, bump=True) for _ in range(args.S)]
            one = [synth_curve(rng, n, R, args.noise_sd, None, 0.0, bump=False) for _ in range(args.S)]
            lab, _ = decide(analyse_runs(two, R, args.dmax, fit=False),
                            analyse_runs(one, R, args.dmax, fit=False),
                            args.dmax_rule, args.excess_fire, args.excess_null,
                            args.plateau_lo, args.plateau_gap)
            labels[lab] = labels.get(lab, 0) + 1
        out[str(amp)] = labels
        print("amp", amp, labels, flush=True)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--results", default=os.path.join(HERE, "results"))
    ap.add_argument("--seeds", default="1,2,3,4,5,6")
    ap.add_argument("--R", type=int, default=15)
    ap.add_argument("--dmax", type=int, default=6)
    ap.add_argument("--dmax-rule", type=int, default=4)
    ap.add_argument("--excess-fire", type=int, default=2)
    ap.add_argument("--excess-null", type=int, default=0)
    ap.add_argument("--plateau-lo", type=int, default=8)
    ap.add_argument("--plateau-gap", type=int, default=2)
    ap.add_argument("--power", action="store_true")
    ap.add_argument("--power-trials", type=int, default=100)
    ap.add_argument("--power-amps", type=lambda s: [float(x) for x in s.split(",")], default=[1.0, 2.0, 3.0])
    ap.add_argument("--noise-sd", type=float, default=0.003)
    ap.add_argument("--S", type=int, default=6)
    ap.add_argument("--out", default=None)
    args = ap.parse_args()
    t0 = datetime.now(timezone.utc).isoformat()
    if args.power:
        payload = dict(mode="power", args=vars(args), run_start_at=t0, firing=power(args),
                       run_end_at=datetime.now(timezone.utc).isoformat())
        out = args.out or os.path.join(HERE, "results", "induction_bump_power.json")
        guarded_write(payload, out); print("wrote", out); return
    seeds = [int(s) for s in args.seeds.split(",")]
    per = {}
    for layers in (2, 1):
        runs = []
        for s in seeds:
            path = os.path.join(args.results, f"induction_bump_L{layers}_seed{s}.json")
            with open(path) as f:
                runs.append(json.load(f))
        per[layers] = analyse_runs(runs, args.R, args.dmax)
    label, detail = decide(per[2], per[1], args.dmax_rule, args.excess_fire, args.excess_null,
                           args.plateau_lo, args.plateau_gap)
    payload = dict(mode="verdict_rule", args=vars(args), run_start_at=t0,
                   mechanical_output=label, detail=detail,
                   two_layer={k: v for k, v in per[2].items() if k != "Ltabs"},
                   one_layer={k: v for k, v in per[1].items() if k != "Ltabs"},
                   run_end_at=datetime.now(timezone.utc).isoformat())
    out = args.out or os.path.join(HERE, "results", "induction_bump_table.json")
    guarded_write(payload, out)
    print("mechanical output:", label, detail)
    print("U (two-layer):", per[2]["U"], " U (one-layer):", per[1]["U"])
    print("A (two-layer):", per[2]["A"], " A (one-layer):", per[1]["A"])
    print("bump rows:", per[2]["bump_rows"], per[1]["bump_rows"])
    print("wrote", out)


if __name__ == "__main__":
    main()
