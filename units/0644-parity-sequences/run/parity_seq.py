"""The parity of pi(2^m) and of the rows a(m) = pi(2^m) - pi(2^(m-1)), m = 1..92, against shuffles. EXPLORATORY.
Counts of odd values, runs (maximal stretches of one parity), the longest run, and autocorrelation at lags 1..10;
each against 20000 random orders of the same 92 values (random.seed 1 for runs, 2 for the rest)."""
import json, random, itertools
pi = [int(x) for x in open('pi_2pow.txt')]
a = [pi[m] - pi[m - 1] for m in range(1, 93)]
seqs = {"pi": [pi[m] % 2 for m in range(1, 93)], "row": [v % 2 for v in a]}
def runs(x): return 1 + sum(x[i] != x[i - 1] for i in range(1, len(x)))
def longest(x): return max(len(list(g)) for _, g in itertools.groupby(x))
def ac(x, k):
    n = len(x); mu = sum(x) / n
    return sum((x[i] - mu) * (x[i + k] - mu) for i in range(n - k)) / sum((v - mu) ** 2 for v in x)
out = {"rows": 92}
random.seed(1)
for name, x in seqs.items():
    sims = [runs(random.sample(x, 92)) for _ in range(20000)]
    out[name] = {"sequence": "".join(map(str, x)), "odd": sum(x), "runs": runs(x), "runs_shuffled_mean": round(sum(sims) / len(sims), 2),
                 "runs_p_le": round(sum(v <= runs(x) for v in sims) / len(sims), 3), "longest_run": longest(x),
                 "autocorr_lags_1_10": [round(ac(x, k), 3) for k in range(1, 11)]}
random.seed(2); N = 20000
out["pi"]["p_longest_ge_observed"] = round(sum(longest(random.sample(seqs["pi"], 92)) >= out["pi"]["longest_run"] for _ in range(N)) / N, 4)
out["row"]["p_longest_ge_observed"] = round(sum(longest(random.sample(seqs["row"], 92)) >= out["row"]["longest_run"] for _ in range(N)) / N, 4)
mx = max(abs(v) for v in out["row"]["autocorr_lags_1_10"])
out["row"]["p_max_abs_autocorr_ge_observed"] = round(sum(max(abs(ac(s, k)) for k in range(1, 11)) >= mx for s in (random.sample(seqs["row"], 92) for _ in range(5000))) / 5000, 4)
json.dump(out, open("parity_seq.json", "w"), indent=1); print(json.dumps(out, indent=1))
