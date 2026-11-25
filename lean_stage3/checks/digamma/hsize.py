import mpmath as mp
mp.mp.dps=20
def Gr(s): return mp.pi**(-s/2)*mp.gamma(s/2)
for T in [1e2,1e4,1e8]:
  L=mp.log(T); worst=0; worstz=0
  for tt in [T/4,T,2*T]:
    for x in [3/8.,3,45/8.]:
      w=mp.mpc(x,tt)
      for r in ([1] if x==3 else [1/8.]):
        for k in range(16):
          z=w+r*mp.e**(2j*mp.pi*k/16)
          h=abs(Gr(z)/Gr(w))*mp.e**(-(L/2)*(z.real-w.real))
          worst=max(worst,h); worstz=max(worstz,h*abs(mp.zeta(z))/tt)
  print(T,float(worst),float(worstz))
