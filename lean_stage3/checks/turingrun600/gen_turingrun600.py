"""Generator for Turing's point run to height ~600: `Stage3/TuringRun600Log.lean`,
`Stage3/TuringRun600Pts*.lean` and `Stage3/TuringRun600.lean`.  Copied from
`checks/turingrun/gen_turingrun.py` (block S14 of `lean_stage3/design/stencil.md`) and extended:

* the old run's certificates are reused: `TuringRun.sign_b10 .. sign_b227` (gaps 10..227) and
  `TuringRun.sign_a0 .. sign_a53` (gaps 228..281, each lies strictly inside one gap of zeros), read
  from `../turingrun/plan.json`; new points (namespace `TuringRun600`) are `sign_c<i>` for gaps
  282..n-1 and T1, and `sign_d<j>` above T1;
* the log chain continues from `TuringRun.log_ball_517`, the inverse square roots from 122;
* `--scan n1 n2` prints the planned closing margin for each n; `--n n` picks n; `--plan` writes
  the build-cost estimate to `plan.out` without certifying.

Original docstring follows.

Copied and extended from `checks/stirlingseries/gen_stirlingseries.py` (which reuses
`checks/signdata/gen_signdata.py` for the balls).  What changed:

* the zeta side is Euler-Maclaurin of order K = 20 (`TuringRunEM.zeta_emK`, `rem_leK`) instead of
  order 4 (`SignDataZeta.zeta_em4`): at t = 500 the order-4 remainder needs N ~ 440 terms for
  0.03, order 20 needs N ~ 104.  The boundary sum is a chain of balls for P_j = prod_{i<j}(s+i)
  (`prodS_succ`) and the terms P_j B_{j+1}/(j+1)! N^{-j} (`ball_rmul`, `emW_succ`);
* log(t/2) at rational t comes from log n, n = round(t/2), and the series of log(1-u)
  (`TuringRunEM.log_near_ball`), so t need not factor over small primes;
* the points are chosen from the zeros of Z (mpmath `zetazero`, cached in `zeros.txt` by
  `zeros.py`): one point where |Z| is largest in each gap below T1, T1 itself just right of the
  zero gamma_n, s_0 at the largest |Z| in (T1, gamma_{n+1}), and s_j just right of gamma_{n+j};
* the closing inequality `hnum'` of `TuringSlope.StmtClosingData'` is checked here with exact
  rationals (pi, log bounds, the enclosure of theta(T1) by `TuringRunTheta.phaseTheta_ball` and
  `StirlingSeriesK5.gamma_phase_ball5`) before anything is written.

The first ten points (t = 14, 18, 23, 55/2, 63/2, 71/2, 39, 42, 91/2, 49) are the existing
`SignDataPt*` certificates.  Every rational is exact (`fractions`), and every inequality a
generated `norm_num` closes is checked here first with the formula of the Lean lemma it feeds.

Usage (from lean_stage3/checks/turingrun600/):
    python3 gen_turingrun600.py --scan 338 352   margins per n
    python3 gen_turingrun600.py --n N --plan     cost estimate to plan.out
    python3 gen_turingrun600.py --n N            plan and check, print the table
    python3 gen_turingrun600.py --n N --write    also write the Lean files
"""
from fractions import Fraction as F
import math, os, re, sys, json

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.normpath(os.path.join(HERE, "..", "signdata")))
import gen_signdata as g          # noqa: E402
import mpmath as mp               # noqa: E402
import zeros as Zs                # noqa: E402

mp.mp.dps = 30
STAGE3 = g.STAGE3
lit, up, rnd, check, tlit = g.lit, g.up, g.rnd, g.check, g.tlit
PI0, PIEPS = g.PI0, g.PIEPS
KEM = 20                      # Euler-Maclaurin order
GROUP_BUDGET = 700            # sum of N per point module
THR_EDGE = F(1, 100)          # |Z| at the points just right of a zero
LOG_K_MIN = 2

# Bernoulli numbers
BERN = [F(1)]
for _n in range(1, KEM + 2):
    BERN.append(1 - sum(F(math.comb(_n, k), _n - k + 1) * BERN[k] for k in range(_n)))


def bernC(j):
    """B_{j+1}/(j+1)!  (bernoulli = bernoulli' for n != 1)."""
    return BERN[j + 1] / math.factorial(j + 1)


OLD = [F(14), F(18), F(23), F(55, 2), F(63, 2), F(71, 2), F(39), F(42), F(91, 2), F(49)]
OLD_NAME = {t: "sign_" + g.name(t) for t in OLD}

# the old run (`TuringRun`, checks/turingrun/plan.json): reused certificates
_OLDPLAN = json.load(open(os.path.join(HERE, "..", "turingrun", "plan.json")))
REUSE = ([F(x) for x in _OLDPLAN["below"][10:228]] + [F(x) for x in _OLDPLAN["above"]])
REUSE_NAME = {}
for _i, _x in enumerate(_OLDPLAN["below"][10:228], start=10):
    REUSE_NAME[F(_x)] = f"TuringRun.sign_b{_i}"
for _j, _x in enumerate(_OLDPLAN["above"]):
    REUSE_NAME[F(_x)] = f"TuringRun.sign_a{_j}"
GAP_NEW = 10 + len(REUSE)       # first gap with a new point (282)
OLD_LOG_M = 517                 # TuringRun.log_ball_517 is the last of the old chain
OLD_ISQ_M = 121                 # TuringRun.isqrt_ball_121


def Z(t, dps=30):
    with mp.workdps(dps):
        return mp.siegelz(mp.mpf(t.numerator) / t.denominator if isinstance(t, F) else t)


# ---------------------------------------------------------------- the zeta side, order K

def plan_N(t, target):
    q = g.sqrt_up((F(1, 2) + KEM - 1)**2 + t**2)
    for N in range(4, 400):
        lo = g.sqrt_lo(F(N))
        Q = 4 * q**KEM / (6**KEM * (F(N)**(KEM - 1) * lo) * (KEM - F(1, 2)))
        if Q < target:
            return N
    raise SystemExit("no N")


