---
applyTo: "**/*.lua"
excludeAgent: "coding-agent"
---

## Lua conventions for this project

**Truthiness:** Only `nil` and `false` are falsy. `0`, `""`, and `{}` are all truthy. Do not suggest replacing `== nil` / `~= nil` guards with `not x` — they are not equivalent when `x` could be `0`.

**Module pattern:** Modules use `function Module.new(...)` returning a plain table. No metatables or OOP inheritance. Do not suggest introducing them.

**Mutation:** Queue state and cursor are mutated in place by convention. Do not suggest returning new values instead.

**No external libraries:** Standard Playdate SDK only. Do not suggest third-party packages.
