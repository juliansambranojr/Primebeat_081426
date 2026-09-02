"""weil_Lc_mod.py — support length L_c(eps, k) for zero k moved off the line, measured on
a test family MODULATED TO THE ZERO'S HEIGHT: G(u) = P_n(u/h) cos(gamma_k u) and
P_n(u/h) sin(gamma_k u), n < M (2M real functions, M = 16 by default, --M).
EXPLORATORY.  No prereg, no decision rule, no verdict.

Why.  weil_Lc_height.py's Legendre family (n < 96) carries no Fourier energy at
|t| = gamma_k once h gamma_k >~ M (Ghat_n(t) ~ j_n(h t) is evanescent for n < h t), so for
k >= 30 every minimiser was a low-frequency bump that never looked at gamma_k and the
rows sat under the floor.  This family looks at gamma_k by construction.

Same instrument otherwise (imported from weil_Lc_eps.py / weil_Lc_height.py):

    Q_{eps,k}(G) = Z'_k(G) + tail(G) + 2w T_{eps,k}(G),
    Z'_k(G)      = 2 sum_{j != k} |Ghat(gamma_j)|^2         (zeros1.txt, zero k removed)
    T_{eps,k}(G) = 2 Re[Ghat(gamma_k - i eps) conj Ghat(gamma_k + i eps)] = 2(|A|^2 - |B|^2),
    tail(G)      = (G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi)+1)/gamma_N,

w = 1/2 primary (pair -> pair, multiplicity conserving), w = 1 the unit-multiplicity
quadruple (secondary column); Ghat(t) = int G(u) e^{i u t} du.

The transform of the modulated basis.  Write the orthonormal Legendre functions
G_n^Leg(u) = sqrt((2n+1)/2h) P_n(u/h) on [-h, h] with transform
Ghat_n^Leg(t) = sqrt(2h(2n+1)) i^n j_n(h t).  The basis here is

    c_n(u) = G_n^Leg(u) cos(gamma_k u),   s_n(u) = G_n^Leg(u) sin(gamma_k u),

(normalised through the Gram S below, so the sqrt((2n+1)/2h) prefactor is a convention).
From cos(g u) = (e^{i g u} + e^{-i g u})/2 and sin(g u) = (e^{i g u} - e^{-i g u})/(2i),

    chat_n(t) = int G_n^Leg(u) cos(g u) e^{i u t} du = [ Ghat_n^Leg(t + g) + Ghat_n^Leg(t - g) ] / 2,
    shat_n(t) = int G_n^Leg(u) sin(g u) e^{i u t} du = [ Ghat_n^Leg(t + g) - Ghat_n^Leg(t - g) ] / (2i),

valid for complex t as well (both sides are entire in t).  At the moved zero's
arguments t = gamma_k -/+ i eps this needs Ghat^Leg at t - g = -/+ i eps (tiny, purely
imaginary — j_n is evaluated from its power series there, no branch to pick) and at
t + g = 2 gamma_k -/+ i eps (mp.besselj at complex argument, as in weil_Lc_height).
For real t (the file zeros) the double-precision table wr.spherical_jn_table is used on
|h(t -/+ g)| with j_n(-z) = (-1)^n j_n(z), and j_n(0) = delta_{n0} at an exact zero.
Even n: chat_n real, shat_n imaginary; odd n: chat_n imaginary, shat_n real — so the
double-double Gram over the zeros accumulates Re and Im parts separately
(Z = 2 (Re R^T Re R + Im R^T Im R)) and there is no even/odd block structure in u:
the full 2M x 2M real symmetric Q is solved with mp.eigsy.

Normalisation.  The 2M functions are real but NOT orthonormal in L2(-h, h):
<c_n, c_m> = delta/2 + Re I_nm(2g)/2, <s_n, s_m> = delta/2 - Re I_nm(2g)/2,
<c_n, s_m> = Im I_nm(2g)/2, with I_nm(w) = int G_n^Leg G_m^Leg e^{i w u} du.  I_nm is
exact through Adams' linearisation P_n P_m = sum_l (2l+1) (n m l; 0 0 0)^2 P_l and
int P_l(u/h) e^{i w u} du = 2h i^l j_l(w h):
    I_nm(w) = sqrt((2n+1)(2m+1)) sum_l (2l+1) (n m l;0 0 0)^2 i^l j_l(w h)
(unit test [M2] checks S against composite Gauss-Legendre quadrature in mp).  lam_min is the minimum of Q(G) over ||G||_2 = 1,
i.e. the smallest eigenvalue of the pencil (Q, S).  S is diagonalised (mp.eigsy),
directions with S-eigenvalue below --S-cut times the largest are dropped (the family is
nearly linearly dependent when g h is small: cos(g u) ~ 1 and sin(g u) ~ g u on the
support), Q is whitened on the kept directions and mp.eigsy gives lam_min and the
minimiser y; the raw coefficient vector is c = W y with ||G||_2 = 1 exactly.
The number of kept directions and cond(S) are recorded per grid point.

Floor model (the sign call), extended for the non-orthonormal coefficients:
    floor = max( 2 sqrt(Z'(G)/2) * bessel_rel * sqrt(tr Z'/2) * ||c||_2 ,
                 floor_rel * max|Q| * ||c||_2^2 ),
the first term the double-precision error of the Ghat(gamma_j) entries propagated
through G = sum c_a phi_a, the second the double-double rounding of the Gram; both
reduce to weil_Lc_eps's when ||c|| = 1.  lam_min counts as negative only below -floor.

Everything else — L grid 0.3 .. 12.06 (28 points, weil_Lc_eps's 25 extended by the same
ratio), geometric bisection to bracket ratio < 1.02, L_c = negative end of the bracket,
lam at 1.5 L_c and 2 L_c, eps = 0 control, dps 40 — is weil_Lc_height.py's.

Reported at each L_c (minimiser G*): E(|t - gamma_k| < local gap) and E(|t| < gamma_1)
of (1/2pi)|Ghat*(t)|^2 (Parseval total = 1; E near -gamma_k equals E near +gamma_k since
G* is real), |A|^2, |B|^2, Z'(G*), tail(G*), and which term carries the detection.

Outputs: results/weil_Lc_mod.json, weil_Lc_mod.txt (results/weil_Lc_mod.log via tee).
Fits, w = 1/2, per eps, over every k with an L_c, written by this script under
fits[eps][form] for form in {log_gamma_k, gamma_k, inv_mean_gap, neighbour_gap,
inv_neighbour_gap}.
"""
import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import sys
import time

import numpy as np
from numpy.polynomial.legendre import leggauss, legvander
from mpmath import mp, mpf, mpc, matrix as mpmatrix

_HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(_HERE, "results")