def zeta_balls(t, N, logs, isq):
    t = F(t)
    steps = []
    terms = {1: (F(1), F(0), F(0))}
    for m in range(2, N + 1):
        c, e, _ = logs[m]
        eb = g.exp_ball(-(t * c), abs(t) * e)
        lo_, hi_, sc, sR = isq[m]
        tb = g.b_mul((sc, F(0), sR), eb["ball"])
        steps.append(("exp", m, eb))
        steps.append(("term", m, tb))
        terms[m] = tb
    S = terms[1]
    sums = {1: S}
    for m in range(2, N + 1):
        S = g.b_add(S, terms[m])
        sums[m] = S
        steps.append(("sum", m, S))
    # P_j, j = 1..K-1
    P = (F(1), F(0), F(0))
    Ps = {0: P}
    for j in range(1, KEM):
        P = g.b_mul(P, (F(1, 2) + (j - 1), t, F(0)))
        Ps[j] = P
        steps.append(("P", j, P))
    W = (F(0), F(0), F(0))
    for j in range(1, KEM):
        c = bernC(j) / F(N)**j
        a, b, r = Ps[j]
        e, f = rnd(a * c), rnd(b * c)
        R = up(abs(a * c - e) + abs(b * c - f) + abs(c) * r)
        W = g.b_add(W, (e, f, R))
        steps.append(("W", j + 1, dict(c=c, term=(e, f, R), W=W)))
    den = F(1, 4) + t**2
    A = (-(F(N) / 2) / den - F(1, 2), -(F(N) * t) / den, F(0))
    steps.append(("A", N, A))
    B = g.b_add(A, W)
    steps.append(("B", N, B))
    NB = g.b_mul(terms[N], B)
    steps.append(("NB", N, NB))
    Y = g.b_add(sums[N], NB)
    steps.append(("Y", N, Y))
    q = g.sqrt_up((F(1, 2) + KEM - 1)**2 + t**2)
    lo = g.sqrt_lo(F(N))
    Q = up(4 * q**KEM / (6**KEM * (F(N)**(KEM - 1) * lo) * (KEM - F(1, 2))))
    Rz = up(Y[2] + Q)
    Zb = (Y[0], Y[1], Rz)
    steps.append(("zeta", N, dict(q=q, lo=lo, Q=Q, ball=Zb)))
    return steps, Zb


# ---------------------------------------------------------------- the Gamma side

def logt_ball(t, logs):
    """log(t/2) from log n, n = round(t/2), u = 1 - (t/2)/n."""
    y = t / 2
    n = max(2, round(y))
    u = 1 - y / n
    au = abs(u)
    check(au < 1, "|u| < 1")
    K = LOG_K_MIN
    while au**(K + 1) / (1 - au) > F(1, 10**26):
        K += 1
    a, e, _ = logs[n]
    S = sum(u**(i + 1) / (i + 1) for i in range(K))
    c = rnd(a - S)
    R = up(e + abs(a - S - c) + au**(K + 1) / (1 - au))
    true = mp.log(mp.mpf(y.numerator) / y.denominator)
    check(abs(true - mp.mpf(c.numerator) / c.denominator) <= float(R) + 1e-25, "log(t/2) vs mpmath")
    return dict(n=n, u=u, K=K, l=c, el=R)


def sig3(t):
    rho = F(1, 4)**2 + (t / 2)**2
    p = F(1, 4) / rho
    q = -(t / 2) / rho
    return F(1, 12) * q - F(1, 360) * (3 * p**2 * q - q**3)


def sig5(t):
    rho = F(1, 4)**2 + (t / 2)**2
    p = F(1, 4) / rho
    q = -(t / 2) / rho
    return (F(1, 12) * q - F(1, 360) * (3 * p**2 * q - q**3)
            + F(1, 1260) * (5 * p**4 * q - 10 * p**2 * q**3 + q**5)
            - F(1, 1680) * (7 * p**6 * q - 35 * p**4 * q**3 + 21 * p**2 * q**5 - q**7))


def phase_ball(t, lt, lpi):
    l, el = lt["l"], lt["el"]
    c, epi = lpi[0], lpi[1]
    y = 1 / (2 * t)
    check(y < 1, "y < 1")
    tau = y**6 / (1 - y) / 6
    expr = (t / 2) * (l + y**2 / 2 - y**4 / 4) - (PI0 / 2 + (-y + y**3 / 3 - y**5 / 5)) / 4 \
        - t / 2 + sig3(t) - t / 2 * c
    phi0 = rnd(expr)
    E = up(abs(expr - phi0) + (t / 2) * (el + tau + epi) + (PIEPS / 2 + tau) / 4)
    z = mp.mpc(0.25, float(t) / 2)
    true = mp.im(mp.loggamma(z)) - float(t) / 2 * mp.log(mp.pi)
    check(abs(true - float(phi0)) <= float(E) + 0.4 / float(t)**3 + 1e-12, "phase vs mpmath")
    return dict(phi0=phi0, E=E)


def gamma_phase5(t, lt):
    """`StirlingSeriesK5.gamma_phase_ball5`: Im logG(1/4 + it/2) in a ball."""
    l, el = lt["l"], lt["el"]
    y = 1 / (2 * t)
    tau = y**6 / (1 - y) / 6
    expr = (t / 2) * (l + y**2 / 2 - y**4 / 4) - (PI0 / 2 + (-y + y**3 / 3 - y**5 / 5)) / 4 \
        - t / 2 + sig5(t)
    phi0 = rnd(expr)
    E = up(abs(expr - phi0) + (t / 2) * (el + tau) + (PIEPS / 2 + tau) / 4)
    Efin = up(E + F(10) / t**7)
    true = mp.im(mp.loggamma(mp.mpc(0.25, float(t) / 2)))
    check(abs(true - mp.mpf(phi0.numerator) / phi0.denominator) <= float(Efin) + 1e-20,
          "gamma phase vs mpmath")
    return phi0, E, Efin


# ---------------------------------------------------------------- one point

def certify(t, logs, lpi, isq, Nmin=None):
    """Smallest N (from the plan up) whose ball certifies the sign; returns the point record."""
    t = F(t)
    zt = Z(t)
    lt = logt_ball(t, logs)
    ph = phase_ball(t, lt, lpi)
    eb = g.exp_ball(ph["phi0"], ph["E"])
    N = plan_N(t, abs(F(float(zt))) / 4) if Nmin is None else Nmin
    while True:
        steps, Zb = zeta_balls(t, N, logs, isq)
        X = g.b_mul(eb["ball"], Zb)
        a, b, r = X
        if a > r or a < -r:
            break
        N += 2
    positive = a > r
    check((positive and zt > 0) or ((not positive) and zt < 0), f"sign at {t} disagrees with mpmath")
    return dict(t=t, N=N, steps=steps, Zb=Zb, X=X, lt=lt, ph=ph, eb=eb, positive=positive,
                Z=float(zt), margin=float(abs(a) / r))


# ---------------------------------------------------------------- Lean emission

