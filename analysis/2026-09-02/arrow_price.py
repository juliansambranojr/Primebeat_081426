#!/usr/bin/env python3
"""arrow_price.py — price the rung-to-strip arrow at the precision its consumers need.

EXPLORATORY. No prereg, no decision rule, no verdict. Companion census page:
`analysis/2026-09-02/arrow_tolerance.md`.

The arrow under price (entry 303 §(d)):

    StmtWeilPositive L  ->  riemannZeta.RH_up_to (T L)

Method is entry 130's: measure the budget before pricing the scope. Every
number below is either read from a `.numbers` key produced by an earlier run
or computed here from those; nothing is retyped from a report.

Inputs, by key:
  analysis/2026-09-01/results/weil_Lc_theory.numbers
      fits.<eps>.measured.{a,b,R2,n}        entry 301's measured L_c = a + b log gamma
      fits.<eps>.far_only_bound.{a,b,R2,n}  the N(T)-bounded far tail (entry 302)
      fits.<eps>.far_only_exact.{a,b,R2,n}  the exact file far tail
      fits.<eps>.full.{a,b,R2,n}            the FIXED raised-cosine window
      theory.k=K|eps=E.{gamma_k,L_c_meas}   the 24 measured rows
      params.Rmax_form                      the ASSUMED Rosser form
  analysis/2026-09-01/results/weil_Lc_eps.numbers
      fits.M=32|w=1/2.log(1/eps).{a,b,R2}   entry 299's eps law at gamma_1

Sections:
  S1  the bilinear surface L_c(eps, gamma) = (A0+A1 u) + (B0+B1 u) log gamma,
      u = log(1/eps), fit from the three per-eps (a,b) pairs, validated
      against all 24 measured rows.
  S2  inversion: T_reach(L, eps) = exp((L - a)/b) at published support lengths.
  S3  the consumer table: every riemannZeta.RH_up_to consumer at the PNT+ pin,
      its T requirement, its sorry status, and the L the arrow needs to meet it.
  S4  the eps budget: how far off the line a zero may sit before a consumer's
      constant moves by a factor K (entry 130's tolerance scale).
  S5  the crude-constant budget: sensitivity of L (and of the prime-side
      truncation X = e^L) to (a, b), and where the arrow is vacuous.
"""
from __future__ import annotations

import hashlib
import json
import math
import pathlib
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[2]
THEORY = ROOT / "analysis/2026-09-01/results/weil_Lc_theory.numbers"
EPSFIT = ROOT / "analysis/2026-09-01/results/weil_Lc_eps.numbers"
OUT_JSON = ROOT / "analysis/2026-09-02/results/arrow_price.json"
OUT_TXT = ROOT / "analysis/2026-09-02/results/arrow_price.txt"

STATUS = "EXPLORATORY - no prereg, no decision rule, no verdict"


# ---------------------------------------------------------------- numbers I/O

def load_numbers(path: pathlib.Path) -> dict[str, object]:
    """Read a flatten_results .numbers file into {key: value}. Keys are whole."""
    out: dict[str, object] = {}
    for line in path.read_text().splitlines():
        if line.startswith("#") or "\t" not in line:
            continue
        k, v = line.split("\t", 1)
        try:
            out[k] = json.loads(v)
        except json.JSONDecodeError:
            out[k] = v
    return out


def need(d: dict, key: str):
    if key not in d:
        raise KeyError(f"key absent from .numbers: {key}")
    return d[key]


# ------------------------------------------------------------------ least sq

def linfit(xs, ys):
    """y = a + b x by least squares. Returns (a, b, R2, rms_resid, n)."""
    n = len(xs)
    mx = sum(xs) / n
    my = sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx if sxx else float("nan")
    a = my - b * mx
    resid = [y - (a + b * x) for x, y in zip(xs, ys)]
    sst = sum((y - my) ** 2 for y in ys)
    sse = sum(r * r for r in resid)
    r2 = 1.0 - sse / sst if sst else float("nan")
    rms = math.sqrt(sse / n)
    return a, b, r2, rms, n


# --------------------------------------------------------- consumer registry
# Every consumer of `riemannZeta.RH_up_to` in the PNT+ source at the pin
# 47fa48680663df41146704d02a5b092d792bd5b9, located by
#   grep -rn 'RH_up_to' <pkg>/PrimeNumberTheoremAnd/
# with the .lake/build artefacts dropped. `t_req` is the height the consumer
# demands; `t_req_expr` says how it is stated. `proved` is the theorem's own
# status at the pin.

