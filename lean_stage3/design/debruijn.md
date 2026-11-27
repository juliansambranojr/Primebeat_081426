# debruijn.md — block H2 of `heatflow.md`: every zero of `H_λ` is real for `λ ≥ 1/2`

Written 2026-11-26, a design and research worksheet. Read first after any
compaction; do not re-derive what is here. On paper, unchecked by anyone else.
No Lean module is built and no Lean build was run for it. The one `#check` run
failed, because the upstream module is not compiled in this tree (§ Build state).

## What is wanted

    Φ(u)     = Σ_{n≥1} (2π²n⁴e^{9u} − 3πn²e^{5u}) · exp(−πn²e^{4u})
    H_λ(z)   = ∫₀^∞ e^{λu²} Φ(u) cos(zu) du                  (z ∈ ℂ)
    H_0(z)   = Ξ(z/2)/8 = ξ(1/2 + iz/2)/8

    de Bruijn 1950:  H_λ(z) = 0  ⇒  (Im z)² ≤ max(1 − 2λ, 0)      (λ ≥ 0)
    so for λ ≥ 1/2 every zero of H_λ is real; the de Bruijn–Newman Λ ≤ 1/2.

The normalisation is Polymath 15 (1)–(4) and Rodgers–Tao (3)–(4), both opened.
`heatflow.md` writes `H_0(z) = Ξ(z)/8` and flags that the normalisation must be
read from the source. The source gives `Ξ(z/2)/8`, and so does unit 0578's
script (`run/heatflow.py` header: "the zeros of H_0 are x = 2*gamma").

Lean has no `λ` identifier (it is the lambda keyword), so the time is `t` below.

## The route, in one paragraph

Write `T_a f(z) = (f(z + ia) + f(z − ia))/2`, the operator `cos(a·d/dz)`.
On the Fourier side, `cos((z+ia)u) + cos((z−ia)u) = 2 cosh(au) cos(zu)`, so
`T_a` multiplies the kernel by `cosh(au)`, and `n` steps with `a² = 2t/n`
multiply it by `cosh(a u)ⁿ → e^{tu²}`. The core step is one inequality.
Take `f` real, even and entire of order `< 2`, with its zeros in `|Im| ≤ Δ`.
Then every zero of `T_a f` lies in `(Im)² ≤ max(Δ² − a², 0)`. The proof
compares `|f(z+ia)|` with `|f(z−ia)|` factor by factor in the Hadamard
product, taking each zero together with its conjugate. Iterating `n` times
takes the strip from `Δ²` to `max(Δ² − 2t, 0)` exactly, with no loss.
Hurwitz's theorem passes the strip to the limit `H_t`. The start is `Δ = 1`:
`ξ` has no zeros off `0 ≤ Re s ≤ 1`. That needs only the Euler product and
the functional equation, and it needs Riemann's identity `H_0 = Ξ(z/2)/8`.

De Bruijn's own statement is the strip theorem of Polymath 15 Theorem 3.2
(opened). Suppose `H_{t0}` has no zeros with `y > y0`. Then for `t > t0`,
`H_t` has no zeros with `y > max(y0² − 2(t − t0), 0)^{1/2}`. Polymath cites
it as "[5, Theorem 13]" without proof. The proof through `T_a` is from memory
of de Bruijn's method; the paper was not opened. The inequality it rests on
was derived here and checked numerically (§ Sources).

## Which properties of Φ are used, and where

- **Real-valued.** `H_t` is real on the real axis, so its zeros come in
  conjugate pairs (D1, D6).
- **Positive on `[0, ∞)`.** Each term is positive for `u ≥ 0`, because
  `2πn²e^{4u} ≥ 2π > 3`. So every weighted transform is positive at `0`.
  This gives non-triviality and puts no zero at the origin (D0, D1). Polymath
  §3 uses the same fact: "the positivity of Φ".
