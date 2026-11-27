> Source: session transcript, 2026-11-25

> Yes please

From `units/0551-long-mollifier-kappa/run/kappa.py`, the constant computed:

```
def c(pc,qc,R,th):
    P=Pn.polyval(U,pc); dP=Pn.polyval(U,Pn.polyder(pc))
    Q=Pn.polyval(V,qc); dQ=Pn.polyval(V,Pn.polyder(qc))
    d=R*th*P*Q+dP*Q+th*P*dQ
    return 1+(1/th)*np.sum(W*np.exp(2*R*V)*d**2)
```
