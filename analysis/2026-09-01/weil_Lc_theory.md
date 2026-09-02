# L_c(eps, gamma) for a fixed test function — derivation page

EXPLORATORY. No prereg, no decision rule, no verdict. Companion to
`weil_Lc_theory.py` (this directory); numbers live in `weil_Lc_theory.txt`
and `results/weil_Lc_theory.json`. Conventions are `weil_Lc_mod.py`'s
(Bombieri 2000 eq. 12.2 normalisation; `weil_Lc_mod.py:1-66`).

## 1. The quadratic form on the zero side

For a real G supported in [-h, h], Ghat(t) = int G(u) e^{iut} du, and one
zero 1/2 + i gamma_k moved off the line to 1/2 +- eps + i gamma_k (pair -> pair,
w = 1/2):

```text
Q(G)   = Z'_k + tail + 2 w T_eps,          T_eps = 2 (|A|^2 - |B|^2)
Z'_k   = 2 sum_{j != k} |Ghat(gamma_j)|^2
A      = (Ghat(gamma_k - i eps) + Ghat(gamma_k + i eps)) / 2
B      = (Ghat(gamma_k - i eps) - Ghat(gamma_k + i eps)) / 2
tail   = (G(h)^2 + G(-h)^2) (log(gamma_N / 2 pi) + 1) / (pi gamma_N)      (zeros past the file)
```

L_c is the length 2h at which Q first turns negative on the instrument's
grid. With ||G||_2 = 1 the zero side is a number, and detection needs
2|B|^2 > Z'_k + tail + 2|A|^2 (w = 1/2).

## 2. Why the fixed window has an odd envelope

Write G(u) = E(u) cos(gamma u) with E supported in [-h, h] and h gamma >> 1.
Then Ghat(gamma_k +- i eps) = (1/2) Ehat(+- i eps) + (1/2) Ehat(2 gamma_k +- i eps),
and the second (2 gamma) lobe is O((h gamma)^-3) for a smooth E.

