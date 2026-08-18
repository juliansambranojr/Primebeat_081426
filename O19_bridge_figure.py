#!/usr/bin/env python3
"""
O19 — Bridge figure: Connes' truncated-Weil accuracy against the dyadic table's depth axis.

NAMING. O1-O9 and O11-O18 exist; O10 is a deliberate gap in this tree and is left
unfilled rather than absorbed by unrelated work.

WHAT THIS IS. A figure, not a measurement. It produces no results JSON and makes no
claim of its own; every number it draws is transcribed from a cited source or computed
from a stated identity. It exists so that Connes' construction and this project's
difference table can be read on one axis.

THE SHARED COORDINATE.
  A table cell at depth d touches pi over the exponent window [r-d-1, r], i.e. a value
  window of ratio 2^(d+1).
  Connes' Weil quadratic form QW_lambda is restricted to test functions supported in
  [lambda^-1, lambda], a value window of ratio lambda^2, with L = 2 log lambda.
  A prime p enters QW_lambda only when p <= lambda, since W_p vanishes on functions
  supported in [p^-1, p]  (arXiv:2602.04022 §4.1).
  Equating window ratios:      lambda^2 = 2^(d+1)      ->      lambda = 2^((d+1)/2)
  Matching by ratio is a choice — it is the only scale-invariant match available — and
  nothing else is tuned.

DATA PROVENANCE.
  CONNES_DIFFS: the 50 values printed under "DIFFERENCES BETWEEN VALUES (USING PRIMES
  <= 13)" in A. Connes, "The Riemann Hypothesis: Past, Present and a Letter Through
  Time", arXiv:2602.04022v1, 3 Feb 2026, §5. Transcribed verbatim; the source calls
  them upper bounds. The tail is NOT monotone in the source (entry 47 < 46; entry 48 >
  49 and 50) and is drawn as printed.
  TABLE_ZEROS: the four exact zeros of the dyadic prime difference table, verified in
  this tree by O16_centered_difference_table.py to be the only ones for r <= 62,
  d <= 61, using exact Python integer arithmetic.
  Prime counts per window are computed here, not transcribed.

REQUIREMENTS
  pip install numpy matplotlib

USAGE
  ./.venv/bin/python3 O19_bridge_figure.py
  ./.venv/bin/python3 O19_bridge_figure.py --out results/bridge_connes_table.png --dpi 300
"""

from __future__ import annotations

import argparse
import hashlib
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", "bridge_connes_table.png")

# --------------------------------------------------------------------------
# Data
# --------------------------------------------------------------------------

# arXiv:2602.04022v1 §5, zeros 1..50, verbatim.
CONNES_DIFFS = [
    2.60179e-55, 4.80071e-52, 4.43756e-50, 3.89903e-47, 7.59453e-46,
    1.13198e-43, 1.07245e-41, 1.26940e-40, 4.40141e-38, 4.24869e-37,
    5.86724e-36, 3.24443e-34, 2.44517e-32, 9.02026e-32, 5.13539e-30,
    7.04142e-29, 6.47754e-28, 4.96772e-27, 5.86016e-25, 3.76751e-24,
    1.03779e-23, 3.52722e-22, 3.03977e-21, 5.66201e-20, 1.41755e-19,
    2.19821e-18, 6.31599e-17, 1.42037e-16, 4.34328e-16, 4.47113e-15,
    7.01522e-14, 3.81989e-13, 5.99581e-13, 4.26414e-11, 1.10653e-10,
    1.95651e-10, 5.20728e-10, 2.05031e-09, 3.42274e-08, 2.10931e-07,
    2.23714e-07, 5.95608e-07, 5.77737e-06, 1.41389e-04, 5.56111e-04,
    7.20794e-04, 3.14865e-04, 2.09081e-02, 3.13565e-03, 2.12727e-03,
]

# (r, d) of the four exact zeros of the prime-side table, and a short label.
TABLE_ZEROS = [(2, 1), (4, 1), (8, 3), (20, 6)]

CONNES_LAMBDA = 13.0                      # "the upper limit, which was x = 13 here"
CONNES_FIRST_ZERO_ERR = CONNES_DIFFS[0]

ACCENT = "#1F5FA8"
ACCENT2 = "#C1651A"
INK = "#16181c"
MUTED = "#5d636e"
GRID = "#e3e5e8"
SURFACE = "#fcfcfb"


