#include <stdio.h>
#include <stdlib.h>
#include "dsum.h"
static u64 T_plain(u128 n){ u64 X=isqrt_u128(n), s=0; for(u64 x=1;x<=X;x++) s+=(u64)(n/x); return s; }
int main(){ srand(7); long bad=0, tests=0;
  for(u64 n=1;n<=200000;n++){ tests++; if(T_hull(n,4)!=T_plain(n)){ if(bad<5) printf("bad n=%llu\n",(unsigned long long)n); bad++; } }
  for(int i=0;i<3000;i++){ u128 n=((u128)rand()*rand()) % 1000000000000ULL + 1; tests++; if(T_hull(n,4)!=T_plain(n)){ if(bad<10) printf("bad big\n"); bad++; } }
  for(int e=20;e<=50;e++){ u128 n=((u128)1<<e)+rand()%1000; tests++; if(T_hull(n,4)!=T_plain(n)){ printf("bad 2^%d\n",e); bad++; } }
  printf("tests %ld bad %ld\n",tests,bad); return 0; }
