/* S(2^m) = sum_{n<=x} 2^omega(n) mod 2^64 by a split that avoids touching every e up to sqrt x. EXPLORATORY.
   S = A + B1 + B2,
     A  = sum_{e<=c}     mu(e) D(x/e^2)          D by the hull walk (dsum.h)
     B1 = sum_{c<e<=L}   mu(e) D(x/e^2)          mu by segmented sieve; D(v) at v = x/e^2 from a hull value at
                                                 the block's lowest v and a segmented tau sweep upward
     B2 = sum_{L<e<=sqrt x} mu(e) D(x/e^2) = sum_{m<=W} tau(m) (M(z_m) - M(L)),  z_m = floor(sqrt(x/m)),
          W = floor(x/(L+1)^2); M(z_m) by M(z) = 1 - sum_{k>=2} M(floor(z/k)) with floor(z_m/k) = z_{mk^2}:
          k <= K1 = floor(sqrt(W/m)) recursive; K1 < k <= sqrt z from the mu sweep ("middle");
          k > sqrt z grouped by q = floor(z/k) <= x^(1/4) from a small table.
   usage: fast m log2c log2L      prints: m S_mod_2^64 S_mod4 pi_parity seconds_A seconds_B1+mid seconds_B2 seconds_roots */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include "dsum2.h"
typedef int64_t i64;
static u64 *P; static u64 NP;
static void primes_upto(u64 n){ char *c=calloc(n+1,1); P=malloc(sizeof(u64)*(n/2+10)); NP=0;
  for(u64 i=2;i<=n;i++) if(!c[i]){ P[NP++]=i; for(u64 j=i*i;j<=n;j+=i) c[j]=1; } free(c); }
/* mu on [lo, hi] into mu[0..hi-lo] */
static void mu_seg(u64 lo,u64 hi,int8_t *mu,u64 *prod){ u64 len=hi-lo+1;
  for(u64 i=0;i<len;i++){ mu[i]=1; prod[i]=1; }
  for(u64 j=0;j<NP;j++){ u64 p=P[j]; if(p*p>hi) break; u64 st=((lo+p-1)/p)*p;
    for(u64 q=st;q<=hi;q+=p){ mu[q-lo]=-mu[q-lo]; prod[q-lo]*=p; }
    u64 p2=p*p; u64 s2=((lo+p2-1)/p2)*p2; for(u64 q=s2;q<=hi;q+=p2) mu[q-lo]=0; }
  for(u64 i=0;i<len;i++) if(mu[i] && prod[i]!=lo+i) mu[i]=-mu[i]; }
/* tau mod 2^64 on [lo, hi] */
static void tau_seg(u64 lo,u64 hi,u64 *t,u64 *rem){ u64 len=hi-lo+1;
  for(u64 i=0;i<len;i++){ t[i]=1; rem[i]=lo+i; }
  for(u64 j=0;j<NP;j++){ u64 p=P[j]; if(p*p>hi) break; u64 st=((lo+p-1)/p)*p;
    for(u64 q=st;q<=hi;q+=p){ u64 r=rem[q-lo]; int e=0; while(r%p==0){ r/=p; e++; } rem[q-lo]=r; t[q-lo]*=(u64)(e+1); } }
  for(u64 i=0;i<len;i++) if(rem[i]>1) t[i]*=2; }
/* tau on [lo, hi] with multiplications only: each multiple of p doubles tau and multiplies the found part
   by p; each multiple of p^k, k >= 2, turns the factor k into k + 1 (tau += tau / k, exact); a number whose
   found part falls short of it has one prime factor above sqrt(hi) left, which doubles tau. */