def emit_point(p, nm):
    t, N = p["t"], p["N"]
    T = tlit(t)
    L = []
    for kind, m, data in p["steps"]:
        if kind == "exp":
            eb = data
            L.append(f"""theorem {nm}_E{m} : ‖cexp ((((-({T} * Real.log ((({m} : ℕ)) : ℝ))) : ℝ) : ℂ) * Complex.I)
    - {g.cxrot(eb)}‖ ≤ {lit(eb['R'])} :=
  exp_ball{eb['j']} (neg_mul_ball log_ball_{m} {T}) ({eb['k']} : ℤ) (y₀ := {lit(eb['y0'])})
    (ε' := {lit(eb['epsp'])}) (e := {lit(eb['e'])}) (f := {lit(eb['f'])}) (by norm_num)
    (by norm_num) {g.KEXP} (by norm_num) (by {g.TAY})
""")
        elif kind == "term":
            e, f, R = data
            L.append(f"""theorem {nm}_T{m} : ‖((({m} : ℕ)) : ℂ) ^ (-lineS {T}) - {g.cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [natCast_cpow_line (by norm_num) {T}]
  exact ball_mul (ball_ofReal isqrt_ball_{m}) {nm}_E{m} (by norm_num)
""")
        elif kind == "sum":
            e, f, R = data
            prev = f"{nm}_S{m-1}" if m > 2 else f"(sum_one_ball {T})"
            L.append(f"""theorem {nm}_S{m} :
    ‖∑ m ∈ Finset.Icc 1 ({m-1} + 1), ((m : ℕ) : ℂ) ^ (-lineS {T}) - {g.cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [Finset.sum_Icc_succ_top (by norm_num)]
  exact ball_add {prev} {nm}_T{m} (by norm_num)
""")
        elif kind == "P":
            e, f, R = data
            j = m
            prev = f"{nm}_P{j-1}" if j > 1 else f"(prodS_zero_ball {T})"
            L.append(f"""theorem {nm}_P{j} : ‖prodS {T} ({j-1} + 1) - {g.cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [prodS_succ]
  exact ball_mul {prev} (ball_exact _ _) (by norm_num)
""")
        elif kind == "W":
            j1 = m           # the ball is for emW (j + 1)
            j = j1 - 1
            e, f, R = data["W"]
            c = data["c"]
            prev = f"{nm}_W{j}" if j > 1 else f"(emW_one {T} {N})"
            bc = f"bernC_{j}"
            L.append(f"""theorem {nm}_W{j1} : ‖emW ({j} + 1) {T} {N} - {g.cxl(e, f)}‖ ≤ {lit(R)} := by
  rw [emW_succ (by norm_num)]
  exact ball_add {prev} (ball_rmul {nm}_P{j} (c := {lit(c)}) (by rw [{bc}]; norm_num)
    (e := {lit(data['term'][0])}) (f := {lit(data['term'][1])}) (R := {lit(data['term'][2])})
    (by norm_num)) (by norm_num)
""")
        elif kind == "A":
            e, f, R = data
            L.append(f"""theorem {nm}_A : ‖emA {T} {N} - {g.cxl(e, f)}‖ ≤ 0 :=
  emA_ball {T} {N} (by norm_num) (by norm_num)
""")
        elif kind == "B":
            e, f, R = data
            L.append(f"""theorem {nm}_B : ‖emA {T} {N} + emW {KEM} {T} {N} - {g.cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_add {nm}_A {nm}_W{KEM} (by norm_num)
""")
        elif kind == "NB":
            e, f, R = data
            L.append(f"""theorem {nm}_NB : ‖((({N} : ℕ)) : ℂ) ^ (-lineS {T}) * (emA {T} {N} + emW {KEM} {T} {N})
    - {g.cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_mul {nm}_T{N} {nm}_B (by norm_num)
""")
        elif kind == "Y":
            e, f, R = data
            L.append(f"""theorem {nm}_Y : ‖(∑ m ∈ Finset.Icc 1 ({N-1} + 1), ((m : ℕ) : ℂ) ^ (-lineS {T})
    + ((({N} : ℕ)) : ℂ) ^ (-lineS {T}) * (emA {T} {N} + emW {KEM} {T} {N})) - {g.cxl(e, f)}‖ ≤ {lit(R)} :=
  ball_add {nm}_S{N} {nm}_NB (by norm_num)
""")
        elif kind == "zeta":
            z = data
            e, f, R = z["ball"]
            L.append(f"""theorem {nm}_zeta : ‖riemannZeta (lineS {T}) - {g.cxl(e, f)}‖ ≤ {lit(R)} :=
  zeta_ballK {T} (K := {KEM}) (by norm_num) (N := {N}) (by norm_num) {nm}_Y
    (rem_leK {T} (by norm_num) (by norm_num) (q := {lit(z['q'])}) (lo := {lit(z['lo'])})
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (le_refl _))
    (by norm_num)
""")
    lt = p["lt"]
    L.append(f"""theorem {nm}_logt : |Real.log ({T} / 2) - {lit(lt['l'])}| ≤ {lit(lt['el'])} :=
  log_near_ball (n := ((({lt['n']} : ℕ)) : ℝ)) (by norm_num) (u := {lit(lt['u'])}) (by norm_num)
    (by norm_num) log_ball_{lt['n']} {lt['K']}
    (by simp only [Finset.sum_range_succ, Finset.sum_range_zero]; norm_num)
""")
    ph, eb = p["ph"], p["eb"]
    L.append(f"""theorem {nm}_phase : |stirPhase 3 {T} - {lit(ph['phi0'])}| ≤ {lit(ph['E'])} :=
  stirPhase3_ball (by norm_num) (by norm_num) {nm}_logt log_pi_ball' (by norm_num [sig3])
""")
    L.append(f"""theorem {nm}_dir : ‖stirDir 3 {T} - {g.cxrot(eb)}‖ ≤ {lit(eb['R'])} := by
  unfold stirDir
  exact exp_ball{eb['j']} {nm}_phase ({eb['k']} : ℤ) (y₀ := {lit(eb['y0'])})
    (ε' := {lit(eb['epsp'])}) (e := {lit(eb['e'])}) (f := {lit(eb['f'])})
    (by norm_num) (by norm_num) {g.KEXP} (by norm_num) (by {g.TAY})
""")
    a, b, r = p["X"]
    L.append(f"""theorem {nm}_X : ‖stirDir 3 {T} * riemannZeta (lineS {T}) - {g.cxl(a, b)}‖ ≤ {lit(r)} :=
  ball_mul {nm}_dir {nm}_zeta (by norm_num)
""")
    if p["positive"]:
        L.append(f"""/-- **The sign at `t = {float(t)}`**: `Re Λ(1/2 + it) > 0`. -/
theorem sign_{nm} : 0 < reL {T} :=
  re_lambda_pos_stir3 (by norm_num) {nm}_X (by norm_num)
""")
    else:
        L.append(f"""/-- **The sign at `t = {float(t)}`**: `Re Λ(1/2 + it) < 0`. -/
theorem sign_{nm} : reL {T} < 0 :=
  re_lambda_neg_stir3 (by norm_num) {nm}_X (by norm_num)
""")
    return "\n".join(L)


