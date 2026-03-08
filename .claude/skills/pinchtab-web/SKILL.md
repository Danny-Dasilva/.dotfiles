---
name: pinchtab-web
description: Web search and page interaction via Pinchtab browser control
allowed-tools: [Bash, Read]
---

# Pinchtab Web - Browser-Based Web Search & Interaction

Control a real Chrome browser for web searches, page reading, form filling, and interaction.

## When to Use

- Web searches via Google/DuckDuckGo
- Reading full web pages (not just fetching HTML)
- Filling forms, clicking buttons, navigating multi-page flows
- Extracting structured text from JavaScript-heavy pages
- Taking screenshots of web pages
- Any task requiring a real browser (JS rendering, auth flows, SPAs)

## Prerequisites

Pinchtab must be installed (`npm install -g pinchtab`) and a server must be running.

## Server Management

```bash
# Start server (headless, background)
BRIDGE_HEADLESS=true pinchtab &

# Start server (visible browser for debugging)
BRIDGE_HEADLESS=false pinchtab &

# Check if server is running
pinchtab health

# Stop server
pkill -f "pinchtab$" || true
```

## Core Workflow

### 1. Ensure Server Running
```bash
pinchtab health 2>/dev/null || (BRIDGE_HEADLESS=true pinchtab &>/dev/null & sleep 2)
```

### 2. Navigate
```bash
pinchtab nav "https://example.com"
```

### 3. Read Page Content
```bash
# Full text extraction (most useful for reading pages)
pinchtab text

# Accessibility tree snapshot (see page structure)
pinchtab snap -c

# Interactive elements only (find buttons/links/inputs)
pinchtab snap -i -c
```

### 4. Interact
```bash
pinchtab click e5           # Click element by ref
pinchtab fill e3 "query"    # Fill input field
pinchtab press Enter        # Press key
pinchtab select e7 "value"  # Select dropdown option
pinchtab scroll 500         # Scroll down 500px
```

## Common Patterns

### Web Search (DuckDuckGo - preferred, no bot blocking)
```bash
pinchtab nav "https://html.duckduckgo.com/html/?q=your+search+query"
pinchtab text
```

### Web Search (Google - may be blocked by CAPTCHA)
```bash
pinchtab nav "https://www.google.com/search?q=your+search+query"
pinchtab text
```

### Read a Web Page
```bash
pinchtab nav "https://example.com/article"
pinchtab text
```

### Screenshot a Page
```bash
pinchtab nav "https://example.com"
pinchtab ss -o /tmp/screenshot.png
```

### Fill and Submit a Form
```bash
pinchtab nav "https://example.com/form"
pinchtab snap -i -c                    # Find form elements
pinchtab fill e3 "value"               # Fill fields
pinchtab click e5                      # Submit button
```

### Multi-Page Navigation
```bash
pinchtab nav "https://example.com"
pinchtab snap -i -c                    # Find links
pinchtab click e12                     # Click a link
pinchtab text                          # Read new page
```

### Extract Specific Content via JS
```bash
pinchtab eval "document.querySelector('h1').textContent"
pinchtab eval "document.title"
pinchtab eval "[...document.querySelectorAll('a')].map(a => a.href).join('\\n')"
```

### Export Page as PDF
```bash
pinchtab nav "https://example.com"
pinchtab pdf --tab 1 -o /tmp/page.pdf
```

## Tab Management
```bash
pinchtab tabs                    # List open tabs
pinchtab tabs new "https://..."  # Open URL in new tab
pinchtab tabs close 2            # Close tab by ID
```

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `PINCHTAB_URL` | `http://127.0.0.1:9867` | Server URL |
| `BRIDGE_HEADLESS` | `true` | Run Chrome headless |
| `BRIDGE_PORT` | `9867` | Server port |

## Tips

- Always call `pinchtab health` first to ensure the server is running
- Use `pinchtab text` for content extraction (most token-efficient)
- Use `pinchtab snap -i -c` to find interactive elements before clicking
- Element refs (e5, e12, etc.) are from the most recent `snap` output
- URL-encode search queries or use quotes around URLs with special characters
- Use DuckDuckGo HTML version (`html.duckduckgo.com/html/`) for searches — Google blocks automated requests with CAPTCHAs
- Replace spaces with `+` in search query URLs
