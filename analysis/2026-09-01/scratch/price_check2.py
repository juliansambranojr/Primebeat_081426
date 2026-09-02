import math
LN2 = math.log(2)

def gate(r, d, c, alpha, A=1.0):
    n = d + 1
    if r - n <= 1: return False
    L = ((r - n) * LN2) ** alpha
    lhs = math.log(A) - c*L + n*math.log(1.5)
    rhs = math.log(0.5) - (d+1)*LN2 + d*math.log(LN2) - math.log(r)
    return lhs < rhs

def crossover(d, c, alpha, rmax=10**9):
    if not gate(rmax, d, c, alpha): return None
    lo, hi = 2, rmax
    while lo < hi:
        mid = (lo+hi)//2
        if gate(mid, d, c, alpha): hi = mid
        else: lo = mid+1
    return lo

shapes = [
    ("PNT+ MediumPNT  (log x)^0.10  [FORMALIZED, sorry-free]", 0.10),
    ("de la Vallee Poussin (log x)^0.50  [classical, 1899]", 0.50),
    ("Vinogradov-Korobov  (log x)^0.60  [best known]", 0.60),
]
for name, alpha in shapes:
    print(f"\n{name}")
    print(f"  {'c':>6} " + " ".join(f"d={d:<10}" for d in (1,3,6,10)))
    for c in (1.0, 0.3, 0.1, 0.03):
        row=[]
        for d in (1,3,6,10):
            r = crossover(d, c, alpha)
            row.append("—" if r is None else f"2^{r:.4g}")
        print(f"  {c:>6} " + " ".join(f"{v:<12}" for v in row))
print("\n(— means no r below 2^1e9)")
print("\nRH shape, same gate, exact Lean defs:  d=1:r>=16  d=3:r>=29  d=6:r>=45  d=10:r>=66")