def emit_group(gi, pts):
    rows = []
    for nm, p in pts:
        rows.append(f"| `sign_{nm}` | `t = {float(p['t'])}`, `N = {p['N']}`, `Re X {'>' if p['positive'] else '<'} 0`, "
                    f"centre `{float(p['X'][0]):.4e}`, radius `{float(p['X'][2]):.3e}` | proved |")
    head = f"""/-
TuringRun600Pts{gi} — Turing's point run to height ~600 (after block S14 of
`lean_stage3/design/stencil.md`): the sign of `Re Λ(1/2 + it)` at {len(pts)} heights. 2026-11-26.
Generated by `lean_stage3/checks/turingrun600/gen_turingrun600.py`; do not edit by hand.

Per point: Euler–Maclaurin of order {KEM} (`TuringRunEM.zeta_emK`, `rem_leK`) with `N` terms,
the balls `e^{{−it log m}}`, `m^{{−s}}`, the partial sums, `P_j`, the boundary sum `emW`, then the
Stirling phase `φ₃(t)` (`StirlingSeriesPhase.stirPhase3_ball`, `log(t/2)` by
`TuringRunEM.log_near_ball`) and `X = e^{{iφ₃}} ζ(1/2 + it)`, whose ball fixes the sign of
`Re Λ` (`re_lambda_pos_stir3`, `re_lambda_neg_stir3`).

| name | content | status |
|---|---|---|
{chr(10).join(rows)}

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringRunEM
import Stage3.TuringRun600Log
import Stage3.StirlingSeriesPhase

namespace TuringRun600

open Complex SignData StirlingSeries TuringRun

noncomputable section

"""
    body = "\n".join(emit_point(p, nm) for nm, p in pts)
    # Mathlib's root `ball_mul`, `ball_add` (metric balls) collide with `SignData`'s under
    # `open SignData`; the failed overload costs a coercion search per call
    body = re.sub(r"(?<![\w.])ball_(mul|add)\b", r"SignData.ball_\1", body)
    pins = "\n".join(f"""/-- info: 'TuringRun600.sign_{nm}' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sign_{nm}
""" for nm, p in pts)
    return head + body + "\nend\n\n" + pins + "\nend TuringRun600\n"


def emit_log_file(M, Nmax, logs, isq):
    L = []
    for q in range(OLD_LOG_M + 1, M + 1):
        c, R, K = logs[q]
        a, e, _ = logs[q - 1]
        L.append(f"""theorem log_ball_{q} : |Real.log ((({q} : ℕ)) : ℝ) - {lit(c)}| ≤ {lit(R)} :=
  log_succ_ball (p := (({q-1} : ℕ) : ℝ)) (by norm_num) (by norm_num) log_ball_{q-1} {K}
    (by simp only [Finset.sum_range_succ, Finset.sum_range_zero]; norm_num)
""")
    for m in range(OLD_ISQ_M + 1, Nmax + 1):
        lo, hi, c, R = isq[m]
        L.append(f"""theorem isqrt_ball_{m} : |(Real.sqrt ((({m} : ℕ)) : ℝ))⁻¹ - {lit(c)}| ≤ {lit(R)} :=
  inv_sqrt_ball (lo := {lit(lo)}) (hi := {lit(hi)}) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num)
""")
    head = f"""/-
TuringRun600Log — Turing's point run to height ~600: the real balls
`log m` for `{OLD_LOG_M + 1} ≤ m ≤ {M}` and `(√m)⁻¹` for `{OLD_ISQ_M + 1} ≤ m ≤ {Nmax}`, continuing the chains of
`TuringRunLog` (`log m`, `m ≤ {OLD_LOG_M}`; `(√m)⁻¹`, `m ≤ {OLD_ISQ_M}`). 2026-11-26.
Generated by `lean_stage3/checks/turingrun600/gen_turingrun600.py`; do not edit by hand.

| name | content | status |
|---|---|---|
| `log_ball_m` | `|log m − c_m| ≤ e_m` (`SignDataBall.log_succ_ball` from `m − 1`) | proved |
| `isqrt_ball_m` | `|(√m)⁻¹ − c| ≤ e` (`SignDataBall.inv_sqrt_ball`) | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringRunLog

namespace TuringRun600

open SignData StirlingSeries TuringRun

noncomputable section

"""
    tail = f"""
end

/-- info: 'TuringRun600.log_ball_{M}' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_ball_{M}

end TuringRun600
"""
    return head + "\n".join(L) + tail


# ---------------------------------------------------------------- shared data

def shared(M, Nmax):
    logs = g.log_chain(M)
    lpi = g.log_pi(logs[3])
    isq = {m: g.isqrt_ball(m) for m in range(2, Nmax + 1)}
    return logs, lpi, isq


def write(path, text):
    with open(path, "w") as fh:
        fh.write(text)


if __name__ == "__main__" and "--test" in sys.argv:
    i = sys.argv.index("--test")
    t = F(sys.argv[i + 1])
    Nt = int(sys.argv[i + 2])
    M = max(Nt, round(t / 2) + 2, 40)
    logs, lpi, isq = shared(M, max(Nt, 40))
    p = certify(t, logs, lpi, isq, Nmin=Nt)
    print(f"t = {float(t)}  N = {p['N']}  Z = {p['Z']:.4f}  Re X = {float(p['X'][0]):.6e}  "
          f"r = {float(p['X'][2]):.3e}  Q = {float(p['steps'][-1][2]['Q']):.3e}")
    write(os.path.join(HERE, "TestLog.lean"), emit_log_file(M, max(Nt, 40), logs, isq)
          .replace("namespace TuringRun", "namespace TuringRunTest"))
    txt = emit_group("Test", [("x", p)]).replace("import Stage3.TuringRunLog\n", "")
    write(os.path.join(HERE, "TestPoint.lean"), txt)


# ---------------------------------------------------------------- the plan

A_LW = F(3, 2) + F(113, 4)            # pi * a of `LittlewoodSharp.littlewood_sharp`
PI_LO = F("3.14159265358979323846")   # Real.pi_gt_d20


_CACHE_PATH = os.path.join(HERE, "points_cache.json")
try:
    _CACHE = json.load(open(_CACHE_PATH))
except (OSError, ValueError):
    _CACHE = {}


def _cached(key, fn):
    if key not in _CACHE:
        _CACHE[key] = str(fn())
        json.dump(_CACHE, open(_CACHE_PATH, "w"), indent=0)
    return F(_CACHE[key])


def argmax_Z(lo, hi, step=F(1, 100)):
    return _cached(f"max {lo} {hi} {step}", lambda: _argmax_Z(lo, hi, step))


def right_of(gamma, nxt, thr=THR_EDGE, step=F(1, 1000)):
    return _cached(f"edge {gamma} {nxt} {thr} {step}", lambda: _right_of(gamma, nxt, thr, step))


def _argmax_Z(lo, hi, step=F(1, 100)):
    """The grid point k*step in (lo, hi) with the largest |Z| (searched at 15 digits)."""
    a = math.floor(lo / step) + 1
    b = math.ceil(hi / step) - 1
    best = None
    for k in range(a, b + 1, 2):
        v = abs(float(Z(F(k) * step, 15)))
        if best is None or v > best[0]:
            best = (v, k)
    k0 = best[1]
    for k in (k0 - 1, k0 + 1):
        if a <= k <= b:
            v = abs(float(Z(F(k) * step, 15)))
            if v > best[0]:
                best = (v, k)
    return F(best[1]) * step


