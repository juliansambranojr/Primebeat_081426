#!/usr/bin/env python3
"""
analyze_twins.py -- excursion analysis of the twin-prime counting residual.

    python analyze_twins.py twins_1e11.csv

Reads x,pi2 checkpoints; computes R(x) = pi_2(x) - 2*C2*Li_2(x); reports
excursion structure; runs a phase-randomised surrogate test on the crossing
clustering. At 1e8 there were only 12 excursions and the test was toothless.
At 1e11 there should be enough to actually decide.

Needs: numpy, matplotlib
"""
import sys
import os
import json
import datetime
import numpy as np

C2 = 0.6601618158468695739278121100145557784326

def jnum(v):
    """float() for json; non-finite -> None so the file stays valid json."""
    v = float(v)
    return v if np.isfinite(v) else None

def li2(x, npts=8_000_001):
    """Int_2^x dt/log^2 t, trapezoid on a fine log-spaced grid (accurate + fast)."""
    hi = float(np.max(x))
    w = np.linspace(np.log(2.0), np.log(hi), npts)
    t = np.exp(w)
    f = t / np.log(t)**2
    cum = np.concatenate([[0.0], np.cumsum(np.diff(w) * 0.5 * (f[:-1] + f[1:]))])
    return np.interp(np.log(x), w, cum)

def binstats(x, R, edges, q):
    """per-bin (count, quantity, geomean of x). edges are log10 x; first bin is
    open below and last open above, so the top edge is inclusive."""
    idx = np.digitize(np.log10(x), edges[1:-1], right=False)
    out = []
    for i in range(len(edges) - 1):
        m = idx == i
        n = int(m.sum())
        if n == 0:
            out.append((n, np.nan, np.nan))
            continue
        v = R[m]
        if q == "rms_about_zero":
            s = np.sqrt(np.mean(v**2))
        elif q == "std_about_mean":
            s = v.std()
        else:
            s = np.mean(np.abs(v))
        out.append((n, float(s), float(np.exp(np.mean(np.log(x[m]))))))
    return out

def alphafit(rows, weighted, minc):
    """ols slope of log(quantity) on log(geomean x); None if < 3 usable bins."""
    b = [r for r in rows if r[0] > 0 and r[0] >= minc
         and np.isfinite(r[1]) and r[1] > 0]
    if len(b) < 3:
        return None
    gx = np.log(np.array([r[2] for r in b]))
    yy = np.log(np.array([r[1] for r in b]))
    w = np.sqrt(np.array([r[0] for r in b], float)) if weighted else None
    return float(np.polyfit(gx, yy, 1, w=w)[0])

