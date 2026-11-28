> Source: session transcript, 2026-11-28

> What if the structure is not in the parity of the cell numbers but the zeros and what's inside the cell as integers in binary

> Lock, write, commit and run

From `run/bits.py`:

```
def v2(n): return None if n == 0 else (n & -n).bit_length() - 1
```
