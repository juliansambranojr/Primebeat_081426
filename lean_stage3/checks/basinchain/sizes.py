"""Sizes of step 4 of block S15 (the chain from no right zeros), checked before proving.

The increment bound proved in Stage3/BasinChainCount.lean, for a, b in [T/4, 2T] off the heights
of zeros and V = ConreyCount.V Q (log T) with no zeros right of the line in [1/2, 3] x [a, b]:

  D(b) - D(a) < [S(b) + h(b)/pi] - [S(a) + h(a)/pi] + 1 + |R|/pi,
  h(t) = Im int_{1/2}^{3} V'/V (x + it) dx,   R = Re int_a^b V'/V (3 + it) dt.

|R| <= 2 arcsin r when |V(3 + it) - 1| <= r < 1 (here r = pi^2/6 - 1 + 1/100 from
LevinsonSize.norm_G_sub_one_le and DigammaBound's |V - zeta| <= 1/100).  Averaging a over
[A, A + h], b over [B, B + h] (A + h <= B), with int h = J(t1) - J(t2), J(t) = int log|V|:

  D(B) - D(A + h) <= c0 + E(T, h),
  c0 = 1 + 2 arcsin(r)/pi,
  E  = [2 (a log 2T + b) + (2 U + 2 Lo)/pi] / h,

a, b of LittlewoodSharp.littlewood_sharp; U the upper bound of J (5/2 log(A_Q 2T)), Lo the
open lower bound (a2 log 2T + b2).  D even and >= 0 on increments (monotone), so c0 + E < 2
gives D(B) = D(A + h).
"""
import mpmath as mp

mp.mp.dps = 30
pi = mp.pi

print("== 1. the constant c0 (no T in it) ==")
r_crude = pi**2 / 6 - 1 + mp.mpf(1) / 100
for name, r in [("crude r = pi^2/6 - 1 + 1/100", r_crude),
                ("sharp r = zeta(3) - 1 + 1/100", mp.zeta(3) - 1 + mp.mpf(1) / 100),
                ("r -> 1 (only Re V > 0)", mp.mpf(1))]:
    cR = 2 * mp.asin(r) / pi
    print(f"  {name:34s} r = {mp.nstr(r, 6):8s} |R|/pi <= {mp.nstr(cR, 6):8s} c0 = {mp.nstr(1 + cR, 6)}")
print("  the crude right edge |R| <= pi (right_edge_le_of_re_pos) gives c0 = 2: no margin.")

print("\n== 2. the right edge measured, V = zeta (Q = 1), max |arg zeta(3 + it)| ==")
mx = mp.mpf(0)
for k in range(0, 4001):
    t = 1000 + k * mp.mpf(0.25)
    mx = max(mx, abs(mp.arg(mp.zeta(3 + 1j * t))))
print(f"  t in [1000, 2000], step 1/4: max |arg| = {mp.nstr(mx, 6)}, 2 max/pi = {mp.nstr(2*mx/pi, 6)}"
      f"  (bound 2 arcsin r/pi = {mp.nstr(2*mp.asin(r_crude)/pi, 6)})")

print("\n== 3. the averaged error E(T, h) ==")
a = (mp.mpf(3) / 2 + mp.mpf(113) / 4) / pi
b = (2 + mp.mpf(3) / 2 * mp.log(9) + 128) / pi
c0 = 1 + 2 * mp.asin(r_crude) / pi
margin = 2 - c0
print(f"  littlewood_sharp a = {mp.nstr(a, 6)}, b = {mp.nstr(b, 6)}; margin 2 - c0 = {mp.nstr(margin, 6)}")
# stand-ins for the open lower side and A_Q: the zeta values scaled to the length 5/2, log A_Q = 170
logA = mp.mpf(170)
a2 = mp.mpf(113) / 4 * mp.mpf(5) / 3
b2 = 128 * mp.mpf(5) / 3 + a2 * logA


def E(T, h):
    L2 = mp.log(2 * T)
    U = mp.mpf(5) / 2 * (logA + L2)
    Lo = a2 * L2 + b2
    return (2 * (a * L2 + b) + (2 * U + 2 * Lo) / pi) / h


print(f"  stand-ins: log A_Q = {logA}, a2 = {mp.nstr(a2, 5)}, b2 = {mp.nstr(b2, 6)}")
for T in [mp.mpf(10)**k for k in (4, 6, 8, 12, 20, 40)]:
    eq = E(T, T / 4)
    L = mp.log(T)
    # h = C log T: smallest C with E < margin
    lo, hi = mp.mpf(1), mp.mpf(10)**8
    for _ in range(200):
        mid = (lo + hi) / 2
        if E(T, mid * L) < margin:
            hi = mid
        else:
            lo = mid
    print(f"  T = 1e{int(mp.log10(T)):<3d} h = T/4: c0 + E = {mp.nstr(c0 + eq, 8):12s}"
          f" h = C log T needs C >= {mp.nstr(hi, 6)} (h/T = {mp.nstr(hi*L/T, 3)})")
print("  E = O(log T / h): every h with h/log T -> infinity and h <= T/4 closes it; no factor is lost.")

print("\n== 4. where the closing height sits ==")
print("  DigammaBound.stmtVEdges_holds: T >= 200 + exp(8 + 400 K_Q B), B = exp(2|C| + 160) (gamma_ratio).")
print(f"  log log T0(Q) >= log(400 B) >= {mp.nstr(mp.log(400) + 160, 6)}: the window count holds only at")
print("  heights T0 with log log T0 > 166, and the base D(T*) = 0 is asked there.")

print("\n== 5. the base ==")
print("  The count is a difference count: V = V Q (log T) is controlled only on [T/4, 2T]")
print("  (ConreyCount header), so the averaging bounds D(B) - D(A + h) and never D(B).")
print("  Result: D(T) = D(3T/4) for T >= T*, so D is constant from T* on.  D(T*) = 0 is a")
print("  separate input (a finite computation at height T*); monotonicity then gives D = 0 below.")
