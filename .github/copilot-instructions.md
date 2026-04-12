# Copilot Instructions

## Scripts\sh — sourced scripts

Scripts in `Scripts\sh` are **sourced** into a dynamically-created shell function
at runtime. They must **never** define functions themselves.

- **No function definitions** (`name() { ... }` or `function name { ... }`) anywhere in these files.
- Write all logic as top-level statements only.
- Every script must be **idempotent** — safe to run multiple times. Add a comment at the top of each file stating this.

Use the `edit-batch-script` skill when creating or editing files in `Scripts\sh`.
