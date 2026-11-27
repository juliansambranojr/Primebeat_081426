> Source: session transcript, 2026-11-27

> All three

The second and third of the three, as offered: "log tonight's two findings as units: the rows 1–20 census, and the edge-diagonal result that the corner is where offline zeros would show", and "go after the corner directly."

From `run/edge.py`, the weight a zero carries on an edge cell at depth d:

```
def lw(gam,d): return d*0.5*math.log(3-2*math.sqrt(2)*math.cos(gam*L2))-math.log(math.hypot(.5,gam))
```