def main(path):
    d = np.loadtxt(path, delimiter=",", skiprows=1)
    x, pi2 = d[:, 0], d[:, 1]
    keep = x >= 1e4
    x, pi2 = x[keep], pi2[keep]
    R = pi2 - 2 * C2 * li2(x)

    print(f"checkpoints {len(x)}   x up to {x[-1]:.3g}")
    print(f"pi_2 final {pi2[-1]:.0f}   R final {R[-1]:+.1f}   "
          f"relative {R[-1]/pi2[-1]:+.2e}\n")

    # --- excursions -------------------------------------------------------
    sgn = np.sign(R)
    cross = np.flatnonzero(np.diff(sgn) != 0)
    print(f"zero crossings: {len(cross)}")
    bounds = np.concatenate([[0], cross, [len(x) - 1]])
    peaks, lengths = [], []
    for a, b in zip(bounds[:-1], bounds[1:]):
        if b - a < 2:
            continue
        seg = R[a:b]
        peaks.append(seg[np.argmax(np.abs(seg))])
        lengths.append(np.log(x[b]) - np.log(x[a]))
    peaks, lengths = np.array(peaks), np.array(lengths)
    print(f"excursions: {len(peaks)}   |peak| median {np.median(np.abs(peaks)):.1f}   "
          f"max {np.abs(peaks).max():.1f}")
    print(f"excursion length in log x: median {np.median(lengths):.4f}   "
          f"max {lengths.max():.4f}")

    # --- growth exponent, fitted on excursion peaks (sign-safe) -----------
    # deprecated: r^2 ~ 0.015. excursion lengths shrink with x (fixed linear
    # checkpoint step => density in log x grows like x), so the peaks being
    # regressed are not commensurable across decades.
    if len(peaks) > 6:
        px = np.array([x[(a + b) // 2] for a, b in zip(bounds[:-1], bounds[1:])
                       if b - a >= 2])
        al, c0 = np.polyfit(np.log(px), np.log(np.abs(peaks)), 1)
        yp = np.log(np.abs(peaks))
        r2p = 1 - (np.sum((yp - (al * np.log(px) + c0))**2)
                   / np.sum((yp - yp.mean())**2))
        print(f"\npeak growth |R_peak| ~ x^alpha : alpha = {al:.3f}  "
              f"r^2 = {r2p:.3f}  (deprecated -- noise with a line through it)")

    # --- growth exponent from decade-binned rms (use these) ---------------
    lo10 = float(np.floor(np.log10(x.min())))
    hi10 = float(np.ceil(np.log10(x.max())))
    dec = np.arange(lo10, hi10 + 0.5, 1.0)
    drows = binstats(x, R, dec, "rms_about_zero")
    dn = np.array([r[0] for r in drows])
    dv = np.array([r[1] for r in drows])
    dg = np.array([r[2] for r in drows])
    dflat = dv / np.sqrt(np.sqrt(10.0**dec[:-1] * 10.0**dec[1:]))
    dflat_alt = dv / np.sqrt(dg)
    drat = dv[1:] / dv[:-1]
    dlrat = np.log10(drat)
    dslope = dlrat / np.diff(np.log10(dg))

    a_ols, c_ols = np.polyfit(np.log(dg), np.log(dv), 1)
    yd = np.log(dv)
    r2d = 1 - (np.sum((yd - (a_ols * np.log(dg) + c_ols))**2)
               / np.sum((yd - yd.mean())**2))
    a_rat = float(np.mean(dlrat))
    a_tel = float(np.log10((dv[-1] / dv[0])**(1.0 / (len(dv) - 1))))
    tel_diff = abs(a_rat - a_tel)
    tel_ok = bool(tel_diff < 1e-12)
    a_cw = float(np.polyfit(np.log(dg), np.log(dv), 1, w=np.sqrt(dn))[0])

    # sensitivity sweep -- computed here, never hardcoded
    binnings = [
        ("decade", np.arange(lo10, hi10 + 0.5, 1.0)),
        ("half_decade", np.arange(lo10, hi10 + 0.25, 0.5)),
        ("equal_log_7", np.linspace(lo10, hi10, 8)),
        ("equal_log_10", np.linspace(lo10, hi10, 11)),
        ("equal_log_14", np.linspace(lo10, hi10, 15)),
        ("equal_log_20", np.linspace(lo10, hi10, 21)),
    ]
    quants = ["rms_about_zero", "std_about_mean", "abs_mean"]
    weights = [False, True]
    mincs = [0, 3, 10, 30]
    sw = []
    for _, be in binnings:
        for q in quants:
            rr = binstats(x, R, be, q)
            for wt in weights:
                for mc in mincs:
                    a = alphafit(rr, wt, mc)
                    if a is not None and np.isfinite(a):
                        sw.append(a)
    sw = np.array(sw)
    ncomb = len(binnings) * len(quants) * len(weights) * len(mincs)

    print(f"\ndecade rms growth (rms about zero, strict decades, "
          f"{len(dv)} bins):")
    print(f"  ols on geomean x     alpha = {a_ols:.4f}  r^2 = {r2d:.3f}")
    print(f"  consecutive ratios   alpha = {a_rat:.4f}  "
          f"(geomean ratio {10**a_rat:.3f}; author method; telescopes to "
          f"first/last bin, verified {tel_ok})")
    print(f"  count-weighted ols   alpha = {a_cw:.4f}  "
          f"(sensitivity only -- agreement with the ratio method is coincidence)")
    print(f"  sweep over {ncomb} combos: {len(sw)} valid, alpha in "
          f"[{sw.min():.4f}, {sw.max():.4f}] median {np.median(sw):.4f}")
    print("  flatness rms/sqrt(x), x at geomean of bin edges:")
    for i in range(len(dv)):
        print(f"    {10.0**dec[i]:.0e}-{10.0**dec[i+1]:.0e}  n {dn[i]:5d}  "
              f"rms {dv[i]:9.2f}  rms/sqrt(x) {dflat[i]:.4f}")

    # --- surrogate test on crossing clustering ---------------------------
    u = np.log(x)
    uu = np.linspace(u[0], u[-1], 1 << 15)
    r = np.interp(uu, u, R)

    def burst(v, win=None):
        win = win or max(8, len(v) // 500)
        c = np.flatnonzero(np.diff(np.sign(v)) != 0)
        if len(c) < 2:
            return 0, len(c)
        return max(np.sum((c >= s) & (c < s + win)) for s in c), len(c)

    obs_b, obs_n = burst(r)
    F = np.fft.rfft(r)
    mag = np.abs(F)
    rng = np.random.default_rng(0)
    sb = []
    for _ in range(2000):
        ph = rng.uniform(0, 2 * np.pi, len(F)); ph[0] = 0
        s = np.fft.irfft(mag * np.exp(1j * ph), n=len(uu))
        sb.append(burst(s)[0])
    sb = np.array(sb)
    print(f"\nsurrogate test (2000 phase randomisations):")
    print(f"  observed densest burst {obs_b}   surrogate {sb.mean():.1f} +- {sb.std():.1f}")
    print(f"  P(surrogate >= observed) = {(sb >= obs_b).mean():.4f}")
    print("  -> small p means the clustering is real; near 1 means spectral artefact")

    fr = 2 * np.pi * np.fft.rfftfreq(len(uu), d=(uu[1] - uu[0]))
    P = np.abs(F)**2
    m = (fr > 1) & (fr < 200)
    print(f"\n  spectrum slope: {np.polyfit(np.log(fr[m]), np.log(P[m]), 1)[0]:.2f}  "
          f"(-2 Brownian, 0 white)")

    # --- zeta-zero lines, if a zeros file is present ----------------------
    zeta_ratio = None
    try:
        gam = np.loadtxt("zeros1.txt")
        norm = np.sqrt(x) / np.log(x)**2
        rn = np.interp(uu, u, R / norm)
        rn = (rn - rn.mean()) * np.hanning(len(rn))
        Pn = np.abs(np.fft.rfft(rn))**2
        band = (fr > 5) & (fr < 120)
        f2, p2 = fr[band], Pn[band]
        w = 3 * (fr[1] - fr[0])
        at = np.mean([p2[(f2 > g - w) & (f2 < g + w)].mean()
                      for g in gam[:40] if 5 < g < 120])
        rg = np.random.default_rng(1)
        rnd = np.mean([np.mean([p2[(f2 > q - w) & (f2 < q + w)].mean()
                                for q in rg.uniform(6, 118, 40)])
                       for _ in range(200)])
        print(f"\n  power at zeta zeros / random bands = {at/rnd:.3f}  (1.0 = no signal)")
        zeta_ratio = at / rnd
    except OSError:
        pass

    # --- persist the numbers before anything that can fail ----------------
    out = os.path.splitext(os.path.abspath(path))[0] + "_analysis.json"
    res = {
        "schema_version": 2,
        "input_csv": os.path.abspath(path),
        "timestamp_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "seed_surrogate": 0,
        "seed_zeta": 1,
        "checkpoints": int(len(x)),
        "x_final": jnum(x[-1]),
        "pi2_final": jnum(pi2[-1]),
        "R_final": jnum(R[-1]),
        "R_relative": jnum(R[-1] / pi2[-1]),
        "zero_crossings": int(len(cross)),
        "excursions": int(len(peaks)),
        "peak_abs_median": jnum(np.median(np.abs(peaks))),
        "peak_abs_max": jnum(np.abs(peaks).max()),
        "excursion_logx_median": jnum(np.median(lengths)),
        "excursion_logx_max": jnum(lengths.max()),
        "alpha_note": (
            "alpha_peak is DEPRECATED: its fit has r^2 = 0.015, i.e. it is noise "
            "with a line through it, because excursion lengths shrink "
            "systematically with x and the peaks it regresses are not "
            "commensurable across decades. use the decade-rms estimators "
            "alpha_decade_rms_ols and alpha_decade_rms_ratio instead."
        ),
        "residual_definition": (
            "R(x) = pi_2(x) - 2*C2*Li_2(x) with C2 = 0.66016181584686957 and "
            "Li_2(x) = Int_2^x dt/log^2 t, evaluated at the input_csv "
            "checkpoints kept by the cutoff x >= 1e4 (a no-op here: the data "
            "starts at 1e7). Li_2 is computed by cumulative trapezoid of "
            "t/log(t)^2 dw on w = log t over numpy.linspace(log 2, log(max x), "
            "8000001), then numpy.interp of log(x) onto that grid -- reproduce "
            "that quadrature to match R to the last digit"
        ),
        "alpha_peak": {
            "value": jnum(al) if len(peaks) > 6 else None,
            "intercept": jnum(c0) if len(peaks) > 6 else None,
            "r_squared": jnum(r2p) if len(peaks) > 6 else None,
            "n_points": int(len(peaks)),
            "deprecated": True,
            "definition": (
                "unweighted ols slope of log|R_peak| on log(x_mid), natural logs, "
                "over sign-change excursions with b-a >= 2, where R_peak is the "
                "signed value of largest |R| in the excursion and "
                "x_mid = x[(a+b)//2] for excursion index bounds a,b"
            ),
            "deprecated_reason": (
                "r^2 = 0.015. checkpoint step is a fixed linear 1e7, so checkpoint "
                "density in log x grows like x: median excursion length is 1.15 in "
                "log x in the 1e7 decade vs 0.0018 in the 1e10 decade, and 84 of "
                "108 excursions sit in the top decade. a 'peak' at large x is a "
                "sub-percent local wiggle; at small x it spans a decade."
            ),
        },
        "alpha_decade_rms_ols": {
            "value": jnum(a_ols),
            "intercept": jnum(c_ols),
            "r_squared": jnum(r2d),
            "n_bins": int(len(dv)),
            "definition": (
                "unweighted ols slope of log(rms) on log(x_geomean), natural logs "
                "both axes, over the strict decade bins listed in decade_bins; "
                "rms is about ZERO (sqrt(mean(R^2))), not the standard deviation "
                "about the bin mean; x_geomean = exp(mean(log x)) over the ACTUAL "
                "x values in the bin"
            ),
        },
        "alpha_decade_rms_ratio": {
            "value": jnum(a_rat),
            "definition": (
                "mean of log10 of the ratios of rms between consecutive strict "
                "decade bins, equivalently log10 of the geometric mean of those "
                "ratios; rms about zero, bins as listed in decade_bins"
            ),
            "provenance": (
                "this is the author's section 3 method and the estimator that "
                "produced the headline 0.46"
            ),
            "consecutive_ratios": [jnum(v) for v in drat],
            "n_ratios": int(len(drat)),
            "geometric_mean_ratio": jnum(10**a_rat),
            "telescopes": True,
            "telescoping_note": (
                "the geometric mean of consecutive ratios collapses algebraically "
                "to (rms_last/rms_first)^(1/(n_bins-1)), so this estimator depends "
                "ONLY on the first and last decade bins -- every interior bin "
                "cancels. the first bin has n = 9. this is a real limitation of "
                "the method, not a footnote."
            ),
            "telescoped_value": jnum(a_tel),
            "telescoping_verified": tel_ok,
            "telescoping_abs_diff": jnum(tel_diff),
        },
        "alpha_sensitivity": {
            "alpha_decade_rms_count_weighted": {
                "value": jnum(a_cw),
                "status": "sensitivity entry only -- NOT a headline estimator",
                "definition": (
                    "ols slope of log(rms) on log(x_geomean) over the strict "
                    "decade bins, weighted by bin count "
                    "(numpy.polyfit w = sqrt(count), so the least-squares weight "
                    "is count)"
                ),
                "coincidence_warning": (
                    "its near-agreement with alpha_decade_rms_ratio "
                    "(0.4615 vs 0.4620) is a COINCIDENCE of two different "
                    "methods and must not be mistaken for corroboration. an "
                    "earlier reconstruction wrongly inferred that this was the "
                    "author's method."
                ),
            },
            "sweep": {
                "grid_binning": [b[0] for b in binnings],
                "grid_quantity": quants,
                "grid_weighting": ["unweighted", "count_weighted"],
                "grid_min_bin_count": mincs,
                "log10_x_range": [jnum(lo10), jnum(hi10)],
                "binning_definition": (
                    "edges are in log10 x. decade = width 1.0 from lo10 to hi10; "
                    "half_decade = width 0.5; equal_log_N = N equal-width bins "
                    "spanning [lo10, hi10]. assignment is "
                    "numpy.digitize(log10(x), edges[1:-1], right=False), so the "
                    "first bin is open below and the last is open above (the top "
                    "edge is inclusive)."
                ),
                "quantity_definition": (
                    "rms_about_zero = sqrt(mean(R^2)); std_about_mean = "
                    "population std of R about the bin mean; abs_mean = "
                    "mean(|R|)"
                ),
                "fit_definition": (
                    "ols slope of log(quantity) on log(x_geomean) over usable "
                    "bins, natural logs; a bin is usable if count > 0, "
                    "count >= min_bin_count, and the quantity is finite and > 0; "
                    "a combination is skipped if fewer than 3 usable bins remain"
                ),
                "n_combinations": int(ncomb),
                "n_valid_fits": int(len(sw)),
                "alpha_min": jnum(sw.min()),
                "alpha_max": jnum(sw.max()),
                "alpha_median": jnum(np.median(sw)),
            },
        },
        "decade_bins": {
            "definition": (
                "strict decade bins in log10 x from lo10 to hi10 with lo10 = "
                "floor(log10(min x)) and hi10 = ceil(log10(max x)); assignment "
                "numpy.digitize(log10(x), edges[1:-1], right=False), so the top "
                "edge is inclusive"
            ),
            "rms_convention": (
                "rms about ZERO: sqrt(mean(R^2)) within the bin, NOT the "
                "standard deviation about the bin mean"
            ),
            "x_geomean_convention": (
                "exp(mean(log x)) over the actual x values in the bin"
            ),
            "rms_over_sqrt_x_convention": (
                "rms / sqrt(sqrt(lo*hi)) where lo and hi are the BIN EDGES -- "
                "e.g. bin [1e7,1e8] normalises by sqrt(sqrt(1e7*1e8)) = "
                "sqrt(3.162e7). normalising instead by the geometric mean of the "
                "ACTUAL x in the bin gives 0.0224 for the first bin rather than "
                "0.0257, so the two conventions are distinguishable; the "
                "alternative is recorded per bin as "
                "rms_over_sqrt_x_data_geomean"
            ),
            "local_slope_definition": (
                "log10(rms ratio) / log10(x_geomean ratio) for consecutive bins"
            ),
            "bins": [
                {
                    "lo": jnum(10.0**dec[i]),
                    "hi": jnum(10.0**dec[i + 1]),
                    "count": int(dn[i]),
                    "rms": jnum(dv[i]),
                    "x_geomean": jnum(dg[i]),
                    "rms_over_sqrt_x": jnum(dflat[i]),
                    "rms_over_sqrt_x_data_geomean": jnum(dflat_alt[i]),
                }
                for i in range(len(dv))
            ],
            "consecutive_rms_ratios": [jnum(v) for v in drat],
            "consecutive_log10_rms_ratios": [jnum(v) for v in dlrat],
            "consecutive_local_slopes": [jnum(v) for v in dslope],
        },
        "surrogate_obs_burst": int(obs_b),
        "surrogate_obs_crossings": int(obs_n),
        "surrogate_mean": jnum(sb.mean()),
        "surrogate_std": jnum(sb.std()),
        "surrogate_p": jnum((sb >= obs_b).mean()),
        "spectrum_slope": jnum(np.polyfit(np.log(fr[m]), np.log(P[m]), 1)[0]),
        "zeta_power_ratio": jnum(zeta_ratio) if zeta_ratio is not None else None,
    }
    with open(out, "w") as fh:
        json.dump(res, fh, indent=2)
    print(f"\n  wrote {out}")

    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        fig, ax = plt.subplots(2, 1, figsize=(13, 8))
        ax[0].plot(x, R, lw=0.6, color="crimson")
        ax[0].axhline(0, color="k", lw=0.8)
        ax[0].set_xscale("log"); ax[0].set_ylabel("R(x)")
        ax[0].set_title("twin counting residual vs Hardy-Littlewood")
        ax[0].grid(alpha=0.3)
        ax[1].loglog(fr[m], P[m], lw=0.6)
        ax[1].set_xlabel("frequency in log x  (= gamma if zeros drive it)")
        ax[1].set_ylabel("power"); ax[1].grid(alpha=0.3)
        plt.tight_layout(); plt.savefig("twin_residual.png", dpi=130)
        print("\n  wrote twin_residual.png")
    except ImportError:
        pass

if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "twins.csv")
