> Source: session transcript, 2026-11-25

> Yes run both measurements please

From `units/0565-basin-transfer/run/basin.py`, the lagged correlations:

```
    for lag in (1, 2, 3, 5):
        res[k + f"_corr_lag{lag}"] = sum(dev[i] * dev[i + lag] for i in range(len(dev) - lag)) / ((len(dev) - lag) * var)
```
