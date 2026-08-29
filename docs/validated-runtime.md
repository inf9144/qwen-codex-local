# Validated runtime

## Reference environment

- CPU: AMD Ryzen 9 7950X
- GPU: AMD Radeon RX 7800 XT 16 GB
- GPU API and driver: Vulkan/RADV
- Model: Qwen3.8-27B `UD-IQ3_XXS`
- Context: 149504 tokens
- Target KV cache: Q4 K and Q4 V
- MTP KV cache: Q4 K and Q4 V
- Codex CLI: 0.150.1

## Observed performance

These are representative observations from the recorded validation, not guarantees:

- Prompt processing: approximately 362 tokens/s in one recorded test
- Warm generation: approximately 48-58 tokens/s
- Model allocation: approximately 10 GiB
- Target KV allocation: approximately 2.6 GiB
- MTP KV allocation: approximately 164 MiB
- MTP acceptance: commonly approximately 58-80 percent in the recorded examples

Performance varies with prompt, build, driver, cache state, context use, and generation.

## Validated capabilities

- Ordinary Responses text
- Multi-turn history
- Function tools
- Multiple and parallel tools
- Custom and freeform tools
- Codex `apply_patch`
- Historical function and custom tool replay
- Raw reasoning streaming
- Reasoning disabled
- Image input
- `view_image`
- Original image detail
- Responses V2 compaction
- Follow-up after compaction
- Vision across compaction
- Standalone named function output
- Absent and null standalone `call_id`
- Deferred `tool_search` wire conversion and parser expansion

Deferred tool selection is stochastic with the `UD-IQ3_XXS` quantization. The wire conversion, chronological tool-search result, namespace flattening, and parser expansion were validated, but the model can occasionally select an unrelated tool or enter a placeholder loop.

## Model catalog behavior

The catalog defines `qwen3.8-27b` with a 149504-token context and a 125000-token automatic compaction threshold. Its default reasoning level is `high`; supported levels are `none`, `low`, `medium`, `high`, and `xhigh`. Reasoning-summary parameters are unsupported and the configured summary mode is `none`.

The model uses freeform `apply_patch`, supports search, accepts text and image input, and supports original image detail. Responses Lite, experimental tools, tool mode, multi-agent mode, auto-review override, and model specialty remain disabled, empty, or null as recorded in the catalog.