def _right_of(gamma, nxt, thr=THR_EDGE, step=F(1, 1000)):
    """The first grid point k*step > gamma with |Z| >= thr, before the next zero."""
    k = math.floor(F(gamma) / step) + 1
    while True:
        t = F(k) * step
        check(t < nxt, f"no edge point right of {gamma}")
        if abs(float(Z(t, 15))) >= float(thr):
            return t
        k += 1


def bounds_for(T1, h, logs, lpi):
    """Rational bounds feeding `hnum'`: theta(T1) above, log(T1+1+h) above, log 9 above,
    log 2 and log pi below."""
    lt = logt_ball(T1, logs)
    phi0, E, Efin = gamma_phase5(T1, lt)
    c, epi = lpi[0], lpi[1]
    th_up = phi0 - T1 / 2 * c + Efin + T1 / 2 * epi
    th_true = mp.siegeltheta(mp.mpf(T1.numerator) / T1.denominator)
    check(th_true <= mp.mpf(th_up.numerator) / th_up.denominator, "theta upper bound vs mpmath")
    y = T1 + 1 + h
    ly = logt_ball(2 * y, logs)          # log(y) = log((2y)/2)
    l_up = ly["l"] + ly["el"]
    l9_up = 2 * (logs[3][0] + logs[3][1])
    l2_lo = logs[2][0] - logs[2][1]
    lpi_lo = c - epi
    return dict(lt=lt, phi0=phi0, E=E, Efin=Efin, th_up=th_up, ly=ly, l_up=l_up, l9_up=l9_up,
                l2_lo=l2_lo, lpi_lo=lpi_lo)


def lhs_up(T1, h, k, Ssum, bd):
    Bu = 2 + F(3, 2) * bd["l9_up"] + 128
    Ku = (bd["l_up"] - bd["l2_lo"] - bd["lpi_lo"]) / 2 + F(4, 5) / T1
    return (bd["th_up"] / PI_LO + 1 + (A_LW / PI_LO * bd["l_up"] + Bu / PI_LO - Ssum) / h
            + h * Ku / (2 * PI_LO))


def choose(n, logs, lpi, zs, hstep=F(1, 2)):
    """Points and window for T1 just right of the zero gamma_n."""
    gam = [None] + [F(mp.nstr(z, 20)) for z in zs]       # 1-indexed
    below = list(OLD)
    for i, t in enumerate(REUSE, start=10):
        check(gam[i] < t < gam[i + 1], f"reused point {t} not in gap {i}")
        below.append(t)
    for i in range(GAP_NEW, n):
        below.append(argmax_Z(gam[i] + F(1, 20), gam[i + 1] - F(1, 20)))
    T1 = right_of(gam[n], gam[n + 1])
    below.append(T1)
    s0 = argmax_Z(T1 + F(1, 100), gam[n + 1] - F(1, 20))
    above = [s0]
    i = n + 1
    while gam[i] < T1 + 132:
        above.append(right_of(gam[i], gam[i + 1]))
        i += 1
    best = None
    h = F(40)
    while h <= 130 and T1 + h < gam[i]:
        sel = [s for s in above[1:] if s <= T1 + h]
        Ssum = sum(T1 + h - s for s in sel)
        bd = bounds_for(T1, h, logs, lpi)
        k = len(below) - 1
        marg = k + 2 - lhs_up(T1, h, k, Ssum, bd)
        if best is None or marg > best[0]:
            best = (marg, h, len(sel))
        h += hstep
    marg, h, m = best
    return dict(n=n, T1=T1, h=h, below=below, above=above[:m + 1], margin=marg)


# ---------------------------------------------------------------- the top module

L2_LO = F("0.6931471803")       # Real.log_two_gt_d9


def sgn_name(t, names):
    return names[t]


