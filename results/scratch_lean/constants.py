"""Constant propagation for the substitute chain (entry 232), with both levers.

Every zeta-side input below is a NUMERAL PROVED IN LEAN, no sorries, at
[propext, Classical.choice, Quot.sound]:

  slice 3  logDerivZeta_crude    ‖ζ'/ζ(σ₁+it)‖ ≤ 1996 log(84t) + (29 log t + 129)/(σ₁-1/2)
  slice 4  logDerivZeta_compact  ‖ζ'/ζ(σ₁+it)‖ ≤ 14535 + 212/(σ₁-1/2),  |t| ≤ 2
  slice 5  norm_logDerivZeta_of_one_lt_re
                                 ‖ζ'/ζ(s)‖ ≤ 2/(σ-1) + 4/(σ-1)²,  Re s > 1
  file: results/scratch_lean/unified_opt2.lean  (0 errors, all house axioms)
  also   results/scratch_lean/unified_opt.lean  (r = 29/32, R' = 91/100, cruder logs)

LEVER 1 = slice 5.  `I₁`/`I₉` sit at σ₀ = 1 + 1/L; they had been borrowing
slice 3's critical-line bound (≈ 5.4e4 at L = 10.4).  The Dirichlet series is
absolutely convergent there and gives 2L + 4L² ≈ 453.  RH-free.

LEVER 2 = the Jensen radii.  r' = 3/4 → r = 181/200 → R' = 29/32 → R = 15/16,
replacing 3/4 → 7/8 → 9/10 → 15/16.  r' = 3/4 is a hard floor and R = 15/16
is jensenF_bound's proved reach; r and R' were free choices inherited from
zeta_local_zero_count's 7/4 window, which slice 3 does not use.
FinalBound constant 6600 → 3991; ZerosBound constant 15 → 29.  Two log
numerals also sharpened: log 84 ≤ 4.44 (from 84^5 ≤ 2^32) and
log 1300 ≤ 7.28 (from 1300² ≤ 2^21), replacing 4.86 and 7.625.

The four unbuilt contour integrals (5, 6, 7 and the I₁/I₉ re-proof) are still
done on paper here.  M = sup|ν|, M' = sup|ν'| of the PNT+ bump, which
SmoothExistence never constructs — that is why the answer is a range.
"""
import math

e_2pi = math.e / (2 * math.pi)          # 0.4326
log2 = math.log(2)

# ---- the proved zeta-side numerals, as functions of L = log X ----
# legacy = the entry-232 radii (r = 7/8, R' = 9/10) with no lever 1
LEGACY = dict(Bcomp=lambda L: 25200 + 115 * L,
              Btail=lambda L: 15 * L**2 + 3373 * L + 16038,
              Bsig0=lambda L: 3330 * (L + 1) + 16184)          # already ∫-ed
OPT = dict(Bcomp=lambda L: 14535 + 212 * L,
           Btail=lambda L: 29 * L**2 + 2125 * L + 8863,
           Bsig0=lambda L: 2 * L + 4 * L**2)                   # uniform in t


def Cpsi(L, M, Mp, opt=True, verbose=False):
    """C_psi at exponent k=3, valid for all x with log x >= L (floor)."""
    K = OPT if opt else LEGACY
    S = math.exp(L / 2)                          # sqrt(X) at the floor
    Bcomp, Btail, Bsig0 = K["Bcomp"](L), K["Btail"](L), K["Bsig0"](L)
    # --- I37 : vertical at σ₁, X^{σ₁} = e·sqrt(X), Mellin ≤ 3M/|s| ---
    Ismall = 2 * (1 + math.log(2 / 0.5))         # ∫_{|t|≤2} dt/max(σ₁,|t|) ≤ 2(1+log4)
    Ilarge = 2 * (L - log2)                      # ∫_{2≤|t|≤X} dt/|t|
    I37 = e_2pi * 3 * M * S * (Bcomp * Ismall + Btail * Ilarge)
    # --- I2 + I8 : horizontal at |t| = T = X, Mellin ≤ 3M/X, length 1/2 ---
    I28 = 2 * e_2pi * 0.5 * 3 * M * Btail
    # --- I1 + I9 : |t| ≥ T on σ₀, Mellin ≤ 6M'/(ε|s|²), ε = X^{-1/2} ---
    #     ∫_{|t|≥X} B/t² dt = B/X when B is uniform in t (LEVER 1)
    I19 = 2 * e_2pi * 6 * Mp * S * Bsig0
    # --- ψ_ε - ψ : SmoothedChebyshevClose, C = 6(3c₁+c₂) = 30 log 2 ---
    close = 30 * log2 * (1 / S) * math.exp(L) * L
    # --- Mellin at 1 : |M(1)-1| ≤ 6 M log2 · ε, times X ---
    box = 6 * M * log2 * S
    tot = I37 + I28 + I19 + close + box
    C = tot / (S * L**3)
    if verbose:
        for n, v in [("I37", I37), ("I2+I8", I28), ("I1+I9", I19),
                     ("close", close), ("box", box)]:
            print(f"   {n:8s} {v / (S * L**3):12.3f}")
    return C


BUMPS = [(1.0, 3.4, "frontier ramp"), (1.0, 4.0, "optimistic"),
         (1.7, 7.0, "plausible"), (3.0, 15.0, "conservative")]
# entry 231 measured depth_covered = 6 at C = 1e3 and 5 at C = 1e4 and never
# resolved between.  Bisecting O68.R_of (EXPLORATORY, no prereg) puts the
# depth >= 6 boundary at C_pi = 2640.5 for k = 2, x0 = 2^30.
GATE = 2640.5
L0 = 10.397                         # ψ-floor 2^15  ->  π-floor 2^30, the census row

for tag, opt in [("entry 232 (no levers)", False), ("BOTH LEVERS", True)]:
    print(f"=== {tag} — π-floor 2^30 ===")
    for M, Mp, name in BUMPS:
        c = Cpsi(L0, M, Mp, opt)
        cpi = 3 * c + 13
        print(f"  {name:14s} M={M:4.1f} M'={Mp:5.1f}   C_ψ={c:9.1f}   "
              f"C_π={cpi:10.1f}   gate ×{cpi / GATE:6.2f}")
    print()

print("breakdown at the frontier ramp (M=1.0, M'=3.4), both levers, L=10.397:")
Cpsi(L0, 1.0, 3.4, True, verbose=True)
print()
print(f"C_ψ needed to clear the gate ({GATE}):", (GATE - 13) / 3)
print()
print("floor sensitivity (both levers, frontier ramp):")
for L in [10.397, 13.86, 17.33, 20.79]:
    c = Cpsi(L, 1.0, 3.4, True)
    print(f"  ψ-floor 2^{L/log2:5.1f} -> π-floor 2^{2*L/log2:5.1f}:  "
          f"C_ψ={c:8.1f}  C_π={3*c+13:9.1f}")
