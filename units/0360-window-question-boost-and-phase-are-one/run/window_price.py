"""Price the window question of rung5 section 14 before building anything.

The object. For a window whose transform factors as unit 0347 proves for the
switched power window,

    S(w) = c * w * exp(w^2 * sigma) * (1 + E),   ||E|| <= 2q,

an off-line zero at w = (epsp + i*D)*h contributes 2*Re(S(w)^2) to the zero
side of the Weil form.  Writing A = arg(S), the sign of Re(S^2) = |S|^2 cos(2A)
is the sign of cos(2A), and

    A = arg(w) + Im(w^2)*sigma = arctan(D/epsp) + 2*epsp*D*h^2*sigma.

sigma is the ONLY thing the window sets: it is the tail sum of the window's
product, positive for the P^m family (sigma ~ 1/(pi^2 (m+1))).  So the family
of achievable phases, over all windows of this shape, is

    A(epsp, D; s) = arctan(D/epsp) + 2*epsp*D*h^2*s,  s = sigma >= 0 free.

QUESTION.  Is there an s >= 0 with cos(2A) <= 0 for every (epsp, D) in the box
0 < epsp <= 1/2, |D| <= 1/2?  Equivalently A mod pi in [pi/4, 3pi/4].

The box includes D -> 0 at fixed epsp, where arctan -> 0 and the second term
-> 0, so A -> 0 and cos(2A) -> 1 > 0.  So the answer is NO for every s, and
the obstruction is at D = 0: a zero at the target's own height.

This script checks that, and then asks the weaker and more useful question:
over what sub-box IS the sign fixed, and does the excluded neighbourhood of
D = 0 shrink as s grows -- i.e. can a window push the bad set below the
smallest height gap it would have to cover?
"""
import math

def A(epsp, D, s, h):
    return math.atan2(D, epsp) + 2 * epsp * D * h * h * s

def bad(epsp, D, s, h):
    """True when this zero HURTS: cos(2A) > 0."""
    return math.cos(2 * A(epsp, D, s, h)) > 0

print("1. the sign at D -> 0, any window (s free), any h")
for s in (0.0, 0.01, 0.1, 1.0, 10.0):
    for h in (1.0, 100.0, 1e4):
        vals = [round(math.cos(2 * A(0.25, D, s, h)), 6) for D in (1e-9, 1e-6, 1e-3)]
        print(f"   sigma={s:<6g} h={h:<8g} cos(2A) at D=1e-9,1e-6,1e-3: {vals}")
print("   cos(2A) -> 1 as D -> 0 for every sigma and every h: no window fixes the sign.")
print()

print("2. the bad set's width in D, at epsp = 1/2 (worst), as a function of sigma*h^2")
print(f"   {'sigma*h^2':>12} {'D_bad_max':>12} {'note':>28}")
for X in (1e-2, 1e-1, 1e0, 1e1, 1e2, 1e3, 1e4, 1e6):
    epsp = 0.5
    lo, hi = 0.0, 0.5
    # largest D with cos(2A) > 0 continuously from 0: first crossing of A = pi/4
    D = None
    steps = 2_000_00
    prev = 0.0
    for i in range(1, steps + 1):
        d = 0.5 * i / steps
        a = math.atan2(d, epsp) + 2 * epsp * d * X
        if a >= math.pi / 4:
            D = d
            break
    print(f"   {X:12g} {('%.6g' % D) if D else '>0.5':>12} {'first A = pi/4':>28}")
print("   the bad neighbourhood of D = 0 shrinks like 1/(sigma h^2): a window with a")
print("   larger sigma pushes it down, and sigma ~ 1/(pi^2 (m+1)) with m+1 = lam*h,")
print("   so sigma*h^2 = h/(lam pi^2) and the bad width is ~ lam pi^2/(4 epsp h).")
print()

print("3. what the bad width has to beat: the height gap to the nearest other zero.")
print("   average gap at height T is 2 pi / log T. Setting lam pi^2/(4 epsp h) < 2 pi / log T")
for T in (1e3, 1e6, 1e12):
    for lam in (1, 100):
        for epsp in (0.5, 0.1):
            gap = 2 * math.pi / math.log(T)
            h_need = lam * math.pi**2 / (4 * epsp * gap)
            print(f"   T={T:<8g} lam={lam:<5g} eps'={epsp:<5g} gap={gap:.4f}  h > {h_need:.4g}")
print("   h grows only linearly in lam and in log T: this is a threshold, not a barrier.")

print()
print("4. CORRECTION to 2: the phase keeps turning, so the bad set is not a")
print("   neighbourhood of D = 0 but a union of stripes. Measure of the bad set")
print("   (cos(2A) > 0) over D in [0, 1/2], at eps' = 1/2:")
print(f"   {'sigma*h^2':>12} {'bad measure':>13} {'as fraction':>12} {'stripe width':>14}")
for X in (1e-2, 1e0, 1e2, 1e4, 1e6):
    epsp, n, bad_n = 0.5, 2_000_000, 0
    for i in range(n):
        d = 0.5 * (i + 0.5) / n
        a = math.atan2(d, epsp) + 2 * epsp * d * X
        if math.cos(2 * a) > 0:
            bad_n += 1
    meas = 0.5 * bad_n / n
    stripe = math.pi / (4 * epsp * X) if X > 0 else float('inf')
    print(f"   {X:12g} {meas:13.6f} {meas/0.5:12.4f} {stripe:14.3g}")
print("   the fraction tends to 1/2: half the box hurts, in stripes that get finer")
print("   as sigma*h^2 grows. Shrinking the stripes does not shrink the measure.")
print()
print("5. so the window question answers NO in the strong form and NO in the")
print("   weak form: no window of this shape makes the off-line sign fixed, and")
print("   no choice of h confines the hurting zeros to a small set. The phase")
print("   turning IS the obstruction, and sigma only sets how fast it turns.")

print()
print("6. WHY. The boost and the phase are the same object. For any window of")
print("   this shape the transform carries exp(w^2 * sigma), and")
print("      |exp(w^2 sigma)| = exp((eps'^2 - D^2) h^2 sigma)   <- the boost")
print("      arg exp(w^2 sigma) = 2 eps' D h^2 sigma             <- the phase")
print("   one sigma, both effects. Detection needs the boost at the target,")
print("   which forces the sweep at every other off-line zero.")
print(f"   {'sigma*h^2':>12} {'log boost at D=0':>18} {'phase per unit D':>18}")
for X in (1e0, 1e2, 1e4, 1e6):
    epsp = 0.5
    print(f"   {X:12g} {epsp**2 * X:18.4g} {2*epsp*X:18.4g}")
print("   the boost is exp(eps'^2 X) and the sweep is 2 eps' X: making the boost")
print("   big makes the sweep fast, at the same rate in X. sigma = 0 removes the")
print("   sweep (sign becomes (eps'^2 - D^2)/(eps'^2 + D^2), fixed) and removes")
print("   the boost with it, so the target no longer beats the background.")
