"""weil_Lc_height.py — support length L_c(eps, k) at which the restricted Weil form first
detects zero k moved off the line, for zeros at height: does L_c track log gamma_k?
EXPLORATORY.  No prereg, no decision rule, no verdict.

Same instrument, normalisation and multiplicity-conserving move as weil_Lc_eps.py
(imported): the pair {rho_k, conj rho_k} moves to {rho', conj rho'} with
rho' = 1/2 + eps + i gamma_k, every other zero fixed, ZERO SIDE ONLY:

    Q_{eps,k}(G) = Z'_k(G) + tail(G) + 2w T_{eps,k}(G),
    Z'_k(G)      = 2 sum_{j != k} |Ghat(gamma_j)|^2        (zeros1.txt, zero k removed)
    T_{eps,k}(G) = 2 Re[Ghat(gamma_k - i eps) conj Ghat(gamma_k + i eps)] = 2(|A|^2 - |B|^2),
    A = int G cosh(eps u) e^{i u gamma_k} du,  B = int G sinh(eps u) e^{i u gamma_k} du,

w = 1/2 primary (T_0 = the pair's own term 2|Ghat(gamma_k)|^2), w = 1 the
unit-multiplicity quadruple (secondary column), exactly as in weil_Lc_eps.py.

Differences from weil_Lc_eps.py, all forced by height:
  * Z'_k: the double-double Gram over ALL file zeros is built once per h and the
    rank-one term of zero k (the same double-precision Ghat(gamma_k^file) values that
    entered the Gram) is subtracted in mpmath — an exact removal up to the
    double-double rounding (~1e-32 relative, unit test [H3]).  gamma_k itself
    (mp.zetazero(k)) enters only through T in mpmath, as before.
  * T: the 384-node quadrature of weil_Lc_eps.MPTransform cannot resolve
    e^{i u gamma_k} at h gamma_k ~ 10^4, so A_n, B_n come from the spherical-Bessel
    closed form at complex argument,
        Ghat_n(t) = sqrt(2h(2n+1)) i^n j_n(h t),  j_n(z) = sqrt(pi/2z) J_{n+1/2}(z),
    with mp.besselj (unit tests [H1], [H2] check it against the quadrature where
    that converges and against mp.quad for the indicator at k = 1000).
  * Resolution check.  Ghat_n(t) ~ j_n(h t) is negligible for n > h t, so a Legendre
    basis of M functions can only carry Fourier energy at |t| = gamma_k when
    M > h gamma_k; the brief's criterion M >~ h gamma_k / pi is printed alongside.
    Each (k, eps) is run at M = 32 and 64; if M = 64 < h_c gamma_k / pi at its own
    L_c the ladder is also run at M = 96.  Both criteria (h_c gamma_k / pi and
    h_c gamma_k) are reported per (k, eps, M) next to the M-convergence.
  * L grid: weil_Lc_eps's 25-point geometric grid 0.3 .. 8 (ratio 1.1466), extended
    upward with the same ratio to 12.06 (three more points) so that the k = 1
    brackets are identical to the previous run (sanity).

Everything else — floor model for the sign call, bisection to bracket ratio < 1.02,
lam at 1.5 L_c and 2 L_c, parity-block eigensolves at dps 40 — is weil_Lc_eps.py's.

HOW IT WAS RUN
--------------
    cd /Users/juliansambrano/GitHub/Primebeat_081426
    .venv/bin/python analysis/2026-09-01/weil_Lc_height.py 2>&1 | tee analysis/2026-09-01/results/weil_Lc_height.log

Outputs: analysis/2026-09-01/results/weil_Lc_height.json, analysis/2026-09-01/weil_Lc_height.txt
"""

import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import time

import numpy as np
from mpmath import mp, mpf, mpc, matrix as mpmatrix

_HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(_HERE, "results")


