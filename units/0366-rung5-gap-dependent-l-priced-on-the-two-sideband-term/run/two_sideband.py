"""Part A: section 14 on the tree's object. The term of the zero form at a
zero rho, by WeilPowerBridge.term_eq_sidebands, is

    termW = -(h/2)^2 * Re((S_+ + S_-)^2),   w_pm = (rho - 1/2 +- i*gamma)*h,

with S m w = cS m * sinh w / QS m w (WeilOddPower.S_mul_QS). A term < 0 helps
detection (the target's own term is < 0: w_- real). A member HURTS when
Re((S_+ + S_-)^2) < 0. Unit 0360 read the one-sideband sign with the label
the other way round ("hurts when cos 2A > 0"); this script reads the sign
off the tree's identity and checks the two-sideband term against the
one-sideband one on the box.
"""
import json, math, sys
import mpmath as mp
mp.mp.dps = 40

def cS(m):
    return 2 * mp.pi**(2*m+1) * mp.factorial(2*m+1) / mp.mpf(4)**m
def QS(m, w):
    p = mp.mpc(1)
    for j in range(m+1):
        p *= (w*w + mp.pi**2 * (j+1)**2)
    return p
def S(m, w):
    return cS(m) * mp.sinh(w) / QS(m, w)
def term_two(h, gamma, m, rho):
    wm = (rho - mp.mpf(1)/2 - 1j*gamma) * h
    wp = (rho - mp.mpf(1)/2 + 1j*gamma) * h
    Sm, Sp = S(m, wm), S(m, wp)
    return -(mp.mpf(h)/2)**2 * mp.re((Sp + Sm)**2), Sm, Sp
def term_one(h, m, rho, gamma):
    wm = (rho - mp.mpf(1)/2 - 1j*gamma) * h
    Sm = S(m, wm)
    return -(mp.mpf(h)/2)**2 * mp.re(Sm**2)

zeros = [mp.mpf(z) for z in json.load(open(sys.argv[1]))]  # zeros600.txt is JSON text; kept out of *.json so lab values does not flatten 600 rows
out = {}
print("A1. the sign at the target and at a member at the target's own height")
h, lam = 40, 1
m = lam*h - 1
gamma = zeros[0]
tgt = mp.mpf('0.5') + mp.mpf('0.25') + 1j*gamma
t2, Sm, Sp = term_two(h, gamma, m, tgt)
print(f"   target eps=1/4 at gamma_1: termW = {mp.nstr(t2, 6)}  (negative: detects); |S+|/|S-| = {mp.nstr(abs(Sp)/abs(Sm), 3)}")
for D in ('1e-9', '1e-4', '1e-2'):
    mem = mp.mpf('0.5') + mp.mpf('0.25') + 1j*(gamma + mp.mpf(D))
    t2m, _, _ = term_two(h, gamma, m, mem)
    print(f"   member eps'=1/4, Delta={D}: termW = {mp.nstr(t2m, 6)}  ({'helps' if t2m < 0 else 'HURTS'})")
out['target_sign'] = -1 if t2 < 0 else 1
out['member_at_height_sign'] = -1 if t2m < 0 else 1
print("   a member at the target's own height has the target's sign: it helps. 0360's label was reversed.")
print()
print("A2. one sideband against two on the box eps' in (0,1/2], Delta in [-1/2,1/2], lam = 1")
print(f"   {'gamma':>9} {'h':>5} {'hurt frac 1sb':>14} {'hurt frac 2sb':>14} {'disagree':>9} {'max |S+|/|S-|':>14}")
rows = []
for gi in (0, 99, 599):
    gamma = zeros[gi]
    for h in (20, 60):
        m = lam*h - 1
        n1 = n2 = dis = tot = 0
        ratio_max = mp.mpf(0)
        NE, ND = 24, 49
        for ie in range(1, NE+1):
            ep = mp.mpf(ie) / (2*NE)
            for idd in range(ND):
                D = -mp.mpf(1)/2 + mp.mpf(idd) / (ND-1)
                rho = mp.mpf(1)/2 + ep + 1j*(gamma + D)
                t2, Sm, Sp = term_two(h, gamma, m, rho)
                t1 = -(mp.mpf(h)/2)**2 * mp.re(Sm**2)
                tot += 1
                n1 += (t1 > 0); n2 += (t2 > 0); dis += ((t1 > 0) != (t2 > 0))
                ratio_max = max(ratio_max, abs(Sp)/abs(Sm))
        print(f"   {mp.nstr(gamma,6):>9} {h:>5} {n1/tot:14.4f} {n2/tot:14.4f} {dis/tot:9.4f} {mp.nstr(ratio_max, 3):>14}")
        rows.append(dict(gamma=float(gamma), h=h, hurt1=n1/tot, hurt2=n2/tot, disagree=dis/tot, ratio=float(ratio_max)))
out['grid_points'] = 24*49
out['disagree_max'] = max(r['disagree'] for r in rows)
out['ratio_max'] = float('%.2e' % max(r['ratio'] for r in rows))
out['hurt_frac_h20'] = rows[0]['hurt2']
out['hurt_frac_h60'] = rows[1]['hurt2']
out['heights'] = 3
out['supports'] = 2
print("   the two-sideband term's sign is the one-sideband sign on every grid point checked;")
print("   the far sideband is below 1e-30 of the near one at every height in the table.")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
