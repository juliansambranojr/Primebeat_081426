#!/usr/bin/env python3
"""
induction_bump_train.py -- train one small attention-only transformer on a
random-token copy task and record its loss at every step.

The object under test is the loss curve read as a difference table across
doublings (prereg preregs/induction_bump_difference_table_v1_20260907.md).
This script only produces the curve; utilities/induction_bump_table.py reads
it. Every array is written raw, one value per optimizer step, so the table
can be built at any spacing afterwards.

Task. Sequences of T tokens drawn from a Zipf(s) distribution over V tokens;
one span of length K, at a random start, is copied to a random later
position. Predicting the copied span (after its first token) needs the
[A][B] ... [A] -> [B] circuit: find the earlier match, read what followed,
copy it forward. Olsson et al. 2022: two attention layers form it, one
cannot. `--layers 1` is the control.

Model. Token + learned position embedding, `layers` blocks of pre-LN
multi-head self-attention with a residual, no MLP, unembed. AdamW at a
constant learning rate after a linear warmup. CPU, deterministic.

Output. analysis/<date>/results/induction_bump_L<layers>_seed<seed>.json
through the results guard: config, per-step train loss, per-step eval loss
on a fixed held-out batch, split into copied and non-copied positions.
"""
import argparse
import json
import math
import os
import sys
import time
from datetime import datetime, timezone

import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, ROOT)
from utilities.resultsguard import guarded_write  # noqa: E402


def make_batch(rng, n, T, V, K, zipf_s):
    """n sequences of length T+1 (inputs T, targets shifted), with one copied
    span of length K; returns tokens and a mask of copied target positions
    excluding the first copied token (which nothing can predict)."""
    ranks = np.arange(1, V + 1)
    p = ranks ** (-zipf_s)
    p /= p.sum()
    x = rng.choice(V, size=(n, T + 1), p=p)
    copied = np.zeros((n, T + 1), dtype=bool)
    for i in range(n):
        src = rng.integers(0, T + 1 - 2 * K)
        dst = rng.integers(src + K, T + 1 - K)
        x[i, dst:dst + K] = x[i, src:src + K]
        copied[i, dst + 1:dst + K] = True
    return torch.from_numpy(x.astype(np.int64)), torch.from_numpy(copied[:, 1:])


class Block(nn.Module):
    def __init__(self, d, heads):
        super().__init__()
        self.ln = nn.LayerNorm(d)
        self.attn = nn.MultiheadAttention(d, heads, batch_first=True)

    def forward(self, h, mask):
        a = self.ln(h)
        out, _ = self.attn(a, a, a, attn_mask=mask, need_weights=False)
        return h + out


class AttnOnly(nn.Module):
    def __init__(self, V, T, d, heads, layers):
        super().__init__()
        self.tok = nn.Embedding(V, d)
        self.pos = nn.Embedding(T, d)
        self.blocks = nn.ModuleList(Block(d, heads) for _ in range(layers))
        self.ln = nn.LayerNorm(d)
        self.out = nn.Linear(d, V, bias=False)
        self.register_buffer("mask", torch.triu(torch.ones(T, T, dtype=torch.bool), 1))

    def forward(self, x):
        T = x.shape[1]
        h = self.tok(x) + self.pos(torch.arange(T))[None]
        m = self.mask[:T, :T]
        for b in self.blocks:
            h = b(h, m)
        return self.out(self.ln(h))


def losses(model, x, copied):
    logits = model(x[:, :-1])
    tgt = x[:, 1:]
    ce = F.cross_entropy(logits.reshape(-1, logits.shape[-1]), tgt.reshape(-1), reduction="none")
    ce = ce.reshape(tgt.shape)
    total = ce.mean()
    cp = ce[copied].mean() if copied.any() else torch.tensor(float("nan"))
    nc = ce[~copied].mean()
    return total, cp, nc


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--layers", type=int, required=True)
    ap.add_argument("--seed", type=int, required=True)
    ap.add_argument("--steps", type=int, default=8192)
    ap.add_argument("--d", type=int, default=64)
    ap.add_argument("--lr", type=float, default=1e-3)
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    cfg = dict(V=256, T=128, K=32, zipf_s=1.0, d=args.d, heads=4, layers=args.layers,
               batch=64, eval_n=128, lr=args.lr, warmup=100, weight_decay=0.0,
               steps=args.steps, seed=args.seed, device="cpu", threads=8)
    torch.manual_seed(cfg["seed"])
    torch.use_deterministic_algorithms(True)
    torch.set_num_threads(cfg["threads"])
    rng = np.random.default_rng(cfg["seed"])
    eval_rng = np.random.default_rng(10_000 + cfg["seed"])
    ex, ecopied = make_batch(eval_rng, cfg["eval_n"], cfg["T"], cfg["V"], cfg["K"], cfg["zipf_s"])

    model = AttnOnly(cfg["V"], cfg["T"], cfg["d"], cfg["heads"], cfg["layers"])
    opt = torch.optim.AdamW(model.parameters(), lr=cfg["lr"], weight_decay=cfg["weight_decay"])

    train_loss, eval_loss, eval_copy, eval_noncopy = [], [], [], []
    t0 = datetime.now(timezone.utc).isoformat()
    tic = time.time()
    for step in range(1, cfg["steps"] + 1):
        lr = cfg["lr"] * min(1.0, step / cfg["warmup"])
        for g in opt.param_groups:
            g["lr"] = lr
        x, copied = make_batch(rng, cfg["batch"], cfg["T"], cfg["V"], cfg["K"], cfg["zipf_s"])
        model.train()
        total, _, _ = losses(model, x, copied)
        opt.zero_grad(set_to_none=True)
        total.backward()
        opt.step()
        train_loss.append(float(total.detach()))
        model.eval()
        with torch.no_grad():
            et, ec, en = losses(model, ex, ecopied)
        eval_loss.append(float(et)); eval_copy.append(float(ec)); eval_noncopy.append(float(en))
        if step % 1024 == 0 or step == 1:
            print(f"step {step:5d}  train {float(total):.4f}  eval {float(et):.4f}  "
                  f"copy {float(ec):.4f}  noncopy {float(en):.4f}  {time.time()-tic:.0f}s", flush=True)
    payload = dict(config=cfg, run_start_at=t0, run_end_at=datetime.now(timezone.utc).isoformat(),
                   seconds=round(time.time() - tic, 1), torch=torch.__version__,
                   unigram_entropy_nats=float(-(lambda p: (p * np.log(p)).sum())(
                       (lambda r: r / r.sum())(np.arange(1, cfg["V"] + 1) ** (-cfg["zipf_s"])))),
                   train_loss=train_loss, eval_loss=eval_loss, eval_copy_loss=eval_copy,
                   eval_noncopy_loss=eval_noncopy)
    out = args.out or os.path.join(os.path.dirname(os.path.abspath(__file__)), "results",
                                   f"induction_bump_L{cfg['layers']}_seed{cfg['seed']}.json")
    guarded_write(payload, out)
    print("wrote", out)


if __name__ == "__main__":
    main()
