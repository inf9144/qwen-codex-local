# Architecture

The runtime is divided into three layers:

```text
ggml-org/llama.cpp
        ^
        | generic fixes may be contributed separately
        |
inf9144/llama.cpp : codex-compat
        |
        | remaining engine compatibility
        |
qwen3.8-codex-local
        |
        +-- Codex config
        +-- model catalog
        +-- Qwen/Codex template
        +-- runtime profile
```

Upstream llama.cpp provides the inference engine, server, chat-template system, and general protocol infrastructure. The `codex-compat` fork carries engine-side compatibility that has not been accepted upstream. This companion repository owns deployment policy and model/client-specific behavior.

The split keeps Qwen/Codex configuration and the validated hardware profile out of the engine fork. It also makes the remaining llama.cpp delta easier to understand and reduce.

The long-term aim is to reduce the fork delta by contributing generic fixes individually where maintainers want them. The complete Codex/Qwen policy layer is not intended to be upstreamed as one change.

The template remains duplicated temporarily because the fork currently loads it from its own tree in some workflows. `scripts/check-template-sync.sh` detects divergence while the companion launch script loads the companion copy.