- **Super-exponential decay** `Φ(u) ≤ C·e^{9u − πe^{4u}}` on `[0, ∞)`. It
  makes the transforms entire and of order `< 2`, and it dominates the limit
  (D0, D1, D8).
- **Evenness of Φ is not used** by the strip machinery: `H_t` is even because
  `cos` is. Theta modularity enters once, inside D3, as the evenness of
  `Θ(u) = e^u·θ(e^{4u})`. That is Mathlib's `evenKernel_functional_equation`.
- **Hurwitz's theorem** is used (D7), in a max-modulus form.
- **Jensen's formula** is used only inside the upstream Hadamard proof.
- **Pólya's universal factor and the Laguerre–Pólya class** are not used as
  objects. The `T_a` iteration is their quantitative form. The universal-factor
  theorem alone gives only monotonicity: real zeros at `t₀` give real zeros at
  every `t > t₀`. It cannot shrink a strip, so it cannot give `1/2`.

## Build state (read before the first brief)

- PNT+ is pinned at `47fa48680663df41146704d02a5b092d792bd5b9`, the
  `.lake/packages/PrimeNumberTheoremAnd` HEAD. Its source holds general
  Hadamard factorization. Opened:
  `PrimeNumberTheoremAnd/Mathlib/Analysis/Complex/HadamardFactorization/Order.lean`,
  `Complex.Hadamard.hadamard_factorization_of_order` (line 176):

      theorem hadamard_factorization_of_order {f : ℂ → ℂ} {ρ : ℝ} (hρ : 0 ≤ ρ)
          (hnot : ∃ z : ℂ, f z ≠ 0)
          (horder : EntireOfOrderAtMost ρ f) :
          ∃ (P : Polynomial ℂ),
            P.degree ≤ Nat.floor ρ ∧
            ∀ z : ℂ,
              f z =
                Complex.exp (Polynomial.eval z P) *
                  z ^ (analyticOrderNatAt f 0) *
                  divisorCanonicalProduct (Nat.floor ρ) f (Set.univ : Set ℂ) z

  with `EntireOfOrderAtMost ρ f := Differentiable ℂ f ∧ ∀ ε > 0, ∃ C > 0,
  ∀ z, ‖f z‖ ≤ Real.exp (C * (1 + ‖z‖) ^ (ρ + ε))` (line 78).
- **Not compiled here.** `lake env lean` on
  `import PrimeNumberTheoremAnd.Mathlib.Analysis.Complex.HadamardFactorization.Order`
  stops with "object file ... HadamardFactorization/Order.olean ... does not
  exist". Built: `HadamardFactorization.olean`,
  `HadamardFactorization/Summability.olean`, `Divisor*.olean`,
  `CanonicalProduct.olean`, `WeierstrassFactor.olean`. Not built: `Growth`,
  `Order` (492 + 325 source lines), `Analysis/SpecialFunctions/CompletedXi`,
  `NumberTheory/LSeries/RiemannZetaHadamard`. The first module that imports
  them compiles them, so the first D5/D6 build costs upstream compile time.
  That cost is not counted below.

## Blocks

### D0 The kernel — OPEN
Objects.   `dbnPhi u = Σ' n : ℕ, (2π²(n+1)⁴ e^{9u} − 3π(n+1)² e^{5u}) e^{−π(n+1)² e^{4u}}`.
Statement. (a) summable for every real `u`, continuous on `ℝ`.
           (b) `0 < dbnPhi u` for `0 ≤ u`.
           (c) `dbnPhi u ≤ C · e^{9u − πe^{4u}}` for `0 ≤ u`, with a crude
               explicit `C`: `e^{−πn²e^{4u}} ≤ e^{−πe^{4u}} e^{−π(n²−1)}` and
               `Σ n⁴ e^{−π(n²−1)}` is finite.
Route.     Termwise. (b) uses `2π(n+1)²e^{4u} ≥ 2π > 3`.
Composes.  Mathlib `Real.summable_...` comparisons (to be grepped at brief time).
Size.      120–200 lines. Easy.