static void tau_seg2(u64 lo,u64 hi,u64 *t,u64 *prod){ u64 len=hi-lo+1;
  for(u64 i=0;i<len;i++){ t[i]=1; prod[i]=1; }
  for(u64 j=0;j<NP;j++){ u64 p=P[j]; if(p*p>hi) break; u64 st=((lo+p-1)/p)*p;
    for(u64 q=st;q<=hi;q+=p){ t[q-lo]<<=1; prod[q-lo]*=p; }
    u64 pk=p*p; int k=2;
    while(pk<=hi){ u64 s2=((lo+pk-1)/pk)*pk; for(u64 q=s2;q<=hi;q+=pk){ t[q-lo]+=t[q-lo]/(u64)k; prod[q-lo]*=p; }
      if(pk>hi/p) break; pk*=p; k++; } }
  for(u64 i=0;i<len;i++) if(prod[i]!=lo+i) t[i]<<=1; }
static u64 iroot128(u128 x,int k){ u64 r=(u64)powl((long double)x,1.0L/k); 
  for(;;){ u128 p=1; int over=0; for(int i=0;i<k;i++){ p*=r; if(p>x){over=1;break;} } if(over) r--; else break; }
  for(;;){ u128 p=1; int over=0; u64 s=r+1; for(int i=0;i<k;i++){ p*=s; if(p>x){over=1;break;} } if(over) break; r=s; }
  return r; }
static int64_t lucy_pi(u64 n){       /* pi(n), Lucy_Hedgehog, O(n^(3/4)) */
  if(n<2) return 0; u64 r=(u64)sqrtl((long double)n); while(r*r>n) r--; while((r+1)*(r+1)<=n) r++;
  u64 nv=r+n/r-1; /* values n/i for i<=r, then r-1..1 */
  int64_t *Slo=malloc((r+2)*sizeof(int64_t)), *Shi=malloc((r+2)*sizeof(int64_t));
  for(u64 i=1;i<=r;i++){ Shi[i]=(int64_t)(n/i)-1; Slo[i]=(int64_t)i-1; }
  for(u64 p=2;p<=r;p++){ if(Slo[p]==Slo[p-1]) continue; int64_t sp=Slo[p-1]; u64 p2=p*p;
    u64 lim = r < n/p2 ? r : n/p2;
    for(u64 i=1;i<=lim;i++){ u64 d=i*p; int64_t v = (d<=r)? Shi[d] : Slo[n/d]; Shi[i]-= v-sp; }
    for(u64 i=r;i>=p2;i--){ Slo[i]-= Slo[i/p]-sp; } }
  int64_t res=Shi[1]; free(Slo); free(Shi); (void)nv; return res; }
/* the same tau on [lo, hi], hi - lo < 2^18, cache-sized: tau in 32 bits, and the found part kept as a sum of
   base-two logarithms; a leftover prime factor is above sqrt(hi), at least 10 bits when lo >= 2^20, while the
   float sum is off by far less than a bit, so a gap above 5 bits marks it. Below 2^20, tau_seg2. */
static void tau_seg3(u64 lo,u64 hi,uint32_t *t,float *lg){ u64 len=hi-lo+1;
  for(u64 i=0;i<len;i++){ t[i]=1; lg[i]=0.f; }
  for(u64 j=0;j<NP;j++){ u64 p=P[j]; if(p*p>hi) break; float lp=log2f((float)p); u64 st=((lo+p-1)/p)*p;
    for(u64 q=st;q<=hi;q+=p){ t[q-lo]<<=1; lg[q-lo]+=lp; }
    u64 pk=p*p; uint32_t k=2;
    while(pk<=hi){ u64 s2=((lo+pk-1)/pk)*pk; for(u64 q=s2;q<=hi;q+=pk){ t[q-lo]+=t[q-lo]/k; lg[q-lo]+=lp; }
      if(pk>hi/p) break; pk*=p; k++; } }
  for(u64 i=0;i<len;i++) if(log2((double)(lo+i)) - (double)lg[i] > 5.0) t[i]<<=1; }
