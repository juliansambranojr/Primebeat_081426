"""O97 - the floor reconstruction, preregistered fresh-range test.

Prereg: preregs/floor_reconstruction_v1_20260828.md.  Run ONLY after that
prereg is LOCKED (sidecar present) and committed.

Claim under test (exploratory record: entries 247-252): the quiet floor of
S(x) = sum_{0<g<=T} e^{i g log x} is deterministic - reproduced by two
zero-parameter pieces, prime-power skirts and the density edge - on an
x-range never computed before this run: x in [512, 2048).

Every parameter below is locked by the prereg's table. No flags.
"""
import hashlib
import json
import sys
import numpy as np

sys.path.insert(0, "/Users/juliansambrano/GitHub/Primebeat_081426")
from utilities.resultsguard import guarded_write
from math import log, pi

# ---- locked parameters (prereg table; do not edit) ----
ZEROS = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
ZEROS_SHA = "3436c916a7878261ac183fd7b9448c9a4736b8bbccf1356874a6ce1788541632"
T = 74920.0
T_EDGE = 74919.667477          # midpoint of the bracketing zero gap
U_LO, U_HI = log(512), log(2048)
M = 4096
NMAX_LADDER = (10**6, 10**7)
DETREND_DEG = 4
QUIET_DEG = 3
OUT = "/Users/juliansambrano/GitHub/Primebeat_081426/results/floor_reconstruction_fresh.json"
# thresholds
R_PASS, RES_PASS = 0.98, 0.02
R_FAIL, RES_FAIL = 0.90, 0.05
LADDER_TOL = 0.005
# -------------------------------------------------------

sha = hashlib.sha256(open(ZEROS, "rb").read()).hexdigest()
gam = np.array([float(l.split()[0]) for l in open(ZEROS)])
g = gam[gam <= T]
N = len(g)

us = np.linspace(U_LO, U_HI, M, endpoint=False) + (U_HI - U_LO) / (2 * M)
xg = np.exp(us)

NMAX = NMAX_LADDER[-1]
sieve = np.ones(NMAX + 1, dtype=bool)
sieve[:2] = False
for p in range(2, int(NMAX ** 0.5) + 1):
    if sieve[p]:
        sieve[p * p::p] = False
primes = np.nonzero(sieve)[0]
ns, lams = [], []
for p in primes:
    q = int(p)
    while q <= NMAX:
        ns.append(q)
        lams.append(log(p))
        q *= int(p)
ns = np.array(ns, dtype=float)
lams = np.array(lams)
order = np.argsort(ns)
ns, lams = ns[order], lams[order]
vs = np.log(ns)
cs = -(1.0 / (2 * pi)) * lams / np.sqrt(ns)

print(f"O97 - floor reconstruction, fresh range [512, 2048).  PREREGISTERED.")
print(f"  zeros sha256 {sha[:16]}...  match: {sha == ZEROS_SHA}")
print(f"  T={T}  N={N}  edge={T_EDGE}  teeth {len(ns)} <= 1e7")


def measure(u):
    out = np.empty(len(u), dtype=complex)
    for i in range(0, len(u), 256):
        out[i:i + 256] = np.exp(1j * np.outer(u[i:i + 256], g)).sum(axis=1)
    return out


def build(stop_n):
    stop = int(np.searchsorted(ns, stop_n, side="right"))
    eu = np.exp(1j * T_EDGE * us)
    evm = np.exp(-1j * T_EDGE * vs[:stop])
    evp = np.conj(evm)
    acc = np.zeros(M, dtype=complex)
    for j in range(0, stop, 16000):
        blk = slice(j, min(j + 16000, stop))
        for i in range(0, M, 512):
            uu = us[i:i + 512, None]
            w1 = uu - vs[None, blk]
            w2 = uu + vs[None, blk]
            k1 = (eu[i:i + 512, None] * evm[None, blk] - 1.0) / (1j * w1)
            k2 = (eu[i:i + 512, None] * evp[None, blk] - 1.0) / (1j * w2)
            acc[i:i + 512] += (cs[None, blk] * (k1 + k2)).sum(axis=1)
    dens = (log(T_EDGE / (2 * pi)) / (2 * pi)
            * np.exp(1j * us * T_EDGE) / (1j * us))
    return acc + dens


def detrend(y, deg):
    V = np.vander(us, deg + 1)
    coef, *_ = np.linalg.lstsq(V, y, rcond=None)
    return y - V @ coef


Smeas = measure(us)
mr = detrend(Smeas.real, DETREND_DEG)
mi = detrend(Smeas.imag, DETREND_DEG)
ampq = np.hypot(detrend(Smeas.real, QUIET_DEG), detrend(Smeas.imag, QUIET_DEG))
quiet = np.zeros(M, dtype=bool)
for lo in (512, 1024):
    sel = (xg >= lo) & (xg < lo * 2)
    quiet[sel] = ampq[sel] < np.median(ampq[sel])
floor_med = float(np.median(np.hypot(mr, mi)[quiet]))

res = {}
for nm in NMAX_LADDER:
    Sm = build(nm)
    br = detrend(Sm.real, DETREND_DEG)
    bi = detrend(Sm.imag, DETREND_DEG)
    rRe = float(np.corrcoef(mr[quiet], br[quiet])[0, 1])
    rIm = float(np.corrcoef(mi[quiet], bi[quiet])[0, 1])
    frac = float(np.median(np.hypot(mr - br, mi - bi)[quiet]) / floor_med)
    res[nm] = {"r_Re": rRe, "r_Im": rIm, "resid_over_floor": frac}
    print(f"  Nmax {nm:.0e}:  r_Re {rRe:+.4f}  r_Im {rIm:+.4f}"
          f"  resid/floor {frac:.4f}")

final = res[NMAX_LADDER[-1]]
compromised = (
    sha != ZEROS_SHA
    or int(quiet.sum()) != M // 2
    or res[NMAX_LADDER[-1]]["resid_over_floor"]
       > res[NMAX_LADDER[0]]["resid_over_floor"] + LADDER_TOL
)
if compromised:
    outcome = "compromised"
elif (final["r_Re"] >= R_PASS and final["r_Im"] >= R_PASS
      and final["resid_over_floor"] <= RES_PASS):
    outcome = "floor_deterministic"
elif (final["r_Re"] < R_FAIL or final["r_Im"] < R_FAIL
      or final["resid_over_floor"] >= RES_FAIL):
    outcome = "floor_not_deterministic"
else:
    outcome = "inconclusive"

payload = {
    "prereg": "preregs/floor_reconstruction_v1_20260828.md",
    "zeros_sha256": sha, "T": T, "T_edge": T_EDGE, "N": N,
    "range": [512, 2048], "M": M, "quiet_n": int(quiet.sum()),
    "floor_median": floor_med, "ladder": {str(k): v for k, v in res.items()},
    "mechanical_output": outcome,
}
guarded_write(payload, OUT)
print(f"\nDECISION RULE OUTPUT (mechanical): {outcome}")
print("   The verdict line is Julian's to write.")
print(f"  results written to {OUT}")
