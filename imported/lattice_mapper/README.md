# imported/lattice_mapper — b-adic difference tables (imported evidence)

**Source:** `/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/`
**Copied:** 2026-08-18, byte-for-byte (`cp -p`); every file SHA-256 verified
source-vs-destination at copy time. Source tree was read-only throughout.

**These are imported evidence, not outputs of this bench.** No script in
Primebeat_081426 produced them and none should regenerate them. They are here
because `lab_notebook.md` entry 17 cites `triadic_difference_table_32.csv` by a
path outside this repo; this directory closes that provenance gap.

## Convention (holds for every file below)

Power-regime, **backward** differences: `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, and
`delta_d` at regime r is the d-th backward difference ending at r
(verified: stored `delta_1@r2` == `A(2) − A(1)` in all 26 tables).

**The primes 2 and 3 are excluded as lattice, not counted as primes** — the
convention entry 17 records for the triadic table. It holds for every base
here, not just base 3: `A(1) = π(b) − 2` for b ≥ 3, and for b = 2 the two
lattice primes straddle the regime boundary (2 in (1,2], 3 in (2,4]) so one
is dropped from each of `A(1)` and `A(2)`.

`silenceXYZ` suffixes silence the additionally-named primes; each silenced
prime landing in (b, b²] decrements cell (2,1) by exactly one.

## What was deliberately NOT imported

`archive_unsilenced/` — excluded on purpose. It is an earlier generation using
**forward** differences with **only 2** dropped (`gen_difference_table.py:22-29`,
`silenced_primepi` subtracts 1), its `*_64bit_*.csv` files use a third schema
(`pi_n`, integer regime), and it carries ~58 MB of binaries. Mixing conventions
in one imported directory is the confusion this import exists to end. It
remains readable in place at the source path above.

## Caveat on `source_README.md`

The source README describes `64bit/` as an integer-regime `π(n)` table. That is
stale — the two files actually imported here are power-regime `A_count` tables
on the same convention as `32bit/`, verified identical to `32bit/` on all 496
overlapping cells. The description fits the `archive_unsilenced/*_64bit_*` files.

## Manifest — SHA-256 and source mtime

| file | sha256 | source mtime |
|---|---|---|
| `32bit/composite_minus_prime_32.csv` | `12cd25b2151c6f3e77ef8502ed3ad5e5301c14b7151298a07fb98d6a40c7c6b8` | 2026-02-11T11:55:05 |
| `32bit/dyadic_composite_difference_table_32.csv` | `f1688fef149d59b292a6325068f2be546fdce68e7cda614f408c9bc4ac7d4f50` | 2026-02-11T01:12:10 |
| `32bit/dyadic_composite_difference_table_32_silence46.csv` | `c738812b68fb9f5d23003c96ec25710688379a23bdf762b0e64503aa1fa145c1` | 2026-02-11T01:12:10 |
| `32bit/dyadic_composite_difference_table_32_silence468.csv` | `302ec9d896a68fa10938c92783a8b0382f59fb1e882974b4da760b038d25fc3a` | 2026-02-11T01:15:10 |
| `32bit/dyadic_composite_extended_emptied_32.csv` | `64fd573f674fe2e9bd37a6797c08adb62bcdc2a06a17b671d2843d1d4ea15c2b` | 2026-02-11T12:13:27 |
| `32bit/dyadic_composite_extended_emptied_32_silence46.csv` | `a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` | 2026-02-11T12:13:27 |
| `32bit/dyadic_composite_full_silenced_32.csv` | `a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` | 2026-02-11T12:20:04 |
| `32bit/dyadic_diff_full_silenced_32.csv` | `e52ffe5f90f86917bffcdd7784369cf1b19fdedfd6097df0e1e5bc510904be95` | 2026-02-11T12:20:04 |
| `32bit/dyadic_difference_table_32.csv` | `7a3b6a8654ab50754cb1e7f8e441cdaaeb14fa3520b6aea2a6ef0c3900ce2b74` | 2026-02-11T00:11:09 |
| `32bit/dyadic_prime_full_silenced_32.csv` | `2c85af35abdd37df5a400e4f54f5444eee292f432f4b7fcf75de17a5b056f81a` | 2026-02-11T12:20:04 |
| `32bit/enneadic_difference_table_20.csv` | `ecfc20d1fc20f82d10441c4fd64da9c9554ef7c9d4eddea4ad04c6b7e7c1628b` | 2026-02-11T00:25:05 |
| `32bit/heptadic_difference_table_22.csv` | `90cbb0f937bd98b01dc709832cf1892837645d254355809e05ae16d715c97dd7` | 2026-02-11T00:24:17 |
| `32bit/hexadic_difference_table_24.csv` | `b04d5d35624a175bd7c0a4b5723ea6b3beb9fbb52e4a912a37a24539642a4a21` | 2026-02-11T00:24:04 |
| `32bit/octadic_difference_table_21.csv` | `c74abcf735eb824d77ad4778c752af70317874072b530b7d34bd60cb5e4edf80` | 2026-02-11T00:24:39 |
| `32bit/pentadic_difference_table_27.csv` | `ad26ee606cfd54ebf8b16c017b17b3475ad0f2bca80b7b2b4de4cfb2c570aeeb` | 2026-02-11T00:23:48 |
| `32bit/prime_composite_sidebyside_32.csv` | `15a0c35f14fcabeb8454ec9439f0f6ad7c5162bcfcf3dcc94eabebe276a1438f` | 2026-02-11T12:01:36 |
| `32bit/tetradic_difference_table_32.csv` | `f65d003b69bbedb1e30883a75d605ba83e38f98d8a23e111d04a4b33dce50ca7` | 2026-02-11T00:23:27 |
| `32bit/tetradic_difference_table_32_silence2357.csv` | `a59dcaf57dc9a2e4cc5811bcae73315d1d3d133748d2e922d79958ba408a14d0` | 2026-02-11T00:45:19 |
| `32bit/tetradic_difference_table_32_silence235711.csv` | `ac95b49322b8be7602f25db96f2acdf6c83e8ca9a75bdccf168df51e29a3ceac` | 2026-02-11T00:46:00 |
| `32bit/triadic_difference_table_32.csv` | `961da81fcb94364642b70f58efe62ba830063eea7985fc5e1918ed0eed9358d9` | 2026-02-11T00:19:35 |
| `32bit/triadic_difference_table_32_silence235.csv` | `6f08adced68c1bf51756c8948ce7c34b57f7ff7744bb6c90afe4afdb529d9252` | 2026-02-11T00:31:39 |
| `32bit/triadic_difference_table_32_silence2357.csv` | `4f012802a7d951ba591cb96193d6999e1af15740447ccd932ff85a769f67e466` | 2026-02-11T00:36:15 |
| `64bit/dyadic_difference_table_64.csv` | `91d29e12c2aa36e5505ee864a3e0cc280f99e720b92520500c8fed84e6cf42b3` | 2026-02-11T00:12:21 |
| `64bit/triadic_difference_table_40.csv` | `dca1b6a25da8dc044e71de975a5e924afc4bb1a1d255d8ead657d6eefead7918` | 2026-02-11T00:22:45 |
| `64bit/triadic_difference_table_40_silence235.csv` | `bc06472984a49aa42fb96972519d9844a99995ee025bdd64f1560774a6f937db` | 2026-02-11T00:48:35 |
| `64bit/triadic_difference_table_40_silence2357.csv` | `0dcca43dafc3e79bcc0efa833dc123ab7854fe26985004b23c7a8126079d0ca3` | 2026-02-11T00:49:13 |
| `source_README.md` (from `README.md`) | `552c5cf4c2a61bce1041745358a84f0af4b79b8697cd41e231d5344e9ed2216c` | 2026-02-09T13:39:25 |

27 files: 22 from `32bit/` (the complete directory — 12 base-series tables for
bases 2–9 plus 10 dyadic prime/composite split files), 4 from `64bit/`, and the
source README.

Note: `dyadic_composite_extended_emptied_32_silence46.csv` and
`dyadic_composite_full_silenced_32.csv` share SHA-256 `a0030692…` — they are
byte-identical in the source and are preserved as-is under both names.
