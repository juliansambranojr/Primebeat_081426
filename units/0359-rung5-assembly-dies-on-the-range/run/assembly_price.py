"""Price the assembly of rung5 section 13 before writing its block.

Setup, from the proved blocks:
  target at eps (largest real part in the box, section 8), member at (epsp, D)
  window m+1 = lam*h;  u(h) = h/(lam*pi^2) to leading order (unit 0350)
  member's weighted term, relative to the target (unit 0347 re_S_sq_ge):
     ((epsp^2+D^2)/eps^2) * exp(2(epsp^2 - D^2 - eps^2) u) * cos/sin bracket
  section 8 picks the target with epsp <= eps, so the exponent is <= -2 D^2 u:
  every member decays, and its total over all h is at most lam*pi^2/(2 D^2).

  Block 13g: a member helps (term >= 0) while its phase stays under the sign
  condition, which for D << epsp is D * b <= lo,  lo = lam*pi^3/(8 epsp).
  So members with D <= lo/b are free; the rest cost at most lam*pi^2/(2 D^2)
  each, worst case all N of them sitting at D = lo/b.

  Target gives at least 1 per h, so at least b - h0 over the range.

Requirement:  N * lam*pi^2/(2*(lo/b)^2)  <  b - h0  ~  b
  =>  b  <  2*lo^2/(N*lam*pi^2)  =  lam*pi^4/(32*N*epsp^2)   =: b_max

Threshold (section 12): h0 ~ 2*pi^2*lam*log(P)/eps^2, P the polynomial in the
background and the lost prefactors.

The test is b_max / h0.  If it is under 1 there is no range at all.
"""
import math

def ratio(N, logP, eps, epsp, lam):
    b_max = lam * math.pi**4 / (32 * N * epsp**2)
    h0 = 2 * math.pi**2 * lam * logP / eps**2
    return b_max, h0, b_max / h0

print("closed form:  b_max/h0 = pi^2 * eps^2 / (64 * N * epsp^2 * logP)")
print("at epsp = eps:          = %.4f / (N * logP)" % (math.pi**2 / 64))
print()
print(f"{'N':>6} {'logP':>6} {'eps':>6} {'lam':>8} {'b_max':>12} {'h0':>14} {'ratio':>10}")
for N in (1, 10, 100):
    for logP in (1, 10):
        for eps in (0.5, 0.1):
            for lam in (1, 100, 10**6):
                b, h, r = ratio(N, logP, eps, eps, lam)
                print(f"{N:6d} {logP:6g} {eps:6g} {lam:8g} {b:12.3g} {h:14.3g} {r:10.5f}")
print()
print("lam cancels: b_max and h0 are both linear in lam, so no window width helps.")
print("eps cancels at epsp = eps. The ratio is pi^2/(64 N logP), under 1 for every")
print("N >= 1 and logP >= 1: the range must be shorter than the threshold it starts at.")
