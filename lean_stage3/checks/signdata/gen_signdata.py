"""Generator for the certified signs of Re Lambda(1/2 + it): `Stage3/SignDataLog.lean` and
`Stage3/SignDataPt*.lean`.  Block S14 of `lean_stage3/design/stencil.md`, Turing's sign data.

Every rational the Lean proofs need is computed here with exact `fractions`, and every
inequality that a generated `norm_num` must close is checked here first, with the same
formula as the Lean lemma it feeds (`SignDataBall`, `SignDataZeta`, `SignDataGamma`).
A failing check stops the generator; nothing is written for a point that does not close.

Usage:  python3 gen_signdata.py [--write]   (from lean_stage3/checks/signdata/)
Output: a table per point (centre of Re X, radius, margin) on stdout; with --write the
Lean files under lean_stage3/Stage3/.
"""
from fractions import Fraction as F
import math, sys, os
import mpmath as mp

mp.mp.dps = 50
D = 30          # digits of centres and radii
DY = 20         # digits of the reduced angle y0
KEXP = 10       # Taylor order 2K of exp
PI0 = F("3.14159265358979323846")
PIEPS = F(1, 10**20)
LOG2C = F("0.69314718055")      # |log 2 - LOG2C| <= LOG2E from Real.log_two_gt_d9 / lt_d9
LOG2E = F("0.00000000025")
HERE = os.path.dirname(os.path.abspath(__file__))
STAGE3 = os.path.normpath(os.path.join(HERE, "..", "..", "Stage3"))


def rnd(x, d=D):
    q = 10**d
    return F(round(x * q), q)


def up(x, d=D):
    q = 10**d
    v = F(math.ceil(x * q), q)
    assert v >= x
    return v