### D1 The weighted transforms — OPEN
Objects.   For a weight `w : ℝ → ℝ`, `0 ≤ w u ≤ K·e^{c u²}` on `[0, ∞)`:
           `dbnW w z = ∫ u in Ioi 0, (w u * dbnPhi u : ℂ) * Complex.cos (z * u)`.
           `dbnH t = dbnW (fun u ↦ rexp (t * u^2))`.
Statement. (a) `Differentiable ℂ (dbnW w)`.
           (b) real: `dbnW w (conj z) = conj (dbnW w z)`; even: `dbnW w (−z) = dbnW w z`.
           (c) `0 < (dbnW w 0).re` and `(dbnW w 0).im = 0` when `0 < w` on `Ioi 0`.
           (d) `EntireOfOrderAtMost (3/2) (dbnW w)`. Any `ρ ∈ [1, 2)` gives genus
               `Nat.floor ρ = 1`. `3/2` is crude on purpose: the estimate is
               `|cos(zu)| ≤ e^{|z|u}`, split at `u = 1 + log(1 + |z|)`, which
               gives `exp(O(|z| log |z|)) ≤ exp(C(1 + |z|)^{3/2})`.
           (e) limit: if `w_n → w` pointwise on `Ioi 0` and `|w_n| ≤ w̄` with `w̄`
               of the same type, then `dbnW w_n → dbnW w` uniformly on every
               `{|Im z| ≤ R}`. Dominated convergence on the single integrand
               `|w_n − w|·Φ·cosh(Ru)`, which does not depend on `z`.
Route.     (a) by `hasDerivAt_integral_of_dominated_loc_of_deriv_le`
           (Mathlib `Analysis/Calculus/ParametricIntegral.lean`, grepped). The
           rest is pointwise.
Size.      300–450 lines. Moderate. Most of it is (a) and (d).

### D2 The shift is the cosh weight — OPEN
Statement. `T_a (dbnW w) = dbnW (fun u ↦ w u * Real.cosh (a*u))`, with
           `T_a f z = (f (z + a*I) + f (z − a*I)) / 2`. So
           `(T_a)^[k] (dbnH 0) = dbnW (fun u ↦ Real.cosh (a*u) ^ k)`.
