import sympy as sp, math
from check import kfl_closed, young
pc=[0,'87/100','-1/100','7/50']; 
for qc,R in [([1,'-27/50','-36/25','24/25'],'37/25'),([1,'-27/50','-36/25','24/25'],'3/2'),([1,'-11/20','-3/2','1'],'37/25')]:
    r,c=kfl_closed(pc,qc,R,'49/100')
    K=float(r)+float(c)*math.exp(2*float(sp.Rational(R)))
    print(qc,R,K,1-math.log(K)/float(sp.Rational(R)),'young',young([float(sp.Rational(x)) for x in pc],[float(sp.Rational(x)) for x in qc],float(sp.Rational(R)),0.49), r, c)
