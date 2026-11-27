import mpmath as mp, zeros
mp.mp.dps=20
pi=mp.pi
a=(mp.mpf(3)/2+mp.mpf(113)/4)/pi
b=(2+mp.mpf(3)/2*mp.log(9)+128)/pi
zs=zeros.load()
def margin(n,h,d0=0,d=0):
    T1=zs[n-1]+d0
    S=0
    for i in range(n,len(zs)):
        s=zs[i]+d
        if s> T1+h: break
        S+=T1+h-s
    K=mp.log((T1+1+h)/(2*pi))/2+mp.mpf(4)/5/T1
    E=(a*mp.log(T1+1+h)+b-S)/h+h*K/(2*pi)
    return n+2-mp.siegeltheta(T1)/pi-1-E
best=[]
for n in range(30,300):
    m,h=max((margin(n,h),h) for h in range(30,120,2))
    best.append((n,float(zs[n-1]),h,float(m)))
for r in best:
    if r[3]>0: print(r)
print("---- with d0=0.02 d=0.03")
for n in range(230,300,3):
    m,h=max((margin(n,h,0.02,0.03),h) for h in range(60,110,2))
    print(n, float(zs[n-1]), h, float(m))