Route.     `cos(x + iy) + cos(x − iy) = 2 cos x cosh y`, linearity of the
           integral (both shifted integrands integrable by D1's bound), then
           induction on `k`.
Size.      60–100 lines. Easy.

### D3 Riemann's integral for Ξ — OPEN (the largest block; can be a leaf)
Statement. `dbnH 0 z = riemannXi (1/2 + I*z/2) / 8` for all `z : ℂ`.
           `riemannXi s = (s(s−1)·completedRiemannZeta₀ s + 1)/2`, from PNT+
           `Mathlib/Analysis/SpecialFunctions/CompletedXi.lean` (opened, line 47).
Route.     Written here, checked on paper only. It avoids both the evenness of
           Φ and any integral over the whole line.
  D3a  `θ(x) = evenKernel 0 x = Σ_{n∈ℤ} e^{−πn²x}`, and `Θ(u) = e^u θ(e^{4u})` is
       even in `u`. Source: `evenKernel_functional_equation` (Mathlib
       `NumberTheory/LSeries/HurwitzZetaEven.lean:132`,
       `θ(x) = x^{−1/2} θ(1/x)`).
  D3b  With `g(u) = Θ(u) − e^u = 2e^u ψ(e^{4u})` and `ψ = Σ_{n≥1} e^{−πn²x}`:
       `dbnPhi u = (g''(u) − g(u)) / 16` for `u ≥ 0`. Termwise: for
       `g_n = 2e^u e^{−πn²e^{4u}}`, `g_n'' − g_n = 16(2π²n⁴e^{9u} − 3πn²e^{5u})e^{−πn²e^{4u}}`
       (checked by hand). Needs the series differentiated twice, uniformly on
       `[0, ∞)`.
  D3c  `g'(0) = −1`. `Θ` is even and differentiable, so `Θ'(0) = 0`, and
       `Θ' = e^u + g'`. This is `ψ(1) + 4ψ'(1) = −1/2` without computing a
       derivative of the functional equation.
  D3d  Two integrations by parts on `Ioi 0`, with `g` and `g'` decaying at `∞`:
       `∫₀^∞ g'' cos(zu) = −g'(0) − z² ∫₀^∞ g cos(zu)`, so
       `dbnH 0 z = (1 − (z² + 1)·J(z)) / 16` with `J(z) = ∫₀^∞ g(u) cos(zu) du`.
       Mathlib `integral_Ioi_mul_deriv_eq_deriv_mul`
       (`MeasureTheory/Integral/IntegralEqImproper.lean:1350`, grepped).
  D3e  Substitute `x = e^{4u}`: `J(z) = (1/4)(I(s₊) + I(s₋))`, where
       `I(s) = ∫₁^∞ ψ(x) x^{s−1} dx` and `s± = (1 ± iz)/4`.
  D3f  Mathlib's `completedRiemannZeta₀ S = (hurwitzEvenFEPair 0).Λ₀ (S/2) / 2`
       (`RiemannZeta.lean:64`, `HurwitzZetaEven.lean:302`). Here
       `Λ₀ = mellin f_modif` (`AbstractFuncEq.lean:376`), and the pair has
       `f = evenKernel 0`, `f₀ = 1`, `k = 1/2`, `ε = 1`, `g = cosKernel 0 = f`
       (`HurwitzZetaEven.lean:254`, opened). On `(0,1)` the integrand of
       `f_modif` is `θ(x) − x^{−1/2}`. Substitute `x ↦ 1/x` and use the
       functional equation:
       `Λ₀(s) = 2(I(s) + I(1/2 − s))`, hence
       `completedRiemannZeta₀ S = I(S/2) + I((1−S)/2)`.
       At `S = 1/2 + iz/2`: `S/2 = s₊`, `(1−S)/2 = s₋`, `S(S−1) = −(z²+1)/4`. So
       `riemannXi S = 1/2 − ((z²+1)/8)(I(s₊) + I(s₋)) = 8 · dbnH 0 z`. ✓
Composes.  `mellin_comp_inv` (`Analysis/MellinTransform.lean:154`), PNT+
           `riemannXi`. Grep the change-of-variables lemma on `Ioi` for D3e at
           brief time.
Leaf.      Until D3 is built, D4 can take `StmtXiPhi : ∀ z, dbnH 0 z = riemannXi
           (1/2 + I*z/2) / 8` as a named Prop. Citation: Titchmarsh §2.16 (2.16.1);
           Polymath 15 eq. (3), citing "[27, p. 255]". Budget: none, it is an
           identity. Route: D3a–D3f. D5–D8 do not depend on it.
Size.      450–750 lines. Moderate to hard: long bookkeeping, no new idea.
           D3b and D3f are the bulk.

### D4 The starting strip — OPEN
Statement. `dbnH 0 z = 0 → |z.im| ≤ 1`.
Route.     Let `s = 1/2 + iz/2`, so `Re s = 1/2 − Im z / 2`. If `Re s > 1`:
           `riemannXi_eq_mul_completedRiemannZeta` (PNT+ CompletedXi.lean:66),
           `completedRiemannZeta = Gammaℝ · ζ`, `riemannZeta_ne_zero_of_one_lt_re`
           (Mathlib `LSeries/Dirichlet.lean:326`), `Gammaℝ_ne_zero_of_re_pos`
           (`Gamma/Deligne.lean:66`). If `Re s < 0`: `riemannXi_one_sub`
           (CompletedXi.lean:74). The closed strip is enough, because D6 works
           with `|Im| ≤ Δ`, and Polymath's proof of Prop. 3.3 says the same
           ("no zeroes H0(x + iy) = 0 with y > 1").
Size.      50–90 lines. Easy.

### D5 Conjugate pairing on the upstream zero index — OPEN
Objects.   `divisorZeroIndex f U = Σ z : ℂ, Fin (Int.toNat (MeromorphicOn.divisor f U z))`
           and `divisorZeroIndex₀ = {p // p.1 ≠ 0}` (PNT+ `DivisorIndex.lean:39–48`, opened).
Statement. For `f` entire and real (`f (conj z) = conj (f z)`), there is
           `e : divisorZeroIndex₀ f univ ≃ divisorZeroIndex₀ f univ` with
           `val (e p) = conj (val p)`.
Route.     `analyticOrderAt f (conj z) = analyticOrderAt f z` (conj is an
           isometric ℝ-linear involution that intertwines `f` with itself), so the
           divisor is conj-invariant. Map `⟨z, k⟩ ↦ ⟨conj z, cast k⟩`.
Size.      100–200 lines. Moderate. The risk is the upstream API, not the maths.

### D6 The de Bruijn step — OPEN (the hardest block)
Statement. Hypotheses on `f : ℂ → ℂ`:
           `EntireOfOrderAtMost (3/2) f`, `f 0 ≠ 0`, `f` real, `f` even,
           `0 ≤ Δ`, and `∀ w, f w = 0 → |w.im| ≤ Δ`.
           Let `0 < a`. Then `∀ z, T_a f z = 0 → z.im ^ 2 ≤ max (Δ^2 − a^2) 0`.
Sizes.     The pair identity, for `w = u + iv`, `p = x − u`, and
           `q(τ) = |x + iτ − w|²·|x + iτ − w̄|²`, is
               `q(A) − q(B) = (A² − B²)(2p² + A² + B² − 2v²)`.
           Take a zero `z = x + iy` of `T_a f` with `y > 0` and `y² > Δ² − a²`.
           Reality gives `|f(z − ia)| = |f(x + iB)|` with `A = y + a`, `B = a − y`.
           Then `A² − B² = 4ay > 0` and `A² + B² = 2(y² + a²) > 2Δ² ≥ 2v²`, so
           every pair term is strictly positive. A real zero `v = 0`, unpaired,
           gives `A² − B² > 0`. The Weierstrass exponentials cancel inside each
           conjugate pair: `Re((x+iτ)(1/w + 1/w̄)) = 2x·Re(1/w)` does not depend
           on `τ`. The `exp(P)` factor has a real linear coefficient: `|f|` and the
           product are conj-invariant (D5), so `Re P(z̄) = Re P(z)`, which forces
           `Im P'(0) = 0`. Nothing is lost: the bound after `n` steps is exactly
           `max(Δ² − n a², 0)`.
Route.     Hadamard (above) with `analyticOrderNatAt f 0 = 0` from `f 0 ≠ 0`.
           Take `log ‖·‖` of the product as a `tsum`. It is summable because
           `log|E₁(ζ)| = O(|ζ|²)` (PNT+ `weierstrassFactor_sub_one_pow_bound`,
           `WeierstrassFactor.lean:211`) and `Σ ‖a_p‖⁻²` converges (PNT+
           `EntireOfOrderAtMost.summable_norm_inv_pow_divisorZeroIndex₀`,
           `Order.lean:160`, power `Nat.floor ρ + 1 = 2`). Use
           `S = Σ d_p = Σ d_{e p}` (D5's `Equiv.tsum_eq`), so `2S = Σ (d_p + d_{e p}) > 0`.
           An empty index means `f = e^{αz+β}`, and evenness forces `α = 0`, so
           `T_a f = f` has no zeros. If `f(z ± ia) = 0`, then `(y + a)² > Δ²`
           contradicts the strip. `y < 0` follows by conjugation and `y = 0` is
           trivial.
Size.      300–550 lines. Hard. It is the only block with a new argument at the
           Lean level, and its plumbing (log of a `tprod`, reindexing a `tsum`
           over D5's equivalence) is untested against the upstream API.

### D7 Hurwitz, max-modulus form — OPEN
Statement. Suppose `F_n → F` uniformly on compacts of `ℂ`, `F` is entire,
           `F 0 ≠ 0`, and `F z₀ = 0`. Then for every `r > 0`, frequently
           `∃ z ∈ ball z₀ r, F_n z = 0`.
Route.     The zero is isolated (`AnalyticAt.eventually_eq_zero_or_eventually_ne_zero`,
           `Analysis/Analytic/IsolatedZeros.lean:125`; identity theorem
           `eqOn_zero_of_preconnected_of_frequently_eq_zero`, line 214). Take a
           sphere `|z − z₀| = ρ < r` with `|F| ≥ m > 0` on it; eventually
           `|F_n| ≥ m/2` there. If `F_n` has no zero in the ball, then
           `‖1/F_n(z₀)‖ ≤ 2/m` by `Complex.norm_le_of_forall_mem_frontier_norm_le`
           (`Analysis/Complex/AbsMax.lean:400`), which contradicts `F_n z₀ → 0`.
           Mathlib has no Rouché and no Hurwitz (grep: no match for "Rouche";
           "hurwitz" matches only Hurwitz zeta); PNT+'s `LocallyUniformLimit.lean`
           has one lemma, `TendstoUniformlyOn.mul_left_bounded`.
Size.      100–180 lines. Moderate.

### D8 Assembly — OPEN
Statement. `debruijn_strip : 0 ≤ t → dbnH t z = 0 → z.im ^ 2 ≤ max (1 − 2*t) 0`;
           `debruijn_half  : 1/2 ≤ t → dbnH t z = 0 → z.im = 0`.
Route.     `t = 0` is D4. For `t > 0`, take `a_n = √(2t/n)`. By induction on
           `k ≤ n`, using D6 with D1/D2 supplying its hypotheses, the zeros of
           `(T_{a_n})^[k] (dbnH 0)` satisfy `(Im)² ≤ max(1 − k a_n², 0)`; at
           `k = n` this is `max(1 − 2t, 0)`. The limit is D1(e) with
           `w_n = cosh(a_n u)^n`. Domination: `cosh(a_n u)^n ≤ e^{tu²}`
           (`Real.cosh_le_exp_half_sq`, `Trigonometric/Series.lean:154`). Pointwise:
           squeeze `(1 + tu²/n)^n ≤ cosh(a_n u)^n ≤ e^{tu²}`, then
           `Real.tendsto_one_add_div_pow_exp` (`Complex/LogBounds.lean:440`).
           At a zero `z₀` of `dbnH t` with `(Im z₀)² > max(1 − 2t, 0)`, a ball
           misses the strip, so D7 gives a contradiction (`dbnH t 0 > 0` by D1(c)).
Module.    `Stage3/DeBruijn*.lean`, namespace `DeBruijn`. Pins: `debruijn_strip`,
           `debruijn_half`, `deBruijn_step` (D6), `hurwitz_zero` (D7).
Size.      120–200 lines. Moderate.

### D9 Free extensions — OPEN, optional
Run D1–D8 from base `dbnW (e^{t₀u²})` in place of `dbnH 0`. That proves
Polymath's Theorem 3.2 in full: no zero above `y₀` at `t₀` gives no zero above
`max(y₀² − 2(t − t₀), 0)^{1/2}` at `t`. It does not need D3. `y₀ = 0` is
Pólya's monotonicity, which Newman's `Λ` rests on. 30–80 lines on top of D8.

## The hardest step, and shorter routes

**Hardest: D6, with D5 under it.** It is short mathematics resting on two
untested upstream interfaces: the `tprod`/`tsum` of the Hadamard product, and
the divisor index. **Largest: D3.** After the `Θ` trick (D3a–D3c) it is
routine calculus, and it can stay a named leaf while D5–D8 are built.

Routes considered:
- **Zero dynamics** (`dz_k/dt = 2Σ 1/(z_k − z_j)`, giving `d(y²)/dt ≤ −2`;
  Polymath 15 §3, Prop. 3.1 and 3.3, opened). This is the heuristic the
  statement comes from. A Lean version needs simple and multiple zeros,
  the implicit function theorem in `t`, and Rouché. Longer.
- **Pólya's universal factor / closure of the Laguerre–Pólya class** under
  `e^{−tD²}`. It gives monotonicity only (D9 with `y₀ = 0`). It cannot turn
  a strip into the real line.
- **Newman 1976, the Lee–Yang route.** It shows `Λ` exists and is `< ∞`, with
  no explicit bound. From memory.
- **Ki–Kim–Lee 2009, `Λ < 1/2`.** Much harder. From memory.
- **The `T_a` route of this worksheet** is the shortest one known here.
  Hadamard is upstream; D6 is one finite inequality; D7 and D8 are
  dominated convergence plus max modulus. The link to `ξ` (D3) cannot be
  avoided for `Δ = 1`, but it is one isolated identity.

**Total.** D0–D8: about 1600–2700 lines. Adding D9: about 1650–2800. Upstream
compile of `Growth`, `Order` and `CompletedXi` comes on top.

## Sources

Opened this session:
- Polymath 15, "Effective approximation of heat flow evolution of the Riemann ξ
  function, and a new upper bound for the de Bruijn–Newman constant",
  arXiv:1904.12438v2 (PDF fetched from arxiv.org). Used: the definitions (1)–(4),
  `H_0(z) = ξ(1/2 + iz/2)/8`, Theorem 3.2 (de Bruijn's strip bound, cited
  "[5, Theorem 13]"), and §3 (positivity of Φ, order 1, Hadamard, zero dynamics).
- Rodgers–Tao, "The De Bruijn–Newman constant is non-negative",
  arXiv:1801.05914. Used: the intro, which says the same as Polymath on de
  Bruijn and on Pólya's monotonicity.
- Mathlib and PNT+ at the pins, the files and lines named in each block. All
  were grepped; the definitions, `hadamard_factorization_of_order`,
  `hurwitzEvenFEPair` and `riemannXi` were opened.
- Unit 0578 (`unit.md`, `run/heatflow.py`) and `lean_stage3/design/heatflow.md`.

Not opened (the hosts were unreachable: projecteuclid.org, terrytao.wordpress.com,
export.arxiv.org and wikipedia all returned no connection):
- de Bruijn, "The roots of trigonometric integrals", Duke Math. J. 17 (1950)
  197–226. That the `T_a` iteration is de Bruijn's own proof of Theorem 13 is
  from memory.
- Newman 1976 (Proc. AMS 61), Csordas–Smith–Varga 1994, Ki–Kim–Lee 2009, and
  Titchmarsh §2.16. Their content above is from memory or from the citations
  inside Polymath and Rodgers–Tao.

Exploratory checks, no unit, scratch only
(`/tmp/claude-0/-home-user/d2968cf2-ba85-5b2d-a2ea-bf06a81f4dbc/scratchpad/chk.py`,
`chk2.py`):
- The pair identity, at 10⁴ random points: residual at rounding level, about
  `1.6e-13`.
- One `T_a` step, on 300 random real even polynomials with zeros in `|Im| ≤ 1`,
  at 60 digits: no zero outside `(Im)² ≤ max(1 − a², 0)`. A first double-precision
  run through `numpy.polyfit` reported violations; the exact rerun showed they
  were conditioning errors.
- The factor 8: `∫₀^∞ Φ = 0.0621400972735393` and `ξ(1/2)/8 = 0.0621400972735393`.
