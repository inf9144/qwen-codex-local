# Qwen3.8 Codex local runtime

A reproducible runtime package for running Qwen3.8-27B with Codex CLI through the Responses-compatible `inf9144/llama.cpp` fork.

## Features

- Portable Codex provider configuration and pinned model catalog
- Qwen3.8/Codex Jinja template with XML tool calls, reasoning, Vision, and compaction behavior
- Validated Vulkan launch profile with Q4 KV caches and MTP speculative decoding
- Responses support for function, parallel, custom/freeform, namespace, and deferred tools
- Template synchronization check against the llama.cpp fork

## Validated stack

- llama.cpp: `inf9144/llama.cpp`, branch `codex-compat`, commit `2edda1156f1d0e3f0bedae63bd69a90ed2786b35`
- Codex CLI: `0.150.1`
- Model: `unsloth/Qwen3.8-27B-GGUF:UD-IQ3_XXS`
- Alias: `qwen3.8-27b`
- Hardware: Ryzen 9 7950X and Radeon RX 7800 XT 16 GB using Vulkan/RADV

Performance observations and the complete capability list are in [validated runtime](docs/validated-runtime.md).

## Quick start

Build the validated llama.cpp fork with Vulkan. The launcher expects it at `~/src/llama.cpp` by default:

```bash
export LLAMA_CPP_DIR=/absolute/path/to/llama.cpp
export LLAMA_SERVER_BIN="$LLAMA_CPP_DIR/build-vulkan/bin/llama-server"
./scripts/run_llama.sh
```

The script allows configuration of paths, model source, Hugging Face cache, host, and port through `LLAMA_CPP_DIR`, `LLAMA_SERVER_BIN`, `MODEL_REPO`, `MODEL_QUANT`, `MODEL_ALIAS`, `LLAMA_CACHE`, `LLAMA_HOST`, and `LLAMA_PORT`.

Reference tuning remains intentionally pinned in `scripts/run_llama.sh`: context size, K/V cache types, Vulkan offload, flash attention, parallel slots, batch and ubatch sizes, thread counts, MTP mode, and draft cache settings. The launcher is not intended to be a generic hardware tuner.

Create a local Codex configuration:

```bash
cp config/config.toml.example config/config.toml
```

Edit `model_catalog_json` in the copied file to the absolute path of `config/model-catalog-qwen.json`. Place the resulting configuration in the Codex home you intend to use.

The provider name must remain `OpenAI`: Codex 0.150.1 uses it to select Responses remote-compaction V2. `requires_openai_auth = false` intentionally prevents OpenAI authentication from being required or forwarded to localhost.

Verify that the duplicated template still matches the fork:

```bash
LLAMA_CPP_DIR="$HOME/src/llama.cpp" ./scripts/check-template-sync.sh
```

### Security note

The example Playwright MCP mirrors the validated setup and enables `--allow-unrestricted-file-access` together with broad browser permissions. Review or remove that MCP configuration before using it in an environment where browser or filesystem access should be restricted.

## Repository boundary

This repository owns runtime policy: Codex configuration, model catalog, Qwen/Codex template, and launch profile. The `inf9144/llama.cpp` `codex-compat` branch owns the remaining engine-side Responses compatibility. Upstream `ggml-org/llama.cpp` remains a separate generic engine layer.

The long-term boundary and fork-reduction principle are documented in [architecture](docs/architecture.md). Detailed runtime observations are in [validated runtime](docs/validated-runtime.md).
