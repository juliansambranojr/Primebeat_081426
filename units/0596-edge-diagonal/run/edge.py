"""The deep corner of the true dyadic table to row 92, and the zeros that drive it.
pi_2pow.txt: pi(2^n) for n = 0..92, the list in lean/DepthSix.lean (OEIS A007053).
Zeros: imported/twin_count/zeros1.txt (the first 100000 ordinates). EXPLORATORY."""
import json, math
pi=[int(x) for x in open("pi_2pow.txt")]
a=[0]+[pi[m]-pi[m-1] for m in range(1,len(pi))]
T={}
for r in range(0,93): T[(r,0)]=a[r] if r>=1 else 0
for d in range(1,93):
    for r in range(0,93): T[(r,d)]=T[(r,d-1)]-(T[(r-1,d-1)] if r>=1 else 0)
out={"growth":{},"corner":{},"ranking":{}}
# growth along the edge diagonals r = g + d, per unit of depth, over 20 depths
for g in (5,10):
    rates=[(math.log(abs(T[(g+d,d)]))-math.log(abs(T[(g+d-20,d-20)])))/20 for d in range(40,93-g)]
    out["growth"][f"g{g}"]={"min":min(rates),"max":max(rates),"mean":sum(rates)/len(rates)}
out["growth"]["log_1_plus_sqrt2"]=math.log(1+math.sqrt(2))
# corner cells past r = 3.5 d: parents of opposite sign
opp=same=0
for r in range(20,93):
    for d in range(1,r):
        if 7*d<=2*r: continue
        x,y=T[(r,d-1)],T[(r-1,d-1)]
        if x*y<0: opp+=1
        else: same+=1
out["corner"]={"cells":opp+same,"opposite_parents":opp,"same_parents":same}
# zeros ranked by their weight on an edge cell at depth d: |2^rho - 1|^d / |rho|
L2=math.log(2)
g=[float(x) for x in open("../../../imported/twin_count/zeros1.txt").read().split()]
def lw(gam,d): return d*0.5*math.log(3-2*math.sqrt(2)*math.cos(gam*L2))-math.log(math.hypot(.5,gam))
for d in (10,40,80,320):
    s=sorted(g,key=lambda x:-lw(x,d))[:2]
    out["ranking"][f"d{d}"]={"leader":s[0],"lead_log":lw(s[0],d)-lw(s[1],d),
        "factor":math.sqrt(3-2*math.sqrt(2)*math.cos(s[0]*L2))}
json.dump(out,open("edge.json","w"),indent=1); print(json.dumps(out,indent=1))
