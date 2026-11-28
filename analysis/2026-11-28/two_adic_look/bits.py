"""Binary structure of the cells (EXPLORATORY). v2 = trailing zero bits; a zero cell has v2 = infinity.
Real table vs a null: the same table built from rows whose low 20 bits are replaced by random bits.
Cells used for the comparison: rows <= 92 whose lowest row r-d is >= 26 (every row involved has >= 20 bits)."""
import math, random, json
pi=[int(x) for x in open('../../../units/0641-corner-residues/run/pi_2pow.txt')]
M=92; a=[0]+[pi[m]-pi[m-1] for m in range(1,M+1)]
def table(row):
    T={}
    for r in range(1,M+1):
        T[(r,0)]=row[r]
    for d in range(1,M):
        for r in range(d+1,M+1): T[(r,d)]=T[(r,d-1)]-T[(r-1,d-1)]
    return T
def v2(n):
    if n==0: return None
    return (n & -n).bit_length()-1
T=table(a)
cells=[(r,d) for r in range(2,M+1) for d in range(1,r) if r-d>=26]
real=[v2(T[c]) for c in cells]
print('cells compared', len(cells), 'zeros among them', sum(v is None for v in real))
random.seed(5); NULL=200; MASK=(1<<20)-1
hist_real=[0]*25; hist_null=[0]*25
per_d_real={}; per_d_null={}
for c,v in zip(cells,real):
    hist_real[min(v,24)]+=1; per_d_real.setdefault(c[1],[]).append(v)
for t in range(NULL):
    row=[0]+[(a[m] & ~MASK) | random.getrandbits(20) if a[m]>MASK else a[m] for m in range(1,M+1)]
    Tn=table(row)
    for c in cells:
        v=v2(Tn[c]); v=24 if v is None else min(v,24); hist_null[v]+=1; per_d_null.setdefault(c[1],[]).append(v)
hn=[h/NULL for h in hist_null]
print('v2  real  null-mean  geometric(1/2^(k+1))')
for k in range(0,16): print(k, hist_real[k], round(hn[k],1), round(len(cells)/2**(k+1),1))
print('>=16', sum(hist_real[16:]), round(sum(hn[16:]),2))
# tail test: count with v2 >= k for k=6..12 vs null distribution
for k in (6,8,10,12):
    obs=sum(v>=k for v in real)
    print('v2>=%d: real %d, null mean %.1f'%(k,obs,sum(hn[k:])))
# per depth: mean v2 real vs null, largest deviations
dev=[]
for d in sorted(per_d_real):
    r_=per_d_real[d]; n_=per_d_null[d]
    mr=sum(r_)/len(r_); mn=sum(n_)/len(n_); sd=(sum((x-mn)**2 for x in n_)/len(n_))**0.5/len(r_)**0.5
    dev.append(((mr-mn)/sd if sd>0 else 0, d, len(r_), round(mr,2), round(mn,2)))
dev.sort()
print('depths with mean v2 furthest below / above the null (z, d, cells, real, null):')
print(dev[:3]); print(dev[-3:])
zs=[x[0] for x in dev]; print('per-depth z: mean %.2f sd %.2f over %d depths'%(sum(zs)/len(zs),(sum(z*z for z in zs)/len(zs))**0.5,len(zs)))
# low bits uniformity mod 16 of real cells
from collections import Counter
cnt=Counter(T[c]%16 for c in cells); exp=len(cells)/16
print('mod 16 chi2 %.1f (15 dof, 5%% critical 25.0)'%sum((cnt[i]-exp)**2/exp for i in range(16)))
# middle-bit density: for |cell| with >= 24 bits, bits 4..(len-4)
ones=tot=0
for c in cells:
    n=abs(T[c]); L=n.bit_length()
    if L>=24:
        for b in range(4,L-4): ones+=(n>>b)&1; tot+=1
print('middle bits: %.4f ones over %d bits'%(ones/tot,tot))
# around the four zeros (small rows, not in the comparison): v2 of the neighbours
for z in ((2,1),(4,1),(8,3),(20,6)):
    r,d=z; nb=[(r+i,d+j) for i in (-1,0,1) for j in (-1,0,1) if (i,j)!=(0,0) and 1<=d+j<r+i<=M]
    print('zero',z,'neighbours (cell:value:v2):',[(c,T[c],v2(T[c])) for c in nb if c in T])
