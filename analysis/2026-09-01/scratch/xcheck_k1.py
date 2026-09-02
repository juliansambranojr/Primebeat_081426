import json, sys, importlib.util, os, math, time
import numpy as np
from mpmath import mp, mpf, mpc, matrix as mpmatrix
HERE="/Users/juliansambrano/GitHub/Primebeat_081426/analysis/2026-09-01"
def _load(name):
    spec=importlib.util.spec_from_file_location(name, os.path.join(HERE,name+".py")); m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m); return m
lm=_load("weil_Lc_mod"); le=lm.le; lh=lm.lh; wq=lm.wq
mp.dps=40
SP=sys.argv[1]
d=json.load(open(SP+"/mod_smoke.json"))
r=d["ladder"]["k=1|eps=0.01|M=16|w=1/2"]
Lc=r["L_c"]; h=Lc/2; c=np.array(r["minimiser_at_Lc"]["coeffs"]); M=16
g=mp.zetazero(1).imag; eps=0.01; w=mpf(1)/2
gfile=np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)]); gN=float(gfile[-1])
print("L_c",Lc,"h",h,"lam_mod at bracket",r["lam_at_bracket"], "floor", r["floor_at_bracket"])
# recompute modulated lam at h
adams=lm.adams_table(M)
Za,_=lm.zero_side_mod(M,h,float(g),gfile); Rk=lm.ghat_row_as_in_gram(M,h,float(g),gfile,1); Zp=Za-lh.rank_one_mp(Rk); tail=lm.tail_mod(M,h,g,gN)
A,B=lm.transforms_mod(M,h,g,eps); T=le.pair_matrix(A,B,w); S=lm.gram_mod(M,h,g,adams)
Q=Zp+tail+(2*w)*T
lam,cc,nk,cond,_=lm.eig_pencil(Q,S,1e-24)
print("recomputed lam_mod",mp.nstr(lam,10),"kept",nk)
cm=mpmatrix([[mpf(float(x))] for x in c])
print("Q(c) raw coeffs from json:",mp.nstr((cm.T*Q*cm)[0,0],10)," S(c):",mp.nstr((cm.T*S*cm)[0,0],10))
# Legendre M64 at same h
ML=64
ZL,_=le.zero_side_dd(ML,h,gfile)
RkL=le.ghat_legendre(ML,h,gfile[:25000])[:,0]
ZpL=ZL-lh.rank_one_mp(RkL); tailL=le.tail_matrix(ML,h,gN)
AL,BL=lh.transforms_bessel(ML,h,g,eps); TL=le.pair_matrix(AL,BL,w)
QL=ZpL+tailL+(2*w)*TL
lamL,vec,par,lo,le_,lo_=le.lam_min_parity(QL,ML)
print("Legendre M64 lam_min at this h:",mp.nstr(lamL,10),par)
# project modulated G* onto Legendre M64: d_n = sum_a c_a <phi_a, G_n^Leg>; <G_m cos, G_n> = Re I_nm(g), <G_m sin, G_n> = Im I_nm(g)
J=lm.jn_mp(ML+M, g*mpf(h))
def I(n,m):
    s=mpc(0)
    for l in range(abs(n-m), n+m+1, 2):
        s+= (2*l+1)*lm._threej0_sq(n,m,l)*(1j)**l*J[l]
    return s*mp.sqrt(mpf((2*n+1)*(2*m+1)))
dvec=mpmatrix(ML,1)
for n in range(ML):
    s=mpf(0)
    for m in range(M):
        Inm=I(n,m)
        s+= cm[m]*mp.re(Inm) + cm[M+m]*mp.im(Inm)
    dvec[n]=s
nd=(dvec.T*dvec)[0,0]
print("||proj||^2 =",mp.nstr(nd,15))
QLd=(dvec.T*QL*dvec)[0,0]
print("Q_Leg(proj G*) =",mp.nstr(QLd,10)," vs lam_mod",mp.nstr(lam,10))
# and the Legendre minimiser's value in the modulated form? (not representable) -- skip
# components: Z', tail, T for both
for nm,(Mm,Mat,v) in {"mod":(2*M,(Zp,tail,T),cm),"leg":(ML,(ZpL,tailL,TL),dvec)}.items():
    print(nm, "Z'",mp.nstr((v.T*Mat[0]*v)[0,0],8),"tail",mp.nstr((v.T*Mat[1]*v)[0,0],8),"2wT",mp.nstr((v.T*Mat[2]*v)[0,0]*2*w,8))