def _load(name):
    spec = importlib.util.spec_from_file_location(name, os.path.join(_HERE, name + ".py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


le = _load("weil_Lc_eps")        # ghat_legendre, zero_side_dd, tail_matrix, MPTransform, pair_matrix, lam_min_parity, fourier_energy_near
wr = le.wr                       # weil_rung_min: describe_G, gap_matrix
wq = le.wq                       # weil_QX: ZEROS_FILE


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# ------------------------------------------------------------ closed-form transforms at complex t (mp)
def ghat_complex_bessel(M, h, t):
    """[Ghat_n(t)]_{n<M} at complex t: sqrt(2h(2n+1)) i^n sqrt(pi/(2z)) J_{n+1/2}(z), z = h t."""
    h = mpf(h)
    z = h * t
    pref = mp.sqrt(mp.pi / (2 * z))
    out = []
    for n in range(M):
        out.append(mp.sqrt(2 * h * (2 * n + 1)) * (1j) ** n * pref * mp.besselj(n + mpf(1) / 2, z))
    return out


def transforms_bessel(M, h, gamma, eps):
    """(A, B) with A_n = (Ghat_n(g - i eps) + Ghat_n(g + i eps))/2, B_n = (Ghat_n(g - i eps) - Ghat_n(g + i eps))/2."""
    g = mpf(gamma)
    e = mpf(eps)
    if eps == 0:
        gm = ghat_complex_bessel(M, h, mpc(g, 0))
        return gm, [mpc(0) for _ in range(M)]
    gm = ghat_complex_bessel(M, h, mpc(g, -e))
    gp = ghat_complex_bessel(M, h, mpc(g, e))
    A = [(gm[n] + gp[n]) / 2 for n in range(M)]
    B = [(gm[n] - gp[n]) / 2 for n in range(M)]
    return A, B


def rank_one_mp(vals):
    """2 Re[v v^H] as an mp matrix for a complex numpy vector v (entries lifted exactly)."""
    M = len(vals)
    P = mpmatrix(M, M)
    v = [mpc(mpf(float(x.real)), mpf(float(x.imag))) for x in vals]
    for i in range(M):
        for j in range(M):
            P[i, j] = 2 * mp.re(v[i] * mp.conj(v[j]))
    return P


def lstsq_line(x, y):
    X = np.column_stack([np.ones_like(x), x])
    coef, *_ = np.linalg.lstsq(X, y, rcond=None)
    resid = y - X @ coef
    ss = float(np.sum((y - y.mean()) ** 2))
    return {"a": float(coef[0]), "b": float(coef[1]), "residuals": resid.tolist(),
            "rms_resid": float(np.sqrt(np.mean(resid ** 2))),
            "R2": float(1 - np.sum(resid ** 2) / ss) if ss > 0 else None}


# ------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--ks", type=str, default="1,2,5,10,30,100,300,1000")
    ap.add_argument("--eps", type=str, default="0.001,0.01,0.1")
    ap.add_argument("--Ms", type=str, default="32,64", help="M values run for every (k, eps)")
    ap.add_argument("--Mraise", type=int, default=96, help="extra M run when the largest of --Ms fails the h_c gamma_k/pi check (0 = never)")
    ap.add_argument("--dps", type=int, default=40)
    ap.add_argument("--Lmin", type=float, default=0.3)
    ap.add_argument("--Lbase", type=float, default=8.0, help="end of weil_Lc_eps's base grid")
    ap.add_argument("--npts", type=int, default=25, help="points of the base grid (weil_Lc_eps: 25)")
    ap.add_argument("--Lmax", type=float, default=12.0, help="extend the grid with the same ratio until >= Lmax")
    ap.add_argument("--bisect-ratio", type=float, default=1.02)
    ap.add_argument("--floor-rel", type=float, default=1e-30)
    ap.add_argument("--bessel-rel", type=float, default=1e-15)
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_Lc_height.json"))
    ap.add_argument("--txt", type=str, default=os.path.join(_HERE, "weil_Lc_height.txt"))
    args = ap.parse_args()

    mp.dps = args.dps
    os.makedirs(RESULTS, exist_ok=True)
    started = datetime.datetime.now(datetime.timezone.utc)
    ks = [int(k) for k in args.ks.split(",")]
    eps_list = [float(e) for e in args.eps.split(",")]
    Ms = sorted(int(m) for m in args.Ms.split(","))
    Mall = sorted(set(Ms + ([args.Mraise] if args.Mraise else [])))
    Mmax = max(Mall)
    weights = [("w=1/2", mpf(1) / 2), ("w=1", mpf(1))]
    ratio = (args.Lbase / args.Lmin) ** (1 / (args.npts - 1))
    grid = [args.Lmin * ratio ** j for j in range(args.npts)]
    while grid[-1] < args.Lmax:
        grid.append(grid[-1] * ratio)

    print("weil_Lc_height  EXPLORATORY - no prereg, no decision rule, no verdict.")
    print(f"  k={ks}  eps={eps_list}  M={Ms} (+{args.Mraise} where the h_c gamma_k/pi check fails at M={max(Ms)})  dps={args.dps}")
    print(f"  L grid {grid[0]:.3f}..{grid[-1]:.3f} ({len(grid)} pts, ratio {ratio:.4f}; the first {args.npts} = weil_Lc_eps's grid), bisect to {args.bisect_ratio}")
    print("  primary w=1/2: T = 2 Re[Ghat(g_k - i eps) conj Ghat(g_k + i eps)] (pair -> pair); secondary w=1: 2T (four points, multiplicity one)")

    gfile = np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)])
    gam_N = float(gfile[-1])
    gk_mp = {k: mp.zetazero(k).imag for k in ks}
    gz = lambda k: gk_mp[k] if k in gk_mp else mp.zetazero(k).imag     # unit tests use fixed k regardless of --ks
    gaps = {}
    for k in ks:
        up = gfile[k] - gfile[k - 1]
        dn = gfile[k - 1] - gfile[k - 2] if k >= 2 else None
        gaps[k] = float(min(up, dn)) if dn is not None else float(up)
    print(f"  zeros1.txt: {len(gfile)} zeros, gamma_N {gam_N:.3f}")
    print(f"  {'k':>5} {'gamma_k (mp)':>22} {'|file-mp|':>10} {'log gamma_k':>12} {'local gap':>10}")
    for k in ks:
        print(f"  {k:>5} {mp.nstr(gk_mp[k], 20):>22} {abs(float(gk_mp[k]) - gfile[k-1]):>10.1e} {math.log(float(gk_mp[k])):>12.4f} {gaps[k]:>10.4f}")
    tr = le.MPTransform(8)

    def ghat_row_as_in_gram(M, hh, k, chunk=25000):
        """Ghat_n(gamma_k^file) as the SAME doubles that entered zero_side_dd's Gram: weil_rung_min's Miller
        recurrence picks its starting order from the chunk maximum, so the row is recomputed inside its chunk."""
        i0 = ((k - 1) // chunk) * chunk
        return le.ghat_legendre(M, hh, gfile[i0:i0 + chunk])[:, (k - 1) - i0]

    # ============================================================ unit tests
    print("\n===== unit tests =====")
    tests = {}
    # [H1] Bessel closed form vs weil_Lc_eps's 384-node quadrature, where the quadrature converges (h gamma_k <~ 300)
    rows = []
    for k, hh in ((1, 0.75), (2, 2.0), (10, 3.0), (30, 1.5)):
        for eps in (0.0, 0.01, 0.1):
            Aq, Bq = tr.transforms(Mmax, hh, gz(k), eps)
            Ab, Bb = transforms_bessel(Mmax, hh, gz(k), eps)
            eA = max(abs(Aq[n] - Ab[n]) for n in range(Mmax))
            eB = max(abs(Bq[n] - Bb[n]) for n in range(Mmax))
            rows.append({"k": k, "h": hh, "eps": eps, "h_gamma": float(hh * gz(k)), "err_A": float(eA), "err_B": float(eB)})
            print(f"  [H1] k={k:<4d} h={hh} eps={eps:<5g} (h gamma_k = {float(hh*gz(k)):.1f}): |A_bessel - A_quad| {mp.nstr(eA, 3)}, |B ...| {mp.nstr(eB, 3)}")
    tests["H1_bessel_vs_quadrature"] = rows
    # [H2] k = 1000: indicator, closed form 2 sin(ht)/t at complex t vs Bessel n = 0, and vs mp.quad of A_0, B_0 (subdivided)
    rows = []
    for hh in (0.5, 2.0):
        g = gz(1000)
        e = mpf(0.01)
        tm, tp = mpc(g, -e), mpc(g, e)
        Gc = lambda t: 2 * mp.sin(mpf(hh) * t) / t
        closed = 2 * mp.re(Gc(tm) * mp.conj(Gc(tp)))
        A, B = transforms_bessel(4, hh, g, 0.01)
        Tm = le.pair_matrix(A, B, mpf(1) / 2)
        matrix_el = 2 * mpf(hh) * Tm[0, 0]
        nsub = int(4 * hh * float(g) / math.pi) + 8
        pts = [-mpf(hh) + 2 * mpf(hh) * i / nsub for i in range(nsub + 1)]
        Aq = mp.quad(lambda u: mp.cosh(e * u) * mp.expj(u * g), pts)
        Bq = mp.quad(lambda u: mp.sinh(e * u) * mp.expj(u * g), pts)
        direct = 2 * (abs(Aq) ** 2 - abs(Bq) ** 2)
        rows.append({"h": hh, "closed_form": float(closed), "matrix_element": float(matrix_el), "direct_quadrature": float(direct),
                     "err_matrix": float(abs(matrix_el - closed)), "err_direct": float(abs(direct - closed)), "quad_subintervals": nsub})
        print(f"  [H2] k=1000 eps=0.01 h={hh} (h gamma = {float(hh*g):.0f}): indicator closed form {mp.nstr(closed, 15)}; Bessel matrix el diff "
              f"{mp.nstr(abs(matrix_el-closed), 2)}; mp.quad ({nsub} panels) diff {mp.nstr(abs(direct-closed), 2)}")
    tests["H2_k1000_indicator"] = rows
    # [H3] rank-one removal: Z_all(dd) - P_k(exact from the same doubles)  vs  Z' built with zero k physically removed
    rows = []
    hh = 0.75
    Zall, _ = le.zero_side_dd(Mmax, hh, gfile)
    for k in (1, 10, 1000):
        Rk = ghat_row_as_in_gram(Mmax, hh, k)
        Zk = Zall - rank_one_mp(Rk)
        Zrm, _ = le.zero_side_dd(Mmax, hh, np.delete(gfile, k - 1))
        d = max(abs(Zk[i, j] - Zrm[i, j]) for i in range(Mmax) for j in range(Mmax))
        rows.append({"k": k, "h": hh, "max_abs_diff": float(d), "max_entry": float(max(abs(Zall[i, i]) for i in range(Mmax)))})
        print(f"  [H3] h={hh} k={k:<4d}: max |(Z_all - P_k) - Z'_{{k removed}}| = {mp.nstr(d, 3)}  (entries up to {float(max(abs(Zall[i,i]) for i in range(Mmax))):.3f})")
    tests["H3_rank_one_removal"] = rows
    # [H4] eps = 0: T_0(w=1/2) equals the pair term 2|Ghat(gamma_k)|^2 for k = 1000 (Bessel closed form)
    A0, B0 = transforms_bessel(Mmax, hh, gz(1000), 0.0)
    T0 = le.pair_matrix(A0, B0, mpf(1) / 2)
    d4 = max(abs(T0[i, j] - 2 * mp.re(A0[i] * mp.conj(A0[j]))) for i in range(Mmax) for j in range(Mmax))
    tests["H4_eps0_pair_k1000"] = float(d4)
    print(f"  [H4] k=1000 eps=0 h={hh}: max |T_0(w=1/2) - 2 Re[Ghat Ghat^H]| = {mp.nstr(d4, 3)}")

    # ============================================================ caches
    cache_Zall = {}
    cache_Zk = {}
    cache_T = {}
    tstat = {"Z": 0.0, "T": 0.0, "eig": 0.0, "nZ": 0, "nT": 0, "neig": 0}

    def get_Zk(hh, k):
        key = (hh, k)
        if key not in cache_Zk:
            t0 = time.time()
            if hh not in cache_Zall:
                Za, _ = le.zero_side_dd(Mmax, hh, gfile)
                cache_Zall[hh] = (Za, le.tail_matrix(Mmax, hh, gam_N))
            Za, tail = cache_Zall[hh]
            Rk = ghat_row_as_in_gram(Mmax, hh, k)
            Zp = Za - rank_one_mp(Rk)
            cache_Zk[key] = (Zp + tail, Zp)
            tstat["Z"] += time.time() - t0
            tstat["nZ"] += 1
        return cache_Zk[key]

    def get_T(hh, k, eps):
        key = (hh, k, eps)
        if key not in cache_T:
            t0 = time.time()
            A, B = transforms_bessel(Mmax, hh, gk_mp[k], eps)
            cache_T[key] = (le.pair_matrix(A, B, mpf(1) / 2), A, B)
            tstat["T"] += time.time() - t0
            tstat["nT"] += 1
        return cache_T[key]

    def solve(L, k, eps, M, w):
        hh = L / 2
        Z, Zp = get_Zk(hh, k)
        T, A, B = get_T(hh, k, eps)
        Q = Z + (2 * w) * T
        t0 = time.time()
        lam, vec, par, lam_other, lam_e, lam_o = le.lam_min_parity(Q, M)
        tstat["eig"] += time.time() - t0
        tstat["neig"] += 1
        qmax = max(abs(Q[i, j]) for i in range(M) for j in range(M))
        vm = mpmatrix(vec.tolist())
        ZpG = (vm.T * Zp[:M, :M] * vm)[0, 0]
        trZp = mp.fsum(Zp[i, i] for i in range(M))
        floor_model = 2 * mp.sqrt(max(ZpG, mpf(0)) / 2) * args.bessel_rel * mp.sqrt(trZp / 2)
        floor = max(float(floor_model), args.floor_rel * float(qmax))
        Av = mp.fsum(vm[i] * A[i] for i in range(M))
        Bv = mp.fsum(vm[i] * B[i] for i in range(M))
        return {"L": L, "h": hh, "k": k, "eps": eps, "M": M, "w": float(w), "lam_min": float(lam), "lam_min_str": mp.nstr(lam, 12),
                "parity": par, "lam_other_parity": float(lam_other), "lam_even": float(lam_e), "lam_odd": float(lam_o),
                "floor": floor, "floor_model": float(floor_model), "Zprime_at_min": float(ZpG),
                "negative": bool(lam < -floor), "raw_negative": bool(lam < 0),
                "A2": float(abs(Av) ** 2), "B2": float(abs(Bv) ** 2),
                "T_at_min": float((2 * w) * 2 * (abs(Av) ** 2 - abs(Bv) ** 2)),
                "vec": vec}

    def ladder_run(k, eps, M, w, wname):
        key = f"k={k}|eps={eps:g}|M={M}|{wname}"
        t0 = time.time()
        pts = [solve(L, k, eps, M, w) for L in grid]
        first = next((i for i, p in enumerate(pts) if p["negative"]), None)
        rec = {"k": k, "eps": eps, "M": M, "weight": wname, "gamma_k": float(gk_mp[k]), "local_gap": gaps[k],
               "grid": [{k2: v for k2, v in p.items() if k2 != "vec"} for p in pts], "L_c": None}
        if first is not None and first > 0:
            La, Lb = grid[first - 1], grid[first]
            pa, pb = pts[first - 1], pts[first]
            nb = 0
            while Lb / La > args.bisect_ratio:
                Lm = math.sqrt(La * Lb)
                pm = solve(Lm, k, eps, M, w)
                nb += 1
                if pm["negative"]:
                    Lb, pb = Lm, pm
                else:
                    La, pa = Lm, pm
            Lc = Lb
            p15 = solve(1.5 * Lc, k, eps, M, w)
            p2 = solve(2.0 * Lc, k, eps, M, w)
            above = [p for p in pts if p["L"] > Lc]
            n_pos_above = sum(1 for p in above if not p["negative"])
            desc = wr.describe_G("legendre", M, Lc / 2, pb["vec"])
            e_near = le.fourier_energy_near(M, Lc / 2, pb["vec"], float(gk_mp[k]), 1.0)
            gapm = wr.gap_matrix("legendre", M, Lc / 2, float(gz(1)))
            e_gap = float(pb["vec"] @ gapm @ pb["vec"])
            hc = Lc / 2
            rec.update({"L_c": Lc, "L_c_bracket": [La, Lb], "X_c": math.exp(Lc), "n_bisect": nb,
                        "lam_at_bracket": [pa["lam_min"], pb["lam_min"]],
                        "lam_at_1.5Lc": p15["lam_min"], "lam_at_2Lc": p2["lam_min"],
                        "negative_at_1.5Lc": p15["negative"], "negative_at_2Lc": p2["negative"],
                        "grid_points_above_Lc": len(above), "grid_points_above_Lc_positive": n_pos_above,
                        "hc_gamma_over_pi": hc * float(gk_mp[k]) / math.pi, "hc_gamma": hc * float(gk_mp[k]),
                        "resolved_brief_criterion": bool(M >= hc * float(gk_mp[k]) / math.pi),
                        "resolved_bessel_criterion": bool(M >= hc * float(gk_mp[k])),
                        "minimiser_at_Lc": {"parity": pb["parity"], "lam_even": pb["lam_even"], "lam_odd": pb["lam_odd"],
                                            "A2": pb["A2"], "B2": pb["B2"], "T_at_min": pb["T_at_min"],
                                            "fourier_energy_within_1_of_gamma_k": e_near,
                                            "energy_below_gamma1": e_gap,
                                            "coeffs": [float(v) for v in pb["vec"]], **desc}})
        elif first == 0:
            rec["L_c"] = grid[0]
            rec["note"] = "negative already at the first grid point"
        else:
            last = pts[-1]
            rec["note"] = (f"no sign change beyond the floor up to L = {grid[-1]:.3f} (there: lam_min {last['lam_min']:+.2e}, "
                           f"floor {last['floor']:.1e}, Z'(G*) {last['Zprime_at_min']:.1e}); min lam on grid {min(p['lam_min'] for p in pts):+.2e}")
        lam_s = " ".join(f"{p['lam_min']:+.1e}{p['parity'][0]}" for p in pts)
        if rec.get("L_c_bracket"):
            lc = (f"L_c={rec['L_c']:.4f} X_c={rec['X_c']:.3f} [{rec['L_c_bracket'][0]:.4f},{rec['L_c_bracket'][1]:.4f}] "
                  f"lam(1.5Lc)={rec['lam_at_1.5Lc']:+.2e} lam(2Lc)={rec['lam_at_2Lc']:+.2e} pos-above={rec['grid_points_above_Lc_positive']}/{rec['grid_points_above_Lc']} "
                  f"h_c g_k/pi={rec['hc_gamma_over_pi']:.1f} h_c g_k={rec['hc_gamma']:.0f}")
        else:
            lc = f"L_c={rec['L_c']}  {rec.get('note')}"
        print(f"  {key:<30s} {lc}   [{time.time()-t0:.1f}s]")
        print(f"      grid: {lam_s}")
        return key, rec

    # ============================================================ ladders
    print("\n===== ladders: lam_min(Q_{eps,k}; L) =====")
    print("  '-' entries beyond the floor are detections; parity e/o of the minimiser; h_c g_k/pi is the brief's resolution criterion (needs M above it), h_c g_k the Bessel one")
    ladder = {}
    M_used = {}
    for k in ks:
        for eps in eps_list:
            Ms_here = list(Ms)
            for M in Ms:
                for wname, w in weights:
                    key, rec = ladder_run(k, eps, M, w, wname)
                    ladder[key] = rec
            top = ladder[f"k={k}|eps={eps:g}|M={max(Ms)}|w=1/2"]
            need_raise = args.Mraise and top.get("L_c") is not None and not top["resolved_brief_criterion"]
            if args.Mraise and top.get("L_c") is None:
                need_raise = True
            if need_raise and args.Mraise > max(Ms):
                print(f"    -> M={max(Ms)} fails the check at its L_c (h_c gamma_k/pi = {top.get('hc_gamma_over_pi', float('nan')):.1f}); running M={args.Mraise}")
                for wname, w in weights:
                    key, rec = ladder_run(k, eps, args.Mraise, w, wname)
                    ladder[key] = rec
                Ms_here.append(args.Mraise)
            M_used[(k, eps)] = Ms_here
    print(f"\n  timings: Z builds {tstat['nZ']} ({tstat['Z']:.1f}s; distinct h {len(cache_Zall)}), T builds {tstat['nT']} ({tstat['T']:.1f}s), eigs {tstat['neig']} ({tstat['eig']:.1f}s)")
    print("  L grid: " + " ".join(f"{L:.3f}" for L in grid))

    # ============================================================ sanity: k = 1 vs weil_Lc_eps
    print("\n===== sanity: k = 1 at M = 32 vs weil_Lc_eps.json (same grid, same bracket) =====")
    sanity = []
    prev_path = os.path.join(RESULTS, "weil_Lc_eps.json")
    prev = json.load(open(prev_path)) if os.path.exists(prev_path) else None
    targets = {0.001: 1.284, 0.01: 1.139, 0.1: 0.960}
    for eps in eps_list:
        for wname, _ in weights:
            r = ladder.get(f"k=1|eps={eps:g}|M=32|{wname}", {})
            p = prev["ladder"].get(f"eps={eps:g}|M=32|{wname}", {}) if prev else {}
            rec = {"eps": eps, "weight": wname, "L_c_here": r.get("L_c"), "L_c_weil_Lc_eps": p.get("L_c"),
                   "bracket_here": r.get("L_c_bracket"), "bracket_weil_Lc_eps": p.get("L_c_bracket"),
                   "brief_target": targets.get(eps) if wname == "w=1/2" else None}
            sanity.append(rec)
            if r.get("L_c") is not None:
                lam_here = r["lam_at_bracket"]
                lam_prev = p.get("lam_at_bracket")
                print(f"  eps={eps:<6g} {wname:<5s} L_c here {r['L_c']:.4f} [{r['L_c_bracket'][0]:.4f},{r['L_c_bracket'][1]:.4f}]  "
                      f"weil_Lc_eps {p.get('L_c', float('nan')):.4f}  brief {targets.get(eps) if wname == 'w=1/2' else '-'}  "
                      f"lam at bracket here {lam_here[0]:+.3e},{lam_here[1]:+.3e}" + (f" prev {lam_prev[0]:+.3e},{lam_prev[1]:+.3e}" if lam_prev else ""))

    # ============================================================ summary table, fits
    print("\n===== L_c(eps, k) =====")
    hdr = f"{'k':>5} {'gamma_k':>10} {'log g_k':>8} {'gap':>8} {'eps':>6} " + " ".join(f"{'M='+str(M)+' '+wn:>13}" for M in Mall for wn, _ in weights) + \
          f" {'X_c':>7} {'lam(1.5Lc)':>10} {'lam(2Lc)':>10} {'M_used':>6} {'h_c g/pi':>9} {'ok':>3}"
    print(hdr)
    summary = []
    for k in ks:
        for eps in eps_list:
            cells = []
            for M in Mall:
                for wn, _ in weights:
                    r = ladder.get(f"k={k}|eps={eps:g}|M={M}|{wn}")
                    cells.append(f"{r['L_c']:>13.4f}" if r and r.get("L_c") is not None else (f"{'none':>13}" if r else f"{'':>13}"))
            Mu = max(M_used[(k, eps)])
            top = ladder.get(f"k={k}|eps={eps:g}|M={Mu}|w=1/2", {})
            row = {"k": k, "eps": eps, "gamma_k": float(gk_mp[k]), "log_gamma_k": math.log(float(gk_mp[k])), "local_gap": gaps[k],
                   "M_used": Mu, "Ms_run": M_used[(k, eps)],
                   "L_c_by_M_w": {f"M={M}|{wn}": ladder[f"k={k}|eps={eps:g}|M={M}|{wn}"].get("L_c") for M in Mall for wn, _ in weights
                                  if f"k={k}|eps={eps:g}|M={M}|{wn}" in ladder},
                   "L_c": top.get("L_c"), "X_c": top.get("X_c"), "lam_at_1.5Lc": top.get("lam_at_1.5Lc"), "lam_at_2Lc": top.get("lam_at_2Lc"),
                   "hc_gamma_over_pi": top.get("hc_gamma_over_pi"), "hc_gamma": top.get("hc_gamma"),
                   "resolved_brief_criterion": top.get("resolved_brief_criterion"), "resolved_bessel_criterion": top.get("resolved_bessel_criterion")}
            summary.append(row)
            tail_s = (f" {top['X_c']:>7.3f} {top['lam_at_1.5Lc']:>+10.2e} {top['lam_at_2Lc']:>+10.2e} {Mu:>6d} {top['hc_gamma_over_pi']:>9.1f} "
                      f"{'y' if top['resolved_brief_criterion'] else 'n':>3}") if top.get("L_c") is not None else f" {'':>7} {'':>10} {'':>10} {Mu:>6d}"
            print(f"{k:>5} {float(gk_mp[k]):>10.3f} {math.log(float(gk_mp[k])):>8.4f} {gaps[k]:>8.4f} {eps:>6g} " + " ".join(cells) + tail_s)

    print("\n  M-convergence of L_c (w=1/2): relative change between successive M run")
    conv = []
    for k in ks:
        for eps in eps_list:
            Ms_here = M_used[(k, eps)]
            vals = [(M, ladder[f"k={k}|eps={eps:g}|M={M}|w=1/2"].get("L_c")) for M in Ms_here]
            parts = []
            for (M1, v1), (M2, v2) in zip(vals[:-1], vals[1:]):
                if v1 is not None and v2 is not None:
                    parts.append(f"M{M1}->M{M2}: {(v2 - v1) / v1:+.4f}")
                    conv.append({"k": k, "eps": eps, "M_from": M1, "M_to": M2, "rel_change": (v2 - v1) / v1})
                else:
                    parts.append(f"M{M1}->M{M2}: {v1} -> {v2}")
            print(f"    k={k:<5d} eps={eps:<6g} " + "  ".join(parts))

    fits = {}
    eps_fit = 0.01 if 0.01 in eps_list else eps_list[0]
    print(f"\n===== fits of L_c({eps_fit:g}, k) (least squares L_c = a + b x, eight k) =====")
    for label, Msel in (("M_used (largest M run per k)", None), ("M=32", 32), ("M=64", 64)):
        for wn, _ in weights:
            pts = []
            for k in ks:
                M = max(M_used[(k, eps_fit)]) if Msel is None else Msel
                r = ladder.get(f"k={k}|eps={eps_fit:g}|M={M}|{wn}", {})
                if r.get("L_c") is not None:
                    pts.append((k, r["L_c"], float(gk_mp[k]), gaps[k], M))
            if len(pts) < 3:
                print(f"  {label} {wn}: only {len(pts)} points with an L_c; no fit")
                continue
            LL = np.array([p[1] for p in pts])
            gg = np.array([p[2] for p in pts])
            gp = np.array([p[3] for p in pts])
            out = {"k": [p[0] for p in pts], "M": [p[4] for p in pts], "L_c": LL.tolist(), "gamma_k": gg.tolist(), "gap": gp.tolist()}
            for name, x in (("log gamma_k", np.log(gg)), ("gamma_k", gg), ("1/gap", 1 / gp)):
                out[name] = lstsq_line(x, LL)
            fits[f"{label}|{wn}"] = out
            print(f"\n  {label}, {wn} ({len(pts)} points; k = {[p[0] for p in pts]}; M = {[p[4] for p in pts]})")
            print("    L_c   = " + " ".join(f"{v:.4f}" for v in LL))
            for name in ("log gamma_k", "gamma_k", "1/gap"):
                f = out[name]
                print(f"    L_c = {f['a']:+.4f} + {f['b']:+.6f} * {name:<12s} rms resid {f['rms_resid']:.4f}  R^2 {f['R2']:.4f}  resid "
                      + " ".join(f"{r:+.3f}" for r in f["residuals"]))

    # ============================================================ minimiser shapes at L_c, eps = 0.01
    print(f"\n===== minimiser at L_c, eps = {eps_fit:g} (w=1/2) =====")
    for k in ks:
        for M in M_used[(k, eps_fit)]:
            r = ladder.get(f"k={k}|eps={eps_fit:g}|M={M}|w=1/2", {})
            d = r.get("minimiser_at_Lc")
            if not d:
                print(f"  k={k} M={M}: no L_c")
                continue
            print(f"  k={k:<5d} M={M:2d} L_c={r['L_c']:.4f} (h={r['L_c']/2:.4f}, h g_k/pi={r['hc_gamma_over_pi']:.1f}): parity {d['parity']} "
                  f"(lam even {d['lam_even']:+.2e}, odd {d['lam_odd']:+.2e}); |A|^2={d['A2']:.3e} |B|^2={d['B2']:.3e} T={d['T_at_min']:+.3e}")
            print(f"      mass: central half {d['mass_central_half']:.4f}, central tenth {d['mass_central_tenth']:.4f}, end tenths {d['mass_end_tenths']:.4f}, "
                  f"|G|max at u/h={d['abs_max_at_u_over_h']:+.3f}, sign changes {d['sign_changes']}, G(0)={d['G_at_0']:+.3f}, G(+-h)={d['G_at_ends'][0]:+.2e},{d['G_at_ends'][1]:+.2e}")
            print(f"      Fourier energy within |t-gamma_k|<1: {d['fourier_energy_within_1_of_gamma_k']:.4f} of ||G||^2 (x2 for the mirror lobe); "
                  f"energy in |t|<gamma_1: {d['energy_below_gamma1']:.4f}")
            print("      G(u/h=-1..1): " + " ".join(f"{v:+.2f}" for v in d["grid_G"][::2]))

    # ============================================================ outputs
    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": "EXPLORATORY - no prereg, no decision rule, no verdict.",
        "params": {"code_version": _code_version(), "ks": ks, "eps": eps_list, "Ms": Ms, "Mraise": args.Mraise, "dps": args.dps,
                   "L_grid": grid, "grid_ratio": ratio, "bisect_ratio": args.bisect_ratio, "floor_rel": args.floor_rel, "bessel_rel": args.bessel_rel,
                   "zeros_file": wq.ZEROS_FILE, "n_zeros": int(len(gfile)), "gamma_N": gam_N,
                   "gamma_k_mp": {str(k): mp.nstr(gk_mp[k], 35) for k in ks}, "local_gap": {str(k): gaps[k] for k in ks},
                   "M_used": {f"k={k}|eps={eps:g}": M_used[(k, eps)] for k in ks for eps in eps_list},
                   "instrument": os.path.join(_HERE, "weil_Lc_eps.py"),
                   "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"), "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ")},
        "constants": {
            "Q": "Z'_k + tail + 2w T;  Z'_k = 2 sum_{j != k} |Ghat(gamma_j)|^2 (double-double Gram over all file zeros minus the exact rank-one term of zero k), "
                 "tail = weil_rung_min.zero_tail, T = 2 Re[Ghat(g_k - i eps) conj Ghat(g_k + i eps)] = 2(|A|^2 - |B|^2), Ghat_n at complex t by mp.besselj",
            "weights": {"w=1/2": "pair -> pair, rho' = 1/2 + eps + i gamma_k (primary)", "w=1": "four points, multiplicity one (secondary)"},
            "L_c": "first L in the bisected bracket with lam_min < -floor, floor = max(2 sqrt(Z'(G*)/2) bessel_rel sqrt(tr Z'/2), floor_rel * max|Q|)",
            "resolution": "resolved_brief_criterion: M >= h_c gamma_k / pi;  resolved_bessel_criterion: M >= h_c gamma_k (j_n(h gamma_k) negligible for n > h gamma_k)",
            "basis": "legendre sqrt((2n+1)/(2h)) P_n(u/h), n = 0..M-1, on [-h, h], h = L/2",
        },
        "unit_tests": tests,
        "sanity_k1_vs_weil_Lc_eps": sanity,
        "summary": summary,
        "M_convergence": conv,
        "fits": fits,
        "ladder": ladder,
        "timings": tstat,
    }
    with open(args.out, "w") as fh:
        json.dump(payload, fh, indent=1)
    print(f"\n  results written to {args.out}")

    txt = args.txt
    with open(txt, "w") as fh:
        fh.write("weil_Lc_height  EXPLORATORY - no prereg, no decision rule, no verdict.\n")
        fh.write(f"generated {payload['generated_utc']}  code_version {payload['params']['code_version'][:16]}\n")
        fh.write("Q = Z'_k + tail + 2w T on the Legendre subspace of L2[-L/2, L/2]; zero k moved to 1/2 + eps + i gamma_k (pair -> pair, w=1/2 primary; w=1 four points).\n")
        fh.write(f"dps {args.dps}; M = {Ms} for every (k, eps), M = {args.Mraise} added where M={max(Ms)} < h_c gamma_k/pi; L grid {grid[0]:.3f}..{grid[-1]:.3f} "
                 f"({len(grid)} pts, ratio {ratio:.4f}), bisect to {args.bisect_ratio}.\n\n")
        fh.write("L_c(eps, k): first bisected L with lam_min < -floor; X_c, lam at 1.5 L_c and 2 L_c, M_used, h_c gamma_k/pi and the check M_used >= h_c gamma_k/pi are at M_used, w=1/2\n")
        fh.write(hdr + "\n")
        for row in summary:
            k, eps = row["k"], row["eps"]
            cells = []
            for M in Mall:
                for wn, _ in weights:
                    v = row["L_c_by_M_w"].get(f"M={M}|{wn}", "absent")
                    cells.append(f"{v:>13.4f}" if isinstance(v, float) else (f"{'none':>13}" if v is None else f"{'':>13}"))
            tail_s = (f" {row['X_c']:>7.3f} {row['lam_at_1.5Lc']:>+10.2e} {row['lam_at_2Lc']:>+10.2e} {row['M_used']:>6d} {row['hc_gamma_over_pi']:>9.1f} "
                      f"{'y' if row['resolved_brief_criterion'] else 'n':>3}") if row["L_c"] is not None else f" {'':>7} {'':>10} {'':>10} {row['M_used']:>6d}"
            fh.write(f"{k:>5} {row['gamma_k']:>10.3f} {row['log_gamma_k']:>8.4f} {row['local_gap']:>8.4f} {eps:>6g} " + " ".join(cells) + tail_s + "\n")
        fh.write("\nM-convergence of L_c (w=1/2), relative change between successive M\n")
        for c in conv:
            fh.write(f"  k={c['k']:<5d} eps={c['eps']:<6g} M{c['M_from']}->M{c['M_to']}: {c['rel_change']:+.4f}\n")
        fh.write("\nper (k, eps, M, w): L_c, bracket, X_c, lam at 1.5 L_c and 2 L_c, grid points above L_c that are positive, h_c g_k/pi, h_c g_k, parity, shape\n")
        for key, r in ladder.items():
            if r.get("L_c_bracket"):
                d = r["minimiser_at_Lc"]
                fh.write(f"  {key:<30s} L_c {r['L_c']:.4f} [{r['L_c_bracket'][0]:.4f}, {r['L_c_bracket'][1]:.4f}] X_c {r['X_c']:.3f}  "
                         f"lam(1.5Lc) {r['lam_at_1.5Lc']:+.3e}  lam(2Lc) {r['lam_at_2Lc']:+.3e}  pos above {r['grid_points_above_Lc_positive']}/{r['grid_points_above_Lc']}  "
                         f"h_c g_k/pi {r['hc_gamma_over_pi']:.1f}  h_c g_k {r['hc_gamma']:.0f}  {d['parity']}  m_half {d['mass_central_half']:.3f}  "
                         f"E(|t-g_k|<1) {d['fourier_energy_within_1_of_gamma_k']:.4f}  E(|t|<g1) {d['energy_below_gamma1']:.4f}\n")
            else:
                fh.write(f"  {key:<30s} L_c {r.get('L_c')}  {r.get('note', '')}\n")
        fh.write("\nlam_min(Q; L) along the grid (parity e/o), one row per (k, eps, M, w)\n")
        fh.write("  L: " + " ".join(f"{L:8.3f}" for L in grid) + "\n")
        for key, r in ladder.items():
            fh.write(f"  {key:<30s} " + " ".join(f"{p['lam_min']:+.1e}{p['parity'][0]}" for p in r["grid"]) + "\n")
        fh.write(f"\nfits of L_c({eps_fit:g}, k) (least squares L_c = a + b x)\n")
        for kf, f in fits.items():
            fh.write(f"  {kf}: k {f['k']} M {f['M']}; L_c " + " ".join(f"{v:.4f}" for v in f["L_c"]) + "\n")
            for name in ("log gamma_k", "gamma_k", "1/gap"):
                g = f[name]
                fh.write(f"    x = {name:<12s} a {g['a']:+.4f} b {g['b']:+.6f} rms resid {g['rms_resid']:.4f} R^2 {g['R2']:.4f} resid "
                         + " ".join(f"{v:+.3f}" for v in g["residuals"]) + "\n")
        fh.write("\nsanity: k = 1, M = 32 vs weil_Lc_eps.json and the brief's 1.284, 1.139, 0.960\n")
        for s in sanity:
            fh.write(f"  eps={s['eps']:<6g} {s['weight']:<5s} here {s['L_c_here']}  weil_Lc_eps {s['L_c_weil_Lc_eps']}  brief {s['brief_target']}\n")
        fh.write("\nunit tests\n")
        fh.write(f"  [H1] Bessel closed form vs 384-node quadrature (k=1,2,10,30): max err_A {max(r['err_A'] for r in tests['H1_bessel_vs_quadrature']):.1e}, "
                 f"err_B {max(r['err_B'] for r in tests['H1_bessel_vs_quadrature']):.1e}\n")
        fh.write(f"  [H2] k=1000 indicator: max |matrix - closed| {max(r['err_matrix'] for r in tests['H2_k1000_indicator']):.1e}, "
                 f"|mp.quad - closed| {max(r['err_direct'] for r in tests['H2_k1000_indicator']):.1e}\n")
        fh.write(f"  [H3] rank-one removal vs physical removal: max {max(r['max_abs_diff'] for r in tests['H3_rank_one_removal']):.1e}\n")
        fh.write(f"  [H4] k=1000 eps=0: |T_0 - pair term| {tests['H4_eps0_pair_k1000']:.1e}\n")
        fh.write(f"\nminimiser at L_c (w=1/2), eps = {eps_fit:g}\n")
        for k in ks:
            for M in M_used[(k, eps_fit)]:
                r = ladder.get(f"k={k}|eps={eps_fit:g}|M={M}|w=1/2", {})
                d = r.get("minimiser_at_Lc")
                if not d:
                    fh.write(f"  k={k} M={M}: no L_c\n")
                    continue
                fh.write(f"  k={k:<5d} M={M:2d} L_c={r['L_c']:.4f}: {d['parity']}; |A|^2 {d['A2']:.3e} |B|^2 {d['B2']:.3e}; mass central half {d['mass_central_half']:.4f}, "
                         f"end tenths {d['mass_end_tenths']:.4f}, |G|max at u/h {d['abs_max_at_u_over_h']:+.3f}, sign changes {d['sign_changes']}; "
                         f"E(|t-g_k|<1) {d['fourier_energy_within_1_of_gamma_k']:.4f}, E(|t|<g1) {d['energy_below_gamma1']:.4f}\n")
                fh.write("    " + " ".join(f"{v:+.3f}" for v in d["grid_G"]) + "\n")
    print(f"  table written to {txt}")
    print("\nEXPLORATORY - no prereg, no decision rule, no verdict.")


if __name__ == "__main__":
    main()
