# Qwen3.8 Codex local runtime

This repository is the reproducible runtime and configuration layer for using Qwen3.8-27B with Codex CLI through the Responses-compatible `inf9144/llama.cpp` fork. It keeps runtime policy separate from llama.cpp engine changes.

The llama.cpp fork still contains the Responses conversion, custom and namespace tool handling, deferred tool parser support, compaction support, response phases, raw-reasoning streaming fixes, and Qwen XML argument handling. This repository contains the Codex configuration, model catalog, Qwen/Codex template, and validated launch profile.

## Validated versions

- llama.cpp: `inf9144/llama.cpp`, branch `codex-compat`, commit `2edda1156f1d0e3f0bedae63bd69a90ed2786b35`
- Codex CLI: `0.150.1`
- Model: `unsloth/Qwen3.8-27B-GGUF:UD-IQ3_XXS`
- Alias: `qwen3.8-27b`
- Hardware: Ryzen 9 7950X and Radeon RX 7800 XT 16 GB using Vulkan/RADV

## Start llama-server

Build the validated llama.cpp fork with Vulkan, then set its location if it is not at `~/src/llama.cpp`:

```bash
export LLAMA_CPP_DIR=/absolute/path/to/llama.cpp
```

The script defaults to `$LLAMA_CPP_DIR/build-vulkan/bin/llama-server`. Override `LLAMA_SERVER_BIN` when the build directory differs:

```bash
export LLAMA_SERVER_BIN="$LLAMA_CPP_DIR/build-codex-integration/bin/llama-server"
./scripts/run_llama.sh
```

`LLAMA_CACHE`, `LLAMA_HOST`, and `LLAMA_PORT` may also be overridden. The model, context, KV cache, Vulkan, batching, and MTP values remain pinned to the validated profile unless their specific environment variables are intentionally changed.

## Configure Codex

Copy the example into a local Codex home. Do not commit the resulting local file:

```bash
cp config/config.toml.example config/config.toml
```

Edit `model_catalog_json` in `config/config.toml` to the absolute path of `config/model-catalog-qwen.json`, then either copy that file into the Codex home as `config.toml` or launch Codex with a `CODEX_HOME` containing it.

The provider name must remain `OpenAI`. Codex 0.150.1 uses that identity to select Responses remote-compaction V2. `requires_openai_auth = false` intentionally prevents OpenAI authentication from being required or forwarded to the localhost server.

The example retains the generic MCP definitions from the validated local configuration. Add trusted projects and any private or machine-specific MCP definitions only in the untracked local config.

## Check template synchronization

The template is temporarily duplicated between this repository and the llama.cpp fork. Verify byte identity with:

```bash
LLAMA_CPP_DIR="$HOME/src/llama.cpp" ./scripts/check-template-sync.sh
```

See [architecture](docs/architecture.md) for the repository boundary and [validated runtime](docs/validated-runtime.md) for observed capabilities and performance.
