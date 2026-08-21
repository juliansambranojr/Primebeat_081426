#!/usr/bin/env python3
"""O48 — small angles and the cross-base transform: where does the residual
table's normalized depth gain null?

Reads with: preregs/small_angle_cross_base_v1_20260821.md  (LOCKED, sidecar
preregs/small_angle_cross_base_v1_20260821.sha256)
            notes/lab_notebook_2.md entry 72

Every parameter below is copied from that prereg's Locked parameters table and
may not be changed. Nothing here is stochastic and there is no --seed flag.

THE CLAIM UNDER TEST. One backward difference on the b-ladder multiplies a mode
b^(r*rho) by Sym(b,rho) = 1 - b^(-rho), so the normalized depth gain
|Sym|/log b tends to |rho| as log b -> 0. At u = gamma*log b = 2*pi*k the
oscillatory part cancels exactly and Sym becomes real, 1 - b^(-1/2): the mode
is NULLED, not aliased. Each zeta zero therefore predicts its own null base
exp(2*pi/gamma_n).

The test is POSITIONAL: where is the dip, not whether it is surprising. There
is no null hypothesis in the statistical sense and no p-value; the rivals are
other deterministic models and the tolerance is a measured noise floor.
"""
import argparse
import hashlib
import json
import math
import pathlib
import statistics
import sys
from datetime import datetime, timezone

import mpmath as mp

_HERE = pathlib.Path(__file__).resolve().parent
DEFAULT_OUT = _HERE / "results" / "small_angle_cross_base.json"

# ---- locked parameters, from the prereg ------------------------------------
GAMMAS = {
    "g1": 14.134725141734693,
    "g2": 21.022039638771555,
    "g3": 25.010857580145688,
    "g4": 30.424876125859513,
}
BASES = [1.1500, 1.2293859, 1.2560, 1.2855907, 1.3160, 1.3483554,
         1.4200, 1.5000, 1.5597432, 1.6200, 1.7500, 2.0000]
CANDIDATES = {1.2293859: "g4", 1.2855907: "g3", 1.3483554: "g2", 1.5597432: "g1"}
VALUE_CEILING = 2 ** 32
VALUE_FLOOR = 10 ** 4
DEPTH_WINDOW = range(3, 9)          # d in [3, 8]
MIN_CELLS_PER_DEPTH = 8
MIN_DEPTHS = 4
FLOOR_COMPROMISED_BELOW = 0.80
DPS = 50

mp.mp.dps = DPS

try:
    from primecountpy import prime_pi as _pi
    PI_BACKEND = "primecountpy.prime_pi"
except Exception:                                        # pragma: no cover
    from sympy import primepi as _sp
    def _pi(n): return int(_sp(n))
    PI_BACKEND = "sympy.primepi"


def code_version():
    return hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest()


# ---- the pipeline ----------------------------------------------------------
def rungs(b):
    """r values whose rung top b**r lies in [VALUE_FLOOR, VALUE_CEILING]."""
    lo = math.ceil(math.log(VALUE_FLOOR) / math.log(b))
    hi = math.floor(math.log(VALUE_CEILING) / math.log(b))
    return list(range(lo, hi + 1))


def residual_row(b, rs):
    """e(r) = [pi(b^r) - pi(b^(r-1))] - [li(b^r) - li(b^(r-1))]."""
    out = {}
    for r in rs:
        hi, lo = math.floor(b ** r), math.floor(b ** (r - 1))
        counted = _pi(hi) - _pi(lo)
        smooth = float(mp.li(mp.mpf(b) ** r) - mp.li(mp.mpf(b) ** (r - 1)))
        out[r] = counted - smooth
    return out


def synthetic_row(b, rs):
    """Control: a mode-free row round(b**(r/2)). Its exact gain is
    |1 - b**(-1/2)| at every depth, so any departure is pipeline noise."""
    return {r: float(round(b ** (r / 2))) for r in rs}


def difference_table(row, rs, dmax):
    """E[d][r], backward differences. E[0] is the row itself."""
    tab = {0: dict(row)}
    for d in range(1, dmax + 1):
        prev, cur = tab[d - 1], {}
        for r in rs:
            if r - 1 in prev and r in prev:
                cur[r] = prev[r] - prev[r - 1]
        tab[d] = cur
    return tab


