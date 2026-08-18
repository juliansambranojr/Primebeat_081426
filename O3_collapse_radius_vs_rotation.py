"""O3 — collapse past the boundary: radius or rotation?
Requires: mpmath, sympy, numpy; primecountpy optional (faster).
r<=45 is ample. Do NOT go past 50 — it buys nothing and costs hours."""
import argparse, json, math, os
from datetime import datetime, timezone
import numpy as np
from mpmath import mp
mp.dps = 80
from mpmath import mpf, li

BOUNDARY = {1:4,2:6,3:8,4:11,5:16,6:20,7:23,8:24,9:29,
            10:33,11:35,12:36,13:37,14:48,15:51,16:53,17:54}
GAMMA_1 = 14.134725141734693
_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
CACHE = os.path.join(_HERE, "pi2n_cache_o3.json")


def _jsonable(o):
    """Coerce numpy / mpmath scalars to JSON-safe Python types.

    numpy floats -> float, numpy ints -> int, numpy bools -> bool,
    mpmath mpf -> float, non-finite floats -> None (JSON null).
    """
    if isinstance(o, dict):
        return {k: _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str):
        return o
    if isinstance(o, (bool, np.bool_)):
        return bool(o)
    if isinstance(o, (int, np.integer)):
        return int(o)
    if isinstance(o, (float, np.floating)):
        f = float(o)
        return f if math.isfinite(f) else None
    try:
        f = float(o)
    except (TypeError, ValueError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a long run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
        print(f"\n  results written to {out_path}")
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}")

def prime_counts(rmax):
    P = {}
    if os.path.exists(CACHE):
        P = {int(k): v for k, v in json.load(open(CACHE)).items()}
    need = [n for n in range(rmax+1) if n not in P]
    if need:
        try:
            import primecountpy as pc
            for n in need:
                P[n] = int(pc.prime_pi(2**n)); print(f"  pi(2^{n})={P[n]}", flush=True)
        except ImportError:
            from sympy import primepi
            for n in need:
                P[n] = int(primepi(2**n)); print(f"  pi(2^{n})={P[n]}", flush=True)
        json.dump({str(k): v for k, v in P.items()}, open(CACHE, "w"))
    return [P[n]-P[n-1] for n in range(1, rmax+1)]

def diff(seq, r, d):
    return sum((-1)**(d-k)*math.comb(d,k)*seq[r-d+k-1] for k in range(d+1))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=45)
    ap.add_argument("--alpha", type=float, default=0.4334)
    ap.add_argument("--span", type=int, default=12)
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path (default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    a = ap.parse_args()
    R, alpha = min(a.rmax, 50), a.alpha

    print("="*78); print("O3 — collapse past the boundary: radius or rotation?"); print("="*78)
    print(f"  alpha={alpha}; radius-only decay = {2**-(1-alpha):.4f} * r/(r+1) per regime")
    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2)**n) - li(mpf(2)**(n-1)) for n in range(1, R+1)]
    w1 = GAMMA_1*math.log(2) % (2*math.pi)
    print(f"  omega_1 = {w1:.6f} rad/regime; period {2*math.pi/w1:.4f} regimes")

    rows = []
    for d in sorted(BOUNDARY):
        rb = BOUNDARY[d]
        if rb + a.span > R: continue
        print(f"\n  depth {d}, r_b={rb}")
        print(f"    {'r':>4} {'ratio':>12} {'decay':>9} {'pred':>9} {'resid':>10} {'phase':>8}")
        prev = None
        for r in range(rb, min(rb+a.span, R)+1):
            S = diff(s, r, d); F = diff(c, r, d) - S
            if S == 0: continue
            ratio = float(abs(F/S)); ph = (w1*r) % (2*math.pi)
            if prev and prev > 0:
                dec = ratio/prev; pr = 2**-(1-alpha)*(r-1)/r; res = dec-pr
                rows.append((d, r, ratio, dec, pr, res, ph))
                print(f"    {r:>4} {ratio:>12.6f} {dec:>9.4f} {pr:>9.4f} {res:>+10.4f} {ph:>8.4f}")
            else:
                print(f"    {r:>4} {ratio:>12.6f} {'—':>9} {'—':>9} {'—':>10} {ph:>8.4f}")
            prev = ratio

    arr = np.array(rows)
    dec, pr, res, ph = arr[:,3], arr[:,4], arr[:,5], arr[:,6]
    print("\n"+"="*78); print("SUMMARY"); print("="*78)
    print(f"  n={len(rows)} steps; mean decay {dec.mean():.4f} (sd {dec.std():.4f}) "
          f"vs predicted {pr.mean():.4f}")
    print(f"  mean residual {res.mean():+.4f}; steeper than predicted in "
          f"{(dec<pr).mean():.3f} of steps")

    print("\n"+"="*78); print("DISCRIMINATING TEST: residual vs rotation phase"); print("="*78)
    rc = np.corrcoef(res, np.cos(ph))[0,1]; rs = np.corrcoef(res, np.sin(ph))[0,1]
    amp = math.hypot(rc, rs)
    print(f"  corr(resid, cos) = {rc:+.4f}\n  corr(resid, sin) = {rs:+.4f}\n  amplitude = {amp:.4f}")
    rng = np.random.default_rng(2026); null = []
    for _ in range(2000):
        p = rng.uniform(0, 2*math.pi, len(res))
        null.append(math.hypot(np.corrcoef(res, np.cos(p))[0,1],
                               np.corrcoef(res, np.sin(p))[0,1]))
    null = np.array(null); pval = (null >= amp).mean()
    print(f"\n  CONTROL (2000 random-phase trials): mean {null.mean():.4f}, "
          f"95th pct {np.percentile(null,95):.4f}, p = {pval:.4f}")
    print(f"""
  amplitude {amp:.4f} vs null 95th pct {np.percentile(null,95):.4f}, p={pval:.4f}

  above null  -> excess collapse tracks rotation: the zeros' oscillation
                 passing through zero. Object, not instrument.
  inside null -> collapse is envelope decay. The radius/rotation split still
                 stands (DT-A5) but this consequence of it does not.

  Limits: alpha is fitted and range-dependent; adjacent regimes share cells so
  steps aren't independent; only gamma_1's phase is tested.""")

    if not a.no_json:
        out_path = a.out if a.out else DEFAULT_OUT
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "rmax_requested": a.rmax,
                "rmax_effective": R,
                "alpha": alpha,
                "span": a.span,
            },
            "constants": {
                "GAMMA_1": GAMMA_1,
                "BOUNDARY": {str(k): v for k, v in sorted(BOUNDARY.items())},
                "rng_seed": 2026,
                "n_null_trials": 2000,
            },
            "summary": {
                "n_steps": len(rows),
                "omega_1": w1,
                "period_regimes": 2 * math.pi / w1,
                "radius_only_decay": 2 ** -(1 - alpha),
                "mean_decay": dec.mean(),
                "sd_decay": dec.std(),
                "mean_predicted": pr.mean(),
                "mean_residual": res.mean(),
                "frac_steeper_than_predicted": (dec < pr).mean(),
                "corr_resid_cos": rc,
                "corr_resid_sin": rs,
                "amplitude": amp,
                "null_mean": null.mean(),
                "null_p95": np.percentile(null, 95),
                "p_value": pval,
            },
            "rows": [
                {"depth": _d, "r": _r, "ratio": _ratio, "decay": _dec,
                 "predicted": _pr, "residual": _res, "phase": _ph}
                for _d, _r, _ratio, _dec, _pr, _res, _ph in rows
            ],
        }
        _write_results(payload, out_path)

if __name__ == "__main__":
    main()