def lam_of_depth(d: float) -> float:
    """Connes' cutoff corresponding to table depth d, by equal window ratio."""
    return 2.0 ** ((d + 1.0) / 2.0)


def depth_of_lam(lam):
    """Inverse of lam_of_depth. Guarded: matplotlib probes the secondary axis at 0."""
    lam = np.asarray(lam, dtype=float)
    return np.where(lam > 0, 2.0 * np.log2(np.where(lam > 0, lam, 1.0)) - 1.0, -1.0)


def primes_upto(n: int) -> list[int]:
    """Exact small sieve; n is tiny here."""
    if n < 2:
        return []
    s = [True] * (n + 1)
    s[0] = s[1] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            s[i * i:: i] = [False] * len(s[i * i:: i])
    return [i for i, v in enumerate(s) if v]


def n_primes_in_window(d: float) -> int:
    return len(primes_upto(int(np.floor(lam_of_depth(d)))))


def code_version() -> str:
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# --------------------------------------------------------------------------
# Figure
# --------------------------------------------------------------------------

def build(out_path: str, dpi: int, dmax: int) -> None:
    fig, (ax1, ax2) = plt.subplots(
        2, 1, figsize=(9.0, 8.2), dpi=dpi,
        gridspec_kw={"height_ratios": [1.15, 1.0], "hspace": 0.66},
    )
    fig.patch.set_facecolor(SURFACE)

    # ---------------- Panel A ----------------
    n = np.arange(1, len(CONNES_DIFFS) + 1)
    y = np.array(CONNES_DIFFS)

    ax1.set_facecolor(SURFACE)
    ax1.plot(n, y, color=ACCENT, lw=2.0, solid_joinstyle="round", zorder=3)
    ax1.plot(n, y, color=ACCENT, lw=0, marker="o", ms=3.0, zorder=4)
    ax1.plot([1], [y[0]], color=ACCENT, marker="o", ms=6.0, zorder=5)
    ax1.plot([48], [y[47]], color=ACCENT, marker="o", ms=6.0, zorder=5)

    ax1.set_yscale("log")
    ax1.set_ylim(1e-57, 1e0)
    ax1.set_xlim(0, 51)
    ax1.set_xlabel("zero index $n$", fontsize=10.5, color="#3c4552")
    ax1.set_ylabel("difference from the true zero", fontsize=10.5, color="#3c4552")
    ax1.set_title(
        "Connes' approximation error, first 50 zeros\n"
        "primes $\\leq 13$ only — a single window at depth $d = 6.40$   (arXiv:2602.04022 §5)",
        fontsize=12.5, loc="left", color=INK, pad=12,
    )
    ax1.grid(True, which="major", color=GRID, lw=1.0)
    ax1.set_axisbelow(True)
    for side in ("top", "right"):
        ax1.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax1.spines[side].set_color("#b9bec6")
    ax1.tick_params(colors="#6b7280", labelsize=9)

    ax1.annotate(
        f"{y[0]:.2e}\nzero 1 — 54 decimals agree",
        xy=(1, y[0]), xytext=(3.2, 3e-52),
        fontsize=9, color=INK, va="center",
        arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9),
    )
    ax1.annotate(
        f"{y[47]:.2e}\nzero 48 — tail is not monotone",
        xy=(48, y[47]), xytext=(29.5, 1e-13),
        fontsize=9, color=INK, ha="left", va="center",
        arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9,
                        connectionstyle="angle3,angleA=0,angleB=70"),
    )

    # ---------------- Panel B ----------------
    ds = np.arange(0, dmax + 1)
    counts = np.array([n_primes_in_window(float(d)) for d in ds])

    ax2.set_facecolor(SURFACE)
    ax2.step(ds, counts, where="post", color=ACCENT, lw=2.0, zorder=3)

    for (r, d) in TABLE_ZEROS:
        ax2.plot([d], [n_primes_in_window(float(d))],
                 marker="D", ms=8, color=INK, zorder=5, linestyle="none")

    d_connes = depth_of_lam(CONNES_LAMBDA)
    ax2.plot([d_connes], [len(primes_upto(int(CONNES_LAMBDA)))],
             marker="o", ms=11, mfc="none", mec=ACCENT2, mew=2.5, zorder=6,
             linestyle="none")

    ax2.annotate("(2,1)  (4,1)\n$\\{2\\}$", xy=(1, 1), xytext=(1, 2.6),
                 fontsize=9, color=INK, ha="center",
                 arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9))
    ax2.annotate("(8,3)\n$\\{2,3\\}$ = the mod-6 lattice", xy=(3, 2), xytext=(3.15, 4.2),
                 fontsize=9, color=INK, ha="center",
                 arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9))
    ax2.annotate("(20,6)\n$\\{2,3,5,7,11\\}$", xy=(6, 5), xytext=(4.55, 6.6),
                 fontsize=9, color=INK, ha="center",
                 arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9))
    ax2.annotate(f"Connes   $d = {d_connes:.2f}$\n$\\lambda = 13$ · "
                 "$\\{2,3,5,7,11,13\\}$",
                 xy=(d_connes, 6), xytext=(7.15, 3.1),
                 fontsize=9, color=ACCENT2, ha="center",
                 arrowprops=dict(arrowstyle="-", color=ACCENT2, lw=0.9))

    ax2.set_xlim(-0.35, dmax + 0.35)
    ax2.set_ylim(-0.4, 9.4)
    ax2.set_xticks(ds)
    ax2.set_xlabel("depth $d$", fontsize=10.5, color="#3c4552")
    ax2.set_ylabel("primes inside the window", fontsize=10.5, color="#3c4552")
    ax2.set_title(
        "The shared coordinate: window depth\n"
        "a cell at depth $d$ spans ratio $2^{d+1}$; Connes' $[\\lambda^{-1},\\lambda]$ "
        "spans $\\lambda^{2}$.  Equate: $\\lambda = 2^{(d+1)/2}$",
        fontsize=12.5, loc="left", color=INK, pad=12,
    )
    ax2.grid(True, axis="y", color=GRID, lw=1.0)
    ax2.set_axisbelow(True)
    for side in ("top", "right"):
        ax2.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax2.spines[side].set_color("#b9bec6")
    ax2.tick_params(colors="#6b7280", labelsize=9)

    sec = ax2.secondary_xaxis("top", functions=(lam_of_depth, depth_of_lam))
    sec.set_xticks([2, 4, 8, 16])
    sec.set_xticklabels(["$\\lambda$=2", "4", "8", "16"], fontsize=8.5)
    sec.tick_params(colors=MUTED)
    for side in ("top",):
        sec.spines[side].set_color("#d7dae0")

    fig.text(
        0.075, 0.028,
        "Diamonds: exact zeros of the dyadic prime difference table $(r,d)$, verified "
        "unique for $r \\leq 62$, $d \\leq 61$ (O16, exact integers).\n"
        "Ring: the window Connes computes in. The only non-trivial table zero sits one "
        "prime short of it.",
        fontsize=8.5, color=MUTED, va="bottom",
    )

    d = os.path.dirname(out_path)
    if d:
        os.makedirs(d, exist_ok=True)
    fig.savefig(out_path, dpi=dpi, facecolor=SURFACE, bbox_inches="tight")
    plt.close(fig)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--dpi", type=int, default=200)
    ap.add_argument("--dmax", type=int, default=8, help="largest depth drawn in panel B")
    args = ap.parse_args()

    print("=" * 78, flush=True)
    print("O19 — bridge figure", flush=True)
    print("=" * 78, flush=True)
    print(f"  code_version : {code_version()}", flush=True)
    print(f"  matplotlib   : {matplotlib.__version__}", flush=True)
    print(f"  numpy        : {np.__version__}", flush=True)
    print("", flush=True)
    print("  window correspondence  lambda = 2^((d+1)/2)", flush=True)
    for d in range(0, args.dmax + 1):
        lam = lam_of_depth(float(d))
        ps = primes_upto(int(np.floor(lam)))
        print(f"    d={d}  lambda={lam:8.4f}   {len(ps)} primes  {ps}", flush=True)
    dc = depth_of_lam(CONNES_LAMBDA)
    print("", flush=True)
    print(f"  Connes lambda=13  ->  d = {dc:.4f}", flush=True)
    print(f"  deep zero (20,6)  ->  lambda = {lam_of_depth(6.0):.4f}", flush=True)
    print(f"  gap in depth      =  {dc - 6.0:.4f}", flush=True)
    print("", flush=True)

    build(args.out, args.dpi, args.dmax)
    print(f"  wrote {args.out}", flush=True)


if __name__ == "__main__":
    main()
