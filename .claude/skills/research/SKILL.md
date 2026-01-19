---
name: research
description: Research codebase (internal) or external sources (docs, web, APIs)
model: claude-opus-4-5-20251101
user-invocable: true
---

# Research Skill

Unified research workflow for both internal codebase exploration and external sources.

## Invocation

```
/research [mode] [options]
```

## Modes

| Mode | Purpose | Tools Used |
|------|---------|------------|
| `internal` | Document codebase as-is | scout, thoughts-locator, thoughts-analyzer |
| `external` | Docs, web, APIs | nia-docs, perplexity, firecrawl |
| `hybrid` | Both internal and external | All tools |

**Default:** If no mode specified, ask the user.

## Question Flow (No Arguments)

### Phase 1: Research Mode

```yaml
question: "What kind of research do you need?"
header: "Mode"
options:
  - label: "Internal (codebase)"
    description: "Explore and document existing code"
  - label: "External (docs/web)"
    description: "Library docs, best practices, APIs"
  - label: "Hybrid (both)"
    description: "Cross-reference codebase with external resources"
```

### Phase 2: Topic

```yaml
question: "What do you want to research?"
header: "Topic"
options: []  # Free text
```

### Phase 3: External Focus (if external or hybrid mode)

```yaml
question: "What kind of external information?"
header: "Focus"
options:
  - label: "Library/package docs"
    description: "API docs, examples, patterns"
  - label: "Best practices"
    description: "Recommended approaches, patterns"
  - label: "General topic"
    description: "Comprehensive multi-source search"
```

### Phase 4: Output

```yaml
question: "What should I produce?"
header: "Output"
options:
  - label: "Summary in chat"
    description: "Tell me what you found"
  - label: "Research document"
    description: "Write to thoughts/shared/research/"
  - label: "Handoff for implementation"
    description: "Prepare context for coding"
```

---

## Mode: Internal

Document codebase as-is with thoughts directory for historical context.

### CRITICAL PRINCIPLE
- **ONLY** describe what exists, where it exists, how it works
- **DO NOT** suggest improvements, critique, or recommend changes
- You are creating a technical map of the existing system

### Workflow

1. **Read mentioned files first** - Use Read tool without limit/offset
2. **Decompose research question** - Break into composable areas
3. **Spawn parallel agents:**
   - **scout** - Comprehensive codebase exploration
   - **thoughts-locator** - Find relevant docs in thoughts/
   - **thoughts-analyzer** - Extract insights from specific docs
4. **Wait for all agents** - Synthesize findings
5. **Write research document** to `thoughts/shared/research/YYYY-MM-DD-{topic}.md`

### Output Format (Internal)

```markdown
---
date: {ISO timestamp}
type: codebase-research
topic: "{topic}"
status: complete
---

# Research: {Topic}

## Summary
{What was found - no recommendations}

## Detailed Findings
### {Component 1}
- Location: `path/file.ts:123`
- How it works: {description}

## Code References
- `path/to/file.py:123` - Description

## Historical Context (from thoughts/)
- `thoughts/shared/doc.md` - Relevant past decision
```

---

## Mode: External

Research external sources (documentation, web, APIs) for libraries, best practices.

> **Note:** Current year is 2025. Use 2024-2025 as reference timeframe.

### Focus Types

| Focus | Primary Tool | Purpose |
|-------|--------------|---------|
| `library` | nia-docs | API docs, usage patterns, code examples |
| `best-practices` | perplexity-search | Recommended approaches, patterns |
| `general` | All MCP tools | Comprehensive multi-source research |

### Workflow

#### Focus: library

```bash
# Semantic search in package
(cd $CLAUDE_PROJECT_DIR/opc && uv run python -m runtime.harness scripts/nia_docs.py \
  --package "$LIBRARY" --registry "$REGISTRY" --query "$TOPIC" --limit 10)
```

#### Focus: best-practices

```bash
# AI-synthesized research
(cd $CLAUDE_PROJECT_DIR/opc && uv run python scripts/perplexity_search.py \
  --research "$TOPIC best practices 2024 2025")

# For thorough depth
(cd $CLAUDE_PROJECT_DIR/opc && uv run python scripts/perplexity_search.py \
  --deep "$TOPIC comprehensive guide 2025")
```

#### Focus: general

Use ALL available MCP tools:
1. **nia-docs** - Library documentation
2. **perplexity** - Web research
3. **firecrawl** - Scrape specific doc pages

### Output Format (External)

```markdown
---
date: {ISO timestamp}
type: external-research
topic: "{topic}"
focus: {focus}
sources: [nia, perplexity, firecrawl]
status: complete
---

# Research: {Topic}

## Summary
{2-3 sentence summary}

## Key Findings

### Library Documentation
{From nia-docs}

### Best Practices (2024-2025)
{From perplexity}

### Code Examples
```{language}
// Working examples
```

## Recommendations
- {Recommendation 1}

## Pitfalls to Avoid
- {Pitfall 1}

## Sources
- [{Source 1}]({url1})
```

---

## Mode: Hybrid

Run both internal and external research, then cross-reference.

### Workflow

1. **Spawn internal research** (scout + thoughts)
2. **Spawn external research** (nia + perplexity + firecrawl)
3. **Cross-reference findings:**
   - How does our implementation compare to best practices?
   - Are we using the library correctly?
   - What patterns match/differ?

### Output Format (Hybrid)

```markdown
---
date: {ISO timestamp}
type: hybrid-research
topic: "{topic}"
status: complete
---

# Research: {Topic}

## Internal Findings
{What exists in codebase}

## External Findings
{What docs/best practices say}

## Cross-Reference Analysis
| Aspect | Our Implementation | Best Practice | Notes |
|--------|-------------------|---------------|-------|
| {aspect} | {what we do} | {what's recommended} | {gap/match} |

## Sources
- Internal: `path/to/file.ts:123`
- External: [{Source}]({url})
```

---

## Options

| Option | Values | Description |
|--------|--------|-------------|
| `--mode` | `internal`, `external`, `hybrid` | Research mode |
| `--topic` | `"string"` | Topic to research |
| `--focus` | `library`, `best-practices`, `general` | External focus type |
| `--depth` | `shallow`, `thorough` | Search depth |
| `--output` | `chat`, `doc`, `handoff` | Output format |
| `--library` | `"name"` | Package name (for library focus) |
| `--registry` | `npm`, `py_pi`, `crates`, `go` | Package registry |

## Error Handling

If an MCP tool fails:
1. **Log the failure** - Note which tool failed
2. **Continue with others** - Partial results are valuable
3. **Set status:** `complete` / `partial` / `failed`
4. **Note gaps** in findings

## Integration

| After Research | Next Skill | For |
|----------------|------------|-----|
| `--output handoff` | `plan-agent` | Create implementation plan |
| Code examples | `implement_task` | Direct implementation |
| Architecture decision | `create_plan` | Detailed planning |

## Notes

- **Internal mode:** Document what IS, not what SHOULD BE
- **External mode:** Always cite sources with URLs
- **Hybrid mode:** Best for "how should we implement X given our codebase"
- **2024-2025 timeframe** for best practices
