#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
typedef uint64_t u64;
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

int main(int argc,char**argv){ u64 n=strtoull(argv[1],0,10); printf("%lld\n",(long long)lucy_pi(n)); return 0; }
