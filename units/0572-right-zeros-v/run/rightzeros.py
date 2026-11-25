# Exploratory: zeros of V_Q(s) = Q(-(1/L) d/ds) zeta(s) with Re s > 1/2, L = log T,
# counted by the winding number of V_Q around rectangles [1/2 + eps, 3] x [y, y + 1]
# over stretches [T, T + H].  V_Q is the reduction of Conrey's V (MeanQRed, unit 0558).
import mpmath as mp, json, math
mp.mp.dps = 15
EPS = 1e-6
SIDE = 24
STRETCHES = [(1000.0, 40.0), (5000.0, 40.0)]
def qpoly(q0, d3):
    d1 = 1 - q0 - d3          # Q(x) = q0 + d1(1-2x) + d3(1-2x)^3, Q(0) = 1, Q'(x) = Q'(1-x)
    return [q0 + d1 + d3, -2 * d1 - 6 * d3, 12 * d3, -8 * d3]
QS = {
    "levinson_1_minus_x": [1.0, -1.0],
    "conrey_Q0": [1.0, -0.54, -1.44, 0.96],
    "sym_q0_0.5_d3_m0.2": qpoly(0.5, -0.2),
    "sym_q0_0.5_d3_p0.2": qpoly(0.5, 0.2),
    "sym_q0_0.3_d3_0": qpoly(0.3, 0.0),
}
def make_V(q, L):
    def V(s):
        return mp.fsum(q[k] * (-1.0 / L) ** k * mp.zeta(s, derivative=k) for k in range(len(q)))
    return V
def winding(f, x0, x1, y0, y1):
    pts = ([mp.mpc(x0 + (x1 - x0) * k / SIDE, y0) for k in range(SIDE)] +
           [mp.mpc(x1, y0 + (y1 - y0) * k / SIDE) for k in range(SIDE)] +
           [mp.mpc(x1 - (x1 - x0) * k / SIDE, y1) for k in range(SIDE)] +
           [mp.mpc(x0, y1 - (y1 - y0) * k / SIDE) for k in range(SIDE)])
    vals = [f(z) for z in pts] + [f(pts[0])]
    tot = sum(float(mp.arg(vals[k + 1] / vals[k])) for k in range(len(vals) - 1))
    return round(tot / (2 * math.pi))
res = {"eps": EPS, "side_points": SIDE}
for (T, H) in STRETCHES:
    L = math.log(T)
    for name, q in QS.items():
        V = make_V(q, L)
        n = 0; boxes = 0
        y = T
        while y < T + H:
            w = winding(V, 0.5 + EPS, 3.0, y, y + 1.0)
            n += max(w, 0); boxes += 1 if w > 0 else 0
            y += 1.0
        key = f"T{int(T)}_{name}"
        res[key + "_zeros_right"] = n
        res[key + "_boxes_with_zero"] = boxes
json.dump(res, open("results.json", "w"), indent=1)
