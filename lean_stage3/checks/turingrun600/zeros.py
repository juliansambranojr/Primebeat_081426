"""Zeros of Z(t) up to a height, by mpmath's zetazero, cached in zeros.txt (n, gamma_n).
Block S14 of `lean_stage3/design/stencil.md`, Turing's point run."""
import os, sys
import mpmath as mp
mp.mp.dps = 25
HERE = os.path.dirname(os.path.abspath(__file__))
PATH = os.path.join(HERE, "zeros.txt")

def load():
    out = []
    if os.path.exists(PATH):
        for line in open(PATH):
            n, g = line.split()
            out.append(mp.mpf(g))
    return out

if __name__ == "__main__":
    H = float(sys.argv[1]) if len(sys.argv) > 1 else 600
    zs = load()
    n = len(zs)
    with open(PATH, "a") as fh:
        while not zs or zs[-1] < H:
            n += 1
            g = mp.im(mp.zetazero(n))
            zs.append(g)
            fh.write(f"{n} {mp.nstr(g, 22)}\n")
    print(len(zs), zs[-1])
