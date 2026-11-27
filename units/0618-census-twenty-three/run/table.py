# The dyadic table to row 23 from a sieve: row r is pi(2^r) - pi(2^(r-1)); depth d is the d-th backward difference.
import json
R = 23
n = 2 ** R
s = bytearray([1]) * (n + 1); s[0] = s[1] = 0
for i in range(2, int(n ** 0.5) + 1):
    if s[i]: s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
pi, c, k = {}, 0, 0
for x in range(n + 1):
    c += s[x]
    if x == 2 ** k: pi[k] = c; k += 1
row = {r: pi[r] - pi[r - 1] for r in range(1, R + 1)}
def cell(r, d):
    from math import comb
    return sum((-1) ** i * comb(d, i) * row[r - i] for i in range(d + 1))
zeros = [[r, d] for r in range(1, R + 1) for d in range(1, r) if cell(r, d) == 0]
json.dump({"pi22": pi[22], "pi23": pi[23], "zeros": zeros, "n_zeros": len(zeros),
           "cells": sum(r - 1 for r in range(1, R + 1))}, open("table.json", "w"), indent=1)
print(zeros, pi[22], pi[23])
import glob, os
blocks = len(glob.glob('../../../lean/PiL23_[0-9]*.lean'))
json.dump({**json.load(open("table.json")), "row23_block_files": blocks}, open("table.json", "w"), indent=1)