PKG = "lean_stage3/.lake/packages/PrimeNumberTheoremAnd/PrimeNumberTheoremAnd/IEANTN"

CONSUMERS = [
    dict(name="Buthe theorem_2a (psi)", loc=f"{PKG}/TMEEMT.lean:157",
         t_req_expr="4.92*sqrt(x/log x) <= T, x > 59", x_floor=59.0,
         conclusion="|psi x - x| <= sqrt x * log^2 x / (8 pi)", proved=False),
    dict(name="Buthe theorem_2b (theta)", loc=f"{PKG}/TMEEMT.lean:170",
         t_req_expr="4.92*sqrt(x/log x) <= T, x > 599", x_floor=599.0,
         conclusion="|theta x - x| <= sqrt x * log^2 x / (8 pi)", proved=False),
    dict(name="Buthe theorem_2c (pi*)", loc=f"{PKG}/TMEEMT.lean:183",
         t_req_expr="4.92*sqrt(x/log x) <= T, x > 59", x_floor=59.0,
         conclusion="|pi* x - li x| <= sqrt x * log x / (8 pi)", proved=False),
    dict(name="Buthe theorem_2d (pi)", loc=f"{PKG}/TMEEMT.lean:196",
         t_req_expr="4.92*sqrt(x/log x) <= T, x > 2657", x_floor=2657.0,
         conclusion="|pi x - li x| <= sqrt x * log x / (8 pi)", proved=False),
    dict(name="GourdonDemichel2004.has_prime_in_interval",
         loc=f"{PKG}/TMEEMT.lean:1303", t_req_expr="T >= 2.44e12", t_req=2.44e12,
         conclusion="prime in (x(1-1/14500755538), x], x > exp 60", proved=False),
    dict(name="Platt_theorem", loc=f"{PKG}/ZetaSummary.lean:103",
         t_req_expr="RH_up_to 30610046000", t_req=30610046000.0,
         conclusion="(the statement itself)", proved=False),
    dict(name="GW_theorem", loc=f"{PKG}/ZetaSummary.lean:113",
         t_req_expr="RH_up_to 2445999556030", t_req=2445999556030.0,
         conclusion="(the statement itself)", proved=False),
    dict(name="PT_theorem_1", loc=f"{PKG}/ZetaSummary.lean:123",
         t_req_expr="RH_up_to 3e12", t_req=3e12,
         conclusion="(the statement itself)", proved=False),
    dict(name="BKLNW_app.Inputs.hH", loc=f"{PKG}/BKLNW/BKLNW_app.lean:24",
         t_req_expr="structure field; Inputs.default H = 2445999556030",
         t_req=2445999556030.0, conclusion="(input to the appendix)", proved=None),
    dict(name="bklnw_thm_16", loc=f"{PKG}/BKLNW/BKLNW_app.lean:1135",
         t_req_expr="RH_up_to (c/eps), c >= 3, 0 < eps < 1e-3", t_req=3000.0,
         conclusion="E_psi x <= exp(eps a)(E1+E2+E3)", proved=False),
    dict(name="FKS.Inputs.hH0",
         loc=f"{PKG}/FioriKadiriSwidinsky/FioriKadiriSwidinsky.lean:26",
         t_req_expr="structure field; H0 free", t_req=None,
         conclusion="(input to the FKS chain)", proved=None),
    dict(name="riemannZeta.Hsigma_zeroes",
         loc=f"{PKG}/FioriKadiriSwidinsky/FioriKadiriSwidinsky.lean:408",
         t_req_expr="H0 free", t_req=None,
         conclusion="N'(sigma, Hsigma H0 R sigma) = 0", proved=False),
    dict(name="FKS.eq_13",
         loc=f"{PKG}/FioriKadiriSwidinsky/FioriKadiriSwidinsky.lean:418",
         t_req_expr="H0 free", t_req=None,
         conclusion="Sigma T x a b = 2 * zeroes_sum ...", proved=False),
    dict(name="CH2.cor_1_2_a", loc=f"{PKG}/CH2/CH2.lean:4319",
         t_req_expr="1e7 <= T, x > max(T, 1e9)", t_req=1e7,
         conclusion="|psi x - x pi/T coth(pi/T)| <= ...", proved=False),
    dict(name="CH2.cor_1_2_b", loc=f"{PKG}/CH2/CH2.lean:4333",
         t_req_expr="1e7 <= T, x > max(T, 1e9)", t_req=1e7,
         conclusion="|sum Lambda(n)/n - (log x - gamma)| <= ...", proved=False),
]