def emit_top(c, recs, names, groups, bd, Ssum, lL):
    T1, h = c["T1"], c["h"]
    below, above = c["below"], c["above"]
    k, m = len(below) - 1, len(above) - 1
    T1l, hl = tlit(T1), tlit(h)
    pos = {p["t"]: p["positive"] for p in recs.values()}
    for t in OLD:
        pos[t] = None
    oldpos = {F(14): False, F(18): True, F(23): False, F(55, 2): True, F(63, 2): False,
              F(71, 2): True, F(39): False, F(42): True, F(91, 2): False, F(49): True}
    for t in OLD:
        pos[t] = oldpos[t]
    for t in REUSE:              # the old certificates agree with mpmath (checked when made)
        pos[t] = Z(t) > 0

    def chain(pts):
        out = []
        for x, y in zip(pts, pts[1:]):
            lem = "mul_neg_of_pos_of_neg" if pos[x] else "mul_neg_of_neg_of_pos"
            check(pos[x] != pos[y], f"no sign change between {x} and {y}")
            out.append(f"  refine chainOK_cons (by norm_num) ({lem} {names[x]} {names[y]}) ?_")
        out.append("  exact chainOK_single _")
        return "\n".join(out)

    lst = lambda xs: "[" + ", ".join(tlit(x) for x in xs) + "]"
    imports = "\n".join([f"import Stage3.TuringRunPts{gi}" for gi in range(len(_OLDPLAN["groups"]))]
                        + [f"import Stage3.TuringRun600Pts{gi}" for gi in range(len(groups))])
    lT = recs[T1]["lt"]
    th_lo_c = bd["phi0"] - T1 / 2 * bd["c"]
    th_rad = bd["Efin"] + T1 / 2 * bd["epi"]
    text = f"""/-
TuringRun600 — Turing's point run extended (after block S14 of `lean_stage3/design/stencil.md`
and `TuringRun`): the Riemann hypothesis up to height `T₁ = {float(T1)}`. 2026-11-26. Generated by
`lean_stage3/checks/turingrun600/gen_turingrun600.py`; do not edit by hand.

**The data.** {k + 1} heights `t₀ < … < t_{k} = T₁` with a strict sign change of `Re Λ(1/2 + it)`
between neighbours (`signs_below`; the first ten are `SignDataPt*`, then `TuringRun.sign_b10 ..
sign_b227` and `TuringRun.sign_a0 .. sign_a53` reused from `TuringRunPts*` (one point inside each
gap of zeros 10..281), then `TuringRun600Pts*`, one point where `|Z|` is largest between
consecutive zeros, and `T₁` just right of the zero
`γ_{k} ≈ {float(F(mp.nstr(Zs.load()[k - 1], 12))):.6f}`), so `k = {k}` zeros on the line up to `T₁`;
and {m + 1} heights `T₁ < s₀ < … < s_{m} ≤ T₁ + h`, `h = {float(h)}`, each `s_j` (`j ≥ 1`) just
right of a zero (`signs_above`). Every sign is a ball for `e^{{iφ₃(t)}} ζ(1/2 + it)` with ζ by
Euler–Maclaurin of order {KEM} (`TuringRunEM`).

**The closing inequality** `hnum'` of `TuringSlope.StmtClosingData' T₁ h`: `θ(T₁)` from above by
`TuringRunTheta.phaseTheta_ball` (`θ = Im logG(1/4 + iT/2) − (T/2) log π`, Stirling's series
with `K = 5`), `log(T₁ + 1 + h)`, `log 9`, `log 2`, `log π`, `π` by rational balls, and
`Σ_j (T₁ + h − s_{{j+1}}) = {float(Ssum):.6f}`; the left side is at most
`{float(k + 2 - (k + 2 - lhs_up(T1, h, k, Ssum, bd))):.6f} < k + 2 = {k + 2}` (margin `{float(k + 2 - lhs_up(T1, h, k, Ssum, bd)):.4f}`).
`TuringSlope.defect_zero_of_closing'` then gives the defect `0` up to `T₁`.

| name | content | status |
|---|---|---|
| `tBelow`, `sAbove` | the heights below and above `T₁` | def |
| `signs_below` | `Turing.StmtSignData {k} (chainFun tBelow 14)` | proved |
| `signs_above` | `Turing.StmtSignData {m} (chainFun sAbove s₀)` | proved |
| `theta_T1_le` | `phaseTheta T₁ ≤ {float(bd['th_up']):.9f}` | proved |
| `hnum_of` | rational bounds ⊢ `hnum'` | proved |
| `closing` | `TuringSlope.StmtClosingData' T₁ h` | proved |
| `rh_up_to_600` | `∀ T ≤ T₁, Defect.defect T = 0` | proved |
| `zeros_on_line_up_to_600` | `ζ ρ = 0`, `0 < Im ρ ≤ T₁`, `0 < Re ρ < 1` ⊢ `Re ρ = 1/2` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringRunTheta
import Stage3.TuringSlope
import Stage3.SignData
{imports}

namespace TuringRun600

open Complex SignData StirlingSeries LineCount Defect Kadiri TuringRun

noncomputable section

/-- The heights below `T₁` after `t₀ = 14`. -/
def tBelow : List ℝ := {lst(below[1:])}

/-- The heights above `T₁` after `s₀`. -/
def sAbove : List ℝ := {lst(above[1:])}

set_option maxRecDepth 20000 in
theorem tBelow_length : tBelow.length = {k} := rfl

set_option maxRecDepth 20000 in
theorem sAbove_length : sAbove.length = {m} := rfl

theorem chain_below : chainOK ((14 : ℝ) :: tBelow) := by
  unfold tBelow
{chain(below)}

theorem chain_above : chainOK ({tlit(above[0])} :: sAbove) := by
  unfold sAbove
{chain(above)}

/-- **{k} sign changes of `Re Λ(1/2 + it)` up to `T₁`.** -/
theorem signs_below : Turing.StmtSignData tBelow.length (chainFun tBelow 14) :=
  signData_of_chain tBelow 14 (by norm_num) chain_below

/-- **{m} sign changes of `Re Λ(1/2 + it)` in `(T₁, T₁ + h]`.** -/
theorem signs_above : Turing.StmtSignData sAbove.length (chainFun sAbove {tlit(above[0])}) :=
  signData_of_chain sAbove {tlit(above[0])} (by norm_num) chain_above

set_option maxRecDepth 20000 in
theorem below_last : chainFun tBelow 14 (Fin.last tBelow.length) = {T1l} := rfl

set_option maxRecDepth 20000 in
theorem above_last : chainFun sAbove {tlit(above[0])} (Fin.last sAbove.length) = {tlit(above[-1])} := rfl

/-- The phase of `Γ(1/4 + iT₁/2)`, Stirling's series with `K = 5`. -/
theorem gamma_phase_T1 : |(Stirling.logG (zz {T1l})).im - {lit(bd['phi0'])}| ≤ {lit(bd['Efin'])} :=
  (gamma_phase_ball5 (by norm_num) {names[T1].replace('sign_', '')}_logt (φ₀ := {lit(bd['phi0'])}) (E := {lit(bd['E'])})
    (by norm_num [sig5])).trans (by norm_num)

/-- **`θ(T₁)` from above.** -/
theorem theta_T1_le : Stage3.phaseTheta {T1l} ≤ {lit(bd['th_up'])} := by
  have h := phaseTheta_ball gamma_phase_T1 log_pi_ball'
  have h2 := (abs_le.mp h).2
  have e : |({T1l} : ℝ) / 2| = {T1l} / 2 := abs_of_pos (by norm_num)
  rw [e] at h2
  linarith

theorem logL_ball : |Real.log ({T1l} + 1 + {hl}) - {lit(lL['l'])}| ≤ {lit(lL['el'])} :=
  log_near_ball (n := ((({lL['n']} : ℕ)) : ℝ)) (by norm_num) (u := {lit(lL['u'])}) (by norm_num)
    (by norm_num) log_ball_{lL['n']} {lL['K']}
    (by simp only [Finset.sum_range_succ, Finset.sum_range_zero]; norm_num)

theorem log_nine_le : Real.log 9 ≤ {lit(bd['l9_up'])} := by
  have h := log_ball_3
  rw [Nat.cast_ofNat] at h
  have e : Real.log 9 = 2 * Real.log 3 := by
    rw [show (9 : ℝ) = 3 ^ 2 by norm_num, Real.log_pow]; norm_num
  rw [e]
  linarith [(abs_le.mp h).2]

/-- **The closing inequality from rational bounds.** -/
theorem hnum_of {{T₁ h θu ℓ l9 l2 lπ Sv : ℝ}} {{k m : ℕ}} {{s : Fin (m + 1) → ℝ}}
    (hT : 0 < T₁) (hh : 0 < h) (hθ : Stage3.phaseTheta T₁ ≤ θu) (hθ0 : 0 ≤ θu)
    (hℓ : Real.log (T₁ + 1 + h) ≤ ℓ) (h9 : Real.log 9 ≤ l9)
    (h2 : l2 ≤ Real.log 2) (hlπ : lπ ≤ Real.log Real.pi)
    (hS : ∑ j : Fin m, (T₁ + h - s j.succ) = Sv)
    (hK0 : 0 ≤ (ℓ - l2 - lπ) / 2 + (4 / 5) / T₁) (hB0 : 0 ≤ 2 + (3 / 2) * l9 + 128)
    (hfin : θu / 3.14159265358979323846 + 1
      + ((3 / 2 + 113 / 4) / 3.14159265358979323846 * ℓ
        + (2 + (3 / 2) * l9 + 128) / 3.14159265358979323846 - Sv) / h
      + h * ((ℓ - l2 - lπ) / 2 + (4 / 5) / T₁) / (2 * 3.14159265358979323846) < k + 2) :
    Stage3.phaseTheta T₁ / Real.pi + 1
      + TuringSlope.turingErr' ((3 / 2 + 113 / 4) / Real.pi)
          ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi) h T₁ s < k + 2 := by
  have hπ := Real.pi_gt_d20
  have hπ0 : (0 : ℝ) < 3.14159265358979323846 := by norm_num
  have hpi : 0 < Real.pi := Real.pi_pos
  unfold TuringSlope.turingErr' TuringSlope.turingK'
  rw [hS]
  have t1 : Stage3.phaseTheta T₁ / Real.pi ≤ θu / 3.14159265358979323846 :=
    (div_le_div_of_nonneg_right hθ hpi.le).trans (div_le_div_of_nonneg_left hθ0 hπ0 hπ.le)
  have hA : (0 : ℝ) ≤ 3 / 2 + 113 / 4 := by norm_num
  have t2 : (3 / 2 + 113 / 4) / Real.pi * Real.log (T₁ + 1 + h)
      ≤ (3 / 2 + 113 / 4) / 3.14159265358979323846 * ℓ := by
    apply mul_le_mul (div_le_div_of_nonneg_left hA hπ0 hπ.le) hℓ (by
      exact Real.log_nonneg (by linarith)) (by positivity)
  have t3 : (2 + (3 / 2) * Real.log 9 + 128) / Real.pi
      ≤ (2 + (3 / 2) * l9 + 128) / 3.14159265358979323846 :=
    (div_le_div_of_nonneg_right (by linarith) hpi.le).trans
      (div_le_div_of_nonneg_left hB0 hπ0 hπ.le)
  have t4 : ((3 / 2 + 113 / 4) / Real.pi * Real.log (T₁ + 1 + h)
        + (2 + (3 / 2) * Real.log 9 + 128) / Real.pi - Sv) / h
      ≤ ((3 / 2 + 113 / 4) / 3.14159265358979323846 * ℓ
        + (2 + (3 / 2) * l9 + 128) / 3.14159265358979323846 - Sv) / h :=
    div_le_div_of_nonneg_right (by linarith) hh.le
  have hlog : Real.log ((T₁ + 1 + h) / (2 * Real.pi))
      = Real.log (T₁ + 1 + h) - Real.log 2 - Real.log Real.pi := by
    rw [Real.log_div (by linarith) (by positivity), Real.log_mul (by norm_num) hpi.ne']
    ring
  have t5 : Real.log ((T₁ + 1 + h) / (2 * Real.pi)) / 2 + 4 / 5 / T₁
      ≤ (ℓ - l2 - lπ) / 2 + (4 / 5) / T₁ := by
    rw [hlog]; linarith
  have t6 : h * (Real.log ((T₁ + 1 + h) / (2 * Real.pi)) / 2 + 4 / 5 / T₁) / (2 * Real.pi)
      ≤ h * ((ℓ - l2 - lπ) / 2 + (4 / 5) / T₁) / (2 * 3.14159265358979323846) := by
    apply (div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left t5 hh.le) (by positivity)).trans
    exact div_le_div_of_nonneg_left (mul_nonneg hh.le hK0) (by positivity) (by linarith)
  linarith

/-- **The closing data at `T₁ = {float(T1)}`, `h = {float(h)}`.** -/
theorem closing : TuringSlope.StmtClosingData' {T1l} {hl} := by
  refine ⟨tBelow.length, sAbove.length, chainFun tBelow 14, chainFun sAbove {tlit(above[0])},
    signs_below, by rw [below_last], signs_above, by rw [chainFun_zero]; norm_num,
    by rw [above_last]; norm_num, ?_⟩
  rw [tBelow_length]
  have hS : ∑ j : Fin sAbove.length, ({T1l} + {hl} - chainFun sAbove {tlit(above[0])} j.succ)
      = {lit(Ssum)} := by
    rw [sum_succ_eq]
    simp only [sAbove, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil]
    norm_num
  have hℓ := (abs_le.mp logL_ball).2
  have hπl := (abs_le.mp log_pi_ball').1
  have h2 := Real.log_two_gt_d9
  exact hnum_of (θu := {lit(bd['th_up'])}) (ℓ := {lit(bd['l_up'])}) (l9 := {lit(bd['l9_up'])})
    (l2 := {lit(L2_LO)}) (lπ := {lit(bd['lpi_lo'])}) (by norm_num) (by norm_num) theta_T1_le
    (by norm_num) (by linarith) log_nine_le h2.le (by linarith) hS (by norm_num)
    (by norm_num) (by norm_num)

/-- **The Riemann hypothesis up to height `{float(T1)}`**: no zero off the line with
`0 < Im ρ ≤ {float(T1)}`. -/
theorem rh_up_to_600 : ∀ T ≤ {T1l}, Defect.defect T = 0 :=
  TuringSlope.defect_zero_of_closing' closing (by norm_num) (by norm_num)

/-- **Every nontrivial zero with `0 < Im ρ ≤ {float(T1)}` is on the line.** -/
theorem zeros_on_line_up_to_600 : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.im → ρ.im ≤ {T1l} →
    0 < ρ.re → ρ.re < 1 → ρ.re = 1 / 2 := by
  intro ρ hz him hle hre0 hre1
  by_contra hne
  have hd := rh_up_to_600 {T1l} le_rfl
  rw [Defect.defect_eq_offCount] at hd
  have hmem : ρ ∈ NontrivialZeros := ⟨⟨hre0, hre1⟩, Set.mem_univ _, hz⟩
  set r : NontrivialZeros := ⟨ρ, hmem⟩ with hr
  unfold Defect.offCount at hd
  have key := (Finset.sum_eq_zero_iff_of_nonneg
    (fun x _ => (riemannZeta_order_pos_nontrivialZero x).le)).mp hd r (by
      rw [Finset.mem_filter, mem_zerosUpTo]
      exact ⟨⟨him, hle⟩, hne⟩)
  exact absurd key (riemannZeta_order_pos_nontrivialZero r).ne'

end

/-- info: 'TuringRun600.closing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms closing

/-- info: 'TuringRun600.rh_up_to_600' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_up_to_600

/-- info: 'TuringRun600.zeros_on_line_up_to_600' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeros_on_line_up_to_600

end TuringRun600
"""
    return text


