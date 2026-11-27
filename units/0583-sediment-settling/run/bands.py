# Exploratory, chosen after seeing results.json: split each N's right-of-line zeros
# by the Riemann-Siegel band t in [2 pi N^2, 2 pi (N+1)^2], where N terms are the
# number that belongs at height t. Strips of height 5 from t = 1; a strip counts as
# in the band when it overlaps it, below when it ends at or before the band's start,
# above when it starts at or after its end. Bands past t = 201 are not measured.
import json, math
r = json.load(open("results.json"))
out = {}
for N in range(1, 13):
    s = r[f"N{N}_right_by_strip"]; starts = [1 + 5 * i for i in range(len(s))]
    lo, hi = 2 * math.pi * N * N, 2 * math.pi * (N + 1) ** 2
    out[f"N{N}_band_lo"] = lo; out[f"N{N}_band_hi"] = hi
    out[f"N{N}_band_measured"] = lo < 201
    out[f"N{N}_in_band"] = sum(k for t, k in zip(starts, s) if t < hi and t + 5 > lo)
    out[f"N{N}_below_band"] = sum(k for t, k in zip(starts, s) if t + 5 <= lo)
    out[f"N{N}_above_band"] = sum(k for t, k in zip(starts, s) if t >= hi)
json.dump(out, open("bands.json", "w"), indent=1)
print(json.dumps(out))