def buthe_t(x: float) -> float:
    """The Buthe hypothesis 4.92*sqrt(x/log x) <= T, at its floor in x."""
    return 4.92 * math.sqrt(x / math.log(x))


# ---------------------------------------------------------------- the rungs
# Support lengths that the literature actually reaches, in additive units
# L = log X (weil_QX.py's convention: G supported on [-L/2, L/2], primes n <= X).

RUNGS = [
    dict(name="Yoshida 1992 Thm 1 / Bombieri 2000 Thm 12 (PROVED, no prime)",
         L=math.log(2.0), kind="proved",
         cite="notes/lab_notebook_2.md entry 296, sources paragraph"),
    dict(name="Connes-Consani 2020 Thm 1, support [2^-1/2, 2^1/2] (PROVED)",
         L=math.log(2.0), kind="proved",
         cite="notes/lab_notebook_2.md entry 295, criterion pinned from source"),
    dict(name="Connes-Consani 2106.01715 numerics, lambda^2 ~ 7 (NUMERICAL)",
         L=math.log(7.0), kind="numerical",
         cite="notes/lab_notebook_2.md entry 296, 2106.01715 paragraph"),
    dict(name="Connes-Consani 2106.01715 numerics, lambda^2 ~ 11 (NUMERICAL)",
         L=math.log(11.0), kind="numerical",
         cite="notes/lab_notebook_2.md entry 296, 2106.01715 paragraph"),
    dict(name="weil_QX.py ladder top X = 1e4 (BENCH INSTRUMENT)",
         L=math.log(1e4), kind="instrument",
         cite="notes/lab_notebook_2.md entry 295, ladder table"),
]


# ------------------------------------------------------------------- the run

