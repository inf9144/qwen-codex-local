#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

LLAMA_CPP_DIR="${LLAMA_CPP_DIR:-$HOME/src/llama.cpp}"
LLAMA_CACHE="${LLAMA_CACHE:-${HF_HOME:-$HOME/.cache/huggingface}}"
LLAMA_SERVER_BIN="${LLAMA_SERVER_BIN:-$LLAMA_CPP_DIR/build-vulkan/bin/llama-server}"
LLAMA_HOST="${LLAMA_HOST:-127.0.0.1}"
LLAMA_PORT="${LLAMA_PORT:-8080}"
MODEL_REPO="${MODEL_REPO:-unsloth/Qwen3.8-27B-GGUF}"
MODEL_QUANT="${MODEL_QUANT:-UD-IQ3_XXS}"
MODEL_ALIAS="${MODEL_ALIAS:-qwen3.8-27b}"

if [[ ! -x "$LLAMA_SERVER_BIN" ]]; then
    printf 'llama-server is not executable: %s\n' "$LLAMA_SERVER_BIN" >&2
    exit 1
fi

export HF_HOME="$LLAMA_CACHE"

exec "$LLAMA_SERVER_BIN" \
    -hf "$MODEL_REPO:$MODEL_QUANT" \
    --alias "$MODEL_ALIAS" \
    --device Vulkan0 \
    --ctx-size 149504 \
    --cache-type-k q4_0 \
    --cache-type-v q4_0 \
    --flash-attn on \
    --parallel 1 \
    --jinja \
    --chat-template-file "$repo_root/templates/llama-cpp-qwen3.8-codex.jinja" \
    --mmproj-offload \
    --gpu-layers all \
    --split-mode none \
    --fit off \
    --batch-size 2048 \
    --ubatch-size 512 \
    --threads 16 \
    --threads-batch 16 \
    --spec-type draft-mtp \
    --spec-draft-n-max 2 \
    --spec-draft-type-k q4_0 \
    --spec-draft-type-v q4_0 \
    --host "$LLAMA_HOST" \
    --port "$LLAMA_PORT" \
    -lv 4
