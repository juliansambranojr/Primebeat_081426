import math
e_2pi = math.e/(2*math.pi)          # 0.4326
log2   = math.log(2)

def Cpsi(L, M, Mp, verbose=False):
    """C_psi at exponent k=3, valid for all x with log x >= L (floor)."""
    S = math.exp(L/2)               # sqrt(X) at the floor
    # --- ζ'/ζ inputs (all GREEN) ---
    Bcomp = 25200 + 115*L                        # slice 4,  |t| <= 2
    Btail = 15*L**2 + 3373*L + 16038             # slice 3,  2 <= |t| <= X, sigma1 = 1/2+1/L
    Bsig0 = lambda t: 3330*math.log(t) + 16184   # slice 3 at sigma0 = 1+1/L
    # --- I37 : vertical at sigma1, X^{sigma1} = e*sqrt(X), Mellin <= 3M/|s| ---
    Ismall = 2*(1 + math.log(2/0.5))             # int_{|t|<=2} dt/max(s1,|t|)  <= 2(1+log4)
    Ilarge = 2*(L - log2)                        # int_{2<=|t|<=X} dt/|t|
    I37 = e_2pi * 3*M * S * (Bcomp*Ismall + Btail*Ilarge)
    # --- I2 + I8 : horizontal at |t| = T = X, Mellin <= 3M/X, length 1/2, X^sigma <= eX ---
    I28 = 2 * e_2pi * 0.5 * 3*M * Btail
    # --- I1 + I9 : |t| >= T on sigma0, Mellin <= 6M'/(eps |s|^2), eps = X^{-1/2} ---
    I19 = 2 * e_2pi * 6*Mp * S * (3330*(L+1) + 16184)
    # --- psi_eps - psi : SmoothedChebyshevClose, C = 6(3c1+c2) = 30 log 2 ---
    close = 30*log2 * (1/S) * math.exp(L) * L    # eps*X*log X = sqrt(X)*L
    # --- Mellin at 1 : |M(1)-1| <= 6 M log2 * eps, times X ---
    box = 6*M*log2 * S
    tot = I37 + I28 + I19 + close + box
    C = tot / (S * L**3)
    if verbose:
        for n,v in [("I37",I37),("I2+I8",I28),("I1+I9",I19),("close",close),("box",box)]:
            print(f"   {n:8s} {v/(S*L**3):12.2f}")
    return C

print("bump-free structure:  C_psi = a(L)*M + b(L)*M' + c(L)")
for L in [10.397, 15, 20.79, 30, 50, 100]:
    a = Cpsi(L,1,0)-Cpsi(L,0,0); b = Cpsi(L,0,1)-Cpsi(L,0,0); c = Cpsi(L,0,0)
    print(f"  L={L:7.3f}  (x0=2^{L/log2:5.1f})   a={a:9.1f}   b={b:8.1f}   c={c:7.3f}")

print()
print("delivered C_pi = 3*C_psi + 13, pi-side floor = x0^2")
for (M,Mp,tag) in [(1.0,4.0,"optimistic bump"),(1.7,7.0,"plausible bump"),(3.0,15.0,"conservative bump")]:
    print(f"  {tag}:  M={M}, M'={Mp}")
    for L in [10.397, 20.79]:
        Cp = 3*Cpsi(L,M,Mp)+13
        print(f"     psi-floor 2^{L/log2:4.1f} -> pi-floor 2^{2*L/log2:4.1f}:  C_psi={Cpsi(L,M,Mp):10.1f}   C_pi={Cp:11.1f}")
print()
print("breakdown at L=10.397 (psi floor 2^15 -> pi floor 2^30), M=1.7, M'=7:")
Cpsi(10.397,1.7,7.0,verbose=True)
