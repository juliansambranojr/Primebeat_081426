/* T(n) = sum_{x <= sqrt n} floor(n/x), mod 2^64, by walking the lower convex hull of the lattice points
   just above the hyperbola xy = n, from x = sqrt n leftwards (Stern-Brocot refinement of the edge vector),
   and summing the columns below n^(1/3)-ish directly. D(n) = 2 T(n) - floor(sqrt n)^2. */
#include <stdint.h>
#include <math.h>
#include <stdlib.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static inline u64 isqrt_u128(u128 x){ u64 r=(u64)sqrtl((long double)x); while((u128)r*r>x) r--; while((u128)(r+1)*(r+1)<=x) r++; return r; }
static inline u64 icbrt_u128(u128 x){ u64 r=(u64)cbrtl((long double)x); while((u128)r*r*r>x) r--; while((u128)(r+1)*(r+1)*(r+1)<=x) r++; return r; }
static u64 T_hull(u128 n, u64 xmin_factor_num){
  u64 X=isqrt_u128(n); if(X<64){ u64 s=0; for(u64 x=1;x<=X;x++) s+=(u64)(n/x); return s; }
  u64 xmin=icbrt_u128(n)*xmin_factor_num/4; if(xmin<1) xmin=1; if(xmin>X) xmin=X;
  size_t cap=1024; u64 *sa=malloc(cap*sizeof(u64)), *sb=malloc(cap*sizeof(u64)); size_t sp=0;
  sa[sp]=0; sb[sp]=1; sp++; sa[sp]=1; sb[sp]=1; sp++;
  u64 x=X; u128 yy=n/X+1; u64 y=(u64)yy; /* y < 2^64 since y ~ sqrt n */
  u64 s=0;
  #define OUT(xx,yv) ((u128)(xx)*(u128)(yv) > n)
  for(;;){
    sp--; u64 a1=sa[sp], b1=sb[sp];
    if(a1==0){ sp++; break; }                       /* vertical: never step along it */
    while(x>=a1 && x-a1>=xmin && OUT(x-a1,y+b1)){
      s += a1*(y-1) + (a1-1)*(b1+1)/2; x-=a1; y+=b1; }
    if(x-a1<xmin || x<a1){ if(x<=xmin+a1) break; }
    if(x<=xmin) break;
    u64 a2=a1, b2=b1;                               /* shallow, does not fit */
    for(;;){
      u64 a3=sa[sp-1], b3=sb[sp-1];                 /* steep, fits */
      u64 am=a2+a3, bm=b2+b3;
      if(am<x && OUT(x-am,y+bm)){ sa[sp]=am; sb[sp]=bm; sp++; if(sp==cap){ cap*=2; sa=realloc(sa,cap*sizeof(u64)); sb=realloc(sb,cap*sizeof(u64)); } }
      else { if(am>=x) break; if((u128)(x-am)*b3 <= (u128)a3*(y+bm)) break; a2=am; b2=bm; }
    }
  }
  free(sa); free(sb);
  for(u64 c=1;c<=x;c++) s+=(u64)(n/c);
  return s;
}
static u64 T_hull64(u64 n, u64 xmin_factor_num){
  u64 X=isqrt_u128((u128)n); if(X<64){ u64 s=0; for(u64 x=1;x<=X;x++) s+=n/x; return s; }
  u64 xmin=icbrt_u128((u128)n)*xmin_factor_num/4; if(xmin<1) xmin=1; if(xmin>X) xmin=X;
  size_t cap=1024; u64 *sa=malloc(cap*sizeof(u64)), *sb=malloc(cap*sizeof(u64)); size_t sp=0;
  sa[sp]=0; sb[sp]=1; sp++; sa[sp]=1; sb[sp]=1; sp++;
  u64 x=X; u64 y=n/X+1; /* y < 2^64 since y ~ sqrt n */
  u64 s=0;
  #undef OUT
  #define OUT(xx,yv) ((u64)(xx)*(u64)(yv) > n)
  for(;;){
    sp--; u64 a1=sa[sp], b1=sb[sp];
    if(a1==0){ sp++; break; }                       /* vertical: never step along it */
    while(x>=a1 && x-a1>=xmin && OUT(x-a1,y+b1)){
      s += a1*(y-1) + (a1-1)*(b1+1)/2; x-=a1; y+=b1; }
    if(x-a1<xmin || x<a1){ if(x<=xmin+a1) break; }
    if(x<=xmin) break;
    u64 a2=a1, b2=b1;                               /* shallow, does not fit */
    for(;;){
      u64 a3=sa[sp-1], b3=sb[sp-1];                 /* steep, fits */
      u64 am=a2+a3, bm=b2+b3;
      if(am<x && OUT(x-am,y+bm)){ sa[sp]=am; sb[sp]=bm; sp++; if(sp==cap){ cap*=2; sa=realloc(sa,cap*sizeof(u64)); sb=realloc(sb,cap*sizeof(u64)); } }
      else { if(am>=x) break; if((x-am)*b3 <= a3*(y+bm)) break; a2=am; b2=bm; }
    }
  }
  free(sa); free(sb);
  for(u64 c=1;c<=x;c++) s+=n/c;
  return s;
}
static inline u64 D_hull(u128 n){ if(n==0) return 0; u64 X=isqrt_u128(n);
  u64 T = (n < ((u128)1<<62)) ? T_hull64((u64)n,8) : T_hull(n,8);
  return 2*T - X*X; }
