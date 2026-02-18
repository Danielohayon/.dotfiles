---
name: report-writing
description: Guidelines for writing experiment reports, including pulling metrics from WandB and structuring analysis. Use when asked to analyze experiments, create ablation reports, or summarize training results.
---

# Report Writing Guidelines

## Style Requirements

- **No emojis** - keep reports professional and plain-text friendly
- Be concise - verbose reports are worthless
- Use tables for comparisons
- Include raw numbers, not just percentages

## Required Report Sections

Every experiment report must include:

### 1. Header with Metadata

```markdown
# [Title]

**Date:** YYYY-MM-DD
**WandB Project:** [entity/project-name](https://wandb.ai/entity/project-name)
**Comparison:** [what is being compared]
```

### 2. Setup Section

Document the experiment configuration:

```markdown
## Setup

**Model:** [model name and size]
**Hardware:** [GPU type and count]
**Config:** [path to config file if applicable]

\`\`\`yaml
# Key hyperparameters
train_batch_size: X
learning_rate: X
# ... relevant settings that differ between runs
\`\`\`
```

### 3. Summary Table

Lead with the bottom line:

```markdown
## Summary

| Metric | Baseline | Experiment | Delta | Winner |
|--------|----------|------------|-------|--------|
| Throughput | 316 tok/s | 370 tok/s | +17% | Experiment |
| Accuracy | 0.95 | 0.89 | -6% | Baseline |

**Verdict:** [one-line recommendation]
```

### 4. Detailed Metrics

Break down each key metric with stats (mean, std, min, max).

### 5. Run Details

List all runs analyzed:

```markdown
## Run Details

| Run | ID | State | Steps |
|-----|-----|-------|-------|
| baseline | abc123 | finished | 500 |
| experiment | xyz789 | running | 450 |
```

---

## Pulling Data from WandB

Use the WandB Python API to pull metrics programmatically. Do NOT rely on the web UI.

### Basic Setup

```python
import wandb
import pandas as pd

api = wandb.Api()
runs = api.runs("entity/project-name")  # or just "project-name"
```

### List Runs

```python
for run in runs:
    print(f"{run.id}: {run.name} ({run.state})")
```

### Discover Available Metrics

Metric names vary by training framework. Always discover them first:

```python
run = runs[0]

# Check summary (final values)
print("Summary keys:", list(run.summary.keys()))

# Check history (time series)
hist = run.history(samples=5)
print("History columns:", list(hist.columns))
```

### Pull Metrics History

```python
# Sampled data (faster, good for trends)
df = run.history(keys=["loss", "accuracy"], samples=1000)

# Full unsampled data (slower, for precise analysis)
df = pd.DataFrame(list(run.scan_history(keys=["loss", "accuracy"])))
```

### Compute Summary Statistics

```python
def compute_stats(series):
    return {
        "mean": series.mean(),
        "std": series.std(),
        "min": series.min(),
        "max": series.max(),
        "final": series.iloc[-1] if len(series) > 0 else None,
    }

# Handle mixed types in WandB data
series = pd.to_numeric(df["metric_name"], errors='coerce').dropna()
stats = compute_stats(series)
```

### Compare Runs

```python
results = []
for run in runs:
    hist = run.history(keys=KEY_METRICS, samples=5000)
    row = {
        "run_name": run.name,
        "run_id": run.id,
        "state": run.state,
        "steps": run.summary.get("_step", 0),
    }
    for metric in KEY_METRICS:
        if metric in hist.columns:
            series = pd.to_numeric(hist[metric], errors='coerce').dropna()
            if len(series) > 0:
                row[f"{metric}_mean"] = series.mean()
                row[f"{metric}_final"] = series.iloc[-1]
    results.append(row)

df = pd.DataFrame(results)
```

### Get Run Config

```python
config = run.config  # dict of hyperparameters
summary = run.summary  # dict of final metric values
```

---

## Common Metrics by Framework

### RL/GRPO Training

```python
ACCURACY_METRICS = [
    "critic/score/mean",
    "critic/rewards/mean",
]

STABILITY_METRICS = [
    "actor/grad_norm",
    "actor/ppo_kl",
    "actor/pg_loss",
]

PERFORMANCE_METRICS = [
    "perf/throughput",
    "perf/time_per_step",
    "perf/max_memory_allocated_gb",
    "timing_s/step",
    "timing_s/gen",
]
```

### SFT Training

```python
METRICS = [
    "train/loss",
    "eval/loss",
    "train/learning_rate",
    "train/grad_norm",
]
```

---

## Analysis Patterns
### analysis setup
most of the runs we are cheking are grpo runs so the charecaristics of grpo training needs to be taken into account. and the web should be used to investigate behaviours observed in the results to try and explain them.

### Stability Analysis

Check for training instability:

```python
# Gradient spikes (> 2x mean)
grad = df["actor/grad_norm"].dropna()
spikes = (grad > 2 * grad.mean()).sum()
spike_pct = spikes / len(grad) * 100

# Inf/NaN occurrences
inf_count = np.isinf(grad).sum()
nan_count = np.isnan(grad).sum()
```

### Learning Curve Comparison

```python
# Compare early vs late performance
first_50 = score.head(50).mean()
last_50 = score.tail(50).mean()
improvement = (last_50 - first_50) / first_50 * 100
```

### Head-to-Head Comparison

When comparing two runs with same config but different settings:

```python
metrics_compare = [
    ("Final Score", "score_final"),
    ("Throughput", "throughput_mean"),
]

print(f"{'Metric':<25} {'Baseline':>15} {'Experiment':>15} {'Diff':>15}")
for name, key in metrics_compare:
    base_val = baseline_row[key]
    exp_val = experiment_row[key]
    diff = (exp_val - base_val) / abs(base_val) * 100
    print(f"{name:<25} {base_val:>15.4f} {exp_val:>15.4f} {diff:>+14.1f}%")
```

---

## Report Checklist

Before finalizing a report, verify:

- [ ] WandB project link included
- [ ] Setup section with hardware, model, and key config
- [ ] Summary table with clear winner/recommendation
- [ ] Run IDs listed for reproducibility
- [ ] No emojis
- [ ] Metrics pulled programmatically (not copied from UI)
- [ ] Sources cited if referencing external research
