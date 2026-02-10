# dotfiles

Personal dotfiles for bash, tmux, neovim, and Claude Code development environment.

Managed as a [bare git repository](https://www.atlassian.com/git/tutorials/dotfiles) in `$HOME`.

## Quick Install (New Machine)

```bash
# 1. Clone the bare repo
git clone --bare https://github.com/Danny-Dasilva/.dotfiles.git ~/.dotfiles.git

# 2. Create the dotfiles alias
echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' > ~/.dotfiles

# 3. Checkout files (--force overwrites defaults like .bashrc)
/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout --force

# 4. Hide untracked files from status
/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME config status.showUntrackedFiles no

# 5. Run the installer
chmod +x ~/install.sh
./install.sh
```

Or run the installer directly (it handles cloning too):

```bash
curl -fsSL https://raw.githubusercontent.com/Danny-Dasilva/.dotfiles/master/install.sh | bash
```

## What Gets Installed

### System Packages (apt)

| Package | Purpose |
|---------|---------|
| `tmux` | Terminal multiplexer |
| `fzf` | Fuzzy finder (Ctrl+R, Ctrl+T, Alt+C) |
| `fd-find` | Fast file search (aliased to `fd`) |
| `ripgrep` | Fast content search (`rg`) |
| `bat` | Syntax-highlighted `cat` (aliased to `cat`) |
| `eza` | Modern `ls` replacement (aliased to `ls`) |
| `btop` | System monitor (aliased to `top`) |
| `xclip` / `xsel` | Clipboard integration |
| `neovim` | Text editor |
| `build-essential` | Compiler toolchain |

### CLI Tools (installed from source/binary)

| Tool | Install Method | Purpose |
|------|---------------|---------|
| [Starship](https://starship.rs) | cargo | Fast, customizable prompt |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | cargo | Smart `cd` replacement (`j` command) |
| [Atuin](https://atuin.sh) | installer script | Searchable shell history |
| [Lazygit](https://github.com/jesseduffield/lazygit) | binary release | Git TUI (tmux popup: `prefix + g`) |
| [Lazydocker](https://github.com/jesseduffield/lazydocker) | installer script | Docker TUI (tmux popup: `prefix + G`) |
| [ble.sh](https://github.com/akinomyoga/ble.sh) | make install | Fish-like autosuggestions in bash |
| [complete-alias](https://github.com/cykerway/complete-alias) | git clone | Tab completion for aliases |

### Runtimes & Package Managers

| Tool | Install Method | Purpose |
|------|---------------|---------|
| [NVM](https://github.com/nvm-sh/nvm) | installer script | Node.js version manager |
| [Pyenv](https://github.com/pyenv/pyenv) | pyenv-installer | Python version manager |
| [UV](https://github.com/astral-sh/uv) | installer script | Fast Python package manager |
| [Rust/Cargo](https://rustup.rs) | rustup | Rust toolchain + cargo |
| [Go](https://go.dev) | binary tarball | Go programming language |
| [Bun](https://bun.sh) | installer script | JavaScript runtime |
| [Deno](https://deno.land) | installer script | JavaScript/TypeScript runtime |

### Development Tools

| Tool | Install Method | Purpose |
|------|---------------|---------|
| [Claude Code](https://claude.ai/claude-code) | npm | AI coding assistant CLI |
| [llm-tldr](https://github.com/Danny-Dasilva/llm-tldr) | `uv tool install git+` | Code analysis (AST, call graph, CFG, DFG) |
| [GitHub CLI](https://cli.github.com) | apt repo | GitHub from the terminal |

---

## Managing Dotfiles

```bash
# Source the alias (auto-loaded from .bashrc)
source ~/.dotfiles

# Check status
dotfiles status

# Add a file
dotfiles add ~/.bashrc

# Commit
dotfiles commit -m "update bashrc"

# Push
dotfiles push origin master

# Pull updates on another machine
dotfiles pull
```

### Troubleshooting

If no origin configured:
```bash
dotfiles remote add origin https://github.com/Danny-Dasilva/.dotfiles.git
```

---

## Bash Configuration

Enhanced `.bashrc` with modern CLI tools, productivity aliases, and fast startup.

### Key Features

| Feature | Description |
|---------|-------------|
| **ble.sh** | Fish-like autosuggestions as you type |
| **Atuin** | Searchable shell history with `Ctrl+R` |
| **Starship** | Fast, customizable prompt |
| **Zoxide** | Smart `cd` replacement (`j` command) |
| **FZF** | Fuzzy finder (`Ctrl+T` files, `Alt+C` dirs) |
| **Modern CLI tools** | eza, bat, fd, ripgrep aliases |

### Modern Tool Aliases

```
ls      → eza with directories first
ll      → eza -la with git status
lt      → eza tree view (2 levels)
cat     → bat with syntax highlighting
fd      → fdfind (faster find)
top     → btop
lg      → lazygit
```

### Navigation

```
..      → cd ..
...     → cd ../..
.3-.5   → cd up 3-5 levels
j foo   → zoxide jump to "foo" directory
mkcd x  → mkdir x && cd x
```

### Git Aliases

```
gs/gd/gds    → status/diff/diff --staged
ga/gaa       → add/add --all
gc/gcm/gp    → commit/commit -m/push
gpl/gf       → pull/fetch --all --prune
gco/gcob/gb  → checkout/checkout -b/branch
gl/glog      → log --oneline/log --graph
gst/gstp     → stash/stash pop
gac/gacp     → add+commit / add+commit+push (functions)
```

### Docker Aliases

```
dps/dpsa     → ps formatted/ps -a
dc/dcu/dcd   → compose/up -d/down
dcr/dclf     → restart/logs -f
dex/dsh      → exec -it / shell into container
```

### System Utilities

```
ports/myip/localip   → network info
mem/disk/usage       → resource usage
psg                  → ps aux | grep
sysinfo              → quick system overview
bashrc               → edit and reload .bashrc
ex <file>            → extract any archive
```

### Performance Optimizations

- **Lazy-loaded NVM**: Node available immediately, `nvm` loads on first use
- **Lazy-loaded Pyenv**: Python available immediately, pyenv loads on first use
- **Cached tool init**: Tool outputs cached for 7 days
- **PATH deduplication**: Prevents PATH bloat from repeated sourcing

---

## Tmux Configuration

Catppuccin-themed tmux with vi-mode, popup tools, and session persistence.

**Prefix Key:** `Ctrl+y`

### Quick Reference

| Action | Keybinding |
|--------|------------|
| Switch to window 1-9 | `Alt+1` through `Alt+9` |
| Navigate panes | `Alt+h/j/k/l` |
| Zoom pane | `Alt+z` |
| Split horizontal | `prefix + \|` |
| Split vertical | `prefix + -` |
| Lazygit popup | `prefix + g` |
| LazyDocker popup | `prefix + G` |
| Htop popup | `prefix + t` |
| Session picker | `prefix + o` |
| Help menu | `prefix + ?` |
| Reload config | `prefix + r` |

### Plugins (managed by TPM)

| Plugin | Key | Purpose |
|--------|-----|---------|
| tmux-resurrect | `Ctrl+s/r` | Save/restore sessions |
| tmux-continuum | automatic | Auto-save sessions |
| tmux-yank | automatic | Better clipboard |
| vim-tmux-navigator | `Ctrl+h/j/k/l` | Seamless vim/tmux nav |
| tmux-fzf | `prefix + F` | Fuzzy find |
| extrakto | `prefix + Tab` | Extract URLs/paths |
| tmux-sessionx | `prefix + o` | Session manager |
| tmux-thumbs | `prefix + Space` | Vimium-style hints |

Install plugins inside tmux: `prefix + I`

---

## Claude Code Configuration

Full Claude Code setup with custom hooks, agents, skills, and rules.

### What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| **Rules** | 12 | Global behavior instructions (concise responses, safety, memory) |
| **Hooks** | 50+ | TypeScript hooks for tool interception, diagnostics, memory |
| **Agents** | 40+ | Specialized sub-agents (scout, kraken, architect, oracle, etc.) |
| **Skills** | 103 | Workflow commands (/commit, /fix, /build, /research, etc.) |
| **Plugins** | 4 | frontend-design, code-simplifier, playwright, gopls-lsp |

### Post-Install Setup

```bash
# 1. Authenticate Claude
claude

# 2. Build hooks (compiles TypeScript to JavaScript)
cd ~/.claude/hooks && npm install && bash build.sh

# 3. Verify hooks are working
claude  # Should see "SessionStart hook success" messages
```

### Hooks Architecture

Hooks intercept Claude Code tool calls at various lifecycle points:

- **PreToolUse**: Smart search routing, TLDR context injection, file claims
- **PostToolUse**: TypeScript compiler-in-the-loop, import validation, diagnostics
- **SessionStart**: Session registration, symbol indexing, continuity restoration
- **UserPromptSubmit**: Skill activation, memory awareness, impact analysis
- **PreCompact**: Continuity preservation before context compression
- **Stop/SessionEnd**: Cleanup, session outcome tracking

---

## TLDR (llm-tldr)

Code analysis tool providing 95% token savings over raw file reading.

### Install

```bash
# Install from forked repo (NOT the default pip package)
uv tool install git+https://github.com/Danny-Dasilva/llm-tldr.git
```

### Usage

```bash
tldr tree src/              # File tree
tldr structure . --lang py  # Code structure (codemaps)
tldr search "pattern" src/  # Search files
tldr cfg file.py func       # Control flow graph
tldr dfg file.py func       # Data flow graph
tldr calls src/             # Cross-file call graph
tldr impact func src/       # Reverse call graph (who calls this?)
tldr dead src/              # Find dead code
tldr arch src/              # Detect architectural layers
tldr diagnostics .          # Type check + lint
tldr change-impact          # Find tests affected by changes
```

---

## File Structure

```
~
├── .bashrc                     # Main shell config
├── .tmux.conf                  # Tmux configuration
├── .dotfiles                   # Bare repo alias definition
├── install.sh                  # This installer
├── README.md                   # This file
├── .config/
│   └── nvim/
│       ├── init.vim            # Neovim config
│       └── coc-settings.json   # CoC LSP settings
└── .claude/
    ├── settings.json           # Claude Code settings + hooks config
    ├── rules/                  # 12 global instruction files
    ├── hooks/                  # TypeScript hooks + compiled JS
    │   ├── src/                # Hook source (TypeScript)
    │   ├── dist/               # Compiled hooks (JavaScript)
    │   └── build.sh            # Build script
    ├── agents/                 # 40+ agent definitions
    ├── skills/                 # 103 skill definitions
    └── plugins/                # Plugin configs
```

---

## License

MIT
