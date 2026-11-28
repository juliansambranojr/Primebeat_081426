/* pi(2^m) mod 2 through S(x) = sum_{n<=x} 2^omega(n) = 1 + 2 Pi(x) (mod 4), EXPLORATORY bench code.
   S(x) = sum_{e<=sqrt x} mu(e) D(floor(x/e^2)),  D(y) = 2 sum_{k<=sqrt y} floor(y/k) - floor(sqrt y)^2.
   Everything is carried modulo 2^64 (unsigned wrap), which keeps it exact modulo 4.
   Part A: e <= c, D by its sqrt loop (128-bit division while y >= 2^64).
   Part B: e in (c, sqrt x], D read from a table of D(y) mod 4 for y <= Y, mu from a segmented sieve.
   pi(x) = Pi(x) - sum_{k>=2} pi(floor(x^(1/k))); those counts by Lucy's algorithm.
   usage: parity m [log2 Y]   prints: m S_mod4 Pi_par pi_par secA secB secRoots */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <omp.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static double now(void){ return omp_get_wtime(); }
static u64 isqrt128(u128 x){ u64 r=(u64)sqrtl((long double)x); while((u128)r*r>x) r--; while((u128)(r+1)*(r+1)<=x) r++; return r; }
static u64 iroot128(u128 x,int k){ u64 r=(u64)powl((long double)x,1.0L/k); 
  for(;;){ u128 p=1; int over=0; for(int i=0;i<k;i++){ p*=r; if(p>x){over=1;break;} } if(over) r--; else break; }
  for(;;){ u128 p=1; int over=0; u64 s=r+1; for(int i=0;i<k;i++){ p*=s; if(p>x){over=1;break;} } if(over) break; r=s; }
  return r; }
static u64 D_mod(u128 y){            /* D(y) mod 2^64 */
  if(y==0) return 0; u64 s=isqrt128(y); u64 tot=0;
  if(y < ((u128)1<<64)){ u64 yy=(u64)y;
    #pragma omp parallel for reduction(+:tot) schedule(static)
    for(u64 k=1;k<=s;k++) tot+=yy/k; }
  else {
    #pragma omp parallel for reduction(+:tot) schedule(static)
    for(u64 k=1;k<=s;k++) tot+=(u64)(y/k); }
  return 2*tot - s*s; }
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
int main(int argc,char**argv){
  int m=atoi(argv[1]); int lY = argc>2? atoi(argv[2]) : 30;
  u128 x=(u128)1<<m; u64 S=isqrt128(x);
  u64 Y=(u64)1<<lY; if((u128)Y> x) Y=(u64)x;
  u64 c = isqrt128(x/Y); if(c<1) c=1;                 /* e > c  =>  x/e^2 < Y */
  double t0=now();
  /* mu up to c by a plain sieve */
  int8_t *muc=malloc(c+1); for(u64 i=0;i<=c;i++) muc[i]=1; char *comp=calloc(c+1,1);
  for(u64 p=2;p<=c;p++) if(!comp[p]){ for(u64 q=p;q<=c;q+=p){ comp[q]= q>p; muc[q]=-muc[q]; } if(p<=c/p) for(u64 q=p*p;q<=c;q+=p*p) muc[q]=0; }
  free(comp);
  u64 A=0; for(u64 e=1;e<=c;e++) if(muc[e]) { u64 d=D_mod(x/((u128)e*e)); A+= muc[e]>0? d : -d; }
  double tA=now()-t0; t0=now();
  /* Part B */
  u64 B=0;
  if(S>c){
    u64 ymax=(u64)(x/((u128)(c+1)*(c+1)));
    u64 *Dt=malloc(sizeof(u64)*(ymax+1)); uint32_t *tau=calloc(ymax+1,4);
    for(u64 d=1;d<=ymax;d++) for(u64 q=d;q<=ymax;q+=d) tau[q]++;
    u64 acc=0; Dt[0]=0; for(u64 y=1;y<=ymax;y++){ acc+=tau[y]; Dt[y]=acc; } free(tau);
    double tTau=now()-t0; (void)tTau;
    u64 sq=(u64)sqrtl((long double)S)+2; char *cs=calloc(sq+1,1); u64 *pr=malloc(sizeof(u64)*(sq+1)); u64 np=0;
    for(u64 p=2;p<=sq;p++) if(!cs[p]){ pr[np++]=p; for(u64 q=p*p;q<=sq;q+=p) cs[q]=1; }
    const u64 SEG=1<<22; u64 lo0=c+1;
    u64 nseg=(S-lo0)/SEG+1;
    #pragma omp parallel reduction(+:B)
    { u64 *prod=malloc(sizeof(u64)*SEG); int8_t *mu=malloc(SEG);
      #pragma omp for schedule(dynamic,1)
      for(u64 sgi=0;sgi<nseg;sgi++){ u64 lo=lo0+sgi*SEG; u64 hi=lo+SEG-1; if(hi>S) hi=S; u64 len=hi-lo+1;
        for(u64 i=0;i<len;i++){ prod[i]=1; mu[i]=1; }
        for(u64 j=0;j<np;j++){ u64 p=pr[j]; if(p*p>hi) break; u64 st=((lo+p-1)/p)*p;
          for(u64 q=st;q<=hi;q+=p){ prod[q-lo]*=p; mu[q-lo]=-mu[q-lo]; }
          u64 p2=p*p; u64 st2=((lo+p2-1)/p2)*p2; for(u64 q=st2;q<=hi;q+=p2) mu[q-lo]=0; }
        for(u64 i=0;i<len;i++){ if(!mu[i]) continue; u64 e=lo+i; int s=mu[i]; if(prod[i]!=e) s=-s;
          u64 y=(u64)(x/((u128)e*e)); u64 d=Dt[y]; B+= s>0? d : -d; } }
      free(prod); free(mu); }
    free(Dt); free(cs); free(pr);
  }
  double tB=now()-t0; t0=now();
  u64 Smod=(A+B)&3; int Pi_par=(int)(((Smod+4-1)/2)&1);
  int64_t roots=0;
  double tR=now()-t0;
  int pi_par=(int)(((Pi_par - (roots&1)) % 2 + 2) % 2);
  printf("%d %llu %llu\n",m,(unsigned long long)(A+B),(unsigned long long)Smod);
  return 0; }
