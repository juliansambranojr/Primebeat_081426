import mpmath as mp
mp.mp.dps = 30
def G(s): return mp.pi**(-s/2)*mp.gamma(s/2)
def grR(i,s): return mp.diff(G,s,i)/G(s)
print("L*|(-1/L)^i grR - (-1/2)^i| , max over grid")
for T in [1e2,1e4,1e8]:
    L = mp.log(T)
    for i in range(1,5):
        m=0
        for sg in [0.25,0.6,1.0]:
            for t in [T/4,T,2*T]:
                s=mp.mpc(sg,t)
                v=abs((-1/L)**i*grR(i,s)-(-0.5)**i)*L
                m=max(m,v)
        print(T,i,mp.nstr(m,6))
print("max ||h_w|| on circle radius 1/8")
for T in [1e2,1e4,1e8]:
    L=mp.log(T); m=0
    for sg in [0.25,1.0]:
        for t in [T/4,2*T]:
            w=mp.mpc(sg,t)
            for k in range(32):
                z=w+mp.mpf(1)/8*mp.expj(2*mp.pi*k/32)
                h=abs(G(z)/G(w)*mp.exp(-(L/2)*(z-w)))
                m=max(m,h)
    print(T,mp.nstr(m,6))
