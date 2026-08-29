#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LLAMA_CPP_DIR="${LLAMA_CPP_DIR:-$HOME/src/llama.cpp}"

companion_template="$repo_root/templates/llama-cpp-qwen3.8-codex.jinja"
llama_template="$LLAMA_CPP_DIR/models/templates/llama-cpp-qwen3.8-codex.jinja"

if [[ ! -f "$llama_template" ]]; then
    printf 'llama.cpp template not found: %s\n' "$llama_template" >&2
    exit 2
fi

if ! cmp -s -- "$companion_template" "$llama_template"; then
    printf 'template differs from %s\n' "$llama_template" >&2
    exit 1
fi

printf 'template is synchronized with %s\n' "$llama_template"