def arg(name, default=None):
    return sys.argv[sys.argv.index(name) + 1] if name in sys.argv else default


# seconds per unit of N for one point module, from the old run (74 min wall, two modules at a
# time, total N 16406, as recorded for checks/turingrun/gen_turingrun.out)
OLD_WALL_S, OLD_TOTN, OLD_PAR = 74 * 60, 16406, 2
SEC_PER_N = OLD_WALL_S * OLD_PAR / OLD_TOTN

if __name__ == "__main__" and "--scan" in sys.argv:
    i = sys.argv.index("--scan")
    n1, n2 = int(sys.argv[i + 1]), int(sys.argv[i + 2])
    zs = Zs.load()
    logs, lpi, isq = shared(800, 40)
    for n in range(n1, n2 + 1):
        c = choose(n, logs, lpi, zs, hstep=F(1, 4))
        print(f"n = {n}  gamma_n = {float(zs[n - 1]):.4f}  T1 = {float(c['T1'])}  h = {float(c['h'])}  "
              f"below {len(c['below'])}  above {len(c['above'])}  margin {float(c['margin']):.5f}", flush=True)
    sys.exit(0)

if __name__ == "__main__" and "--test" not in sys.argv:
    NLAST = int(arg("--n"))
    do_write = "--write" in sys.argv
    zs = Zs.load()
    logs, lpi, isq = shared(800, 40)
    c = choose(NLAST, logs, lpi, zs, hstep=F(1, 4))
    T1, h = c["T1"], c["h"]
    below, above = c["below"], c["above"]
    k, m = len(below) - 1, len(above) - 1
    print(f"n = {NLAST}  T1 = {float(T1)}  h = {float(h)}  below {k + 1}  above {m + 1}  "
          f"planned margin {float(c['margin']):.5f}")
    new = below[GAP_NEW:] + above
    plans = {t: plan_N(t, abs(F(float(Z(t, 15)))) / 4) for t in new}
    if "--plan" in sys.argv:
        # groups by the planned N (the certified N is the plan or a few more)
        gs, cost = [[]], 0
        for t in new:
            if gs[-1] and cost + plans[t] > GROUP_BUDGET:
                gs.append([]); cost = 0
            gs[-1].append(t); cost += plans[t]
        mods = [sum(plans[t] for t in gr) * SEC_PER_N for gr in gs]
        # two at a time, longest first
        lanes = [0.0, 0.0]
        for s in sorted(mods, reverse=True):
            lanes[lanes.index(min(lanes))] += s
        lines = [
            f"Turing run to ~600: build-cost estimate, before any Lean is written (2026-11-26).",
            f"n = {NLAST}, gamma_n = {float(zs[NLAST - 1]):.6f}, T1 = {T1} = {float(T1)}, h = {h} = {float(h)}",
            f"planned closing margin {float(c['margin']):.5f}",
            f"points below T1: {k + 1} (10 SignDataPt + {len(REUSE)} reused TuringRun + "
            f"{len(below) - GAP_NEW} new incl. T1); above: {m + 1} (new)",
            f"new points {len(new)}, planned total N {sum(plans.values())}, planned Nmax {max(plans.values())} "
            f"(certified N may be a few higher)",
            f"old run: total N {OLD_TOTN}, {OLD_WALL_S // 60} min wall at {OLD_PAR} modules at a time "
            f"-> {SEC_PER_N:.3f} s per unit of N per module (per-point seconds ~ {SEC_PER_N:.3f} * N)",
            f"per-point seconds at the new N: min {min(plans.values()) * SEC_PER_N:.0f}, "
            f"max {max(plans.values()) * SEC_PER_N:.0f}",
            f"point modules: {len(gs)} (budget {GROUP_BUDGET} N each), per-module est. "
            f"{min(mods) / 60:.1f}..{max(mods) / 60:.1f} min",
            f"projected wall, two at a time: {max(lanes) / 3600:.2f} h (+ log module and top module)",
            f"limit ~8 h: {'fits' if max(lanes) / 3600 < 8 else 'EXCEEDS'}",
        ]
        txt = "\n".join(lines) + "\n"
        print(txt)
        write(os.path.join(HERE, "plan.out"), txt)
        sys.exit(0)
    Nmax = max(plans.values()) + 12
    logs, lpi, isq = shared(800, Nmax)
    recs, names = {}, {t: OLD_NAME[t] for t in OLD}
    names.update(REUSE_NAME)
    for i, t in enumerate(below[GAP_NEW:], start=GAP_NEW):
        names[t] = f"sign_c{i}"
    for j, t in enumerate(above):
        names[t] = f"sign_d{j}"
    tot = 0
    for t in new:
        p = certify(t, logs, lpi, isq)
        recs[t] = p
        tot += p["N"]
        print(f"{names[t]:10s} t = {float(t):10.3f}  N = {p['N']:3d}  Z = {p['Z']: .4f}  "
              f"Re X = {float(p['X'][0]): .5e}  r = {float(p['X'][2]):.2e}  margin {p['margin']:.2f}", flush=True)
    Nmax = max(p["N"] for p in recs.values())
    sel = above[1:]
    Ssum = sum(T1 + h - s for s in sel)
    bd = bounds_for(T1, h, logs, lpi)
    bd["c"], bd["epi"] = lpi[0], lpi[1]
    check(bd["l2_lo"] >= L2_LO, "log 2 lower bound")
    bd["l2_lo"] = L2_LO
    lL = bd["ly"]
    check(lL["n"] <= 800, "log chain")
    marg = k + 2 - lhs_up(T1, h, k, Ssum, bd)
    check(marg > 0, "closing inequality")
    check(above[-1] <= T1 + h and above[0] > T1 and below[-1] == T1, "window")
    print(f"total N = {tot}, Nmax = {Nmax}, closing margin {float(marg):.6f}, "
          f"theta(T1) <= {float(bd['th_up']):.10f} (mpmath {mp.siegeltheta(float(T1))})")
    groups, cur, cost = [], [], 0
    for t in new:
        nm = names[t].replace("sign_", "")
        if cur and cost + recs[t]["N"] > GROUP_BUDGET:
            groups.append(cur)
            cur, cost = [], 0
        cur.append((nm, recs[t]))
        cost += recs[t]["N"]
    if cur:
        groups.append(cur)
    print(f"{len(groups)} point modules")
    summary = dict(T1=str(T1), h=str(h), k=k, m=m, below=[str(x) for x in below],
                   above=[str(x) for x in above], N={names[t]: recs[t]["N"] for t in new},
                   margin=float(marg), groups=[[nm for nm, _ in gr] for gr in groups])
    Mlog = max(lL["n"], max(p["lt"]["n"] for p in recs.values()), Nmax)
    if "--top-only" in sys.argv:
        write(os.path.join(STAGE3, "TuringRun600.lean"), emit_top(c, recs, names, groups, bd, Ssum, lL))
        print("written: TuringRun600.lean")
    elif do_write:
        write(os.path.join(STAGE3, "TuringRun600Log.lean"), emit_log_file(Mlog, Nmax, logs, isq))
        for gi, gr in enumerate(groups):
            write(os.path.join(STAGE3, f"TuringRun600Pts{gi}.lean"), emit_group(gi, gr))
        write(os.path.join(STAGE3, "TuringRun600.lean"), emit_top(c, recs, names, groups, bd, Ssum, lL))
        write(os.path.join(HERE, "plan.json"), json.dumps(summary, indent=1))
        print("written:", ["TuringRun600Log.lean"] + [f"TuringRun600Pts{gi}.lean" for gi in range(len(groups))]
              + ["TuringRun600.lean"])