def gain_curve(tab, rs, rmin):
    """gain[d] = median over valid r of |E(r,d)| / |E(r,d-1)|, for d in the
    locked depth window. A cell is valid only if its whole window r-d..r sits
    inside the measured rungs."""
    gains = {}
    for d in DEPTH_WINDOW:
        vals = []
        for r in rs:
            if r - d < rmin:
                continue
            num, den = tab.get(d, {}).get(r), tab.get(d - 1, {}).get(r)
            if num is None or den is None or den == 0:
                continue
            vals.append(abs(num) / abs(den))
        if len(vals) >= MIN_CELLS_PER_DEPTH:
            gains[d] = statistics.median(vals)
    return gains


def ghat(row, rs, b):
    tab = difference_table(row, rs, max(DEPTH_WINDOW))
    gains = gain_curve(tab, rs, rs[0])
    if len(gains) < MIN_DEPTHS:
        return None, gains
    return statistics.median(gains.values()) / math.log(b), gains


def predicted_ghat(b, rho):
    h = math.log(b)
    return abs(1 - complex(mp.e) ** (-rho * h)) / h


def dip_ratios(vals):
    """D(b) = Ghat(b) / median(Ghat(left), Ghat(right)) for interior bases."""
    D = {}
    for i in range(1, len(BASES) - 1):
        b = BASES[i]
        here, lo, hi = vals.get(b), vals.get(BASES[i - 1]), vals.get(BASES[i + 1])
        if None in (here, lo, hi):
            continue
        D[b] = here / statistics.median([lo, hi])
    return D


