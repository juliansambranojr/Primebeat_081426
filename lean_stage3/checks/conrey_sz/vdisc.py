import mpmath as mp
exec(open('vsize.py').read().split("Qs={")[0])
mp.mp.dps=20
Qs={'lev':[1,-1],'cubic':[1,mp.mpf(1)/2,-3,2]}
for name,Qc in Qs.items():
  for T in [1e3,1e5]:
    L=mp.log(T)
    mn=10
    for j in range(41):
        t=T/4+j*(2*T-T/4)/40
        mn=min(mn,V(Qc,L,mp.mpc(3,t)).real)
    mx=0
    for t in [T/4,T,2*T]:
      for k in range(12):
        w=mp.mpc(3,t)+mp.mpf(21)/8*mp.expjpi(mp.mpf(k)/6)
        mx=max(mx,abs(V(Qc,L,w))/t)
    print(name,T,'min ReV on edge',mp.nstr(mn,4),'max |V|/t on disc circles',mp.nstr(mx,4))
