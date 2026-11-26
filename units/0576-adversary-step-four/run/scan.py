import sys,time
sys.path.insert(0, '.')
from vlib import *
qn,kind,T0,H=sys.argv[1],sys.argv[2],float(sys.argv[3]),int(sys.argv[4])
L=math.log(T0)
f=(V_script if kind=='script' else V_lean)(QS[qn],L)
tot=0
for i in range(H):
    y=T0+i
    w=winding(f,0.5+1e-6,2.0,y,y+1.0,n=4)
    if abs(w)>0.25: print(qn,kind,y,round(w,3),flush=True)
    tot+=round(w)
print('DONE',qn,kind,T0,H,'total',tot,flush=True)
