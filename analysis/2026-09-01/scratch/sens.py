import math, sys
sys.path.insert(0,'/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/e0529930-f9ed-407f-aa48-0dd5f402f85a/scratchpad')
from mpmath import mp
mp.dps=50
import rebuild_census_price as R
print("\n\n===== SENSITIVITY: A and x0, at the dlVP shape alpha=0.5 =====")
print("depth_covered; census bar is 6 for (20,6), 15 to match today's RH result")
print(f"{'c':>6}{'A':>10}{'log2 x0':>9}   depth_covered")
for c in (2.0,3.0,5.0):
    for A in (1.0,10.0,100.0,1e4):
        for lx0 in (11.4, 30.0, 60.0):
            Rs={d:R.R_of(d, lambda r,d_,A=A,c=c: R.E_high_unc(r,d_,A,c,0.5), 2.0**lx0, rmax=400) for d in range(1,25)}
            print(f"{c:>6}{A:>10.4g}{lx0:>9.1f}   {R.depth_covered(Rs)}")
print("\n===== max A tolerated, alpha=0.5, x0=2^11.4, for depth 6 and 15 =====")
for c in (2.0,3.0,4.0,6.0,10.0):
    out=[]
    for D in (6,15):
        lo,hi,ok=0.0,1e30,None
        for _ in range(200):
            mid=math.sqrt(max(lo,1e-9)*hi)
            Rs={d:R.R_of(d, lambda r,d_,A=mid,c=c: R.E_high_unc(r,d_,A,c,0.5), 2657.0, rmax=400) for d in range(1,D+1)}
            if R.depth_covered(Rs)>=D: lo=mid; ok=mid
            else: hi=mid
        out.append("none" if ok is None else f"{ok:.3g}")
    print(f"  c={c:<5} depth6: A<={out[0]:<12} depth15: A<={out[1]}")
