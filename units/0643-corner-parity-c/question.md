> Source: session transcript, 2026-11-27

> yes and in the cloud, so we save ram here

> Log them as units 0642 (edges) and 0643 (C parity).

From `run/parity.c`, the parity of the prime-power count from S mod 4:

```
  u64 Smod=(A+B)&3; int Pi_par=(int)(((Smod+4-1)/2)&1);
```
