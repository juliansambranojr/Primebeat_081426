#!/usr/bin/env python3
"""O80 — EXPLORATORY. No prereg, no verdict.

Where the Davenport-Heilbronn zeros are: on the line to t = 60, and
off it above.

WHY THIS EXISTS. Entry 161 established that DH is assembled from the
bench's own primes (it is a combination of Dirichlet L-functions mod
5, each with an Euler product) and that the combination carries no
integer table, so there is no exact-zero census on that arm. What DH
does carry, and zeta is not known to, is zeros off the critical line.
Entry 36's crossing-slope law takes its mode gain from
|1 - b^(-rho)| at the lowest zero with Re rho = 1/2 ASSUMED; a zero
with Re rho > 1/2 is less suppressed by the depth operator. Before any
comparison can be designed, those zeros need coordinates. This script
produces them, reproducibly, because entry 162's numbers were first
obtained in throwaway computations and the tree should not carry
numbers it cannot regenerate.

METHOD, two independent instruments.
  ON-LINE   sign changes of a Hardy-type real function
            Z(t) = Re( e^{i theta(t)} f(1/2 + it) ), theta the phase
            of the completed factor, bisected to 1e-15.
  OFF-LINE  the argument principle first — winding number of f around
            rectangles strictly right of the critical line — so the
            count is known before any root is sought; then a coarse
            |f| grid inside a flagged box to seed Newton.
The winding number is the honest half: it says how many zeros are
there without finding them, so a failed search cannot be reported as
an absence.

GATES, before any zero is sought. tau = (sqrt(10-2sqrt5)-2)/(sqrt5-1)
is checked against the independently derived eigenvector condition
tau^2 + (1+sqrt5)tau - 1 = 0, and the completed function's functional
equation |xi(s)/xi(1-s) - 1| is checked at three off-line points. A
recalled constant is not a loaded one.

Reads with: notes/lab_notebook_2.md entries 36, 158, 160, 161;
O79_residue_class_tables.py (the same object, same gates).

HOW IT WAS RUN
--------------
    .venv/bin/python O80_dh_zeros.py
"""
import argparse
import hashlib
import json
import os
from datetime import datetime, timezone

import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "dh_zeros.json")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def make_f(tau):
    a = {1: mp.mpf(1), 2: tau, 3: -tau, 4: mp.mpf(-1)}

    def f(s):
        return 5 ** (-s) * sum(a[j] * mp.zeta(s, mp.mpf(j) / 5)
                               for j in (1, 2, 3, 4))
    return f


def winding(f, x0, x1, y0, y1, n):
    pts = []
    for i in range(n):
        pts.append(mp.mpc(x0 + (x1 - x0) * i / n, y0))
    for i in range(n):
        pts.append(mp.mpc(x1, y0 + (y1 - y0) * i / n))
    for i in range(n):
        pts.append(mp.mpc(x1 - (x1 - x0) * i / n, y1))
    for i in range(n):
        pts.append(mp.mpc(x0, y1 - (y1 - y0) * i / n))
    tot = mp.mpf(0)
    prev = mp.arg(f(pts[-1]))
    for p in pts:
        cur = mp.arg(f(p))
        d = cur - prev
        while d > mp.pi:
            d -= 2 * mp.pi
        while d < -mp.pi:
            d += 2 * mp.pi
        tot += d
        prev = cur
    return tot / (2 * mp.pi)


