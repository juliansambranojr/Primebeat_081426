> Source: session transcript, 2026-11-27

> Ok any ideas, cause what I'm noticing is that the deep corner is just a larger spread of primes so it is more  harmonic like the the smaller corner which is the beat. So the structure should be self similar and steps that created the harmonic are fractals of it

From `run/zoom.py`, the predicted leader at depth d:

```
    pred[d] = int(np.argmax(d * np.log(f2) - np.log(g)))
```
