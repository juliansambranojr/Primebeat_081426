"""The four zeros as row turnovers, and the bands (EXPLORATORY). Along each row the cells start positive (the smooth
part leads); the first depth where a cell is <= 0 is the row's turnover. Code per row 2..92: Z = the turnover is an
exact zero, E = it comes by depth r/2, L = later, . = never. Bands: in windows of six rows, how many even and how many
odd rows turn by depth r/2 (E or Z). The first zero's drift along the turnover path: its offset from the nearest odd
harmonic per row, plus half its per-depth turn arg(1 - 2^-rho), the path running at depth about r/2."""
import json, math, cmath
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92; a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
T = {}
for r in range(1, M + 1): T[(r, 0)] = a[r]
for d in range(1, M):
    for r in range(d + 1, M + 1): T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
sg = lambda v: '+' if v > 0 else ('-' if v < 0 else '0')
out = {"zeros": {}}
for z in ((2, 1), (4, 1), (8, 3), (20, 6)):
    r, d = z
    out["zeros"][f"{r}_{d}"] = {"row_signs": "".join(sg(T[(r, k)]) for k in range(r)),
        "parents": [T[(r, d - 1)], T[(r - 1, d - 1)]], "below": T.get((r, d + 1)), "above_prev_row": T.get((r - 1, d)),
        "diag_below": T.get((r + 1, d + 1)), "diag_parent": T.get((r + 1, d)), "corner_2r_lt_7d": 2 * r < 7 * d}
code = ''
for r in range(2, M + 1):
    f = next((d for d in range(1, r) if T[(r, d)] <= 0), None)
    code += '.' if f is None else ('Z' if T[(r, f)] == 0 else ('E' if f <= r / 2 else 'L'))
out["code_rows_2_92"] = code
out["zero_turnovers"] = code.count('Z')
bands = {}
for s in range(2, M - 4, 6):
    bands[f"{s}_{s+5}"] = {"even": sum(1 for r in range(s, s + 6) if r % 2 == 0 and code[r - 2] in 'EZ'),
                           "odd": sum(1 for r in range(s, s + 6) if r % 2 == 1 and code[r - 2] in 'EZ')}
out["bands"] = bands
g1 = 14.134725141734693; L2 = math.log(2)
delta = ((g1 * L2) % (2 * math.pi)) - math.pi
per_depth = cmath.phase(1 - 2 ** complex(-0.5, -g1))
out["first_zero"] = {"offset_per_row": round(delta, 4), "turn_per_depth": round(per_depth, 4),
    "drift_along_path": round(delta + per_depth / 2, 4), "half_beat_rows_offset_only": round(math.pi / abs(delta), 1),
    "half_beat_rows_along_path": round(math.pi / abs(delta + per_depth / 2), 1)}
json.dump(out, open("turnover.json", "w"), indent=1); print(json.dumps(out, indent=1))
