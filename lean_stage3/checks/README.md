# lean_stage3/checks — the numeric checks the Lean files and the design cite

Each folder holds a script, run before its Lean was written to check a size or
an identity, and a `.out` file recording a fresh run of it from this folder,
with its date and exit code. Nothing here is a proof; each is labelled in the
file that cites it.

| script | cited by | what it checks |
|---|---|---|
| `conrey_sz/vsize.py`, `vdisc.py` | `Stage3/ConreyCountEdge.lean` | Conrey's V on the right edge and on the discs |
| `digamma/hsize.py` | `Stage3/DigammaBound.lean`, `DigammaBoundSize.lean` | the gamma ratio on small circles, flat in T |
| `kfl/kfl.py` | `Stage3/FloorConstLimit.lean` | the closed form `Kfl` against the operator, sympy |
| `fcq/check.py`, `nums.py`, `nums2.py`, `pick.py` | `Stage3/FloorConstQLimit.lean`, `FloorConstQ.lean` | `KflQ` against Young's (1.3); the rationals of the cubic choice |
| `fcq/opt.py` (reads `kappa_orig.py`) | `Stage3/FloorConstQ.lean` | the optimum floor at θ = 0.49 |
| `grratio/check.py` | `Stage3/GrRatio.lean` | the gamma-factor derivative ratios |
| `meanq/check.py` | `Stage3/MeanQRed.lean` | V against Q(−D/L)ζ |
| `opq/linecheck.py` | `Stage3/OperatorQ.lean` | Levinson's line identity failing for a cubic Q, holding for W |
| `b2_unconstrained/b2.py` | `units/0551-long-mollifier-kappa` | the invalid first run, Q unconstrained |

Run each from its own folder: `python3 -I <script>.py`; `fcq/nums.py` and
`fcq/pick.py` import `check.py` from their folder, so run them with `python3`.
The measurements with results are units: 0551, 0554, 0562, 0564, 0565.
