> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `units/0327-rung-5-window-finding/unit.md`, the route this module shortens:

> The fix. The window's smoothness has to grow with its support. Replace the
> envelope `P` by its `m`-th power with `m` of the order of `h`. That is a
> truncated Gaussian. Its transform has a closed form: a constant times
> `sinh(w)` over `w` times the product over `j` up to `m` of `w² + π²j²`. At
> `m` equal to `m_check` 1 this is `π²·sinh(w)/(w(w² + π²))`, checked by hand
> against unit 0318's transform. The proof is the partial-fraction identity
> for a binomial sum over `j` of `(−1)^j·C(n, j)/(x + j)`, by induction on
> `n`, each step subtracting the shifted sum.

From `lean_stage3/Stage3/WeilPower.lean`, the statements as built:

```
theorem K_succ (m : ℕ) (w : ℂ) :
    K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2)
      = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w := by
```

```
theorem K_mul_Q (m : ℕ) (w : ℂ) : K m w * Q m w = (cK m : ℂ) * Complex.sinh w := by
```

```
theorem K_one_mul (w : ℂ) :
    K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Complex.sinh w := by
```