int main(int argc,char**argv){
  int m=atoi(argv[1]); int lc=atoi(argv[2]); int lL=atoi(argv[3]);
  u128 x=(u128)1<<m; u64 R=isqrt_u128(x);
  u64 c=(u64)1<<lc, L=(u64)1<<lL; if(L>R) L=R; if(c>L) c=L;
  u64 W=(u64)(x/((u128)(L+1)*(L+1)));
  u64 V=(u64)(x/((u128)(c+1)*(c+1)));
  u64 q4=isqrt_u128(R)+2;                            /* small table bound, about x^(1/4) */
  u64 pmax=isqrt_u128((u128)(L>V?L:V))+2; if(pmax<q4) pmax=q4; if(pmax < (u64)isqrt_u128(c)+2) pmax=isqrt_u128(c)+2;
  primes_upto(pmax);
  double t0=omp_get_wtime();
  /* ---- A ---- */
  int8_t *muc=malloc(c+1); u64 *tmp=malloc(sizeof(u64)*(c+1)); mu_seg(1,c,muc+1,tmp); free(tmp); muc[0]=0;
  u64 A=0;
  #pragma omp parallel for reduction(+:A) schedule(dynamic,1)
  for(u64 e=1;e<=c;e++) if(muc[e]){ u64 d=D_hull(x/((u128)e*e)); A+= muc[e]>0? d : -d; }
  double tA=omp_get_wtime()-t0; t0=omp_get_wtime();
  /* ---- small table M(q), q <= q4 ---- */
  int8_t *mus=malloc(q4+1); tmp=malloc(sizeof(u64)*(q4+1)); mu_seg(1,q4,mus+1,tmp); free(tmp); mus[0]=0;
  i64 *Ms=malloc(sizeof(i64)*(q4+1)); Ms[0]=0; for(u64 i=1;i<=q4;i++) Ms[i]=Ms[i-1]+mus[i];
  /* ---- the mu sweep over [1, L]: pass 1 block sums ---- */
  const u64 SEG=1<<20; u64 nb=(L+SEG-1)/SEG;
  i64 *bsum=calloc(nb+1,sizeof(i64));
  #pragma omp parallel
  { int8_t *mu=malloc(SEG); u64 *pr=malloc(sizeof(u64)*SEG);
    #pragma omp for schedule(dynamic,1)
    for(u64 b=0;b<nb;b++){ u64 lo=1+b*SEG, hi=lo+SEG-1; if(hi>L) hi=L; mu_seg(lo,hi,mu,pr); i64 s=0; for(u64 i=0;i<=hi-lo;i++) s+=mu[i]; bsum[b]=s; }
    free(mu); free(pr); }
  i64 *bstart=malloc(sizeof(i64)*(nb+1)); bstart[0]=0; for(u64 b=0;b<nb;b++) bstart[b+1]=bstart[b]+bsum[b];
  i64 ML=bstart[nb];
  /* per m <= W: z, r, K1 */
  u64 *zm=malloc(sizeof(u64)*(W+1)), *rm=malloc(sizeof(u64)*(W+1)), *K1=malloc(sizeof(u64)*(W+1));
  for(u64 mm=1;mm<=W;mm++){ zm[mm]=isqrt_u128(x/mm); rm[mm]=isqrt_u128(zm[mm]); K1[mm]=isqrt_u128(W/mm); }
  int nth=omp_get_max_threads(); i64 *midT=calloc((size_t)nth*(W+1),sizeof(i64));
  u64 B1=0;
  /* ---- pass 2: middle queries and B1 ---- */
  #pragma omp parallel reduction(+:B1)
  { int tid=omp_get_thread_num(); i64 *mid=midT+(size_t)tid*(W+1);
    int8_t *mu=malloc(SEG); u64 *pr=malloc(sizeof(u64)*SEG); i64 *Mb=malloc(sizeof(i64)*SEG);
    const u64 TS=1<<18; u64 *tt=malloc(sizeof(u64)*TS), *rr=malloc(sizeof(u64)*TS); uint32_t *t3=malloc(4*TS); float *lg3=malloc(4*TS);
    #pragma omp for schedule(dynamic,1)
    for(u64 b=0;b<nb;b++){ u64 lo=1+b*SEG, hi=lo+SEG-1; if(hi>L) hi=L; u64 len=hi-lo+1;
      mu_seg(lo,hi,mu,pr); i64 run=bstart[b]; for(u64 i=0;i<len;i++){ run+=mu[i]; Mb[i]=run; }
      /* middle: for each m, k in (K1, r] with floor(z/k) in [lo, hi] */
      for(u64 mm=1;mm<=W;mm++){ u64 z=zm[mm]; u64 klo=z/(hi+1)+1, khi=z/lo; if(klo<=K1[mm]) klo=K1[mm]+1; if(khi>rm[mm]) khi=rm[mm]; if(klo<2) klo=2;
        i64 s=0; for(u64 k=klo;k<=khi;k++) s+=Mb[z/k-lo]; mid[mm]+=s; }
      /* B1: e in (c, L] within this block */
      u64 elo = lo>c+1? lo : c+1; if(elo>hi) continue;
      u64 vmin=(u64)(x/((u128)hi*hi)), vmax=(u64)(x/((u128)elo*elo));
      u64 Dcur=D_hull(vmin); u64 v=vmin;               /* D(v), v = the last argument summed */
      u64 bLo=1, bHi=0;                                  /* tau buffer covers [bLo, bHi] */
      u64 e=hi;                                          /* walk e downward: v_e = x/e^2 upward */
      while(e>=elo){ u64 ve=(u64)(x/((u128)e*e));
        while(v<ve){ if(v+1>bHi){ bLo=v+1; bHi=bLo+TS-1; if(bHi>vmax) bHi=vmax;
            if(bLo>=(1ULL<<20)){ tau_seg3(bLo,bHi,t3,lg3); for(u64 i=0;i<=bHi-bLo;i++) tt[i]=t3[i]; } else tau_seg2(bLo,bHi,tt,rr); }
          u64 to= ve<bHi? ve : bHi; for(u64 i=v+1;i<=to;i++) Dcur+=tt[i-bLo]; v=to; }
        int8_t me=mu[e-lo]; if(me) B1+= me>0? Dcur : -Dcur;
        if(e==elo) break; e--; }
      (void)vmax; }
    free(mu); free(pr); free(Mb); free(tt); free(rr); free(t3); free(lg3); }
  double tB1=omp_get_wtime()-t0; t0=omp_get_wtime();
  /* ---- recursion for M(z_m), m = W .. 1 ---- */
  i64 *Mz=malloc(sizeof(i64)*(W+1));
  for(u64 mm=W;mm>=1;mm--){ u64 z=zm[mm], r=rm[mm]; i64 s=0;
    for(int t=0;t<nth;t++) s+=midT[(size_t)t*(W+1)+mm];
    for(u64 k=2;k<=K1[mm] && k<=r;k++) s+=Mz[mm*k*k];
    u64 qmax=z/(r+1);
    for(u64 q=1;q<=qmax;q++){ u64 hiK=z/q, loK=z/(q+1); if(loK<r) loK=r; if(hiK>loK) s+=Ms[q]*(i64)(hiK-loK); }
    Mz[mm]=1-s; if(mm==1) break; }
  u64 B2=0; { u64 *tt=malloc(sizeof(u64)*(W+1)), *rr=malloc(sizeof(u64)*(W+1)); if(W>=1){ tau_seg2(1,W,tt+1,rr+1);
    for(u64 mm=1;mm<=W;mm++) B2+= tt[mm]*(u64)(Mz[mm]-ML); } free(tt); free(rr); }
  double tB2=omp_get_wtime()-t0;
  u64 S=A+B1+B2;
  t0=omp_get_wtime(); int64_t roots=0; for(int k=2;k<=m;k++) roots+=lucy_pi(iroot128(x,k)); double tR=omp_get_wtime()-t0;
  int Pi_par=(int)((((S&3)+4-1)/2)&1); int pi_par=(int)(((Pi_par-(roots&1))%2+2)%2);
  printf("%d %llu %llu %d %.3f %.3f %.3f %.3f\n",m,(unsigned long long)S,(unsigned long long)(S&3),pi_par,tA,tB1,tB2,tR);
  return 0; }