def _load(name):
    spec = importlib.util.spec_from_file_location(name, os.path.join(_HERE, name + ".py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


le = _load("weil_Lc_eps")        # ghat_legendre, dd_gram, to_mp, pair_matrix
lh = _load("weil_Lc_height")     # ghat_complex_bessel, rank_one_mp, lstsq_line
wr = le.wr                       # weil_rung_min: spherical_jn_table
wq = le.wq                       # weil_QX: ZEROS_FILE

_PHASE = np.array([1.0 + 0j, 1j, -1.0 + 0j, -1j])


# ------------------------------------------------------------ Legendre transform, signed / zero-safe
def ghat_leg_signed(M, h, t):
    """(M, len(t)) complex: Ghat_n^Leg(t) = sqrt(2h(2n+1)) i^n j_n(h t) for t of any sign, j_n(0) = delta_{n0}."""
    t = np.asarray(t, dtype=float)
    z = h * np.abs(t)
    nz = z == 0.0
    zz = z.copy()
    zz[nz] = 1.0                                   # placeholder, overwritten below
    J = wr.spherical_jn_table(M - 1, zz)
    if np.any(nz):
        J[:, nz] = 0.0
        J[0, nz] = 1.0
    n = np.arange(M)
    sign = np.where(t < 0, (-1.0) ** n[:, None], 1.0)
    return (np.sqrt(2 * h * (2 * n + 1)) * _PHASE[n % 4])[:, None] * sign * J


def ghat_mod(M, h, g, t):
    """(2M, len(t)) complex: rows 0..M-1 chat_n(t), rows M..2M-1 shat_n(t) (double precision)."""
    t = np.asarray(t, dtype=float)
    gp = ghat_leg_signed(M, h, t + g)
    gm = ghat_leg_signed(M, h, t - g)
    return np.vstack([(gp + gm) / 2, (gp - gm) / (2j)])


# ------------------------------------------------------------ zero side, double-double
def zero_side_mod(M, h, g, gam, chunk=25000):
    """Z = 2 sum_j Re[Ghat_a(gamma_j) conj Ghat_b(gamma_j)] over the file zeros, double-double; (mp matrix, (hi, lo))."""
    Rre, Rim = [], []
    for i0 in range(0, len(gam), chunk):
        Gh = ghat_mod(M, h, g, gam[i0:i0 + chunk])
        Rre.append(Gh.real.T.copy())
        Rim.append(Gh.imag.T.copy())
    Rre = np.vstack(Rre)
    Rim = np.vstack(Rim)
    h1, l1 = le.dd_gram(Rre)
    h2, l2 = le.dd_gram(Rim)
    hi = 2 * (h1 + h2)
    lo = 2 * (l1 + l2)
    return le.to_mp(hi, lo), (hi, lo)


def ghat_row_as_in_gram(M, h, g, gfile, k, chunk=25000):
    """Ghat_a(gamma_k^file) as the SAME doubles that entered zero_side_mod (recomputed inside its chunk)."""
    i0 = ((k - 1) // chunk) * chunk
    return ghat_mod(M, h, g, gfile[i0:i0 + chunk])[:, (k - 1) - i0]


# ------------------------------------------------------------ mp spherical Bessel, entire
def jn_series_mp(nmax, z, terms=None):
    """j_n(z), n = 0..nmax, from the power series (entire; used for |z| small)."""
    out = []
    z2 = -z * z / 2
    for n in range(nmax + 1):
        dfact = mpf(1)
        for q in range(1, 2 * n + 2, 2):
            dfact *= q
        term = mpf(1)
        s = mpf(1)
        m = 0
        while True:
            m += 1
            term = term * z2 / (m * (2 * n + 2 * m + 1))
            s += term
            if abs(term) < mp.eps * abs(s) * mpf(10) ** -5 or m > 400:
                break
        out.append(z ** n / dfact * s)
    return out


def jn_mp(nmax, z):
    """j_n(z), n = 0..nmax, complex z: series for |z| < 40, Bessel closed form (Re z > 0) otherwise."""
    z = mpc(z)
    if abs(z) < 40:
        with mp.extraprec(60):
            return jn_series_mp(nmax, z)
    assert mp.re(z) > 0, "jn_mp: Bessel branch needs Re z > 0"
    pref = mp.sqrt(mp.pi / (2 * z))
    return [pref * mp.besselj(n + mpf(1) / 2, z) for n in range(nmax + 1)]


def ghat_leg_mp(M, h, t):
    """[Ghat_n^Leg(t)]_{n<M} at complex t, entire in t."""
    h = mpf(h)
    J = jn_mp(M - 1, h * mpc(t))
    return [mp.sqrt(2 * h * (2 * n + 1)) * (1j) ** n * J[n] for n in range(M)]


def ghat_mod_mp(M, h, g, t):
    """[chat_n(t)]_{n<M} + [shat_n(t)]_{n<M} at complex t."""
    gp = ghat_leg_mp(M, h, mpc(t) + g)
    gm = ghat_leg_mp(M, h, mpc(t) - g)
    return [(gp[n] + gm[n]) / 2 for n in range(M)] + [(gp[n] - gm[n]) / (2j) for n in range(M)]


def transforms_mod(M, h, g, eps):
    """(A, B): A_a = (Ghat_a(g - i eps) + Ghat_a(g + i eps))/2, B_a = (Ghat_a(g - i eps) - Ghat_a(g + i eps))/2."""
    g = mpf(g)
    e = mpf(eps)
    if e == 0:
        gm = ghat_mod_mp(M, h, g, g)
        return gm, [mpc(0)] * (2 * M)
    gm = ghat_mod_mp(M, h, g, g - 1j * e)
    gp = ghat_mod_mp(M, h, g, g + 1j * e)
    A = [(gm[a] + gp[a]) / 2 for a in range(2 * M)]
    B = [(gm[a] - gp[a]) / 2 for a in range(2 * M)]
    return A, B


# ------------------------------------------------------------ L2 Gram of the basis (exact)
def _threej0_sq(n, m, l):
    """(n m l; 0 0 0)^2 as mpf; zero unless n+m+l even and triangle."""
    J = n + m + l
    if J % 2 or l < abs(n - m) or l > n + m:
        return mpf(0)
    g = J // 2
    num = mp.factorial(2 * g - 2 * n) * mp.factorial(2 * g - 2 * m) * mp.factorial(2 * g - 2 * l) / mp.factorial(2 * g + 1)
    r = mp.factorial(g) / (mp.factorial(g - n) * mp.factorial(g - m) * mp.factorial(g - l))
    return num * r * r


def adams_table(M):
    """a[n][m] = {l: (2l+1) (n m l;000)^2}."""
    return [[{l: (2 * l + 1) * _threej0_sq(n, m, l) for l in range(abs(n - m), n + m + 1, 2)} for m in range(M)] for n in range(M)]


def gram_mod(M, h, g, adams):
    """S (2M x 2M, mp): L2 Gram of {c_n} + {s_n} on [-h, h]."""
    h = mpf(h)
    J = jn_mp(2 * M - 2, 2 * mpf(g) * h)          # real argument
    S = mpmatrix(2 * M, 2 * M)
    for n in range(M):
        for m in range(n, M):
            I = mp.fsum(a * (1j) ** l * J[l] for l, a in adams[n][m].items()) * mp.sqrt(mpf((2 * n + 1) * (2 * m + 1)))
            d = mpf(1) if n == m else mpf(0)
            cc = d / 2 + mp.re(I) / 2
            ss = d / 2 - mp.re(I) / 2
            cs = mp.im(I) / 2
            S[n, m] = S[m, n] = cc
            S[M + n, M + m] = S[M + m, M + n] = ss
            S[n, M + m] = S[M + m, n] = cs
            S[m, M + n] = S[M + n, m] = cs
    return S


def tail_mod(M, h, g, gam_N):
    """(G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi)+1)/gamma_N as a 2M x 2M matrix."""
    h = mpf(h)
    g = mpf(g)
    cst = (mp.log(mpf(gam_N) / (2 * mp.pi)) + 1) / (mp.pi * mpf(gam_N))
    ch, sh = mp.cos(g * h), mp.sin(g * h)
    vals = {}
    for sig in (1, -1):
        v = []
        for n in range(M):
            v.append(mp.sqrt((2 * n + 1) / (2 * h)) * sig ** n * ch)
        for n in range(M):
            v.append(mp.sqrt((2 * n + 1) / (2 * h)) * sig ** n * sig * sh)
        vals[sig] = v
    T = mpmatrix(2 * M, 2 * M)
    for a in range(2 * M):
        for b in range(2 * M):
            T[a, b] = cst * (vals[1][a] * vals[1][b] + vals[-1][a] * vals[-1][b])
    return T


# ------------------------------------------------------------ direct evaluation (unit tests, shapes)
def basis_eval_np(M, h, g, u):
    """(2M, len(u)) values of c_n, s_n at u (double precision)."""
    u = np.asarray(u, dtype=float)
    n = np.arange(M)
    P = legvander(u / h, M - 1).T * np.sqrt((2 * n + 1) / (2 * h))[:, None]
    return np.vstack([P * np.cos(g * u), P * np.sin(g * u)])


def basis_eval_mp(M, h, g, u, a):
    """phi_a(u) in mp."""
    h = mpf(h)
    n = a % M
    P = mp.legendre(n, u / h) * mp.sqrt((2 * n + 1) / (2 * h))
    return P * (mp.cos(mpf(g) * u) if a < M else mp.sin(mpf(g) * u))


_GL_CACHE = {}


def gl_nodes_mp(n=20):
    """Gauss-Legendre nodes/weights on [-1, 1] in mp (Newton from the double-precision nodes)."""
    key = (n, mp.prec)
    if key not in _GL_CACHE:
        x0, _ = leggauss(n)
        xs, ws = [], []
        for x in x0:
            x = mpf(x)
            for _ in range(6):
                p = mp.legendre(n, x)
                dp = n * (x * p - mp.legendre(n - 1, x)) / (x * x - 1)
                x = x - p / dp
            p = mp.legendre(n, x)
            dp = n * (x * p - mp.legendre(n - 1, x)) / (x * x - 1)
            xs.append(x)
            ws.append(2 / ((1 - x * x) * dp * dp))
        _GL_CACHE[key] = (xs, ws)
    return _GL_CACHE[key]


def quad_panels_mp(f, a, b, panels, nodes=20):
    """int_a^b f by composite Gauss-Legendre (fixed rule; ~2 panels per period of the fastest oscillation is plenty)."""
    xs, ws = gl_nodes_mp(nodes)
    a, b = mpf(a), mpf(b)
    wdt = (b - a) / panels
    tot = mpf(0)
    for i in range(panels):
        c = a + wdt * (i + mpf(1) / 2)
        r = wdt / 2
        tot += r * mp.fsum(w * f(c + r * x) for x, w in zip(xs, ws))
    return tot


def ghat_quad_mp(M, h, g, a, t, panels=None):
    """int_{-h}^{h} phi_a(u) e^{i u t} du by composite 20-node Gauss-Legendre, 2 panels per period of e^{2 i g u}."""
    h = mpf(h)
    if panels is None:
        panels = int(2 * float(2 * mpf(g) * h) / math.pi) + 8
    f = lambda u: basis_eval_mp(M, h, g, u, a) * mp.exp(1j * u * mpc(t))
    return quad_panels_mp(f, -h, h, panels)


def gram_quad_mp(M, h, g, a, b, panels=None):
    h = mpf(h)
    if panels is None:
        panels = int(2 * float(2 * mpf(g) * h) / math.pi) + 8
    f = lambda u: basis_eval_mp(M, h, g, u, a) * basis_eval_mp(M, h, g, u, b)
    return quad_panels_mp(f, -h, h, panels)


def fourier_energy(M, h, g, c, t_lo, t_hi, nodes=24):
    """(1/2pi) int_{t_lo}^{t_hi} |Ghat(t)|^2 dt for G = sum c_a phi_a (double precision)."""
    period = math.pi / h
    npan = int(math.ceil((t_hi - t_lo) / (period / 4))) + 2
    edges = np.linspace(t_lo, t_hi, npan + 1)
    xg, wg = leggauss(nodes)
    tt = (((edges[:-1] + edges[1:]) / 2)[:, None] + ((edges[1:] - edges[:-1]) / 2)[:, None] * xg[None, :]).ravel()
    tw = (((edges[1:] - edges[:-1]) / 2)[:, None] * wg[None, :]).ravel()
    gc = c @ ghat_mod(M, h, g, tt)
    return float(np.sum(np.abs(gc) ** 2 * tw) / (2 * math.pi))


def describe_G(M, h, g, c, npts=4001):
    """Shape of G = sum c_a phi_a on [-h, h]: masses, envelope, ends, sign changes; ||G||_2 (should be 1)."""
    u = np.linspace(-h, h, npts)
    G = c @ basis_eval_np(M, h, g, u)
    du = u[1] - u[0]
    G2 = G ** 2
    tot = np.sum(G2) * du
    central_half = np.sum(G2[np.abs(u) <= h / 2]) * du / tot
    central_tenth = np.sum(G2[np.abs(u) <= h / 10]) * du / tot
    end_tenths = np.sum(G2[np.abs(u) >= 0.9 * h]) * du / tot
    imax = int(np.argmax(np.abs(G)))
    sc = int(np.sum(np.diff(np.sign(G[np.abs(G) > 1e-12 * np.max(np.abs(G))])) != 0))
    # envelope: local maxima of |G| (the modulated bump's carrier stripped)
    absG = np.abs(G)
    loc = (absG[1:-1] >= absG[:-2]) & (absG[1:-1] >= absG[2:])
    env_u = u[1:-1][loc]
    env_v = absG[1:-1][loc]
    env_central_half = float(np.mean(env_v[np.abs(env_u) <= h / 2])) if np.any(np.abs(env_u) <= h / 2) else None
    env_outer = float(np.mean(env_v[np.abs(env_u) > h / 2])) if np.any(np.abs(env_u) > h / 2) else None
    step = max(1, npts // 40)
    return {"L2_norm_on_grid": float(math.sqrt(tot)), "mass_central_half": float(central_half),
            "mass_central_tenth": float(central_tenth), "mass_end_tenths": float(end_tenths),
            "abs_max_at_u_over_h": float(u[imax] / h), "G_at_ends": [float(G[0]), float(G[-1])], "G_at_0": float(G[npts // 2]),
            "sign_changes": sc, "n_local_maxima_of_absG": int(loc.sum()),
            "envelope_mean_central_half": env_central_half, "envelope_mean_outer_half": env_outer,
            "grid_G": [[float(u[i] / h), float(G[i])] for i in range(0, npts, step)]}


# ------------------------------------------------------------ whitened eigensolve
def eig_pencil(Q, S, S_cut):
    """lam_min of (Q, S): diagonalise S, drop directions with eigenvalue < S_cut * max, whiten, eigsy."""
    n = Q.rows
    ES, US = mp.eigsy(S)
    emax = max(ES[i] for i in range(n))
    keep = [i for i in range(n) if ES[i] > S_cut * emax]
    emin_kept = min(ES[i] for i in keep)
    W = mpmatrix(n, len(keep))
    for jj, i in enumerate(keep):
        s = 1 / mp.sqrt(ES[i])
        for r in range(n):
            W[r, jj] = US[r, i] * s
    Qt = W.T * Q * W
    for i in range(Qt.rows):                      # symmetrise against rounding
        for j in range(i + 1, Qt.cols):
            v = (Qt[i, j] + Qt[j, i]) / 2
            Qt[i, j] = v
            Qt[j, i] = v
    E, U = mp.eigsy(Qt)
    imin = min(range(len(keep)), key=lambda i: E[i])
    y = U[:, imin]
    c = W * y
    return E[imin], c, len(keep), float(emax / emin_kept), float(min(ES[i] for i in range(n)) / emax)


# ------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--ks", type=str, default="1,2,5,10,30,100,300,1000")
    ap.add_argument("--eps", type=str, default="0,0.001,0.01,0.1")
    ap.add_argument("--M", type=int, default=16, help="P_n, n < M, for each of cos and sin: 2M functions")
    ap.add_argument("--dps", type=int, default=40)
    ap.add_argument("--Lmin", type=float, default=0.3)
    ap.add_argument("--Lbase", type=float, default=8.0)
    ap.add_argument("--npts", type=int, default=25)
    ap.add_argument("--Lmax", type=float, default=12.0)
    ap.add_argument("--bisect-ratio", type=float, default=1.02)
    ap.add_argument("--floor-rel", type=float, default=1e-30)
    ap.add_argument("--bessel-rel", type=float, default=1e-15)
    ap.add_argument("--S-cut", type=float, default=1e-24, help="drop S-directions below this times the largest S eigenvalue")
    ap.add_argument("--no-unit-tests", action="store_true")
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_Lc_mod.json"))
    ap.add_argument("--txt", type=str, default=os.path.join(_HERE, "weil_Lc_mod.txt"))
    args = ap.parse_args()
    mp.dps = args.dps
    T_start = time.time()

    ks = [int(x) for x in args.ks.split(",")]
    eps_list = [float(x) for x in args.eps.split(",")]
    M = args.M
    weights = [("w=1/2", mpf(1) / 2), ("w=1", mpf(1))]
    ratio = (args.Lbase / args.Lmin) ** (1.0 / (args.npts - 1))
    grid = [args.Lmin * ratio ** i for i in range(args.npts)]
    while grid[-1] < args.Lmax:
        grid.append(grid[-1] * ratio)

    print("weil_Lc_mod  EXPLORATORY - no prereg, no decision rule, no verdict.")
    print(f"  basis: P_n(u/h) cos(gamma_k u), P_n(u/h) sin(gamma_k u), n < {M} ({2*M} functions), full 2M eigsy on the pencil (Q, S), S-cut {args.S_cut:g}")
    print(f"  k={ks}  eps={eps_list} (eps=0 is the control)  dps={args.dps}")
    print(f"  L grid {grid[0]:.3f}..{grid[-1]:.3f} ({len(grid)} pts, ratio {ratio:.4f}), bisect to {args.bisect_ratio}")
    print("  primary w=1/2: T = 2 Re[Ghat(g_k - i eps) conj Ghat(g_k + i eps)] (pair -> pair); secondary w=1: 2T")

    gfile = np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)])
    gam_N = float(gfile[-1])
    gk_mp = {}

    def gz(k):
        if k not in gk_mp:
            gk_mp[k] = mp.zetazero(k).imag
        return gk_mp[k]
    gaps, gap_up, gap_dn = {}, {}, {}
    for k in ks:
        up = float(gfile[k] - gfile[k - 1])
        dn = float(gfile[k - 1] - gfile[k - 2]) if k >= 2 else None
        gap_up[k], gap_dn[k] = up, dn
        gaps[k] = min(up, dn) if dn is not None else up
    print(f"  zeros1.txt: {len(gfile)} zeros, gamma_N {gam_N:.3f}")
    print(f"  {'k':>5} {'gamma_k (mp)':>22} {'|file-mp|':>10} {'log gamma_k':>12} {'nb gap':>8} {'mean gap':>9}")
    for k in ks:
        print(f"  {k:>5} {mp.nstr(gz(k), 20):>22} {abs(float(gz(k)) - gfile[k-1]):>10.1e} {math.log(float(gz(k))):>12.4f} {gaps[k]:>8.4f} {2*math.pi/math.log(float(gz(k))/(2*math.pi)):>9.4f}")
    adams = adams_table(M)

    # ============================================================ unit tests
    tests = {}
    if not args.no_unit_tests:
        print("\n===== unit tests =====")
        t0 = time.time()
        # [M0] series j_n vs mp.besselj at moderate complex argument; Legendre limit of ghat_leg_mp vs weil_Lc_height's closed form
        rows = []
        for z in (mpc(30, 0.1), mpc(5, -0.3), mpc(39.9, 2)):
            with mp.extraprec(60):
                Js = jn_series_mp(M - 1, z)
            pref = mp.sqrt(mp.pi / (2 * z))
            Jb = [pref * mp.besselj(n + mpf(1) / 2, z) for n in range(M)]
            rows.append({"z": mp.nstr(z, 8), "max_rel_err": float(max(abs(Js[n] - Jb[n]) / abs(Jb[n]) for n in range(M)))})
        for hh, t in ((0.5, mpc(14.13, -0.01)), (3.0, mpc(1419.4, 0.01))):
            a = ghat_leg_mp(M, hh, t)
            b = lh.ghat_complex_bessel(M, hh, t)
            rows.append({"h": hh, "t": mp.nstr(t, 8), "max_abs_err_vs_height_closed_form": float(max(abs(a[n] - b[n]) for n in range(M)))})
        tests["M0_series_vs_besselj"] = rows
        for r in rows:
            print(f"  [M0] {r}")
        # [M1] chat_n, shat_n at t = gamma_k - i eps vs composite GL quadrature in mp; matrix element T[a,b] (w=1/2) vs the quad values
        rows = []
        for k in (1, 30, 1000):
            for hh in (0.5, 3.0):
                for eps in (0.0, 0.01):
                    g = gz(k)
                    t = g - 1j * mpf(eps)
                    tq = g + 1j * mpf(eps)
                    cf = ghat_mod_mp(M, hh, g, t)
                    cfp = ghat_mod_mp(M, hh, g, tq)
                    A, B = transforms_mod(M, hh, g, eps)
                    errs = {}
                    qv = {}
                    tt0 = time.time()
                    for a in (0, 5, M, M + 5):
                        q = ghat_quad_mp(M, hh, g, a, t)
                        qv[a] = q
                        errs[f"a={a}"] = {"closed": mp.nstr(cf[a], 12), "quad": mp.nstr(q, 12),
                                          "abs_err": float(abs(cf[a] - q)), "rel_err": float(abs(cf[a] - q) / abs(q)) if abs(q) > 0 else None}
                    # matrix element via A, B from the quad values (eps = 0: T_ab = 2 Re[q_a conj q_b])
                    a1, a2 = 0, M + 5
                    if eps == 0:
                        T_q = 2 * mp.re(qv[a1] * mp.conj(qv[a2]))
                    else:
                        qp1 = ghat_quad_mp(M, hh, g, a1, tq)
                        qp2 = ghat_quad_mp(M, hh, g, a2, tq)
                        Aq = [(qv[a1] + qp1) / 2, (qv[a2] + qp2) / 2]
                        Bq = [(qv[a1] - qp1) / 2, (qv[a2] - qp2) / 2]
                        T_q = 2 * (mp.re(Aq[0] * mp.conj(Aq[1])) - mp.re(Bq[0] * mp.conj(Bq[1])))
                    T_c = 2 * (mp.re(A[a1] * mp.conj(A[a2])) - mp.re(B[a1] * mp.conj(B[a2])))
                    rows.append({"k": k, "h": hh, "eps": eps, "h_gamma": float(hh * g), "ghat": errs,
                                 "T_elem_(0,M+5)_closed": mp.nstr(T_c, 12), "T_elem_quad": mp.nstr(T_q, 12),
                                 "T_elem_abs_err": float(abs(T_c - T_q)), "quad_seconds": time.time() - tt0})
                    worst = max(v["abs_err"] for v in errs.values())
                    print(f"  [M1] k={k:<5d} h={hh:<4g} eps={eps:<5g} h*gamma={float(hh*g):>8.1f}  max|closed-quad| over a in (0,5,M,M+5): {worst:.1e}  "
                          f"T[0,M+5] closed {mp.nstr(T_c, 10)} quad {mp.nstr(T_q, 10)} |diff| {float(abs(T_c-T_q)):.1e}  [{time.time()-tt0:.1f}s]")
        tests["M1_ghat_vs_quad"] = rows
        # [M2] Gram S vs composite GL quadrature in mp
        rows = []
        for k, hh in ((1, 0.5), (30, 0.5), (1000, 0.15)):
            g = gz(k)
            S = gram_mod(M, hh, g, adams)
            worst = 0
            ent = []
            for a, b in ((0, 0), (0, 2), (1, 3), (M, M), (M + 1, M + 4), (0, M), (2, M + 3), (M - 1, 2 * M - 1), (5, M + 5)):
                q = gram_quad_mp(M, hh, g, a, b)
                e = float(abs(S[a, b] - q))
                worst = max(worst, e)
                ent.append({"a": a, "b": b, "S": mp.nstr(S[a, b], 12), "quad": mp.nstr(q, 12), "abs_err": e})
            ES = mp.eigsy(S)[0]
            ES = [ES[i] for i in range(2 * M)]
            emin, emax = min(ES), max(ES)
            rows.append({"k": k, "h": hh, "2_gamma_h": float(2 * g * hh), "entries": ent, "max_abs_err": worst,
                         "S_eig_min": float(emin), "S_eig_max": float(emax), "cond_S": float(emax / emin)})
            print(f"  [M2] k={k:<5d} h={hh:<4g} 2*gamma*h={float(2*g*hh):>8.1f}  max|S - quad| {worst:.1e}  S eig min {float(emin):.2e} max {float(emax):.2e} cond {float(emax/emin):.1e}")
        tests["M2_gram_vs_quad"] = rows
        # [M3] rank-one removal: Z_all - 2 Re[v v^H] at zero k vs the Gram built without zero k
        rows = []
        for k, hh in ((1, 0.75), (30, 1.5), (1000, 0.5)):
            g = float(gz(k))
            Za, _ = zero_side_mod(M, hh, g, gfile)
            Rk = ghat_row_as_in_gram(M, hh, g, gfile, k)
            Zp = Za - lh.rank_one_mp(Rk)
            Zw, _ = zero_side_mod(M, hh, g, np.delete(gfile, k - 1))
            d = max(abs(Zp[i, j] - Zw[i, j]) for i in range(2 * M) for j in range(2 * M))
            mx = max(abs(Zw[i, j]) for i in range(2 * M) for j in range(2 * M))
            rows.append({"k": k, "h": hh, "max_abs_diff": float(d), "max_abs_entry": float(mx), "rel": float(d / mx),
                         "Ghat_k_row_max": float(np.max(np.abs(Rk)))})
            print(f"  [M3] k={k:<5d} h={hh:<4g} |Z_all - rank1 - Z_without| max {float(d):.1e} (entries up to {float(mx):.2e}; |Ghat(gamma_k)| row max {np.max(np.abs(Rk)):.3f})")
        tests["M3_rank_one_removal"] = rows
        # [M4] S conditioning across the grid at the extreme k (what the whitening will face)
        rows = []
        for k in (ks[0], ks[-1]):
            for L in (grid[0], grid[len(grid) // 2], grid[-1]):
                S = gram_mod(M, L / 2, gz(k), adams)
                ES = mp.eigsy(S)[0]
                ES = [ES[i] for i in range(2 * M)]
                emin, emax = min(ES), max(ES)
                nk = sum(1 for e in ES if e > args.S_cut * emax)
                rows.append({"k": k, "L": L, "gamma_h": float(gz(k) * L / 2), "S_eig_min": float(emin), "S_eig_max": float(emax), "cond_S": float(emax / emin), "kept": nk})
                print(f"  [M4] k={k:<5d} L={L:<7.3f} gamma*h={float(gz(k)*L/2):>9.1f}  S eig min {float(emin):.2e} max {float(emax):.2e} cond {float(emax/emin):.1e}  kept {nk}/{2*M} at S-cut {args.S_cut:g}")
        tests["M4_S_conditioning"] = rows
        # [M5] eps = 0: pair term equals 2|Ghat(gamma_k)|^2 and T_0 (w=1/2) = the rank-one term of zero k up to double precision
        rows = []
        for k, hh in ((1, 0.75), (1000, 0.5)):
            g = gz(k)
            A, B = transforms_mod(M, hh, g, 0.0)
            Tm = le.pair_matrix(A, B, mpf(1) / 2)
            Rk = ghat_row_as_in_gram(M, hh, float(g), gfile, k)
            P = lh.rank_one_mp(Rk)
            d = max(abs(Tm[i, j] - P[i, j]) for i in range(2 * M) for j in range(2 * M))
            mx = max(abs(P[i, j]) for i in range(2 * M) for j in range(2 * M))
            rows.append({"k": k, "h": hh, "max_abs_diff": float(d), "max_abs_entry": float(mx), "rel": float(d / mx)})
            print(f"  [M5] k={k:<5d} h={hh:<4g} |T_0(w=1/2) - 2Re[v v^H](gamma_k^file)| max {float(d):.1e} rel {float(d/mx):.1e} (mp gamma_k vs file gamma_k, double-precision row)")
        tests["M5_eps0_pair_term"] = rows
        print(f"  unit tests: {time.time()-t0:.1f}s")

    # ============================================================ caches and solver
    cache_Z, cache_T, cache_S = {}, {}, {}
    tstat = {"Z": 0.0, "nZ": 0, "T": 0.0, "nT": 0, "S": 0.0, "nS": 0, "eig": 0.0, "neig": 0}

    def get_Z(hh, k):
        key = (hh, k)
        if key not in cache_Z:
            t0 = time.time()
            g = float(gz(k))
            Za, _ = zero_side_mod(M, hh, g, gfile)
            Rk = ghat_row_as_in_gram(M, hh, g, gfile, k)
            Zp = Za - lh.rank_one_mp(Rk)
            tail = tail_mod(M, hh, gz(k), gam_N)
            cache_Z[key] = (Zp + tail, Zp, tail)
            tstat["Z"] += time.time() - t0
            tstat["nZ"] += 1
        return cache_Z[key]

    def get_T(hh, k, eps):
        key = (hh, k, eps)
        if key not in cache_T:
            t0 = time.time()
            A, B = transforms_mod(M, hh, gz(k), eps)
            cache_T[key] = (le.pair_matrix(A, B, mpf(1) / 2), A, B)
            tstat["T"] += time.time() - t0
            tstat["nT"] += 1
        return cache_T[key]

    def get_S(hh, k):
        key = (hh, k)
        if key not in cache_S:
            t0 = time.time()
            cache_S[key] = gram_mod(M, hh, gz(k), adams)
            tstat["S"] += time.time() - t0
            tstat["nS"] += 1
        return cache_S[key]

    def solve(L, k, eps, w):
        hh = L / 2
        Z, Zp, tail = get_Z(hh, k)
        T, A, B = get_T(hh, k, eps)
        S = get_S(hh, k)
        Q = Z + (2 * w) * T
        t0 = time.time()
        lam, c, nkept, condS, smin_rel = eig_pencil(Q, S, args.S_cut)
        tstat["eig"] += time.time() - t0
        tstat["neig"] += 1
        n2 = 2 * M
        qmax = max(abs(Q[i, j]) for i in range(n2) for j in range(n2))
        cn = mp.sqrt(mp.fsum(c[i] ** 2 for i in range(n2)))
        ZpG = (c.T * Zp * c)[0, 0]
        tailG = (c.T * tail * c)[0, 0]
        trZp = mp.fsum(Zp[i, i] for i in range(n2))
        floor_model = 2 * mp.sqrt(max(ZpG, mpf(0)) / 2) * args.bessel_rel * mp.sqrt(trZp / 2) * cn
        floor = max(float(floor_model), args.floor_rel * float(qmax) * float(cn) ** 2)
        Av = mp.fsum(c[i] * A[i] for i in range(n2))
        Bv = mp.fsum(c[i] * B[i] for i in range(n2))
        cvec = np.array([float(c[i]) for i in range(n2)])
        return {"L": L, "h": hh, "k": k, "eps": eps, "M": M, "w": float(w), "lam_min": float(lam), "lam_min_str": mp.nstr(lam, 12),
                "floor": floor, "floor_model": float(floor_model), "Zprime_at_min": float(ZpG), "tail_at_min": float(tailG),
                "coef_norm": float(cn), "S_kept": nkept, "cond_S_kept": condS, "S_min_rel": smin_rel,
                "negative": bool(lam < -floor), "raw_negative": bool(lam < 0),
                "A2": float(abs(Av) ** 2), "B2": float(abs(Bv) ** 2),
                "T_at_min": float((2 * w) * 2 * (abs(Av) ** 2 - abs(Bv) ** 2)),
                "cos_block_norm": float(np.linalg.norm(cvec[:M])), "sin_block_norm": float(np.linalg.norm(cvec[M:])),
                "vec": cvec}

    def ladder_run(k, eps, w, wname):
        key = f"k={k}|eps={eps:g}|M={M}|{wname}"
        t0 = time.time()
        pts = [solve(L, k, eps, w) for L in grid]
        first = next((i for i, p in enumerate(pts) if p["negative"]), None)
        rec = {"k": k, "eps": eps, "M": M, "weight": wname, "gamma_k": float(gz(k)), "local_gap": gaps[k],
               "grid": [{k2: v for k2, v in p.items() if k2 != "vec"} for p in pts], "L_c": None}
        if first is not None and first > 0:
            La, Lb = grid[first - 1], grid[first]
            pa, pb = pts[first - 1], pts[first]
            nb = 0
            while Lb / La > args.bisect_ratio:
                Lm = math.sqrt(La * Lb)
                pm = solve(Lm, k, eps, w)
                nb += 1
                if pm["negative"]:
                    Lb, pb = Lm, pm
                else:
                    La, pa = Lm, pm
            Lc = Lb
            hc = Lc / 2
            p15 = solve(1.5 * Lc, k, eps, w)
            p2 = solve(2.0 * Lc, k, eps, w)
            above = [p for p in pts if p["L"] > Lc]
            n_pos_above = sum(1 for p in above if not p["negative"])
            g = float(gz(k))
            desc = describe_G(M, hc, g, pb["vec"])
            e_gap = fourier_energy(M, hc, g, pb["vec"], g - gaps[k], g + gaps[k])
            e_one = fourier_energy(M, hc, g, pb["vec"], g - 1.0, g + 1.0)
            e_low = fourier_energy(M, hc, g, pb["vec"], -float(gz(1)), float(gz(1)))
            # the pair's own weight: 2w * 2|A|^2 against Z'(G*) + tail; the detection term is -2w * 2|B|^2
            posA = float(2 * w) * 2 * pb["A2"]
            negB = float(2 * w) * 2 * pb["B2"]
            through = "energy at gamma_k (|A|^2 term comparable to Z')" if posA > 0.1 * max(pb["Zprime_at_min"], 1e-300) else "|B|^2 alone (|A|^2 term negligible against Z')"
            rec.update({"L_c": Lc, "L_c_bracket": [La, Lb], "X_c": math.exp(Lc), "n_bisect": nb,
                        "lam_at_bracket": [pa["lam_min"], pb["lam_min"]], "floor_at_bracket": [pa["floor"], pb["floor"]],
                        "lam_at_1.5Lc": p15["lam_min"], "lam_at_2Lc": p2["lam_min"],
                        "negative_at_1.5Lc": p15["negative"], "negative_at_2Lc": p2["negative"],
                        "grid_points_above_Lc": len(above), "grid_points_above_Lc_positive": n_pos_above,
                        "hc_gamma": hc * g, "hc_gamma_over_pi": hc * g / math.pi,
                        "minimiser_at_Lc": {"A2": pb["A2"], "B2": pb["B2"], "T_at_min": pb["T_at_min"],
                                            "Zprime_at_min": pb["Zprime_at_min"], "tail_at_min": pb["tail_at_min"],
                                            "pair_positive_term_2w2A2": posA, "pair_negative_term_2w2B2": negB,
                                            "detection_through": through, "A2_over_B2": pb["A2"] / pb["B2"] if pb["B2"] > 0 else None,
                                            "E_within_local_gap_of_gamma_k": e_gap, "E_within_1_of_gamma_k": e_one,
                                            "E_below_gamma1": e_low,
                                            "coef_norm": pb["coef_norm"], "S_kept": pb["S_kept"], "cond_S_kept": pb["cond_S_kept"],
                                            "cos_block_norm": pb["cos_block_norm"], "sin_block_norm": pb["sin_block_norm"],
                                            "coeffs": [float(v) for v in pb["vec"]], **desc}})
        elif first == 0:
            rec["L_c"] = grid[0]
            rec["note"] = "negative already at the first grid point"
        else:
            last = pts[-1]
            imin = min(range(len(pts)), key=lambda i: pts[i]["lam_min"])
            rec["note"] = (f"no sign change beyond the floor up to L = {grid[-1]:.3f} (there: lam_min {last['lam_min']:+.2e}, "
                           f"floor {last['floor']:.1e}, Z'(G*) {last['Zprime_at_min']:.1e}, |A|^2 {last['A2']:.1e}, |B|^2 {last['B2']:.1e}, "
                           f"||c|| {last['coef_norm']:.1e}, kept {last['S_kept']}/{2*M}); min lam on grid {pts[imin]['lam_min']:+.2e} at L = {grid[imin]:.3f}")
        lam_s = " ".join(f"{p['lam_min']:+.1e}" for p in pts)
        flo_s = " ".join(f"{p['floor']:.0e}/{p['S_kept']}" for p in pts)
        if rec.get("L_c_bracket"):
            m = rec["minimiser_at_Lc"]
            lc = (f"L_c={rec['L_c']:.4f} X_c={rec['X_c']:.3f} [{rec['L_c_bracket'][0]:.4f},{rec['L_c_bracket'][1]:.4f}] "
                  f"lam(1.5Lc)={rec['lam_at_1.5Lc']:+.2e} lam(2Lc)={rec['lam_at_2Lc']:+.2e} pos-above={rec['grid_points_above_Lc_positive']}/{rec['grid_points_above_Lc']} "
                  f"h_c g_k={rec['hc_gamma']:.1f}")
            lc2 = (f"      at L_c: |A|^2={m['A2']:.3e} |B|^2={m['B2']:.3e} Z'={m['Zprime_at_min']:.3e} tail={m['tail_at_min']:.1e} "
                   f"E(|t-g_k|<gap)={m['E_within_local_gap_of_gamma_k']:.4f} E(|t-g_k|<1)={m['E_within_1_of_gamma_k']:.4f} E(|t|<g_1)={m['E_below_gamma1']:.3e} "
                   f"||c||={m['coef_norm']:.2e} kept={m['S_kept']}/{2*M}  -> {m['detection_through']}")
        else:
            lc = f"L_c={rec['L_c']}  {rec.get('note')}"
            lc2 = None
        print(f"  {key:<28s} {lc}   [{time.time()-t0:.1f}s]")
        print(f"      grid lam: {lam_s}")
        print(f"      floor/kept: {flo_s}")
        if lc2:
            print(lc2)
        sys.stdout.flush()
        return key, rec

    # ============================================================ ladders
    print("\n===== ladders: lam_min(Q_{eps,k}; L) on the modulated family =====")
    print("  '-' entries beyond the floor are detections; floor/kept = floor at that L and S-directions kept out of 2M")
    ladder = {}
    for k in ks:
        for eps in eps_list:
            for wname, w in weights:
                if eps == 0 and wname == "w=1":
                    continue                       # T_0 is the pair's own term; w=1 at eps=0 double-counts (weil_Lc_eps)
                key, rec = ladder_run(k, eps, w, wname)
                ladder[key] = rec
    print(f"\n  timings: Z builds {tstat['nZ']} ({tstat['Z']:.1f}s), S builds {tstat['nS']} ({tstat['S']:.1f}s), T builds {tstat['nT']} ({tstat['T']:.1f}s), pencil eigs {tstat['neig']} ({tstat['eig']:.1f}s)")
    print("  L grid: " + " ".join(f"{L:.3f}" for L in grid))

    # ============================================================ sanity: k = 1 vs the Legendre family
    print("\n===== sanity: k = 1 vs the Legendre family (weil_Lc_eps.json M=32; weil_Lc_height.json M=64) =====")
    sanity = []
    prev = {}
    for nm in ("weil_Lc_eps.json", "weil_Lc_height.json"):
        pth = os.path.join(RESULTS, nm)
        prev[nm] = json.load(open(pth)) if os.path.exists(pth) else None
    for eps in eps_list:
        for wname, _ in weights:
            r = ladder.get(f"k=1|eps={eps:g}|M={M}|{wname}", {})
            pe = prev["weil_Lc_eps.json"]["ladder"].get(f"eps={eps:g}|M=32|{wname}", {}) if prev["weil_Lc_eps.json"] else {}
            ph = prev["weil_Lc_height.json"]["ladder"].get(f"k=1|eps={eps:g}|M=64|{wname}", {}) if prev["weil_Lc_height.json"] else {}
            rec = {"eps": eps, "weight": wname, "L_c_modulated": r.get("L_c"), "bracket_modulated": r.get("L_c_bracket"),
                   "L_c_legendre_M32": pe.get("L_c"), "bracket_legendre_M32": pe.get("L_c_bracket"),
                   "L_c_legendre_M64": ph.get("L_c"), "bracket_legendre_M64": ph.get("L_c_bracket"),
                   "modulated_ge_legendre_M32": (r.get("L_c") >= pe["L_c"]) if (r.get("L_c") is not None and pe.get("L_c") is not None) else None}
            # the brackets stop at ratio < bisect_ratio, so compare lam at the SAME L: at the Legendre M64 bracket ends,
            # lam_mod >= lam_Leg64 is what containment (modulated family inside the degree-63 polynomials to ~1e-30) requires
            if r and ph.get("L_c_bracket") and eps != 0:
                wv = mpf(1) / 2 if wname == "w=1/2" else mpf(1)
                same_L = []
                for Lx, lamL in zip(ph["L_c_bracket"], ph["lam_at_bracket"]):
                    px = solve(Lx, 1, eps, wv)
                    same_L.append({"L": Lx, "lam_modulated": px["lam_min"], "lam_legendre_M64": lamL, "modulated_ge_legendre": bool(px["lam_min"] >= lamL),
                                   "floor_modulated": px["floor"]})
                rec["at_legendre_M64_bracket_ends"] = same_L
            sanity.append(rec)
            if r:
                print(f"  eps={eps:<6g} {wname:<5s} modulated L_c {r.get('L_c')!s:<22} bracket {r.get('L_c_bracket')}  Legendre M32 {pe.get('L_c')!s:<22} bracket {pe.get('L_c_bracket')}  M64 {ph.get('L_c')!s:<22} "
                      f"modulated >= Legendre M32: {rec['modulated_ge_legendre_M32']}")
                for q in rec.get("at_legendre_M64_bracket_ends", []):
                    print(f"      at L={q['L']:.5f}: lam modulated {q['lam_modulated']:+.4e} (floor {q['floor_modulated']:.1e})  Legendre M64 {q['lam_legendre_M64']:+.4e}  modulated >= Legendre: {q['modulated_ge_legendre']}")

    # ============================================================ summary table
    print("\n===== L_c(eps, k), modulated family =====")
    print(f"{'k':>5} {'gamma_k':>10} {'log g_k':>8} {'nb gap':>8} {'mean gap':>9} {'eps':>6} {'w=1/2':>10} {'w=1':>10} {'X_c':>8} {'lam(1.5Lc)':>10} {'lam(2Lc)':>10} {'h_c g_k':>8} {'|A|^2':>9} {'|B|^2':>9} {'Z(G*)':>9} {'E_gap':>7} {'E<g1':>8}")
    summary = []
    for k in ks:
        for eps in eps_list:
            r = ladder.get(f"k={k}|eps={eps:g}|M={M}|w=1/2", {})
            r1 = ladder.get(f"k={k}|eps={eps:g}|M={M}|w=1", {})
            g = float(gz(k))
            mg = 2 * math.pi / math.log(g / (2 * math.pi))
            row = {"k": k, "eps": eps, "gamma_k": g, "log_gamma_k": math.log(g), "neighbour_gap": gaps[k], "gap_up": gap_up[k], "gap_down": gap_dn[k],
                   "mean_gap": mg, "L_c": r.get("L_c"), "L_c_w1": r1.get("L_c"), "X_c": r.get("X_c"),
                   "lam_at_1.5Lc": r.get("lam_at_1.5Lc"), "lam_at_2Lc": r.get("lam_at_2Lc"), "hc_gamma": r.get("hc_gamma"),
                   "note": r.get("note")}
            m = r.get("minimiser_at_Lc")
            if m:
                row.update({"A2": m["A2"], "B2": m["B2"], "Zprime_at_min": m["Zprime_at_min"], "tail_at_min": m["tail_at_min"],
                            "E_within_local_gap_of_gamma_k": m["E_within_local_gap_of_gamma_k"], "E_below_gamma1": m["E_below_gamma1"],
                            "detection_through": m["detection_through"], "S_kept": m["S_kept"], "coef_norm": m["coef_norm"]})
            summary.append(row)
            f = lambda v, fmt: (fmt % v) if v is not None else "none"
            print(f"{k:>5} {g:>10.3f} {math.log(g):>8.4f} {gaps[k]:>8.4f} {mg:>9.4f} {eps:>6g} {f(row['L_c'], '%10.4f'):>10} {f(row['L_c_w1'], '%10.4f'):>10} "
                  f"{f(row['X_c'], '%8.3f'):>8} {f(row['lam_at_1.5Lc'], '%+10.2e'):>10} {f(row['lam_at_2Lc'], '%+10.2e'):>10} {f(row['hc_gamma'], '%8.1f'):>8} "
                  f"{f(row.get('A2'), '%9.2e'):>9} {f(row.get('B2'), '%9.2e'):>9} {f(row.get('Zprime_at_min'), '%9.2e'):>9} "
                  f"{f(row.get('E_within_local_gap_of_gamma_k'), '%7.4f'):>7} {f(row.get('E_below_gamma1'), '%8.1e'):>8}")

    # ============================================================ fits, w = 1/2, per eps
    print("\n===== fits (w=1/2): L_c = a + b x over every k with an L_c, per eps =====")
    forms = {"log_gamma_k": lambda k: math.log(float(gz(k))),
             "gamma_k": lambda k: float(gz(k)),
             "inv_mean_gap": lambda k: math.log(float(gz(k)) / (2 * math.pi)) / (2 * math.pi),
             "neighbour_gap": lambda k: gaps[k],
             "inv_neighbour_gap": lambda k: 1 / gaps[k]}
    fits = {}
    for eps in eps_list:
        ks_ok = [k for k in ks if ladder.get(f"k={k}|eps={eps:g}|M={M}|w=1/2", {}).get("L_c") is not None]
        y = np.array([ladder[f"k={k}|eps={eps:g}|M={M}|w=1/2"]["L_c"] for k in ks_ok])
        fits[f"{eps:g}"] = {"ks": ks_ok, "L_c": y.tolist(), "n": len(ks_ok)}
        for fname, fx in forms.items():
            x = np.array([fx(k) for k in ks_ok])
            if len(ks_ok) >= 2:
                ft = lh.lstsq_line(x, y)
            else:
                ft = {"a": None, "b": None, "residuals": None, "rms_resid": None, "R2": None, "note": "fewer than 2 points"}
            ft["x"] = x.tolist()
            fits[f"{eps:g}"][fname] = ft
            if ft.get("a") is not None:
                print(f"  eps={eps:<6g} vs {fname:<18s} n={len(ks_ok)} ks={ks_ok}: a={ft['a']:+.4f} b={ft['b']:+.5f} rms={ft['rms_resid']:.4f} R2={ft['R2'] if ft['R2'] is not None else float('nan'):.4f}  "
                      f"resid={' '.join(f'{r:+.3f}' for r in ft['residuals'])}")
            else:
                print(f"  eps={eps:<6g} vs {fname:<18s} n={len(ks_ok)} ks={ks_ok}: {ft.get('note')}")

    # ============================================================ minimiser shapes
    print("\n===== minimiser at L_c (w=1/2) =====")
    shapes = {}
    for k in ks:
        for eps in eps_list:
            r = ladder.get(f"k={k}|eps={eps:g}|M={M}|w=1/2", {})
            m = r.get("minimiser_at_Lc")
            if not m:
                continue
            shapes[f"k={k}|eps={eps:g}"] = {kk: m[kk] for kk in m if kk not in ("coeffs", "grid_G")}
            print(f"  k={k:<5d} eps={eps:<6g} L_c={r['L_c']:.4f}: ||G||={m['L2_norm_on_grid']:.4f} central-half mass {m['mass_central_half']:.3f} end-tenths {m['mass_end_tenths']:.3f} "
                  f"|G|max at u/h={m['abs_max_at_u_over_h']:+.3f} sign changes {m['sign_changes']} local maxima of |G| {m['n_local_maxima_of_absG']} "
                  f"cos-block ||c||={m['cos_block_norm']:.2e} sin-block {m['sin_block_norm']:.2e} kept {m['S_kept']}/{2*M} cond(S kept) {m['cond_S_kept']:.1e}")
            print(f"           |A|^2={m['A2']:.3e} |B|^2={m['B2']:.3e} A2/B2={m['A2_over_B2'] if m['A2_over_B2'] is not None else float('nan'):.2e} Z'={m['Zprime_at_min']:.3e} tail={m['tail_at_min']:.2e} "
                  f"E(|t-g_k|<gap)={m['E_within_local_gap_of_gamma_k']:.4f} E(|t-g_k|<1)={m['E_within_1_of_gamma_k']:.4f} E(|t|<g_1)={m['E_below_gamma1']:.3e} -> {m['detection_through']}")

    # ============================================================ write
    elapsed = time.time() - T_start
    payload = {"script": os.path.basename(__file__), "status": "EXPLORATORY - no prereg, no decision rule, no verdict",
               "timestamp": datetime.datetime.now().isoformat(timespec="seconds"),
               "params": {"ks": ks, "eps": eps_list, "M": M, "n_functions": 2 * M, "dps": args.dps, "S_cut": args.S_cut,
                          "L_grid": grid, "grid_ratio": ratio, "bisect_ratio": args.bisect_ratio,
                          "floor_rel": args.floor_rel, "bessel_rel": args.bessel_rel,
                          "zeros_file": wq.ZEROS_FILE, "n_zeros": int(len(gfile)), "gamma_N": gam_N,
                          "gamma_k_mp": {str(k): mp.nstr(gz(k), 35) for k in ks},
                          "neighbour_gap": {str(k): gaps[k] for k in ks}, "gap_up": {str(k): gap_up[k] for k in ks}, "gap_down": {str(k): gap_dn[k] for k in ks},
                          "mean_gap": {str(k): 2 * math.pi / math.log(float(gz(k)) / (2 * math.pi)) for k in ks},
                          "weights": {"w=1/2": "pair -> pair, multiplicity conserving (primary)", "w=1": "unit-multiplicity quadruple (secondary)"}},
               "unit_tests": tests, "sanity_k1_vs_legendre": sanity, "summary": summary, "fits": fits,
               "minimiser_shapes": shapes, "ladder": ladder,
               "timings": {**tstat, "elapsed_s": elapsed}}
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as f:
        json.dump(payload, f, indent=1)
    sha = hashlib.sha256(open(args.out, "rb").read()).hexdigest()
    print(f"\nwrote {args.out}  sha256 {sha}  ({elapsed/60:.1f} min)")

    # ============================================================ txt
    lines = [f"weil_Lc_mod.txt — {payload['timestamp']} — EXPLORATORY (no prereg, no decision rule, no verdict)",
             f"json: {args.out}  sha256 {sha}",
             f"basis: P_n(u/h) cos(gamma_k u), P_n(u/h) sin(gamma_k u), n < {M} ({2*M} functions), pencil (Q, S), S-cut {args.S_cut:g}, dps {args.dps}",
             f"k = {ks}; eps = {eps_list} (0 = control); L grid {grid[0]:.3f}..{grid[-1]:.3f} ({len(grid)} pts), bisect ratio {args.bisect_ratio}",
             f"Q = Z'_k + tail + 2w T_eps;  T_eps = 2(|A|^2 - |B|^2);  w = 1/2 primary, w = 1 secondary", "",
             "== L_c(eps, k) ==",
             f"{'k':>5} {'gamma_k':>10} {'log g_k':>8} {'nb gap':>8} {'mean gap':>9} {'eps':>6} {'w=1/2':>10} {'w=1':>10} {'X_c':>8} {'lam(1.5Lc)':>10} {'lam(2Lc)':>10} {'h_c g_k':>8} {'|A|^2':>9} {'|B|^2':>9} {'Z(G*)':>9} {'E_gap':>7} {'E<g1':>8}  through"]
    f = lambda v, fmt: (fmt % v) if v is not None else "none"
    for row in summary:
        lines.append(f"{row['k']:>5} {row['gamma_k']:>10.3f} {row['log_gamma_k']:>8.4f} {row['neighbour_gap']:>8.4f} {row['mean_gap']:>9.4f} {row['eps']:>6g} "
                     f"{f(row['L_c'], '%10.4f'):>10} {f(row['L_c_w1'], '%10.4f'):>10} {f(row['X_c'], '%8.3f'):>8} {f(row['lam_at_1.5Lc'], '%+10.2e'):>10} "
                     f"{f(row['lam_at_2Lc'], '%+10.2e'):>10} {f(row['hc_gamma'], '%8.1f'):>8} {f(row.get('A2'), '%9.2e'):>9} {f(row.get('B2'), '%9.2e'):>9} "
                     f"{f(row.get('Zprime_at_min'), '%9.2e'):>9} {f(row.get('E_within_local_gap_of_gamma_k'), '%7.4f'):>7} {f(row.get('E_below_gamma1'), '%8.1e'):>8}  {row.get('detection_through', '')}")
    lines.append("")
    lines.append("== rows without an L_c ==")
    for row in summary:
        if row["L_c"] is None:
            lines.append(f"  k={row['k']} eps={row['eps']:g}: {row['note']}")
    lines.append("")
    lines.append("== sanity: k = 1 vs Legendre ==")
    for s in sanity:
        lines.append(f"  eps={s['eps']:g} {s['weight']}: modulated {s['L_c_modulated']} bracket {s['bracket_modulated']}  Legendre M32 {s['L_c_legendre_M32']} bracket {s['bracket_legendre_M32']}  M64 {s['L_c_legendre_M64']}  modulated >= Legendre M32: {s['modulated_ge_legendre_M32']}")
        for q in s.get("at_legendre_M64_bracket_ends", []):
            lines.append(f"      at L={q['L']:.5f}: lam modulated {q['lam_modulated']:+.4e} (floor {q['floor_modulated']:.1e})  Legendre M64 {q['lam_legendre_M64']:+.4e}  modulated >= Legendre: {q['modulated_ge_legendre']}")
    lines.append("")
    lines.append("== fits (w=1/2), per eps: L_c = a + b x ==")
    for e, fe in fits.items():
        lines.append(f"  eps={e}: n={fe['n']} ks={fe['ks']} L_c={[round(v, 4) for v in fe['L_c']]}")
        for fname in forms:
            ft = fe[fname]
            if ft.get("a") is not None:
                lines.append(f"    vs {fname:<18s} a={ft['a']:+.4f} b={ft['b']:+.5f} rms={ft['rms_resid']:.4f} R2={ft['R2'] if ft['R2'] is not None else float('nan'):.4f} resid={' '.join(f'{r:+.3f}' for r in ft['residuals'])}")
            else:
                lines.append(f"    vs {fname:<18s} {ft.get('note')}")
    lines.append("")
    lines.append("== minimiser at L_c (w=1/2) ==")
    for key, m in shapes.items():
        lines.append(f"  {key}: ||G||={m['L2_norm_on_grid']:.4f} central-half {m['mass_central_half']:.3f} end-tenths {m['mass_end_tenths']:.3f} |G|max@u/h={m['abs_max_at_u_over_h']:+.3f} "
                     f"sign changes {m['sign_changes']} maxima of |G| {m['n_local_maxima_of_absG']} env central/outer {m['envelope_mean_central_half']}/{m['envelope_mean_outer_half']} "
                     f"kept {m['S_kept']}/{2*M} ||c||={m['coef_norm']:.2e}")
        lines.append(f"      |A|^2={m['A2']:.3e} |B|^2={m['B2']:.3e} Z'={m['Zprime_at_min']:.3e} tail={m['tail_at_min']:.2e} E(|t-g_k|<gap)={m['E_within_local_gap_of_gamma_k']:.4f} "
                     f"E(|t-g_k|<1)={m['E_within_1_of_gamma_k']:.4f} E(|t|<g_1)={m['E_below_gamma1']:.3e} -> {m['detection_through']}")
    lines.append("")
    lines.append("== ladders (lam_min per grid point; floor/kept) ==")
    for key, r in ladder.items():
        lines.append(f"  {key}: L_c={r['L_c']} bracket={r.get('L_c_bracket')} {r.get('note', '')}")
        lines.append("      lam: " + " ".join(f"{p['lam_min']:+.2e}" for p in r["grid"]))
        lines.append("      flo: " + " ".join(f"{p['floor']:.0e}/{p['S_kept']}" for p in r["grid"]))
    lines.append("")
    lines.append("== unit tests ==")
    for name, rows in tests.items():
        lines.append(f"  {name}:")
        for r in rows:
            rr = {kk: v for kk, v in r.items() if kk not in ("ghat", "entries")}
            if "ghat" in r:
                rr["max_abs_err_ghat"] = max(v["abs_err"] for v in r["ghat"].values())
            lines.append(f"    {rr}")
    lines.append("")
    lines.append(f"timings: {payload['timings']}")
    with open(args.txt, "w") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"wrote {args.txt}")


if __name__ == "__main__":
    main()
