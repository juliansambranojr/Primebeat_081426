"""The per-depth gain of a zero at real part beta on the on-line zeros' top edge factor,
(2^beta + 1)/(2^(1/2) + 1), against the per-row gain 2^(beta - 1/2). Exploratory check of
OfflineGain.offline_gain_le at a few beta."""
import json, math
out={}
for b in (0.55, 0.6, 0.75, 1.0):
    out[f"b{int(b*100)}"]={"depth_gain":(2**b+1)/(2**0.5+1),"row_gain":2**(b-0.5),
        "depth_gain_log":math.log((2**b+1)/(2**0.5+1)),"row_gain_log":(b-0.5)*math.log(2)}
json.dump(out,open("gain.json","w"),indent=1); print(out)
