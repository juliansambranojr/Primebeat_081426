import math, sys
sys.path.insert(0,'/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/e0529930-f9ed-407f-aa48-0dd5f402f85a/scratchpad')
from mpmath import mp; mp.dps=50
import rebuild_census_price as R
print("classical zero-free region sigma > 1 - 1/(R log t)  =>  c = 1/sqrt(R)")
print("   (balance log x/(R u) = u at u = log T; log^2 factors ignored, they only hurt)")
print(f"{'R (upstream)':>14}{'c=1/sqrt(R)':>13}{'depth_cov':>11}   {'c=sqrt(2/R)':>12}{'depth_cov':>11}")
for Rz,lab in ((5.573412,'MT_theorem_1'),(5.5666305,'MT_R0'),(5.558691,'MTY'),(4.896,'BTY')):
    out=[]
    for c in (1/math.sqrt(Rz), math.sqrt(2/Rz)):
        Rs={d:R.R_of(d, lambda r,d_,c=c: R.E_high_unc(r,d_,1.0,c,0.5), 2657.0, rmax=400) for d in range(1,25)}
        out += [f"{c:.4f}", str(R.depth_covered(Rs))]
    print(f"{Rz:>14}{out[0]:>13}{out[1]:>11}   {out[2]:>12}{out[3]:>11}   {lab}")
print()
for D,need in ((6,1.96),(15,3.87)):
    print(f"  depth {D:>2} needs c >= {need:.2f}  ->  R <= 1/c^2 = {1/need**2:.4f}"
          f"  (or <= 2/c^2 = {2/need**2:.4f})   vs best upstream R = 4.896")
    print(f"      i.e. a zero-free region {4.896*need**2:.0f}x  (or {4.896*need**2/2:.0f}x) stronger than the record")
