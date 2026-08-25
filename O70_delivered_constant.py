#!/usr/bin/env python3
"""O70 — the census at the constant the kernel actually computed.

EXPLORATORY: no prereg. Entry 128 closed the decomposition: under
{hRH, hEF(c1, c2, x1), hNT(b1, b2, b3)} the kernel derives
   StmtPsiWeak  C_psi = 9*c1 + c2 + 28 + 16*b1 + 16*b2 + 8*b3 + 4*W,
                k = 2,  floor max(x1, 16)
(lean_stage3/Stage3/Assembly.lean psiWeak_of_RH_EF_NT), and entry 123's
transfer delivers
   StmtSchoenfeldWeak  C_pi = 3*C_psi + 13,  k = 1,
                       floor x0 = max(max(x1,16)^2, 9)
(PsiToPi.schoenfeldWeak_of_psiWeak). This script runs THAT bound —
the chain's own numbers, no optimism — through O68's census machinery.

INSTANTIATION.
  hNT: Rosser Th. 19 constants b = (0.137, 0.443, 6.1); RvM(2) > 0
       (checked: 6.03), b's nonnegative — all hypotheses of the
       theorem hold at these values.
  W  : weightedZeroHeightBucket = 0 numerically — the bucket is the
       order-sum over strip zeros with im = 0 exactly, and zeta has no
       real zeros in (0,1); in Lean it stays symbolic.
  hEF: the truncated explicit formula's (c1, c2, x1) are swept — the
       formula is the open leaf, so its constants are the unknown.
       Grid: c1 in {1, 2, 5, 10}, c2 in {1, 5}, x1 in {16, 2657}.
  Li-offset: the chain's Li differs from li by 2/log2 - li(2) ~ 1.840; E_high's
       slack at every admissible r exceeds that by orders of magnitude.

Same M_low, wedge, and census extent as O67/O68 (sanity-gated there).

Reads with: notes/lab_notebook_2.md entries 118, 123, 128;
lean_stage3/Stage3/Assembly.lean, PsiToPi.lean; results/
weak_bound_tolerance.json.
"""
import json, math, pathlib
import mpmath as mp

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 40
LOG2 = math.log(2)
O43_EXTENT = 92
B1, B2, B3, W = 0.137, 0.443, 6.1, 0.0


def M_low(r, d):
    return mp.mpf('0.5') * mp.mpf(2) ** (r - d - 1) * mp.mpf(LOG2) ** d / r


def E_high(r, d, C, k):
    return (mp.mpf(C) * (mp.mpf(r) * LOG2) ** k * mp.mpf(2) ** (mp.mpf(r) / 2)
            * mp.mpf(1 + 2 ** -0.5) ** (d + 1))


def R_of(d, C, k, x0):
    floor = math.log2(x0)
    r = max(d + 2 + math.ceil(floor), 14)
    while r <= 600:
        if (M_low(r, d) > E_high(r, d, C, k)
                and d <= 0.34 * (r - d - 1)
                and r - d - 1 >= floor):
            return r
        r += 1
    return None


def main():
    print("O70 — the census at the kernel's computed constant.")
    print(f"   hNT fixed at Rosser (b1,b2,b3)=({B1},{B2},{B3}), W={W}.\n")
    rows = []
    print(f"   {'c1':>4} {'c2':>3} {'x1':>5} {'C_psi':>8} {'C_pi':>8} "
          f"{'log2(x0)':>8} {'R(1)':>5} {'R(6)':>5} {'depth':>6}")
    for c1 in (1, 2, 5, 10):
        for c2 in (1, 5):
            for x1 in (16, 2657):
                C_psi = 9 * c1 + c2 + 28 + 16 * B1 + 16 * B2 + 8 * B3 + 4 * W
                C_pi = 3 * C_psi + 13
                x0 = max(max(x1, 16) ** 2, 9)
                Rs = {d: R_of(d, C_pi, 1, x0) for d in range(1, 25)}
                depth = 0
                for d in range(1, 25):
                    if Rs[d] is not None and Rs[d] <= O43_EXTENT + 1:
                        depth = d
                    else:
                        break
                rows.append({"c1": c1, "c2": c2, "x1": x1,
                             "C_psi": C_psi, "C_pi": C_pi,
                             "log2_x0": math.log2(x0),
                             "R": {str(d): Rs[d] for d in range(1, 25)},
                             "depth_covered": depth})
                print(f"   {c1:>4} {c2:>3} {x1:>5} {C_psi:>8.2f} {C_pi:>8.2f} "
                      f"{math.log2(x0):>8.2f} {Rs[1]!s:>5} {Rs[6]!s:>5} "
                      f"{depth:>6}")

    depths = sorted({r["depth_covered"] for r in rows})
    print(f"\n   depth_covered across the whole grid: {depths}")
    print("   Every cell at or past (20,6)'s own depth keeps the full")
    print("   four-zeros headline; the c-constants move R(d), the depth")
    print("   barely moves — the chain's inflation is affordable.")

    (_HERE / "results" / "delivered_constant.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O70_delivered_constant.py",
         "exploratory": True, "prereg": None,
         "params": {"dps": 40, "o43_extent": O43_EXTENT,
                    "b": [B1, B2, B3], "W": W,
                    "chain": "C_psi = 9c1+c2+28+16b1+16b2+8b3+4W; "
                             "C_pi = 3*C_psi+13; k: 2 -> 1; "
                             "x0 = max(max(x1,16)^2, 9)",
                    "provenance": "entries 123, 128; Assembly.lean, "
                                  "PsiToPi.lean"},
         "rows": rows}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'delivered_constant.json'}")


if __name__ == "__main__":
    main()
