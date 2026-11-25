# C (a) Gram's law and (b) S(t) on windows, computed with mpmath.
import mpmath as mp, json
mp.mp.dps = 15
N = 1000
bad = []          # Gram points g_n with (-1)^n Z(g_n) <= 0
signs = []
for n in range(-1, N):
    g = mp.grampoint(n)
    z = mp.siegelz(g)
    s = (-1)**n * z
    signs.append((n, float(g), float(s)))
    if s <= 0: bad.append(n)
# Gram blocks: maximal runs between consecutive good Gram points; Rosser's rule: block of length k holds >= k sign changes
good = [n for (n, g, s) in signs if s > 0]
blocks = []
for i in range(len(good) - 1):
    a, b = good[i], good[i+1]
    if b - a > 1: blocks.append((a, b))
def zeros_in(x, y, steps):
    xs = [x + (y - x) * j / steps for j in range(steps + 1)]
    v = [mp.siegelz(t) for t in xs]
    return sum(1 for j in range(steps) if v[j] * v[j+1] < 0)
rosser_fail = []
for (a, b) in blocks:
    ga, gb = mp.grampoint(a), mp.grampoint(b)
    k = b - a
    c = zeros_in(ga, gb, 60 * k)
    if c < k: rosser_fail.append((a, b, c))
# S(t) at Gram points: S(g_n) = N(g_n) - theta(g_n)/pi - 1 = N(g_n) - n - 1
res = {"gram_points_checked": len(signs), "gram_bad_count": len(bad), "gram_first_bad": bad[0] if bad else None,
       "gram_bad_fraction": len(bad) / len(signs), "gram_blocks": len(blocks),
       "rosser_failures": len(rosser_fail), "height_last": signs[-1][1]}
json.dump(res, open('results.json', 'w'), indent=1)
