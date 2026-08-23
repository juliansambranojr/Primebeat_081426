#!/usr/bin/env python3
"""O60 — EXPLORATORY. No prereg, no verdict.

The torus from the WHOLE TABLE, not from the zeros.

WHY. O59 plotted the zeta zeros on the fundamental annulus. That is the
spectrum, not the table. This plots the table's own cells: every depth column
of the dyadic difference table, z-transformed, roots drawn on the annulus.

THE CONSTRUCTION, identical to O39_transform_radius.py:437-450 so the numbers
reconcile with results/transform_radius.json:

    G_d(z) = sum over r of T(r,d) * z^r      the depth-d column as a polynomial
    roots via np.roots on the reversed coefficient list

O39 measured the MEAN modulus of those roots migrating with depth --
0.5330 at depth 0 (near b^-1 = 0.5) to 0.7543 at depth 6 (near b^-1/2 =
0.7071) -- and stored only the aggregate. It never stored a root. This draws
them.

WHAT THE PROVED IDENTITIES SAY THE PICTURE SHOULD BE. From
lean/Transform.lean:

    |z| = 1        Re s = 0    the outer boundary, where Chain.sym_eq_zero_iff
                               puts the symbol's own lattice
    |z| = b^-1/2   Re s = 1/2  the critical circle, inversion_fixes_circle's
                               fixed set
    |z| = b^-1     Re s = 1    the inner boundary

    strip_is_fundamental_domain: those two solid circles bound exactly ONE
    fundamental domain of C*/b^Z.

So if the table's roots migrate from the inner boundary toward the middle
circle as depth rises, that is the table walking onto the critical circle under
its own differencing, in the coordinate the theorems name.

THREE TRIANGLES, as in O39:
    prime   T(r,0) = pi(2^r) - pi(2^(r-1))
    smooth  the same with li in place of pi
    resid   prime - smooth

The smooth control is the falsifier: it has one radius and should stay put.
O39 measured it pinned to depth 43 while the prime table moved.

Reads with: O39_transform_radius.py, lean/Transform.lean, lean/Chain.lean,
results/transform_radius.json, notes/lab_notebook_2.md entries 84, 88, 97, 99
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 60
BASE, RMAX, MIN_COEFFS = 2, 45, 3
DEPTHS = [0, 1, 3, 6, 10, 14, 20]
CACHE = json.load(open(_HERE / "pi2n_cache.json"))


def build(kind):
    """Depth-0 row, then the full backward-difference table."""
    pi = [mp.mpf(CACHE[str(n)]) for n in range(RMAX + 1)]
    li = [mp.li(mp.mpf(BASE) ** r) if r > 0 else mp.mpf(0) for r in range(RMAX + 1)]
    if kind == "prime":
        row = [pi[r] - pi[r - 1] if r > 0 else mp.mpf(0) for r in range(RMAX + 1)]
    elif kind == "smooth":
        row = [li[r] - li[r - 1] if r > 0 else mp.mpf(0) for r in range(RMAX + 1)]
    else:
        row = [(pi[r] - pi[r - 1]) - (li[r] - li[r - 1]) if r > 0 else mp.mpf(0)
               for r in range(RMAX + 1)]
    T = {(r, 0): row[r] for r in range(RMAX + 1)}
    for d in range(1, RMAX + 1):
        for r in range(d, RMAX + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def column_roots(T, d):
    """O39:437-450 verbatim."""
    coeffs = [T[(r, d)] for r in range(d + 1, RMAX + 1)]
    if len(coeffs) < MIN_COEFFS:
        return None
    arr = np.array([float(c) for c in coeffs[::-1]], dtype=float)
    if not np.all(np.isfinite(arr)) or np.all(arr == 0.0):
        return None
    rt = np.roots(arr)
    return rt if rt.size else None


def main():
    print("O60 - the torus from the whole table.  EXPLORATORY, no prereg, no verdict.")
    rin, rmid, rout = BASE ** -1.0, BASE ** -0.5, 1.0
    print(f"base {BASE}, rmax {RMAX}.  inner b^-1 = {rin:.6f}, "
          f"critical b^-1/2 = {rmid:.6f}, outer = {rout:.6f}\n")

    tables = {k: build(k) for k in ("prime", "smooth", "resid")}
    out = {}
    print(f"{'triangle':>8} {'d':>3} {'roots':>6} {'mean|z|':>9} {'min':>9} {'max':>9}"
          f" {'|mean-crit|':>12}")
    for kind in ("prime", "smooth", "resid"):
        out[kind] = []
        for d in range(0, 44):
            rt = column_roots(tables[kind], d)
            if rt is None:
                continue
            m = np.abs(rt)
            rec = {"d": d, "n_roots": int(m.size), "mean_abs": float(m.mean()),
                   "min_abs": float(m.min()), "max_abs": float(m.max())}
            out[kind].append(rec)
            if d in DEPTHS:
                print(f"{kind:>8} {d:>3} {m.size:>6} {m.mean():>9.6f}"
                      f" {m.min():>9.6f} {m.max():>9.6f}"
                      f" {abs(m.mean()-rmid):>12.6f}")

    # reconcile against O39's stored aggregates
    o39 = json.load(open(_HERE / "results" / "transform_radius.json"))["summary"]
    ts = o39["truncation_offsets"]
    p0 = next(w for w in out["smooth"] if w["d"] == 0)["mean_abs"]
    r6 = next(w for w in out["resid"] if w["d"] == 6)["mean_abs"]
    print(f"\nRECONCILE with results/transform_radius.json:")
    print(f"   smooth d=0 : here {p0:.10f}   O39 {ts['smooth']['measured_mean_abs']:.10f}"
          f"   delta {abs(p0-ts['smooth']['measured_mean_abs']):.2e}")
    print(f"   resid  d=6 : here {r6:.10f}   O39 {ts['resid']['measured_mean_abs']:.10f}"
          f"   delta {abs(r6-ts['resid']['measured_mean_abs']):.2e}")

    fig, axes = plt.subplots(1, 3, figsize=(16.2, 5.8))
    th = np.linspace(0, 2 * math.pi, 720)
    cmap = plt.get_cmap("viridis")
    for ax, kind in zip(axes, ("prime", "resid", "smooth")):
        for r, st, lab in ((rout, "-", "|z|=1   Re s=0"),
                           (rmid, "--", "|z|=b^-1/2   critical"),
                           (rin, "-", "|z|=b^-1   Re s=1")):
            ax.plot(r * np.cos(th), r * np.sin(th), st, lw=1.5, color="0.3",
                    label=lab, zorder=1)
        for i, d in enumerate(DEPTHS):
            rt = column_roots(tables[kind], d)
            if rt is None:
                continue
            ax.scatter(rt.real, rt.imag, s=16, alpha=0.85,
                       color=cmap(i / max(1, len(DEPTHS) - 1)),
                       label=f"d={d}", zorder=3)
        ax.set_aspect("equal"); ax.set_xticks([]); ax.set_yticks([])
        ax.set_xlim(-1.35, 1.35); ax.set_ylim(-1.35, 1.35)
        ax.set_title(f"{kind} triangle")
        ax.legend(fontsize=6, loc="upper right", ncol=2, framealpha=0.9)
    fig.suptitle("O60 — the DYADIC TABLE's own depth columns, z-transformed, on the "
                 "fundamental annulus of C*/2^Z.  colour = depth.  "
                 "smooth control is the falsifier: one radius, should not move.",
                 fontsize=9)
    fig.tight_layout()
    p = _HERE / "results" / "table_torus.png"
    fig.savefig(p, dpi=150)

    print("\nMIGRATION of mean|z| with depth (prime triangle):")
    for w in out["prime"]:
        if w["d"] in DEPTHS:
            print(f"   d={w['d']:>2}  mean|z| = {w['mean_abs']:.6f}"
                  f"   {'inner' if abs(w['mean_abs']-rin) < abs(w['mean_abs']-rmid) else 'CRITICAL'}"
                  f" is nearer")

    (_HERE / "results" / "table_torus.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O60_table_torus.py",
         "exploratory": True, "prereg": None,
         "params": {"base": BASE, "rmax": RMAX, "min_coeffs": MIN_COEFFS,
                    "depths_plotted": DEPTHS, "dps": 60},
         "constants": {"r_inner": rin, "r_critical": rmid, "r_outer": rout},
         "rows": out}, indent=2))
    print(f"\nwrote {p}")
    print(f"wrote {_HERE / 'results' / 'table_torus.json'}")


if __name__ == "__main__":
    main()
