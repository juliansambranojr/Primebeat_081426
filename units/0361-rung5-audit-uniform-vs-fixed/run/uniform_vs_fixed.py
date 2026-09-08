"""Audit of unit 0359: what its comparison priced, and the argument that
actually kills a uniform L.

FIXED configuration. Members j = 1..N at height offsets D_j > 0 from the
target, real parts <= the target's (section 8). Unit 0347: a member's term
relative to the target's is at most exp(-2 D_j^2 u(h)), u ~ h/(lam pi^2), so
its total hurt over all h >= a is at most lam*pi^2/(2 D_j^2) * amp, a number
that does not depend on the range's top b. The target earns b - h0. So

    b = h0 + sum_j lam*pi^2/(2 D_j^2) * amp   closes, for every fixed set D_j.

0359 instead put every member at D = lo/b and got b < lam pi^4/(32 N eps'^2).
That D depends on b; the zeros do not move when the range is chosen.

UNIFORM L. The rung wants L(eps, T) with no D in it, so b is chosen from an
explicit finite menu before the zeros are seen. Member j hurts at most
min(b, lam pi^2/(2 D_j^2)) once D_j > lo/b (below that it is free, block 13g).
It blocks a menu value b when its hurt exceeds (b - h0)/N:

    lo/D_j < b < lam pi^2 N/(2 D_j^2) + h0,

an interval in b of log-length about log(N lam pi^2/(2 lo D_j)). A member
with lo/D_j above the menu's top B blocks nothing, so D_j >= lo/B and each
member blocks at most log(N B/b1) in log b, b1 = 2 lo^2/(lam pi^2).
N members block at most N log(N B/b1). The menu [h0, B] has log-length
log(B/h0). A clean b exists only if

    log(B/h0) > N log(N B/b1),   i.e.   B/h0 > (N B/b1)^N.

With b1 < h0 (0359's ratio, pi^2 eps^2/(64 N eps'^2 log P), is b1/h0 up to
the constant) the right side is at least (B/h0)^N, and N >= 2 makes it false
for every B. That is the death, and it is a death of uniformity in the
configuration, which 0359 never stated.
"""
import math

def fixed_closes(D, lam=1.0, eps=0.25, h0=1000.0, amp=1.0):
    cost = sum(lam * math.pi**2 / (2 * d * d) * amp for d in D)
    return h0 + cost

def escalation(N, h0, b1, steps):
    """Greedy cover of the menu from h0 upward. A member placed with its
    blocked interval starting at beta blocks up to N*beta^2/b1 (its hurt
    exceeds (b-h0)/N there). The next member starts where that ends."""
    tops = []
    lb = math.log10(h0)
    for _ in range(steps):
        lb = math.log10(N) + 2 * lb - math.log10(b1)   # log10 of N*beta^2/b1
        tops.append(lb)
    return tops

print("1. fixed configuration: the closing b for a few member sets (lam=1, eps=1/4, h0=1000)")
for D in ([0.5], [0.1, 0.2, 0.3], [0.01] * 10, [1e-3] * 100):
    print(f"   D = {D[:3]}{'...' if len(D) > 3 else ''}  (N={len(D)})  ->  b = {fixed_closes(D):.4g}")
print("   every set closes; b grows like 1/D_min^2, never fails")
print()
print("2. uniform menu: how far N members can block, greedily, from h0 = 1000 with")
print("   b1/h0 = 0.154 (0359's ratio at N = 1, log P = 1). A clean b exists only above")
print("   the last top. In log10 of b:")
h0 = 1000.0; b1 = 0.154 * h0
print(f"   {'N':>4} " + " ".join(f"{'top_'+str(k):>9}" for k in (1, 2, 3, 4)) + f" {'top_N':>12}")
for N in (1, 2, 3, 5, 15):
    t = escalation(N, h0, b1, N)
    row = [f"{t[k-1]:9.1f}" if k <= N else f"{'':>9}" for k in (1, 2, 3, 4)]
    print(f"   {N:4d} " + " ".join(row) + f" {t[-1]:12.3g}")
print("   top_k squares at every step: with N members the menu must reach b ~ h0^(2^N),")
print("   doubly exponential in N. At N = 15 log T + 73 that is beyond any polynomial in T.")
print("   That is the death of a uniform L. A fixed configuration closes at item 1's b.")
