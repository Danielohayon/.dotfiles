---
name: vllm-usage
description: Guidelines for using vLLM correctly, especially max_tokens and prompt length constraints. Use when working with vLLM, debugging context length errors, or setting up inference pipelines.
---

# vLLM Usage Guidelines

## Critical Constraint: max_tokens + prompt_len <= max_model_len

vLLM enforces this constraint on every request:

```
prompt_len + max_tokens <= max_model_len
```

Rearranged, the maximum allowed prompt length is:

```
max_prompt_len = max_model_len - max_tokens
```

### Example

With vLLM started with `--max-model-len 31096`:

| max_tokens | Max prompt allowed | 4500 token prompt |
|------------|-------------------|-------------------|
| 2048 | 31096 - 2048 = **29048** | OK |
| 27000 | 31096 - 27000 = **4096** | FAILS |

### Misleading Error Message

When this constraint is violated, vLLM returns:

```
ValueError: This model's maximum context length is 4096 tokens.
However, your request has 4500 input tokens.
```

**This is misleading.** The "4096" is NOT the model's context length - it's `max_model_len - max_tokens`. The error should say:

> "Given your max_tokens=27000 request and max_model_len=31096, only 4096 tokens are available for the prompt."

### Source Code Reference

From `vllm/entrypoints/openai/serving_completion.py`:

```python
def _build_render_config(self, request, ...):
    max_input_tokens_len = self.max_model_len - (request.max_tokens or 0)
    return RenderConfig(max_length=max_input_tokens_len, ...)
```

## vLLM is Stateless

vLLM has no memory between requests. Each API call is completely independent.

In multi-turn conversations, the **prompt grows every turn** because the client must include all previous context:

```
Turn 1:
  Prompt: [system + user]                    = 1500 tokens
  → Completion                               = 200 tokens

Turn 2:
  Prompt: [system + user + assistant + tool] = 1800 tokens
  → Completion                               = 150 tokens

Turn 3:
  Prompt: [all previous context]             = 2100 tokens
  → Completion                               = 180 tokens

...

Turn 10:
  Prompt: [entire conversation]              = 4500 tokens
  → May fail if max_tokens is too high!
```

## Best Practices

### 1. Set max_tokens to Per-Turn Limit

For multi-turn environments, use the per-turn completion limit, NOT the total completion budget:

```bash
# WRONG - reserves 27000 tokens, leaving only 4096 for prompt
--max-tokens 27000

# CORRECT - leaves 29048 tokens for prompt
--max-tokens 2048
```

### 2. Match max_tokens to Environment Config

If your environment has `max_completion_length_per_turn: 2048`, use `--max-tokens 2048` in vLLM requests.

### 3. Size max_model_len Appropriately

If you need large prompts AND large single completions:

```bash
vllm serve ./model \
    --max-model-len 58000  # 30k prompt + 27k completion + buffer
```

### 4. Enable Prefix Caching

Since prompts grow but share a common prefix, enable caching:

```bash
vllm serve ./model --enable-prefix-caching
```

## Two Token Tracking Systems

| System | What it tracks | Where configured |
|--------|----------------|------------------|
| **vLLM** | Single request: `prompt + completion <= max_model_len` | `--max-model-len`, `max_tokens` per request |
| **rl_env** | Entire trajectory across all turns | `total_max_completion_length`, `total_max_prompt_length` |

vLLM doesn't know about trajectories. Trajectory limits are enforced by the client (rl_env).

## Quick Debugging

If you see "maximum context length is X tokens" where X seems wrong:

1. Check what `max_tokens` you're sending in the request
2. Calculate: `max_model_len - max_tokens = X`
3. If the math matches, reduce `max_tokens` or increase `--max-model-len`

## Working CLI Command Example

```bash
uv run generate-rollouts \
  --inference-backend vllm \
  --vllm-url http://localhost:8000 \
  --model Qwen/Qwen2.5-32B-Instruct \
  --vllm-model-name ./data/model \
  --max-tokens 2048 \           # Per-turn limit, NOT total
  --temperature 0 \
  --max-turns 100 \
  --count 20
```