def lit(x):
    """A Lean real literal: a decimal when the denominator divides a power of 10, else p/q."""
    x = F(x)
    neg = x < 0
    x = abs(x)
    den = x.denominator
    k = 0
    while (10**k) % den != 0 and k <= 120:
        k += 1
    if (10**k) % den == 0:
        n = x.numerator * (10**k // den)
        s = str(n)
        if k > 0:
            s = s.rjust(k + 1, "0")
            s = s[:-k] + "." + s[-k:]
        out = s
    else:
        out = f"{x.numerator}/{x.denominator}"
    return f"(-{out})" if neg else f"({out})"


def tlit(t):
    t = F(t)
    if t.denominator == 1:
        return f"({t.numerator} : ℝ)"
    return f"({t.numerator}/{t.denominator} : ℝ)"


def check(cond, what):
    if not cond:
        raise SystemExit("CHECK FAILED: " + what)


# ---------------------------------------------------------------- balls (mirrors of Lean)

def b_add(z, w):
    a, b, r = z
    c, d, q = w
    e, f = rnd(a + c), rnd(b + d)
    R = up(abs(a + c - e) + abs(b + d - f) + r + q)
    return (e, f, R)


def b_mul(z, w):
    a, b, r = z
    c, d, q = w
    e, f = rnd(a * c - b * d), rnd(a * d + b * c)
    R = up((abs(a) + abs(b)) * q + (abs(c) + abs(d)) * r + r * q
           + abs(a * c - b * d - e) + abs(a * d + b * c - f))
    return (e, f, R)


def cosP(K, y):
    return sum(F((-1)**i) * y**(2 * i) / math.factorial(2 * i) for i in range(K))


def sinP(K, y):
    return sum(F((-1)**i) * y**(2 * i + 1) / math.factorial(2 * i + 1) for i in range(K))


def exp_ball(x0, eps):
    """Ball for e^{ix}, |x - x0| <= eps.  Returns (j, k, y0, eps', e, f, R, centre)."""
    m = round(x0 / (PI0 / 2))
    j = m % 4
    k = (m - j) // 4
    c = F(j, 2) + 2 * k
    y0 = rnd(x0 - c * PI0, DY)
    check(abs(y0) <= 1, "|y0| <= 1")
    epsp = up(abs(x0 - c * PI0 - y0) + abs(c) * PIEPS + eps)
    K = KEXP
    tay = abs(y0)**(2 * K) * F(2 * K + 1, math.factorial(2 * K) * 2 * K)
    cp, sp = cosP(K, y0), sinP(K, y0)
    e, f = rnd(cp), rnd(sp)
    R = up(epsp + tay + abs(cp - e) + abs(sp - f))
    rot = {0: (e, f), 1: (-f, e), 2: (-e, -f), 3: (f, -e)}[j]
    return dict(j=j, k=k, y0=y0, epsp=epsp, e=e, f=f, R=R, ball=(rot[0], rot[1], R))


def log_series(q, K):
    x = F(1, q)
    return sum(x**(i + 1) / (i + 1) for i in range(K))


def log_chain(M):
    """Balls |log m - c| <= e for m = 2..M, from Mathlib's log 2 and log_succ_ball."""
    balls = {2: (LOG2C, LOG2E, None)}
    for q in range(3, M + 1):
        a, e, _ = balls[q - 1]
        K = 1
        while F(1, q)**(K + 1) / (1 - F(1, q)) > F(1, 10**14):
            K += 1
        S = log_series(q, K)
        c = rnd(a + S)
        R = up(e + abs(a + S - c) + F(1, q)**(K + 1) / (1 - F(1, q)))
        balls[q] = (c, R, K)
    return balls


def log_pi(log3):
    a, e, _ = log3
    x0 = 1 - PI0 / 3
    K = 10
    S = sum(x0**(i + 1) / (i + 1) for i in range(K))
    c = rnd(a - S)
    R = up(e + abs(a - S - c) + abs(x0)**(K + 1) / (1 - abs(x0)) + PIEPS)
    return (c, R, K)


def isqrt_ball(m):
    lo = F(math.isqrt(10**(2 * D) // m), 10**D)     # floor(10^D / sqrt m)/10^D
    while (lo + F(1, 10**D))**2 * m <= 1:
        lo += F(1, 10**D)
    while lo**2 * m > 1:
        lo -= F(1, 10**D)
    hi = lo + F(1, 10**D)
    check(lo > 0 and lo**2 * m <= 1 <= hi**2 * m, f"isqrt {m}")
    c = rnd((lo + hi) / 2)
    R = up(max(hi - c, c - lo))
    return (lo, hi, c, R)


def Bre(t, N):
    t, N = F(t), F(N)
    return (-3840 * N**4 - 960 * N**3 * (4 * t**2 + 1) + 80 * N**2 * (4 * t**2 + 1)
            + (4 * t**2 + 1) * (12 * t**2 - 5)) / (1920 * N**3 * (4 * t**2 + 1))


def Bim(t, N):
    t, N = F(t), F(N)
    return t * (-11520 * N**4 + N**2 * (960 * t**2 + 240) + (4 * t**2 - 23) * (4 * t**2 + 1)) \
        / (2880 * N**3 * (4 * t**2 + 1))


def sqrt_up(x, d=12):
    q = F(math.isqrt(math.ceil(x * 10**(2 * d))) + 1, 10**d)
    check(q**2 >= x, "sqrt_up")
    return q


def sqrt_lo(x, d=12):
    q = F(math.isqrt(math.floor(x * 10**(2 * d))), 10**d)
    check(q**2 <= x and q > 0, "sqrt_lo")
    return q


# ---------------------------------------------------------------- one point

def gamma_n(t):
    t = abs(F(t))
    need = (2 * (F(1, 4) + t / 2) + (F(1, 4) + t / 2)**2) / F(3, 2)
    n = 1
    while n < need or n < F(1, 2) + t:
        n *= 2
    return n


def point(t, N, logs, lpi, isq):
    """All balls of one point, in order; returns (steps, Xball, info)."""
    t = F(t)
    steps = []
    # terms m^{-s}, m = 2..N
    terms = {1: (F(1), F(0), F(0))}
    for m in range(2, N + 1):
        c, e, _ = logs[m]
        x0 = -(t * c)
        eps = abs(t) * e
        eb = exp_ball(x0, eps)
        lo, hi, sc, sR = isq[m]
        tb = b_mul((sc, F(0), sR), eb["ball"])
        steps.append(("exp", m, eb))
        steps.append(("term", m, tb))
        terms[m] = tb
    # partial sums
    S = terms[1]
    sums = {1: S}
    for m in range(2, N + 1):
        S = b_add(S, terms[m])
        sums[m] = S
        steps.append(("sum", m, S))
    # N^{-s} * emB
    Bb = (Bre(t, N), Bim(t, N), F(0))
    NB = b_mul(terms[N], Bb)
    steps.append(("NB", N, NB))
    Y = b_add(sums[N], NB)
    steps.append(("Y", N, Y))
    # remainder
    qs = [sqrt_up((F(1, 2) + i)**2 + t**2) for i in range(4)]
    lo = sqrt_lo(F(N))
    Q = up(qs[0] * qs[1] * qs[2] * qs[3] / 24 * (F(1, 30) * (1 / (F(N)**3 * lo) / F(7, 2))))
    R = up(Y[2] + Q)
    Z = (Y[0], Y[1], R)
    steps.append(("zeta", N, dict(qs=qs, lo=lo, Q=Q, ball=Z)))
    # gamma product
    n = gamma_n(t)
    P = (F(1), F(0), F(0))
    for j in range(n):
        fac = (1 + F(1, 4 * (j + 1)), t / (2 * (j + 1)), F(0))
        P = b_mul(P, fac)
        steps.append(("prod", j + 1, P))
    W = b_mul((F(1, 4), t / 2, F(0)), P)
    steps.append(("W", n, W))
    Wc = (W[0], -W[1], W[2])
    # phase: (t/2)(log n - log pi)
    cn, en = n_log(n)
    x0 = (t / 2) * (cn - lpi[0])
    eps = abs(t / 2) * (en + lpi[1])
    eb = exp_ball(x0, eps)
    steps.append(("phase", n, eb))
    G = b_mul(eb["ball"], Wc)
    steps.append(("G", n, G))
    X = b_mul(G, Z)
    steps.append(("X", n, X))
    return steps, X, dict(n=n, N=N, Q=Q, Z=Z, W=W)


def n_log(n):
    k = n.bit_length() - 1
    check(2**k == n, "n a power of two")
    return (k * LOG2C, k * LOG2E)


def truth(t):
    s = mp.mpc(0.5, t)
    lam = mp.gamma(s / 2) * mp.pi**(-s / 2) * mp.zeta(s)
    return lam, mp.siegelz(t)


# ---------------------------------------------------------------- Lean emission

def name(t):
    t = F(t)
    if t.denominator == 1:
        return f"{t.numerator}"
    return f"{t.numerator}_{t.denominator}"


NUM = "norm_num"
TAY = ("simp only [cosP, sinP, Finset.sum_range_succ, Finset.sum_range_zero]; "
       "norm_num [Nat.factorial]")


def cxl(a, b):
    return f"cx {lit(a)} {lit(b)}"


def cxrot(eb):
    """The centre of an exp ball in the syntactic shape of `exp_ball0`..`3`."""
    e, f = lit(eb["e"]), lit(eb["f"])
    return {0: f"cx {e} {f}", 1: f"cx (-{f}) {e}", 2: f"cx (-{e}) (-{f})",
            3: f"cx {f} (-{e})"}[eb["j"]]


def emit_log_file(M, logs, lpi, isq, ns):
    L = []
    L.append("""/-
SignDataLog — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data: the shared real
balls. 2026-11-25. Generated by `lean_stage3/checks/signdata/gen_signdata.py`; do not edit by hand.

`log m` for `m ≤ %d` from Mathlib's `log 2` (`Real.log_two_gt_d9`, `Real.log_two_lt_d9`) and
`log_succ_ball`; `log π` from `log 3` (`log_pi_ball`); `log 2ᵏ` (`log_pow_ball`); `(√m)⁻¹`
(`inv_sqrt_ball`). Every rational was computed in Python with exact fractions first.

| name | content | status |
|---|---|---|
| `log_ball_m` | `|log m − c_m| ≤ e_m` | proved |
| `log_pi_ball'` | `|log π − c| ≤ e` | proved |
| `log_pow2_ball_n` | `|log n − c| ≤ e`, `n = 2ᵏ` | proved |
| `isqrt_ball_m` | `|(√m)⁻¹ − c| ≤ e` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SignDataBall

namespace SignData

noncomputable section
""" % M)
    c2, e2, _ = logs[2]
    L.append(f"""theorem log_ball_2 : |Real.log ((2 : ℕ) : ℝ) - {lit(c2)}| ≤ {lit(e2)} := by
  have h1 := Real.log_two_gt_d9
  have h2 := Real.log_two_lt_d9
  rw [Nat.cast_ofNat, abs_le]; constructor <;> linarith
""")
    for q in range(3, M + 1):
        c, R, K = logs[q]
        a, e, _ = logs[q - 1]
        L.append(f"""theorem log_ball_{q} : |Real.log ((({q} : ℕ)) : ℝ) - {lit(c)}| ≤ {lit(R)} :=
  log_succ_ball (p := (({q-1} : ℕ) : ℝ)) (by norm_num) (by norm_num) log_ball_{q-1} {K}
    (by simp only [Finset.sum_range_succ, Finset.sum_range_zero]; norm_num)
""")
    c, R, K = lpi
    L.append(f"""theorem log_pi_ball' : |Real.log Real.pi - {lit(c)}| ≤ {lit(R)} :=
  log_pi_ball (a := {lit(logs[3][0])}) (e := {lit(logs[3][1])})
    (by have h := log_ball_3; rw [Nat.cast_ofNat] at h; exact h) {K}
    (by simp only [Finset.sum_range_succ, Finset.sum_range_zero]; norm_num)
""")
    for n in ns:
        k = n.bit_length() - 1
        cn, en = n_log(n)
        L.append(f"""theorem log_pow2_ball_{n} : |Real.log ((({n} : ℕ)) : ℝ) - {lit(cn)}| ≤ {lit(en)} := by
  have h := log_pow_ball log_ball_2 {k}
  have e : ((({n} : ℕ)) : ℝ) = (((2 : ℕ) : ℝ)) ^ {k} := by norm_num
  have e1 : ((({k} : ℕ)) : ℝ) * {lit(c2)} = {lit(cn)} := by norm_num
  have e2 : ((({k} : ℕ)) : ℝ) * {lit(e2)} = {lit(en)} := by norm_num
  rw [e, ← e1, ← e2]
  exact h
""")
    for m in sorted(isq):
        lo, hi, c, R = isq[m]
        L.append(f"""theorem isqrt_ball_{m} : |(Real.sqrt ((({m} : ℕ)) : ℝ))⁻¹ - {lit(c)}| ≤ {lit(R)} :=
  inv_sqrt_ball (lo := {lit(lo)}) (hi := {lit(hi)}) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num)
""")
    L.append("""end

/-- info: 'SignData.log_pi_ball'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_pi_ball'

end SignData
""")
    return "\n".join(L)


def emit_point(t, steps, X, info, positive):
    nm = name(t)
    T = tlit(t)
    N, n = info["N"], info["n"]
    L = []
    for kind, m, data in steps:
        if kind == "exp":
            eb = data
            L.append(f"""theorem p{nm}_E{m} : ‖cexp ((((-({T} * Real.log ((({m} : ℕ)) : ℝ))) : ℝ) : ℂ) * Complex.I)
    - {cxrot(eb)}‖ ≤ {lit(eb['R'])} :=
  exp_ball{eb['j']} (neg_mul_ball log_ball_{m} {T}) ({eb['k']} : ℤ) (y₀ := {lit(eb['y0'])})
    (ε' := {lit(eb['epsp'])}) (e := {lit(eb['e'])}) (f := {lit(eb['f'])}) (by norm_num)
    (by norm_num) {KEXP} (by norm_num) (by {TAY})
""")
        elif kind == "term":
            e, f, R = data
            L.append(f"""theorem p{nm}_T{m} : ‖((({m} : ℕ)) : ℂ) ^ (-lineS {T}) - {cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [natCast_cpow_line (by norm_num) {T}]
  exact ball_mul (ball_ofReal isqrt_ball_{m}) p{nm}_E{m} (by norm_num)
""")
        elif kind == "sum":
            e, f, R = data
            prev = f"p{nm}_S{m-1}" if m > 2 else f"(sum_one_ball {T})"
            L.append(f"""theorem p{nm}_S{m} :
    ‖∑ m ∈ Finset.Icc 1 ({m-1} + 1), ((m : ℕ) : ℂ) ^ (-lineS {T}) - {cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [Finset.sum_Icc_succ_top (by norm_num)]
  exact ball_add {prev} p{nm}_T{m} (by norm_num)
""")
        elif kind == "NB":
            e, f, R = data
            L.append(f"""theorem p{nm}_NB : ‖((({N} : ℕ)) : ℂ) ^ (-lineS {T}) * emB {T} {N} - {cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_mul p{nm}_T{N} (emB_ball {T} (by norm_num)) (by norm_num [Bre, Bim])
""")
        elif kind == "Y":
            e, f, R = data
            L.append(f"""theorem p{nm}_Y : ‖(∑ m ∈ Finset.Icc 1 ({N-1} + 1), ((m : ℕ) : ℂ) ^ (-lineS {T})
    + ((({N-1} + 1 : ℕ)) : ℂ) ^ (-lineS {T}) * emB {T} ({N-1} + 1)) - {cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_add p{nm}_S{N} p{nm}_NB (by norm_num)
""")
        elif kind == "zeta":
            z = data
            q0, q1, q2, q3 = z["qs"]
            e, f, R = z["ball"]
            L.append(f"""theorem p{nm}_zeta : ‖riemannZeta (lineS {T}) - {cxl(e, f)}‖ ≤ {lit(R)} :=
  zeta_ball (N := {N-1} + 1) {T} (by norm_num) p{nm}_Y
    (rem_le {T} (by norm_num) (q0 := {lit(q0)}) (q1 := {lit(q1)}) (q2 := {lit(q2)}) (q3 := {lit(q3)})
      (lo := {lit(z['lo'])}) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (le_refl _))
    (by norm_num)
""")
        elif kind == "prod":
            e, f, R = data
            j = m - 1
            prev = f"p{nm}_P{j}" if j > 0 else f"(prod_zero_ball {T})"
            L.append(f"""theorem p{nm}_P{m} : ‖∏ j ∈ Finset.range ({j} + 1), (1 + zz {T} / ((j : ℂ) + 1)) - {cxl(e, f)}‖
    ≤ {lit(R)} := by
  rw [Finset.prod_range_succ]
  exact ball_mul {prev} (factor_ball {T} {j}) (by norm_num)
""")
        elif kind == "W":
            e, f, R = data
            L.append(f"""theorem p{nm}_W : ‖zz {T} * ∏ j ∈ Finset.range ({n-1} + 1), (1 + zz {T} / ((j : ℂ) + 1))
    - {cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_mul (zz_ball {T}) p{nm}_P{n} (by norm_num)
""")
        elif kind == "phase":
            eb = data
            L.append(f"""theorem p{nm}_phase : ‖cexp (((({T} / 2) * (Real.log ((({n} : ℕ)) : ℝ) - Real.log Real.pi) : ℝ) : ℂ)
    * Complex.I) - {cxrot(eb)}‖ ≤ {lit(eb['R'])} :=
  exp_ball{eb['j']} (phase_ball log_pow2_ball_{n} log_pi_ball' {T}) ({eb['k']} : ℤ)
    (y₀ := {lit(eb['y0'])}) (ε' := {lit(eb['epsp'])}) (e := {lit(eb['e'])}) (f := {lit(eb['f'])})
    (by norm_num) (by norm_num) {KEXP} (by norm_num) (by {TAY})
""")
        elif kind == "G":
            e, f, R = data
            L.append(f"""theorem p{nm}_G : ‖gammaDir {T} {n} - {cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_mul p{nm}_phase (ball_conj p{nm}_W) (by norm_num)
""")
        elif kind == "X":
            e, f, R = data
            L.append(f"""theorem p{nm}_X : ‖gammaDir {T} {n} * riemannZeta (lineS {T}) - {cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_mul p{nm}_G p{nm}_zeta (by norm_num)
""")
    if positive:
        L.append(f"""/-- **The sign at `t = {float(t)}`**: `Re Λ(1/2 + it) > 0`. -/
theorem sign_{nm} : 0 < (completedRiemannZeta (lineS {T})).re :=
  re_lambda_pos {T} (n := {n}) (by norm_num) (by norm_num) (by norm_num) p{nm}_X (by norm_num)
""")
    else:
        L.append(f"""/-- **The sign at `t = {float(t)}`**: `Re Λ(1/2 + it) < 0`. -/
theorem sign_{nm} : (completedRiemannZeta (lineS {T})).re < 0 :=
  re_lambda_neg {T} (n := {n}) (by norm_num) (by norm_num) (by norm_num) p{nm}_X (by norm_num)
""")
    a, b, r = X
    head = f"""/-
SignDataPt{nm} — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data: the sign of
`Re Λ(1/2 + it)` at `t = {float(t)}`. 2026-11-25. Generated by
`lean_stage3/checks/signdata/gen_signdata.py`; do not edit by hand.

Euler–Maclaurin of order 4 with `N = {N}` (`SignDataZeta.zeta_em4`), the Gamma phase with
`n = {n}` factors (`SignDataGamma.re_lambda_eq`), `e^{{ix}}` by Taylor of degree {2*KEXP} after reduction
by `π/2` (`SignDataBall.exp_ball0`–`3`). The ball for `X = gammaDir t n · ζ(1/2 + it)` has centre
`Re X = {float(a):.6e}` and radius `{float(r):.3e}`, so `Re X {'>' if positive else '<'} 0` and
`Re Λ {'>' if positive else '<'} 0`.

| name | content | status |
|---|---|---|
| `p{nm}_E*`, `p{nm}_T*`, `p{nm}_S*` | `e^{{−it log m}}`, `m^{{−s}}`, the partial sums | proved |
| `p{nm}_zeta` | `ζ(1/2 + it)` in a ball of radius `{float(info['Z'][2]):.3e}` | proved |
| `p{nm}_P*`, `p{nm}_W`, `p{nm}_phase`, `p{nm}_G` | the Gamma direction | proved |
| `p{nm}_X` | `gammaDir t n · ζ` in a ball | proved |
| `sign_{nm}` | `Re Λ(1/2 + it) {'>' if positive else '<'} 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SignDataLog
import Stage3.SignDataGamma

namespace SignData

open Complex

noncomputable section
"""
    tail = f"""
end

/-- info: 'SignData.sign_{nm}' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sign_{nm}

end SignData
"""
    return head + "\n" + "\n".join(L) + tail


# ---------------------------------------------------------------- main

def plan(t):
    """Smallest N with the zeta radius below a quarter of |Re X| / |W|."""
    lam, Z = truth(float(t))
    for N in range(4, 200):
        qs = [sqrt_up((F(1, 2) + i)**2 + F(t)**2) for i in range(4)]
        lo = sqrt_lo(F(N))
        Q = qs[0] * qs[1] * qs[2] * qs[3] / 24 * (F(1, 30) * (1 / (F(N)**3 * lo) / F(7, 2)))
        if Q < abs(F(float(Z))) / 8:
            return N
    raise SystemExit("no N")


POINTS = [F(14), F(29, 2), F(18), F(23), F(55, 2), F(63, 2), F(71, 2), F(39), F(42), F(91, 2), F(49)]

if __name__ == "__main__":
    write = "--write" in sys.argv
    pts = POINTS
    plans = {t: plan(t) for t in pts}
    M = max(plans.values())
    M = max(M, 3)
    logs = log_chain(M)
    lpi = log_pi(logs[3])
    isq = {m: isqrt_ball(m) for m in range(2, M + 1)}
    ns = sorted({gamma_n(t) for t in pts})
    print(f"log chain to {M}; log pi = {float(lpi[0])} +- {float(lpi[1]):.2e}; gamma n in {ns}")
    out = []
    for t in pts:
        N = plans[t]
        steps, X, info = point(t, N, logs, lpi, isq)
        lam, Z = truth(float(t))
        a, b, r = X
        positive = a > r
        negative = a < -r
        check(positive or negative, f"sign at t = {t} not certified: Re X = {float(a)}, r = {float(r)}")
        check((positive and Z > 0) or (negative and Z < 0), "sign disagrees with mpmath")
        print(f"t = {float(t):8.3f}  N = {N:3d}  n = {info['n']:4d}  Z(t) = {float(Z): .6f}  "
              f"Re X = {float(a): .6e}  r = {float(r):.3e}  margin |Re X|/r = {float(abs(a)/r):8.2f}  "
              f"zeta radius {float(info['Z'][2]):.2e}  steps {len(steps)}")
        out.append((t, steps, X, info, positive))
    if write:
        with open(os.path.join(STAGE3, "SignDataLog.lean"), "w") as fh:
            fh.write(emit_log_file(M, logs, lpi, isq, ns))
        for t, steps, X, info, positive in out:
            with open(os.path.join(STAGE3, f"SignDataPt{name(t)}.lean"), "w") as fh:
                fh.write(emit_point(t, steps, X, info, positive))
        print("written:", ["SignDataLog.lean"] + [f"SignDataPt{name(t)}.lean" for t, *_ in out])
