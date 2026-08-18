# Local-only results artifacts

Three O24 result JSONs exceed 25 MB and are excluded from this
repository by explicit filename in `/.gitignore`. They are **not
deleted** — they exist in the working tree at
`/Users/juliansambrano/GitHub/Primebeat_081426/results/`.

Only per-row detail is missing from the repo. For each excluded JSON
the corresponding `_run.log` **is** committed, and it carries the
headline numbers, the chains, and the scaling-band readings.

| Excluded artifact | Size (bytes) | sha256 | Log carrying headline numbers |
| --- | ---: | --- | --- |
| `results/O24_gen_xmax3e9_results.json` | 71,341,222 | `9cb932d3a8f7a86dc43658c4455140a2a477dbb34130b7bb3f987c7985f0684d` | `results/O24_gen_xmax3e9_run.log` |
| `results/O24_gen_xmax1e9_results.json` | 53,218,022 | `76f7457b3359382991b6a9d3b7036d2b9037b0e2d0eb823409d3c999bf7a7765` | `results/O24_gen_xmax1e9_run.log` |
| `results/O24_gen_to19_results.json` | 31,251,415 | `3ad554f8253471e929a26df5ad1d4c6b20dc0815785e60246dfaff3c095be03f` | `results/O24_gen_to19_run.log` |

All three are outputs of `O24_prime_generator_orbit.py`.

To verify a copy you have been given:

```sh
shasum -a 256 results/O24_gen_xmax3e9_results.json
```

Every other file under `results/` is committed in full.