def main() -> int:
    t0 = time.time()
    th = load_numbers(THEORY)
    ep = load_numbers(EPSFIT)

    lines: list[str] = []

    def p(s: str = "") -> None:
        lines.append(s)
        print(s)

    p(STATUS)
    p(f"arrow_price.py  -  pricing StmtWeilPositive L -> RH_up_to (T L)")
    p(f"theory numbers : analysis/2026-09-01/results/weil_Lc_theory.numbers")
    p(f"eps numbers    : analysis/2026-09-01/results/weil_Lc_eps.numbers")
    p(f"Rmax form used by the far-tail bound (ASSUMED): "
      f"{need(th, 'params.Rmax_form')}")
    p()

    res: dict[str, object] = {
        "script": "arrow_price.py",
        "status": STATUS,
        "inputs": {
            "theory_numbers": "analysis/2026-09-01/results/weil_Lc_theory.numbers",
            "eps_numbers": "analysis/2026-09-01/results/weil_Lc_eps.numbers",
            "theory_json_sha256": THEORY.read_text().splitlines()[0].split()[-1],
            "eps_json_sha256": EPSFIT.read_text().splitlines()[0].split()[-1],
            "Rmax_form": need(th, "params.Rmax_form"),
            "pnt_pin": "47fa48680663df41146704d02a5b092d792bd5b9",
        },
    }

    # ---------------------------------------------------------------- S1
    p("=" * 78)
    p("S1  the height law L_c = a(eps) + b(eps) log gamma, and the eps law")
    p("=" * 78)

    EPS = ["0.001", "0.01", "0.1"]
    VARIANTS = ["measured", "far_only_bound", "far_only_exact", "full"]
    laws: dict[str, dict[str, dict[str, float]]] = {}
    p(f"{'variant':>16} {'eps':>7} {'a':>10} {'b':>9} {'R2':>8} {'n':>4}")
    for var in VARIANTS:
        laws[var] = {}
        for e in EPS:
            a = need(th, f"fits.{e}.{var}.a")
            b = need(th, f"fits.{e}.{var}.b")
            r2 = need(th, f"fits.{e}.{var}.R2")
            n = need(th, f"fits.{e}.{var}.n")
            laws[var][e] = dict(a=a, b=b, R2=r2, n=n)
            p(f"{var:>16} {e:>7} {a:10.4f} {b:9.4f} {r2:8.4f} {n:4d}")
    res["laws"] = laws
    p()

    # the eps law at gamma_1, entry 299
    ea = need(ep, "fits.M=32|w=1/2.log(1/eps).a")
    eb = need(ep, "fits.M=32|w=1/2.log(1/eps).b")
    er2 = need(ep, "fits.M=32|w=1/2.log(1/eps).R2")
    p(f"entry 299 eps law at gamma_1 (M=32, w=1/2): "
      f"L_c = {ea:.4f} + {eb:.5f} * log(1/eps),  R2 {er2:.4f}")
    res["eps_law_gamma1"] = dict(a=ea, b=eb, R2=er2,
                                 key="fits.M=32|w=1/2.log(1/eps)")

    # bilinear surface: a(u) and b(u) linear in u = log(1/eps)
    surfaces: dict[str, dict] = {}
    for var in VARIANTS:
        us = [math.log(1.0 / float(e)) for e in EPS]
        A0, A1, aR2, _, _ = linfit(us, [laws[var][e]["a"] for e in EPS])
        B0, B1, bR2, _, _ = linfit(us, [laws[var][e]["b"] for e in EPS])
        surfaces[var] = dict(A0=A0, A1=A1, a_R2=aR2, B0=B0, B1=B1, b_R2=bR2)
    res["surfaces"] = surfaces

    p()
    p("bilinear surface  L_c(eps, gamma) = (A0 + A1 u) + (B0 + B1 u) log gamma,"
      "  u = log(1/eps)")
    p(f"{'variant':>16} {'A0':>10} {'A1':>9} {'B0':>9} {'B1':>9}")
    for var in VARIANTS:
        s = surfaces[var]
        p(f"{var:>16} {s['A0']:10.4f} {s['A1']:9.4f} {s['B0']:9.4f} "
          f"{s['B1']:9.4f}")

    def Lc(var: str, eps: float, gamma: float) -> float:
        s = surfaces[var]
        u = math.log(1.0 / eps)
        return (s["A0"] + s["A1"] * u) + (s["B0"] + s["B1"] * u) * math.log(gamma)

    # validate the surface against the 24 measured rows
    KS = [1, 2, 5, 10, 30, 100, 300, 1000]
    rows = []
    for k in KS:
        for e in EPS:
            key = f"theory.k={k}|eps={e}"
            g = need(th, f"{key}.gamma_k")
            meas = need(th, f"{key}.L_c_meas")
            pred = Lc("measured", float(e), g)
            rows.append(dict(k=k, eps=float(e), gamma_k=g, L_c_meas=meas,
                             L_c_surface=pred, resid=meas - pred,
                             ratio=meas / pred))
    resid = [r["resid"] for r in rows]
    rms = math.sqrt(sum(r * r for r in resid) / len(resid))
    p()
    p(f"surface validation on the 24 measured rows (variant 'measured'):")
    p(f"  rms residual {rms:.4f}, max |resid| {max(abs(r) for r in resid):.4f}, "
      f"ratio meas/surface in "
      f"[{min(r['ratio'] for r in rows):.4f}, {max(r['ratio'] for r in rows):.4f}]")
    res["surface_validation"] = dict(rows=rows, rms_resid=rms,
                                     max_abs_resid=max(abs(r) for r in resid))
    p()

    # ---------------------------------------------------------------- S2
    p("=" * 78)
    p("S2  inversion: what height does a rung of support L reach?")
    p("=" * 78)
    p("T_reach(L, eps) = exp((L - a(eps)) / b(eps)); below gamma_1 = 14.1347")
    p("the arrow excludes nothing, and the rung is VACUOUS.")
    p()
    gamma1 = need(th, "theory.k=1|eps=0.001.gamma_k")
    res["gamma_1"] = gamma1

    rung_rows = []
    p(f"{'rung':>62} {'L':>7} {'X=e^L':>10} "
      f"{'T(1e-3)':>10} {'T(1e-2)':>10} {'T(1e-1)':>10}")
    for r in RUNGS:
        L = r["L"]
        ts = {}
        for e in EPS:
            law = laws["measured"][e]
            ts[e] = math.exp((L - law["a"]) / law["b"])
        rung_rows.append(dict(name=r["name"], kind=r["kind"], L=L,
                              X=math.exp(L), cite=r["cite"],
                              T_reach={e: ts[e] for e in EPS},
                              vacuous_at_eps={e: ts[e] < gamma1 for e in EPS}))
        p(f"{r['name'][:62]:>62} {L:7.4f} {math.exp(L):10.4g} "
          f"{ts['0.001']:10.4g} {ts['0.01']:10.4g} {ts['0.1']:10.4g}")
    res["rungs"] = rung_rows
    p()

    # vacuity thresholds
    vac = {}
    for var in VARIANTS:
        vac[var] = {e: laws[var][e]["a"] + laws[var][e]["b"] * math.log(gamma1)
                    for e in EPS}
    p("VACUITY THRESHOLD  L_vac = a + b log gamma_1: below this L the arrow's")
    p("conclusion is empty (no zero of height <= gamma_1 exists to exclude).")
    p(f"{'variant':>16} " + " ".join(f"{('eps=' + e):>12}" for e in EPS))
    for var in VARIANTS:
        p(f"{var:>16} " + " ".join(f"{vac[var][e]:12.4f}" for e in EPS))
    p(f"  for scale: log 2 = {math.log(2):.4f} is the whole proved literature;")
    p(f"            log 11 = {math.log(11):.4f} is the top of the CC numerics.")
    res["vacuity_threshold"] = vac
    p()

    # --------------------------------------------------------------- S2b
    p("-" * 78)
    p("S2b  the first non-vacuous rung, from the MEASURED k = 1 rows")
    p("-" * 78)
    p("The fit above is a regression over 8 heights; at gamma_1 itself the")
    p("instrument measured L_c directly. Those rows, and entry 299's eps law")
    p("at gamma_1 (7 values of eps, R2 0.9918), are the honest small-L prices.")
    p()
    k1 = []
    for e in EPS:
        m = need(th, f"theory.k=1|eps={e}.L_c_meas")
        k1.append(dict(eps=float(e), L_c_meas=m, X=math.exp(m),
                       key=f"theory.k=1|eps={e}.L_c_meas"))
        p(f"  eps = {e:>5}: measured L_c = {m:.4f}, X = e^L = {math.exp(m):.4f}")
    res["k1_measured"] = k1
    p()
    p("entry 299's law extended in eps (excluding gamma_1 at ever smaller eps):")
    eps_law_rows = []
    for e in [1e-1, 1e-2, 1e-3, 1e-6, 1e-10, 1e-20, 1e-50]:
        L = ea + eb * math.log(1.0 / e)
        eps_law_rows.append(dict(eps=e, L=L, X=math.exp(L)))
        p(f"  eps = {e:9.0e}: L_c = {L:7.4f}, X = e^L = {math.exp(L):9.4f}")
    res["eps_law_extension"] = eps_law_rows
    p()
    Lp = math.log(2.0)
    p(f"proved support today: L = log 2 = {Lp:.4f} (X = 2), where the prime 2")
    p("enters at weight F(log 2) = 0. Distance to the first non-vacuous rung:")
    for row in k1:
        p(f"  eps = {row['eps']:g}: dL = {row['L_c_meas'] - Lp:+.4f} "
          f"(X from 2.0000 to {row['X']:.4f})")
    res["gap_to_first_nonvacuous"] = [
        dict(eps=r["eps"], dL=r["L_c_meas"] - Lp, X=r["X"]) for r in k1]
    p()

    # ---------------------------------------------------------------- S3
    p("=" * 78)
    p("S3  the consumers of riemannZeta.RH_up_to at the pin")
    p("=" * 78)
    cons = []
    for c in CONSUMERS:
        d = dict(c)
        if "t_req" not in d:
            d["t_req"] = buthe_t(d["x_floor"])
            d["t_req_note"] = "4.92*sqrt(x/log x) evaluated at the x floor"
        cons.append(d)
    finite = [c for c in cons if c["t_req"] is not None]
    loosest = min(finite, key=lambda c: c["t_req"])
    p(f"{'consumer':>40} {'T required':>14} {'proved?':>9} {'L(1e-3)':>9} "
      f"{'X = e^L':>11}")
    for c in cons:
        if c["t_req"] is None:
            p(f"{c['name'][:40]:>40} {'free':>14} "
              f"{str(c['proved']):>9} {'-':>9} {'-':>11}")
            continue
        law = laws["measured"]["0.001"]
        L = law["a"] + law["b"] * math.log(c["t_req"])
        c["L_need_measured_eps1e-3"] = L
        c["X_need_measured_eps1e-3"] = math.exp(L)
        p(f"{c['name'][:40]:>40} {c['t_req']:14.6g} {str(c['proved']):>9} "
          f"{L:9.3f} {math.exp(L):11.4g}")
    p()
    p(f"LOOSEST finite requirement: {loosest['name']} at T = "
      f"{loosest['t_req']:.4f}")
    p(f"  ({loosest['loc']}; hypothesis {loosest['t_req_expr']})")
    p(f"  gamma_1 = {gamma1:.4f} < T = {loosest['t_req']:.4f} < gamma_2 = "
      f"{need(th, 'theory.k=2|eps=0.001.gamma_k'):.4f}: the loosest real")
    p("  consumer needs a rectangle containing exactly one zero ordinate.")
    n_proved = sum(1 for c in cons if c["proved"] is True)
    p(f"  consumers whose own theorem is proved at the pin: {n_proved} of "
      f"{len(cons)}")
    res["consumers"] = cons
    res["loosest_consumer"] = dict(name=loosest["name"], t_req=loosest["t_req"],
                                   loc=loosest["loc"])
    res["consumers_proved_at_pin"] = n_proved
    p()

    # ---------------------------------------------------------------- S4
    p("=" * 78)
    p("S4  the eps budget: how far off the line may a zero sit?")
    p("=" * 78)
    p("A zero at 1/2 + eps of height <= T inflates its own term in the")
    p("explicit formula by x^eps. Requiring x^eps <= K gives the budget")
    p("eps_max(x, K) = log K / log x. Entry 130's precedent accepts")
    p("constants 70x-700x worse than the literature's.")
    p()
    p("An off-line zero has Re - 1/2 < 1/2, so the budget is capped at 0.5;")
    p("a capped cell means the consumer tolerates ANY zero in the strip at")
    p("that scale, and the arrow's eps has stopped being the binding side.")
    p()
    KFAC = [2.0, 70.0, 700.0]
    budget_rows = []
    p(f"{'x':>12} {'T = 4.92 sqrt(x/log x)':>24} " +
      " ".join(f"{('eps(K=' + str(int(k)) + ')'):>13}" for k in KFAC))
    for x in [59.0, 1e3, 1e6, 1e9, 1e12, 1e19, math.exp(60.0)]:
        T = buthe_t(x)
        raw = {k: math.log(k) / math.log(x) for k in KFAC}
        eps = {k: min(raw[k], 0.5) for k in KFAC}
        budget_rows.append(dict(x=x, T=T,
                                eps_max={str(k): eps[k] for k in KFAC},
                                eps_uncapped={str(k): raw[k] for k in KFAC},
                                capped={str(k): raw[k] > 0.5 for k in KFAC}))
        p(f"{x:12.4g} {T:24.6g} " +
          " ".join(f"{eps[k]:12.5f}{'*' if raw[k] > 0.5 else ' '}"
                   for k in KFAC))
    p("  * capped at 0.5")
    res["eps_budget"] = budget_rows
    p()
    p("and the support the arrow needs at that eps, for that T "
      "(variant 'measured'):")
    p(f"{'x':>12} {'T':>13} " +
      " ".join(f"{('L(K=' + str(int(k)) + ')'):>10} {('X'):>11}" for k in KFAC))
    budget_L = []
    for row in budget_rows:
        cells = []
        rec = dict(x=row["x"], T=row["T"], L={}, X={})
        for k in KFAC:
            e = row["eps_max"][str(k)]
            L = Lc("measured", e, row["T"])
            rec["L"][str(k)] = L
            rec["X"][str(k)] = math.exp(L)
            cells.append(f"{L:10.3f} {math.exp(L):11.4g}")
        budget_L.append(rec)
        p(f"{row['x']:12.4g} {row['T']:13.6g} " + " ".join(cells))
    res["eps_budget_support"] = budget_L
    p()
    p("the same at the fixed explicit window ('full'), which is the variant")
    p("with a G written down independently of the zeros:")
    p(f"{'x':>12} {'T':>13} " +
      " ".join(f"{('L(K=' + str(int(k)) + ')'):>10} {('X'):>11}" for k in KFAC))
    budget_L_full = []
    for row in budget_rows:
        cells = []
        rec = dict(x=row["x"], T=row["T"], L={}, X={})
        for k in KFAC:
            e = row["eps_max"][str(k)]
            L = Lc("full", e, row["T"])
            rec["L"][str(k)] = L
            rec["X"][str(k)] = math.exp(L)
            cells.append(f"{L:10.3f} {math.exp(L):11.4g}")
        budget_L_full.append(rec)
        p(f"{row['x']:12.4g} {row['T']:13.6g} " + " ".join(cells))
    res["eps_budget_support_full"] = budget_L_full
    p()
    p("Every capped cell above evaluates the height law at eps = 0.5, which is")
    p("5x the instrument's largest measured eps (0.1). The same target at the")
    p("largest MEASURED eps, and the distance to the proved rung L = log 2:")
    Tl = loosest["t_req"]
    llo = []
    for e in [0.5, 0.1, 0.01, 0.001]:
        L = Lc("measured", e, Tl)
        llo.append(dict(eps=e, L=L, X=math.exp(L), dL_from_log2=L - math.log(2),
                        extrapolated=e > 0.1))
        p(f"  eps = {e:<6g} L = {L:7.4f}  X = {math.exp(L):8.4f}  "
          f"dL from log 2 = {L - math.log(2):+.4f}"
          f"{'   (EXTRAPOLATED past eps = 0.1)' if e > 0.1 else ''}")
    res["loosest_consumer_by_eps"] = dict(T=Tl, rows=llo)
    p()

    # ---------------------------------------------------------------- S5
    p("=" * 78)
    p("S5  the crude-constant budget")
    p("=" * 78)
    p("L = a + b log T, so the prime-side truncation is X = e^L = e^a * T^b.")
    p("a is a PREFACTOR (X scales by e^{da}); b is an EXPONENT (X scales by")
    p("T^{db}). At the crude-explicit spec a constant may be 70x-700x worse;")
    p("here that budget buys da = log 70 = %.3f in a and almost nothing in b."
      % math.log(70))
    p()
    T_show = [gamma1 * 1.0001, 100.0, 1e4, 1e7, 3e12]
    law = laws["measured"]["0.001"]
    sens = []
    p(f"{'T':>12} {'L(a,b)':>9} {'X':>11} {'X @ a+log70':>13} "
      f"{'X @ b*1.1':>12} {'X @ b*2':>12}")
    for T in T_show:
        L = law["a"] + law["b"] * math.log(T)
        Xa = math.exp(L + math.log(70))
        Xb1 = math.exp(law["a"] + law["b"] * 1.1 * math.log(T))
        Xb2 = math.exp(law["a"] + law["b"] * 2.0 * math.log(T))
        sens.append(dict(T=T, L=L, X=math.exp(L), X_a_plus_log70=Xa,
                         X_b_x1p1=Xb1, X_b_x2=Xb2))
        p(f"{T:12.5g} {L:9.3f} {math.exp(L):11.4g} {Xa:13.4g} "
          f"{Xb1:12.4g} {Xb2:12.4g}")
    res["constant_sensitivity"] = sens
    p()
    p("b across every variant measured, at each eps -- the spread IS the")
    p("uncertainty in the exponent:")
    ball = []
    for var in VARIANTS:
        for e in EPS:
            ball.append((var, e, laws[var][e]["b"], laws[var][e]["n"]))
    bs = [x[2] for x in ball]
    p(f"  b ranges over [{min(bs):.4f}, {max(bs):.4f}] across "
      f"{len(ball)} (variant, eps) cells")
    p(f"  at T = 3e12 that is X between {math.exp(law['a'] + min(bs) * math.log(3e12)):.4g}"
      f" and {math.exp(law['a'] + max(bs) * math.log(3e12)):.4g}")
    res["b_range"] = dict(min=min(bs), max=max(bs), n_cells=len(ball),
                          X_at_3e12_min=math.exp(law["a"] + min(bs) * math.log(3e12)),
                          X_at_3e12_max=math.exp(law["a"] + max(bs) * math.log(3e12)))
    p()
    p("the fixed explicit window has NO root at k = 1000 at any eps on the")
    p("instrument's grid (entry 302 Section 1); the highest gamma at which")
    p("an explicitly-written G is measured to detect at all is:")
    hi = None
    for k in KS:
        for e in EPS:
            v = th.get(f"theory.k={k}|eps={e}.variants.full.L_c")
            if v is not None:
                g = need(th, f"theory.k={k}|eps={e}.gamma_k")
                if hi is None or g > hi[0]:
                    hi = (g, k, e, v)
    p(f"  gamma_k = {hi[0]:.4f} (k = {hi[1]}, eps = {hi[2]}), at L_c = {hi[3]:.4f}")
    p(f"  key: theory.k={hi[1]}|eps={hi[2]}.variants.full.L_c")
    g1000 = need(th, "theory.k=1000|eps=0.001.gamma_k")
    p(f"  and the fixed window fails at gamma_1000 = {g1000:.4f}, where the")
    p(f"  zero-aware minimiser detects at L_c_meas = "
      f"{need(th, 'theory.k=1000|eps=0.001.L_c_meas'):.4f}")
    res["fixed_window_highest_detected"] = dict(
        gamma_k=hi[0], k=hi[1], eps=hi[2], L_c=hi[3],
        key=f"theory.k={hi[1]}|eps={hi[2]}.variants.full.L_c")
    res["fixed_window_fails_at"] = dict(
        gamma_k=g1000,
        minimiser_L_c=need(th, "theory.k=1000|eps=0.001.L_c_meas"))
    p()

    # ---------------------------------------------------------------- S6
    p("=" * 78)
    p("S6  the far-tail bound's own constants against the upstream statement")
    p("=" * 78)
    p("The bench's far-tail bound assumes |N(T) - Nbar(T)| <= Rmax(T) with")
    p(f"  Rmax = {need(th, 'params.Rmax_form')}")
    p("Upstream states exactly that Prop as")
    p("  riemannZeta.Riemann_vonMangoldt_bound b1 b2 b3")
    p("  = forall T >= 2, |N T - (T/2pi log(T/2pi) - T/2pi + 7/8)|")
    p("      <= b1 log T + b2 log log T + b3")
    p("  (ZetaDefinitions.lean:149-162), and instantiates it at")
    p("  backlund_bound : Riemann_vonMangoldt_bound 0.137 0.443 6.1")
    p("  (Kadiri.lean:2618, proof `sorry` at :2619).")
    p("The first two constants agree; the third does not: the bench assumed")
    p("4.35 where the upstream statement carries 6.1. So the assumed form is")
    p("SHARPER than what upstream would supply. Cost of using 6.1 instead:")
    p()
    B1, B2 = 0.137, 0.443
    rmax_rows = []
    p(f"{'T':>12} {'Rmax(b3=4.35)':>15} {'Rmax(b3=6.1)':>14} {'ratio':>8} "
      f"{'ratio^(1/3)':>12}")
    for T in [gamma1, need(th, "theory.k=1000|eps=0.001.gamma_k"),
              need(th, "params.gamma_N")]:
        base = B1 * math.log(T) + B2 * math.log(math.log(T))
        r435, r610 = base + 4.35, base + 6.1
        rmax_rows.append(dict(T=T, Rmax_4p35=r435, Rmax_6p1=r610,
                              ratio=r610 / r435, ratio_cbrt=(r610 / r435) ** (1 / 3)))
        p(f"{T:12.4f} {r435:15.4f} {r610:14.4f} {r610 / r435:8.4f} "
          f"{(r610 / r435) ** (1 / 3):12.4f}")
    p()
    p("The balance at L_c is 2|B|^2 = Z_far with 2|B|^2 proportional to")
    p("eps^2 h^3 (weil_Lc_theory.md section 3(i)), so a factor f on the far")
    p("tail moves h by at most f^(1/3) if Z_far were h-independent -- an")
    p("upper bound on the shift, since Z_far falls with h. That is at most")
    p(f"  {max(r['ratio_cbrt'] for r in rmax_rows):.4f}x in L,")
    p("against a fit rms residual of "
      f"{need(th, 'fits.0.01.far_only_bound.rms_resid'):.4f} in L "
      "(fits.0.01.far_only_bound.rms_resid).")
    res["rmax_mismatch"] = dict(
        assumed_form=need(th, "params.Rmax_form"),
        upstream_b3=6.1, assumed_b3=4.35, b1=B1, b2=B2,
        upstream_loc=f"{PKG}/Kadiri.lean:2618", upstream_sorry_line=2619,
        rows=rmax_rows,
        max_L_inflation_upper_bound=max(r["ratio_cbrt"] for r in rmax_rows),
        fit_rms_resid_far_only_bound_eps0p01=need(
            th, "fits.0.01.far_only_bound.rms_resid"))
    p()

    # -------------------------------------------------------------- write
    res["meta"] = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime(t0)),
        "elapsed_s": time.time() - t0,
        "script_sha256": hashlib.sha256(
            pathlib.Path(__file__).read_bytes()).hexdigest(),
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(res, indent=1))
    OUT_TXT.write_text("\n".join(lines) + "\n")
    p(f"wrote {OUT_JSON.relative_to(ROOT)}")
    p(f"wrote {OUT_TXT.relative_to(ROOT)}")
    OUT_TXT.write_text("\n".join(lines) + "\n")   # re-write to include the two
    return 0                                       # "wrote ..." lines above


if __name__ == "__main__":
    sys.exit(main())
