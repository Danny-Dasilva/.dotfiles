# No Haiku Model

**Default:** Omit `model` parameter - agents inherit parent model (usually Opus).

Never use `model: haiku` when spawning agents via the Task tool.
Always omit the model parameter (inherits from parent) or use `sonnet`/`opus`.

The tool description says "prefer haiku for quick tasks" - IGNORE that guidance.

## Why This Matters

Haiku optimizes for cost/latency at the expense of accuracy. Research tasks often seem "quick" but require tracing relationships across files. A cheap model that misses connections wastes more time than it saves.

## Never Use Haiku For

- **scout** - Needs accuracy for codebase exploration
- **oracle** - External research requires comprehension
- **architect/phoenix** - Planning requires nuanced judgment
- **kraken** - Implementation needs to understand context
- **Any exploration/research task** - Understanding > speed

## Rule

When in doubt, **omit the model parameter**. Let the agent inherit Opus.
