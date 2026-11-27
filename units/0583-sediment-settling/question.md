> Source: session transcript, 2026-11-26

> Okay, so think of it this way. If the basins couple, then as they couple, the energy doesn't move from basin to basin. At some point, previous basins have to calcify, but the surface of the basin will always be at the same height. So what if it's inevitable for every zero to be half on the line, because in the end it takes moving through each basin to settle into the half. So if you're trying to measure it as it's moving, all the sediment as the composites and the primes are still moving, but at what point do the basins settle? And if so, the basins are always at half if it's pushing the flow of each basin into the next basin. So from that view of the surface is half, because it's always half of the basin and then half is the other side of the horizon line, which would be the critical line.

From `run/sediment.py`, the function:

```
    def half(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.fsum(n ** (-s) for n in ns)
    return lambda s: half(s) + half(1 - s)
```