Even E (the brief's P(u/h) cos(gamma u)): Ehat(+- i eps) = int E cosh(eps u) du
+- ... ; the cosh part is the same for both signs, so A = (1/2) int E cosh(eps u) du
= O(1) and B = (1/2) int E sinh(eps u) du = 0 exactly (odd integrand).
T_eps = 2|A|^2 > 0 at every h: an even envelope never detects, at any
eps. This is the transform-side statement that Ghat(gamma_k) != 0 puts the
zero's own energy on the positive side of the form.

The measured minimisers have |A|^2 / |B|^2 between 1.6e-7 and 3.4e-3
(`results/weil_Lc_mod.json`, `ladder[...].minimiser_at_Lc.A2_over_B2`),
and their cos-block and sin-block Legendre coefficients sit in opposite
n-parities at every (k, eps) (Section 0 of `weil_Lc_theory.txt`): the
minimiser is, to first order, an odd envelope times the carrier. So the
fixed test function is

```text
G(u) = N (u/h) P(u/h) cos(gamma_k u),      P(x) = cos^2(pi x / 2),  x in [-1, 1],   ||G||_2 = 1.
```

Choice of P: the raised cosine over the Legendre-basis Slepian because
(a) int x P(x) sin(sx) dx is elementary, (b) P(+-1) = P'(+-1) = 0 so the
instrument's tail term vanishes identically, (c) the transform decays as
pi^2 cos s / s^3 with an explicit envelope bound, which is what the N(T)
far-tail bound needs. The k = 1000 minimiser envelope has no simple
description (Section 0: nearest of |x|P, P, x(1-x^2) at normalised L2
distance 0.44-0.46 over the three eps), so no attempt is made to copy it.

## 3. Closed forms (x = u/h, all integrals over [-1, 1])

```text
iota(a)  = (sin a - a cos a) / a^2 = a/3 - a^3/30 + a^5/840 - ...
Psi(s)   = int x P(x) sin(s x) dx = iota(s) + [iota(s + pi) + iota(s - pi)] / 2
         = pi^2 cos s / (s (s^2 - pi^2)) + (pi^4 - 3 pi^2 s^2) sin s / (s^2 (s^2 - pi^2)^2)
Sigma(s) = int x P(x) sinh(s x) dx = -i Psi(i s) = s m2 + s^3 m4 / 6 + ...
m2       = int x^2 P = 1/3 - 2/pi^2 = 0.130691
m22      = int x^2 P^2 = (2 - 15/pi^2) / 8 = 0.0600228
K(a)     = int x^2 cos(a x) dx = 2 [(a^2 - 2) sin a + 2 a cos a] / a^3
C(w)     = int x^2 P^2 cos(w x) dx = [3K(w) + 2K(w+pi) + 2K(w-pi) + (K(w+2pi) + K(w-2pi))/2] / 8
```

Transform and norm:

```text
Ghat(t)  = (i N h / 2) [Psi(h (t - gamma)) + Psi(h (t + gamma))]
||G||^2  = N^2 h [m22 + C(2 gamma h)] / 2 = 1   =>   (N h / 2)^2 = h / (2 (m22 + C(2 gamma h)))
```

(i) The off-line term. With Psi odd and Psi(-i s) = -i Sigma(s):

```text
Ghat(gamma -+ i eps) = (N h / 2) [ +- Sigma(eps h) + i Psi(2 gamma h -+ i eps h) ]
A = (i N h / 2) [Psi(2 gamma h - i eps h) + Psi(2 gamma h + i eps h)] / 2          (2 gamma lobe only)
B = (N h / 2)   [Sigma(eps h) + i (Psi(2 gamma h - i eps h) - Psi(2 gamma h + i eps h)) / 2]
```

First order in eps. B = int G e^{i gamma u} sinh(eps u) du = eps int u G e^{i gamma u} du + O(eps^3), so

```text
|B|^2 = eps^2 |int u G(u) e^{i u gamma} du|^2 + O(eps^4)
      = eps^2 (N h^2 m2 / 2)^2 + O(eps^4, (h gamma)^-3)
2|B|^2 = eps^2 h^3 m2^2 / (m22 + C(2 gamma h))  ->  eps^2 h^3 m2^2 / m22 = 0.2846 eps^2 h^3
```

The correction is Sigma(eps h)/(eps h m2) - 1 = (eps h)^2 m4/(6 m2) + ..., below 1e-2 for eps h < 0.25.
Section 1 of the txt tabulates first-order / exact at every root; Section 0
does the same check for the measured minimisers G_star:

```text
|int G_star e^{i gamma u} sinh(eps u) du|^2   by quadrature from the JSON coefficients, against the JSON |B|^2
eps^2 |int u G_star e^{i gamma u} du|^2       the first-order form, against the exact one
```

(ii) The RH background.

```text
Z'_k = 2 (N h / 2)^2 sum_{j != k} [Psi(h (gamma_j - gamma_k)) + Psi(h (gamma_j + gamma_k))]^2
```

Near lobe: |gamma_j - gamma_k| <= W = 4 mean gaps, summed exactly over the
file. Far tail: the exact file sum beyond W, and separately the bound

```text
sum_{far} f(gamma_j) <= int f dNbar + |int f dR|,       N(T) = Nbar(T) + R(T)
Nbar(T) = (T / 2 pi) log(T / 2 pi) - T / 2 pi + 7/8
|R(T)| <= Rmax(T) = 0.137 log T + 0.443 log log T + 4.35     (ASSUMED; Rosser 1941 form)
right of gamma_k + W:   |int_a^inf f dR| <= Rmax(a) f(a) + int_a^inf Rmax |f'|     (f decreasing)
left  of gamma_k - W:   f <= 2 Psi_b(h(gamma-t))^2 + 2 Psi_b(h(gamma+t))^2, each monotone, |int g dR| <= 2 Rmax(b) sup g
Psi_b(s) = min( 1/2 - 2/pi^2 ,  pi^2 / (s (s^2 - pi^2)) + (3 pi^2 s^2 - pi^4) / (s^2 (s^2 - pi^2)^2) )   (s >= 2 pi)
```

Psi_b >= |Psi| is checked numerically on [0, 2e5] (unit test U3). The same
right-side bound from gamma_N gives the contribution of zeros past the
file ("beyond" in the tables); it is the tail for this G, since the
instrument's (G(h)^2 + G(-h)^2) term is identically zero.

(iii) Pole and tail at this G. tail_instrument = 0 exactly. The pole term
of the explicit formula, int F(u) 2 cosh(u/2) du = 2 Ghat(i/2) Ghat(-i/2)
with F = G * G~, sits on the arithmetic side of the identity and is outside
Q (weil_QX.py:39-45); it is evaluated in closed form at each root and
checked against quadrature (U7), for the record only.

## 4. The balance and its two regimes

With w = 1/2, L_c^theory = 2 h* where

```text
2 |B|^2 (h*) = Z'_k (h*) + tail (h*)
```

solved on the instrument's L grid (extended downward with the same ratio)
by the first sign change and bisection in log h. In first order and with
C dropped the balance reads

```text
eps^2 h^2 m2^2 = sum_{j != k} [Psi(h delta_j) + Psi(h (gamma_j + gamma_k))]^2,    delta_j = gamma_j - gamma_k.
```

If the neighbours are inside the main lobe (h g << 1, g the local gap):
the zeros with h |delta_j| of order 1 dominate the sum, there are of order
1/(h g) of them, each contributes O(1), so the right side is ~ 1/(h g) and
eps^2 h^2 ~ 1/(h g): h ~ eps^{-2/3} g^{-1/3}.
If the neighbours are in the s^-3 tail (h g >> 1): Psi(h delta)^2 ~ pi^4 / (h delta)^6,
the sum is dominated by the nearest gap, eps^2 h^2 ~ (h g)^-6: h ~ eps^{-1/4} g^{-3/4}.
Both regimes appear in Section 3b as the exponent p of log L_c vs log eps.

## 5. Strip worst case

Ghat is entire of exponential type h, and |Ghat(sigma + it)| <= e^{|sigma - 1/2| h} sup_{t'} |Ghat(1/2 + it')|
along the line is the Paley-Wiener bound used; with the other zeros
anywhere in the strip (|sigma - 1/2| <= 1/2) each |Ghat(gamma_j)|^2 in the
leakage is replaced by its worst case e^{h} |Ghat(gamma_j)|^2. Z'_worst = e^{h} Z'.
Section 2 reports L_c^theory under this replacement and its ratio to the
RH value.

## 6. What the script measures

- Section 0: parity split and envelope distances of the 24 measured
  minimisers; |B|^2 exact by quadrature vs the JSON, and first order vs
  exact.
- Section 1: L_c^meas, L_c^theory, ratio, and every piece at h* (2|B|^2,
  Z_near, Z_far exact, Z_far N(T)-bound, beyond-file bound, 2|A|^2,
  n_near, eps h, first-order / exact).
- Section 2: L_c^theory with Z' -> near-only, far-only exact, far-only
  bound, e^{h} Z', first-order B, w = 1.
- Section 3: fits L_c = a + b log gamma_k per eps for each variant; slope
  over the measured slope; regression of L_c^meas on L_c^theory.
- Section 3b: exponent of L_c in eps per k, theory vs measured.
- Unit tests U1-U8 (`weil_Lc_theory.py` docstring).

Run record: `weil_Lc_theory.txt` header; `results/weil_Lc_theory.log` holds
the first run (crashed at the U6 projection line on a numpy broadcasting
precedence error, traceback in the file), `results/weil_Lc_theory_run2.log`
the complete run that wrote the txt and JSON.