# ---- run -------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(DEFAULT_OUT))
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    started = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    rho1 = complex(0.5, GAMMAS["g1"])
    print(f"O48 — small angle cross-base   started {started}")
    print(f"prereg preregs/small_angle_cross_base_v1_20260821.md (LOCKED)")
    print(f"pi backend {PI_BACKEND}   mp.dps {DPS}   code_version {code_version()[:16]}\n")

    print("1. GEOMETRY")
    print(f"{'base':>11} {'r_min':>6} {'r_max':>6} {'rungs':>6}   value window")
    geom, rungmap = {}, {}
    for b in BASES:
        rs = rungs(b)
        rungmap[b] = rs
        geom[b] = {"r_min": rs[0], "r_max": rs[-1], "n_rungs": len(rs)}
        print(f"{b:11.7f} {rs[0]:6d} {rs[-1]:6d} {len(rs):6d}   "
              f"({b**(rs[0]-1):.3e}, {b**rs[-1]:.3e}]")

    print("\n2. PREDICTED, from constants alone (no data touched)")
    pred_h1 = {b: predicted_ghat(b, rho1) for b in BASES}
    pred_h0 = {b: predicted_ghat(b, complex(0.5, 0.0)) for b in BASES}
    print(f"{'base':>11} {'H0 smooth':>10} {'H1 gamma1':>10}  candidate")
    for b in BASES:
        print(f"{b:11.7f} {pred_h0[b]:10.4f} {pred_h1[b]:10.4f}  {CANDIDATES.get(b,'')}")

    print("\n3. MEASURED Ghat")
    meas, gains_all = {}, {}
    for b in BASES:
        g, gains = ghat(residual_row(b, rungmap[b]), rungmap[b], b)
        meas[b], gains_all[b] = g, {str(k): v for k, v in gains.items()}
        flag = "" if g is not None else "  <-- too few depths"
        print(f"{b:11.7f}  Ghat={g if g is None else f'{g:10.4f}'}  "
              f"depths={len(gains)}{flag}")

    print("\n4. CONTROL — mode-free row round(b^(r/2))")
    ctrl = {}
    for b in BASES:
        g, _ = ghat(synthetic_row(b, rungmap[b]), rungmap[b], b)
        ctrl[b] = g
        exact = abs(1 - b ** -0.5) / math.log(b)
        print(f"{b:11.7f}  Ghat_ctrl={g if g is None else f'{g:8.4f}'}   "
              f"exact={exact:8.4f}")
    D_ctrl = dip_ratios(ctrl)
    floor = min(D_ctrl.values()) if D_ctrl else None
    print(f"\n   D_ctrl: " + "  ".join(f"{b:.4f}:{d:.4f}" for b, d in D_ctrl.items()))
    print(f"   floor = min D_ctrl = {floor:.4f}" if floor else "   floor = None")

    print("\n5. D AT EACH CANDIDATE NULL")
    D = dip_ratios(meas)
    for b, tag in sorted(CANDIDATES.items()):
        v = D.get(b)
        print(f"   {tag}  b={b:.7f}   D={v if v is None else f'{v:.4f}'}   "
              f"(predicted under H1: {dip_pred(pred_h1, b):.4f})")

    print("\n6. ARGMIN over all interior bases")
    argmin_b = min(D, key=D.get) if D else None
    print(f"   argmin D = {argmin_b}   D = {D[argmin_b]:.4f}" if argmin_b else "   none")

    print("\n7. SHAPE RESIDUAL (descriptive, no threshold)")
    logs = [math.log(meas[b] / pred_h1[b]) for b in BASES
            if meas.get(b) and pred_h1[b] > 0]
    rms = math.sqrt(sum(x * x for x in logs) / len(logs)) if logs else None
    print(f"   RMS log(measured/predicted H1) = {rms:.4f}" if rms else "   n/a")

    print("\nDECISION RULE — mechanical output (the verdict line is Julian's)")
    out = decide(meas, D, floor, argmin_b)
    print(f"   {out}")

    ended = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    payload = {
        "schema_version": "1",
        "script": pathlib.Path(__file__).name,
        "generated_utc": ended,
        "params": {
            "prereg": "preregs/small_angle_cross_base_v1_20260821.md",
            "prereg_sidecar_sha256":
                (_HERE / "preregs/small_angle_cross_base_v1_20260821.sha256")
                .read_text().strip(),
            "bases": BASES, "candidates": {str(k): v for k, v in CANDIDATES.items()},
            "value_floor": VALUE_FLOOR, "value_ceiling": VALUE_CEILING,
            "depth_window": [3, 8], "min_cells_per_depth": MIN_CELLS_PER_DEPTH,
            "min_depths": MIN_DEPTHS, "dps": DPS, "pi_backend": PI_BACKEND,
            "code_version": code_version(),
        },
        "constants": GAMMAS,
        "summary": {
            "run_start_at": started, "run_end_at": ended,
            "floor": floor, "argmin_base": argmin_b,
            "argmin_D": D.get(argmin_b) if argmin_b else None,
            "D_at_candidates": {str(b): D.get(b) for b in CANDIDATES},
            "shape_rms_log": rms,
            "mechanical_output": out,
            "verdict": None,
        },
        "rows": [{"base": b, "geometry": geom[b],
                  "predicted_h0": pred_h0[b], "predicted_h1": pred_h1[b],
                  "measured_ghat": meas[b], "control_ghat": ctrl[b],
                  "D": D.get(b), "D_ctrl": D_ctrl.get(b),
                  "gain_per_depth": gains_all[b]} for b in BASES],
    }
    if not args.no_json:
        try:
            p = pathlib.Path(args.out); p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(json.dumps(payload, indent=2))
            print(f"\nwrote {p}")
        except Exception as e:                            # never kill a long run
            print(f"\nWARNING: could not write results: {e}", file=sys.stderr)


def dip_pred(pred, b):
    i = BASES.index(b)
    return pred[b] / statistics.median([pred[BASES[i - 1]], pred[BASES[i + 1]]])


def decide(meas, D, floor, argmin_b):
    """Locked decision rule, precedence top to bottom. Reports the mechanical
    output only; it does not stamp a verdict."""
    if any(v is None for v in meas.values()):
        return "compromised  (a base yielded fewer than min_depths depths)"
    if floor is None or floor < FLOOR_COMPROMISED_BELOW:
        return f"compromised  (control floor {floor} < {FLOOR_COMPROMISED_BELOW})"
    if argmin_b is None or D[argmin_b] >= floor:
        return "no_null  (no base has D below the measured floor)"
    tag = CANDIDATES.get(argmin_b)
    if tag == "g1":
        return f"gamma1_null  (argmin at {argmin_b}, D={D[argmin_b]:.4f} < floor={floor:.4f})"
    if tag == "g2":
        return f"gamma2_null  (argmin at {argmin_b}, D={D[argmin_b]:.4f} < floor={floor:.4f})"
    if tag in ("g3", "g4"):
        return f"higher_block_null  (argmin at {argmin_b}, D={D[argmin_b]:.4f})"
    return f"unpredicted_null  (argmin at {argmin_b}, not a candidate, D={D[argmin_b]:.4f})"


if __name__ == "__main__":
    main()
