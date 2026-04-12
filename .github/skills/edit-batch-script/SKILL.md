---
name: edit-batch-script
description: >
  Use when editing or creating scripts in Scripts\sh that are intended to be
  sourced (not executed directly). Apply this skill when the user asks to
  create or modify a .sh file in that directory.
---

## Rules for Scripts\sh scripts

These scripts are **sourced** into a dynamically-created shell function at runtime.
They must never define functions of their own. Write all logic as top-level
statements (variable assignments, conditionals, loops, command invocations, etc.).

### Checklist before writing or modifying a script

1. **No function definitions** — do not use `name() { ... }` or `function name { ... }` syntax anywhere in the file.
2. **Idempotent** — every script must be safe to run multiple times with the same result. Place a comment at the top of every file stating this requirement.
3. **Top-level statements only** — structure code as a linear sequence of commands, using `if/elif/else/fi`, `for`, `while`, and other control-flow constructs directly at the top level.
4. **Avoid `exit`** — the script runs inside a caller's function scope; use a guard variable or `return` logic instead of `exit`.
5. **Be careful with `cd`** — any directory change affects the caller's scope.

### Example — correct structure

```bash
# Everything in this script must be idempotent — safe to run multiple times.

MY_CONF=/etc/some.conf

if grep -q 'pattern' "$MY_CONF" 2>/dev/null; then
    echo "already configured"
else
    echo "new config" | sudo tee -a "$MY_CONF" > /dev/null
fi
```

### Example — incorrect (do NOT do this)

```bash
do_thing() {          # ← WRONG: no function definitions allowed
    echo "hello"
}
do_thing
```
