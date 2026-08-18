#!/usr/bin/env python3
"""
O26 — Compression figure: the zero/prime exchange rate, drawn from O25's result JSON.

NAMING. The O-series in this tree runs O1-O9 and O11..O25; O10 is a deliberate gap
and is not filled here. The next free number after O25 is O26; this file takes it.
Capital "O" per `CLAUDE.md` § "Naming convention (do not re-break)".

WHAT THIS IS. A figure, not a measurement. It RECOMPUTES NOTHING. Every number it
draws is read out of `results/O25_compression_curve_results.json`: the x grid, the
per-target K_stay lists, the ratios K_stay/pi(x), the crossover x, and pi(x) itself
(recovered from the flat `rows`, which carry `pi_x` per grid point). If that JSON is
missing or was written by a different code_version, this script says so and stops.

WHAT IS PLOTTED.
  PANEL A  K_stay against x, one line per accuracy target, log x and log y, with
           pi(x) overlaid as a distinct dashed reference line. K_stay(x, target) is
           the smallest swept K such that every swept K' >= K also holds the error
           at or below the target. The point where the absolute-1.0 line crosses
           pi(x) is ringed and labelled with its x.
  PANEL B  the ratio K_stay / pi(x) against x, same four targets, log y, with a
           horizontal line at 1.0. Above that line the region is labelled EXPANSION
           (K_stay > pi(x)); below it, COMPRESSION.

Null K_stay — no swept K holds the target — is drawn as a GAP, not as a zero, and
the count of such points is printed to stdout and noted in the caption when non-zero.

REQUIREMENTS
  numpy, matplotlib

USAGE
  ./.venv/bin/python3 O26_compression_figure.py --dpi 200
  ./.venv/bin/python3 O26_compression_figure.py \
      --results results/O25_compression_curve_results.json \
      --out results/compression_curve.png --dpi 300
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]

DEFAULT_RESULTS = os.path.join(_HERE, "results",
                               "O25_compression_curve_results.json")
DEFAULT_OUT = os.path.join(_HERE, "results", "compression_curve.png")

# The target whose crossing with pi(x) is ringed in panel A.
CROSSOVER_TARGET_LABEL = "absolute:1"

ACCENT = "#1F5FA8"
ACCENT2 = "#C1651A"
INK = "#16181c"
MUTED = "#5d636e"
GRID = "#e3e5e8"
SURFACE = "#fcfcfb"

# One accent hue, four steps light -> dark, so the four targets read as one family
# and pi(x) (ACCENT2, dashed) reads as the reference it is.
TARGET_SHADES = ["#9ec3e8", "#5b93cd", "#2f6fb4", "#123c6e"]
TARGET_LW = [1.7, 1.9, 2.1, 2.4]


def code_version() -> str:
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def load_results(path: str) -> dict:
    if not os.path.exists(path):
        raise SystemExit(
            f"results JSON not found: {path}\n"
            "Run O25_compression_curve.py first. This script recomputes nothing.")
    with open(path, "r") as fh:
        d = json.load(fh)
    for key in ("params", "summary", "rows"):
        if key not in d:
            raise SystemExit(f"{path}: missing top-level '{key}'")
    if "targets" not in d["summary"]:
        raise SystemExit(f"{path}: summary has no 'targets' block")
    return d


def pi_by_x(rows: list) -> dict:
    """pi(x) per grid point, recovered from the flat rows. Nothing recomputed."""
    out = {}
    for r in rows:
        x = r.get("x")
        p = r.get("pi_x")
        if x is None or p is None:
            continue
        prev = out.get(int(x))
        if prev is not None and prev != int(p):
            raise SystemExit(f"rows disagree about pi({x}): {prev} vs {int(p)}")
        out[int(x)] = int(p)
    if not out:
        raise SystemExit("rows carry no (x, pi_x) pairs")
    return out


def as_masked(vals: list) -> np.ndarray:
    """K list with nulls -> float array with nan, so nulls draw as gaps."""
    return np.array([float("nan") if v is None else float(v) for v in vals],
                    dtype=float)


def build(res: dict, out_path: str, dpi: int) -> dict:
    params = res["params"]
    summary = res["summary"]
    blocks = summary["targets"]

    xs = [int(v) for v in params["x_grid"]]
    pmap = pi_by_x(res["rows"])
    missing = [x for x in xs if x not in pmap]
    if missing:
        raise SystemExit(f"rows carry no pi(x) for grid points {missing[:8]}")
    pis = np.array([pmap[x] for x in xs], dtype=float)
    xarr = np.array(xs, dtype=float)

    offset = params.get("offset")
    n_pp = params.get("n_grid_prime_powers")

    fig, (ax1, ax2) = plt.subplots(
        2, 1, figsize=(9.4, 9.0), dpi=dpi, sharex=True,
        gridspec_kw={"height_ratios": [1.25, 1.0], "hspace": 0.22},
    )
    fig.patch.set_facecolor(SURFACE)

    # ---------------- Panel A — the exchange rate ----------------
    ax1.set_facecolor(SURFACE)
    n_null_total = 0
    for i, b in enumerate(blocks):
        y = as_masked(b["k_stay"])
        n_null_total += int(np.count_nonzero(np.isnan(y)))
        ax1.plot(xarr, y,
                 color=TARGET_SHADES[i % len(TARGET_SHADES)],
                 lw=TARGET_LW[i % len(TARGET_LW)],
                 marker="o", ms=2.8, solid_joinstyle="round",
                 label=f"$K_{{stay}}$, {b['label']}", zorder=3 + i)

    ax1.plot(xarr, pis, color=ACCENT2, lw=2.2, ls=(0, (6, 3)),
             label=r"$\pi(x)$  (primes below $x$)", zorder=9)

    # Ring the crossing of the absolute-1.0 line with pi(x).
    cross = None
    for b in blocks:
        if b.get("label") == CROSSOVER_TARGET_LABEL:
            cross = b
            break
    cross_x = None
    cross_k = None
    if cross is not None and cross.get("crossover_x") is not None:
        cross_x = int(cross["crossover_x"])
        if cross_x in xs:
            j = xs.index(cross_x)
            cross_k = cross["k_stay"][j]
        if cross_k is not None:
            ax1.plot([cross_x], [float(cross_k)], marker="o", ms=13,
                     mfc="none", mec=INK, mew=2.2, ls="none", zorder=12)
            ax1.annotate(
                f"crossover  $x = {cross_x}$\n"
                f"$K_{{stay}} = {int(cross_k)}$,  $\\pi(x) = {int(pmap[cross_x])}$",
                xy=(cross_x, float(cross_k)),
                xytext=(cross_x * 0.30, 2.0),
                fontsize=9, color=INK, ha="center", va="center",
                arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9,
                                connectionstyle="angle3,angleA=0,angleB=80"),
                bbox=dict(boxstyle="round,pad=0.35", facecolor=SURFACE,
                          alpha=0.92, edgecolor="none"),
                zorder=13)

    ax1.set_xscale("log")
    ax1.set_yscale("log")
    # Headroom above the data so the legend never sits on a line.
    a_lo, a_hi = ax1.get_ylim()
    ax1.set_ylim(a_lo * 0.7, a_hi * 25.0)
    ax1.set_ylabel("zeros used  /  primes below $x$   (count)",
                   fontsize=10.5, color="#3c4552")
    ax1.set_title(
        "Zeros needed to reconstruct $\\psi(x)$ to a given accuracy, against "
        "$\\pi(x)$\n"
        "$K_{stay}$ = smallest swept $K$ from which every larger swept $K$ also "
        "holds the error at or below the target",
        fontsize=12.5, loc="left", color=INK, pad=12)
    ax1.grid(True, which="major", color=GRID, lw=1.0)
    ax1.grid(True, which="minor", color=GRID, lw=0.5, alpha=0.6)
    ax1.set_axisbelow(True)
    for side in ("top", "right"):
        ax1.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax1.spines[side].set_color("#b9bec6")
    ax1.tick_params(colors="#6b7280", labelsize=9)
    ax1.legend(loc="upper left", fontsize=9, frameon=True, framealpha=0.96,
               facecolor=SURFACE, edgecolor="#d7dae0", ncol=3,
               columnspacing=1.4, handlelength=2.4, borderpad=0.7)

    # ---------------- Panel B — the ratio ----------------
    ax2.set_facecolor(SURFACE)
    for i, b in enumerate(blocks):
        y = as_masked(b["ratio_k_over_pi"])
        ax2.plot(xarr, y,
                 color=TARGET_SHADES[i % len(TARGET_SHADES)],
                 lw=TARGET_LW[i % len(TARGET_LW)],
                 marker="o", ms=2.8, solid_joinstyle="round",
                 label=b["label"], zorder=3 + i)

    ax2.axhline(1.0, color=ACCENT2, lw=2.0, ls=(0, (6, 3)), zorder=9)

    ax2.set_xscale("log")
    ax2.set_yscale("log")
    ylo, yhi = ax2.get_ylim()
    # Headroom above the data so the legend never sits on a line.
    ylo, yhi = ylo * 0.7, yhi * 30.0
    ax2.set_ylim(ylo, yhi)
    ax2.axhspan(1.0, yhi, color=ACCENT, alpha=0.055, zorder=0)
    _lblbox = dict(boxstyle="round,pad=0.30", facecolor=SURFACE, alpha=0.92,
                   edgecolor="none")
    ax2.text(xarr[0] * 1.06, 2.0, "EXPANSION   $K_{stay} > \\pi(x)$",
             fontsize=9.5, color=ACCENT2, va="bottom", ha="left", zorder=11,
             bbox=_lblbox)
    ax2.text(xarr[0] * 1.06, 0.50, "COMPRESSION   $K_{stay} < \\pi(x)$",
             fontsize=9.5, color=MUTED, va="top", ha="left", zorder=11,
             bbox=_lblbox)

    ax2.set_xlabel("$x$", fontsize=11, color="#3c4552")
    ax2.set_ylabel("$K_{stay}\\ /\\ \\pi(x)$", fontsize=11, color="#3c4552")
    ax2.set_title(
        "$K_{stay}\\,/\\,\\pi(x)$;  the dashed line at $1.0$ is the "
        "compression / expansion boundary",
        fontsize=12.5, loc="left", color=INK, pad=10)
    ax2.grid(True, which="major", color=GRID, lw=1.0)
    ax2.grid(True, which="minor", color=GRID, lw=0.5, alpha=0.6)
    ax2.set_axisbelow(True)
    for side in ("top", "right"):
        ax2.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax2.spines[side].set_color("#b9bec6")
    ax2.tick_params(colors="#6b7280", labelsize=9)
    ax2.legend(loc="upper right", fontsize=9, frameon=True, framealpha=0.96,
               facecolor=SURFACE, edgecolor="#d7dae0", ncol=4,
               title="accuracy target", title_fontsize=9,
               columnspacing=1.3, handlelength=2.2, borderpad=0.7)

    # ---------------- caption ----------------
    top_bits = []
    for b in blocks:
        r = b.get("ratio_at_top")
        rtxt = "—" if r is None else f"{float(r):.4g}"
        top_bits.append(f"{b['label']} {rtxt}")
    cross_bits = []
    for b in blocks:
        cx = b.get("crossover_x")
        cross_bits.append(f"{b['label']} "
                          + ("none in grid" if cx is None else str(int(cx))))

    cap = (f"Crossover $x$ (smallest grid $x$ with every point at or above it "
           f"expansive): " + ";  ".join(cross_bits) + ".\n"
           f"$K_{{stay}}/\\pi(x)$ at the top of the grid, $x = {xs[-1]}$, "
           f"$\\pi = {int(pis[-1])}$: " + ";  ".join(top_bits) + ".")
    if offset is not None:
        cap += (f"\nEvaluated at $x + {float(offset):g}$, off every "
                f"discontinuity of $\\psi$; {n_pp} of {len(xs)} grid integers "
                f"are themselves prime powers.")
    if n_null_total:
        cap += (f"\n{n_null_total} grid point(s) have null $K_{{stay}}$ — no "
                f"swept $K$ holds the target — and are drawn as gaps.")

    fig.text(0.055, 0.005, cap, fontsize=8.5, color=MUTED, va="bottom")

    d = os.path.dirname(out_path)
    if d:
        os.makedirs(d, exist_ok=True)
    fig.savefig(out_path, dpi=dpi, facecolor=SURFACE, bbox_inches="tight")
    plt.close(fig)

    return {
        "n_grid": len(xs),
        "x_first": xs[0],
        "x_last": xs[-1],
        "pi_at_top": int(pis[-1]),
        "n_null_k_stay_drawn": n_null_total,
        "crossover_x_absolute_1": cross_x,
        "k_stay_at_crossover": cross_k,
    }


def main() -> None:
    ap = argparse.ArgumentParser(
        description="O26 — compression figure, drawn from O25's result JSON")
    ap.add_argument("--results", type=str, default=DEFAULT_RESULTS,
                    help=f"O25 results JSON to read (default {DEFAULT_RESULTS})")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT,
                    help=f"PNG path (default {DEFAULT_OUT})")
    ap.add_argument("--dpi", type=int, default=200, help="figure dpi (default 200)")
    args = ap.parse_args()

    rpath = os.path.abspath(args.results)
    out_path = os.path.abspath(args.out)

    print("=" * 78, flush=True)
    print("O26 — compression figure  (reads O25's JSON; recomputes nothing)",
          flush=True)
    print("=" * 78, flush=True)
    print(f"  code_version      : {code_version()}", flush=True)
    print(f"  matplotlib        : {matplotlib.__version__}", flush=True)
    print(f"  numpy             : {np.__version__}", flush=True)
    print(f"  results in        : {rpath}", flush=True)
    print(f"  figure out        : {out_path}", flush=True)
    print(f"  dpi               : {int(args.dpi)}", flush=True)

    res = load_results(rpath)
    p = res["params"]
    print("", flush=True)
    print(f"  O25 script        : {res.get('script')}", flush=True)
    print(f"  O25 generated_utc : {res.get('generated_utc')}", flush=True)
    print(f"  O25 code_version  : {p.get('code_version')}", flush=True)
    print(f"  xmin/xmax/nx      : {p.get('xmin')} / {p.get('xmax')} / "
          f"{p.get('nx_requested')}  ->  {p.get('nx_after_dedup')} after dedup",
          flush=True)
    print(f"  offset            : {p.get('offset')}", flush=True)
    print(f"  grid prime powers : {p.get('n_grid_prime_powers')}", flush=True)
    print(f"  n_zeros           : {p.get('n_zeros')}", flush=True)
    print(f"  kvals             : {p.get('kvals')}", flush=True)
    print(f"  targets           : "
          f"{[t.get('label') for t in p.get('targets', [])]}", flush=True)
    print("", flush=True)
    print("  per target — band, crossover_x, K_stay/pi at the top of the grid:",
          flush=True)
    for b in res["summary"]["targets"]:
        cx = b.get("crossover_x")
        r = b.get("ratio_at_top")
        print(f"    {b.get('label'):>15} : {b.get('band_verdict'):>11}   "
              f"crossover_x = {('none' if cx is None else cx)!s:>6}   "
              f"K_stay_top = "
              f"{('null' if b.get('k_stay_at_top') is None else b.get('k_stay_at_top'))!s:>6}"
              f"   K/pi = "
              f"{('—' if r is None or not math.isfinite(float(r)) else f'{float(r):.6g}')}",
              flush=True)
    print("", flush=True)

    info = build(res, out_path, int(args.dpi))
    for k, v in info.items():
        print(f"  {k:<24}: {v}", flush=True)
    size = os.path.getsize(out_path) if os.path.exists(out_path) else None
    print(f"\n  wrote {out_path}  ({size} bytes)", flush=True)


if __name__ == "__main__":
    main()
