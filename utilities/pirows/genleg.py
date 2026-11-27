import sys, math, sympy, re
sys.setrecursionlimit(100000)
R=int(sys.argv[1]); PER=int(sys.argv[2]) if len(sys.argv)>2 else 20
X=2**R; s=math.isqrt(X)
ps=[p for p in range(s,1,-1) if sympy.isprime(p)]
def phi(x,L):
    if not L or x<=1: return x
    return phi(x,L[1:])-phi(x//L[0],L[1:])
vals=[phi(X//p,ps[i+1:]) for i,p in enumerate(ps)]
n=len(ps); mods=[]
open(f"PiW{R}.lean","w").write(f'''import Legendre

namespace Legendre

/-- The `i`-th peeled term of row {R}. -/
def F{R} (i : ℕ) : ℕ := phi ({X} / (primesTo {s}).getD i 0) ((primesTo {s}).drop (i + 1))

/-- Its value, as a lookup table. -/
def W{R} (i : ℕ) : ℕ := {"["+", ".join(map(str,vals))+"]"}.getD i 0

end Legendre
''')
groups=[]
for g in range(0,n,PER):
    e=min(n,g+PER); m=f"PiL{R}_{g}"; mods.append(m); groups.append((g,e))
    open(m+".lean","w").write(f'''import PiW{R}

namespace Legendre

set_option maxHeartbeats 0 in
theorem g{R}_{g} : ∀ i ∈ Finset.Ico {g} {e}, F{R} i = W{R} i := by
  decide +kernel

end Legendre
''')
pis=int(sympy.primepi(s)); piX=int(sympy.primepi(X))
cases=""
for k,(g,e) in enumerate(groups):
    cases+=f"  {'if' if k==0 else 'else if'} h{k} : i < {e} then exact g{R}_{g} i (Finset.mem_Ico.mpr ⟨by omega, h{k}⟩)\n"
cases+="  else omega\n"
open(f"PiRow{R}.lean","w").write("/-\n"+f"PiRow{R} — row {R} of the π list by Legendre's formula, `π(2^{R}) + 1 = φ(2^{R}, primes ≤ {s}) + π({s})`.\n`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into {n} terms `F{R} i`; each block file `PiL{R}_*` checks\n`F{R} i = W{R} i` on its indices in one kernel evaluation, and the table `W{R}` is summed here.\n"+"-/\n"+"".join(f"import {m}\n" for m in mods)+f'''import PiRow{R-1}

namespace PiChunks
open Legendre

theorem pi_{s} : Nat.primeCounting {s} = {pis} := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

theorem F{R}_eq_W{R} : ∀ i, i < {n} → F{R} i = W{R} i := by
  intro i hi
{cases}
set_option maxHeartbeats 0 in
theorem pi{R} : Nat.primeCounting (2 ^ {R}) = {piX} := by
  have hpeel := phi_add_peel (primesTo {s}) (primesTo_prime {s}) (primesTo_nodup {s}) (x := {X}) (by norm_num)
  have hsum := peel_eq_sum {X} (primesTo {s})
  have hlen : (primesTo {s}).length = {n} := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range {n}, phi ({X} / (primesTo {s}).getD i 0) ((primesTo {s}).drop (i + 1)))
      = ∑ i ∈ Finset.range {n}, F{R} i := rfl
  have hW : ∑ i ∈ Finset.range {n}, F{R} i = ∑ i ∈ Finset.range {n}, W{R} i :=
    Finset.sum_congr rfl fun i hi => F{R}_eq_W{R} i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range {n}, W{R} i = {sum(vals)} := by decide +kernel
  have hL := primeCounting_eq_phi (x := {X}) (s := {s}) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_{s}] at hL
  rw [show (2 : ℕ) ^ {R} = {X} by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … {R}, proved.** -/
theorem piData_le{R} : ∀ n : Nat, n ≤ {R} →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n {R} with h | h
  · exact piData_le{R-1} n (by omega)
  · have : n = {R} := by omega
    subst this; rw [pi{R}]; decide

end PiChunks

/-- info: 'PiChunks.piData_le{R}' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le{R}
''')
lf=open('lakefile.toml').read()
lf=re.sub(r'"PiL%d_\d+", |"PiW%d", |, "PiRow%d"|"PiRow%d", '%(R,R,R,R),'',lf)
lf=lf.replace('"Legendre"','"Legendre", '+", ".join(f'"{m}"' for m in [f"PiW{R}"]+mods+[f"PiRow{R}"]),1)
open('lakefile.toml','w').write(lf)
print(" ".join([f"PiW{R}"]+mods+[f"PiRow{R}"]))