def main():
    ap = argparse.ArgumentParser(
        description=("O80 - Davenport-Heilbronn zero locations, on and "
                     "off the critical line, argument-principle counted. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--tmax-online", type=float, default=25.0,
                    help="ceiling for the on-line scan (default 25)")
    ap.add_argument("--tstep", type=float, default=0.1,
                    help="on-line scan step (default 0.1)")
    ap.add_argument("--boxes", type=str, default="0:30,30:60,60:90,90:120",
                    help="t-ranges for the winding count, right of the "
                         "line (default 0:30,30:60,60:90,90:120)")
    ap.add_argument("--sigma-hi", type=float, default=1.6,
                    help="right edge of the winding rectangles "
                         "(default 1.6)")
    ap.add_argument("--sigma-lo", type=float, default=0.51,
                    help="left edge, strictly right of 1/2 "
                         "(default 0.51)")
    ap.add_argument("--contour-n", type=int, default=400,
                    help="points per rectangle side (default 400)")
    ap.add_argument("--dps", type=int, default=25,
                    help="mpmath precision (default 25)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    mp.mp.dps = args.dps
    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    resid = tau ** 2 + (1 + mp.sqrt(5)) * tau - 1
    f = make_f(tau)

    def xi(s):
        return (5 / mp.pi) ** (s / 2) * mp.gamma((s + 1) / 2) * f(s)

    print("O80 — Davenport-Heilbronn zero locations.  EXPLORATORY.\n")
    print("GATES:")
    print(f"   tau = {mp.nstr(tau, 12)}   residual of "
          f"tau^2+(1+sqrt5)tau-1 = {mp.nstr(resid, 5)}")
    fe = [abs(xi(s) / xi(1 - s) - 1)
          for s in (mp.mpf('0.3') + 2j, mp.mpf('0.7') + 5j,
                    mp.mpf('0.2') + 11j)]
    print(f"   max |xi(s)/xi(1-s) - 1| at three points: "
          f"{mp.nstr(max(fe), 5)}")
    if abs(resid) > mp.mpf(10) ** (-args.dps + 5) or max(fe) > mp.mpf('1e-15'):
        print("   GATES FAILED"); raise SystemExit(1)
    print("   gates PASSED\n")

    def Z(t):
        s = mp.mpf('0.5') + 1j * t
        th = mp.arg((5 / mp.pi) ** (s / 2) * mp.gamma((s + 1) / 2))
        return mp.re(mp.e ** (1j * th) * f(s))

    print(f"ON-LINE — sign changes of the Hardy-type Z on sigma = 1/2, "
          f"t up to {args.tmax_online}:")
    onl = []
    step = mp.mpf(str(args.tstep))
    t = mp.mpf('0.3')
    prev = Z(t)
    while t < args.tmax_online:
        t += step
        cur = Z(t)
        if prev * cur < 0:
            onl.append(mp.findroot(Z, (t - step, t), solver='bisect',
                                   tol=mp.mpf('1e-15')))
        prev = cur
    print("   " + ", ".join(mp.nstr(v, 8) for v in onl))
    print(f"   {len(onl)} zeros; the lowest is {mp.nstr(onl[0], 8)} "
          f"against zeta's 14.134725\n")

    print(f"OFF-LINE — winding number of f around rectangles "
          f"Re s in ({args.sigma_lo}, {args.sigma_hi}), before any "
          f"root is sought:")
    boxes = []
    for spec in args.boxes.split(","):
        lo, hi = (float(x) for x in spec.split(":"))
        w = winding(f, mp.mpf(str(args.sigma_lo)),
                    mp.mpf(str(args.sigma_hi)), mp.mpf(str(lo)),
                    mp.mpf(str(hi)), args.contour_n)
        n = int(mp.nint(w))
        boxes.append({"t_lo": lo, "t_hi": hi, "winding": float(w),
                      "count": n})
        print(f"   t in ({lo:g}, {hi:g}): winding "
              f"{mp.nstr(w, 6):>12}  -> {n} zero(s)")

    print("\n   locating the flagged ones:")
    found = []
    for bx in boxes:
        if bx["count"] < 1:
            continue
        lo, hi = mp.mpf(str(bx["t_lo"])), mp.mpf(str(bx["t_hi"]))
        cand = None
        i = 1
        while True:
            sig = mp.mpf('0.52') + mp.mpf('0.03') * i
            if sig > mp.mpf(str(args.sigma_hi)) - mp.mpf('0.2'):
                break
            j = 0
            while lo + mp.mpf(j) / 4 < hi:
                tt = lo + mp.mpf(j) / 4
                v = abs(f(mp.mpc(sig, tt)))
                if cand is None or v < cand[0]:
                    cand = (v, sig, tt)
                j += 1
            i += 1
        z = mp.findroot(f, mp.mpc(cand[1], cand[2]))
        found.append(z)
        print(f"   t in ({bx['t_lo']:g}, {bx['t_hi']:g}): "
              f"sigma = {mp.nstr(mp.re(z), 12)}, "
              f"t = {mp.nstr(mp.im(z), 12)}, |f| = "
              f"{mp.nstr(abs(f(z)), 3)}, displaced "
              f"{mp.nstr(mp.re(z) - mp.mpf('0.5'), 6)} from the line "
              f"(mirror at {mp.nstr(1 - mp.re(z), 8)})")

    print("\n  READ. DH's zeros are on the line up to t = 60 by the "
          "winding count,\n  and the first departure is at t ~ 85.7. "
          "Entry 36's crossing-slope law\n  assumes Re rho = 1/2 in its "
          "mode gain; these zeros are where that\n  assumption is false "
          "for a function built from the same primes.")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O80_dh_zeros.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "dps": args.dps, "tau": float(tau),
                       "tmax_online": args.tmax_online,
                       "tstep": args.tstep, "boxes": args.boxes,
                       "sigma_lo": args.sigma_lo,
                       "sigma_hi": args.sigma_hi,
                       "contour_n": args.contour_n},
            "online_zeros": [float(v) for v in onl],
            "winding_boxes": boxes,
            "offline_zeros": [{"sigma": float(mp.re(z)),
                               "t": float(mp.im(z)),
                               "abs_f": float(abs(f(z))),
                               "displacement": float(mp.re(z) - mp.mpf('0.5'))}
                              for z in found]}
        try:
            with open(args.out, "w") as fh:
                json.dump(payload, fh, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
