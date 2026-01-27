# dotfiles

Personal dotfiles for bash, tmux, and development environment.

## Setup

```bash
git clone --bare https://github.com/Danny-Dasilva/.dotfiles.git ~/.dotfiles.git

echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> ~/.dotfiles

source ~/.dotfiles

dotfiles checkout --force

fc-cache -rv  # Update fonts
```

## Managing Dotfiles

```bash
# Add files
dotfiles add $your_file

# Commit
dotfiles commit -m "My message"

# Push
dotfiles push origin master

# Pull updates
dotfiles pull
```

### Troubleshooting

If no origin error:
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

```bash
ls      → eza with directories first
ll      → eza -la with git status
lt      → eza tree view (2 levels)
cat     → bat with syntax highlighting
fd      → fdfind (faster find)
```

### Navigation

```bash
..      → cd ..
...     → cd ../..
.3-.5   → cd up 3-5 levels
j foo   → zoxide jump to "foo" directory
mkcd x  → mkdir x && cd x
```

### Git Aliases

```bash
gs      → git status -sb
gd      → git diff
gds     → git diff --staged
ga      → git add
gaa     → git add --all
gc      → git commit
gcm     → git commit -m
gp      → git push
gpl     → git pull
gco     → git checkout
gcob    → git checkout -b
gb      → git branch
gl      → git log --oneline -20
glog    → git log graph view
gst     → git stash
gstp    → git stash pop
gf      → git fetch --all --prune
gac     → git add . && commit (function)
gacp    → git add . && commit && push (function)
```

### Docker Aliases

```bash
dps     → docker ps (formatted)
dpsa    → docker ps -a
dc      → docker compose
dcu     → docker compose up -d
dcd     → docker compose down
dcr     → docker compose restart
dclf    → docker compose logs -f
dex     → docker exec -it
dsh     → shell into container (function)
```

### System Utilities

```bash
ports   → ss -tulanp (show listening ports)
myip    → public IP address
localip → local IP address
mem     → free -h
disk    → df -h
usage   → du -sh * | sort -h
psg     → ps aux | grep
sysinfo → quick system overview (function)
bashrc  → edit and reload bashrc
ex      → extract any archive (function)
```

### Performance Optimizations

- **Lazy-loaded NVM**: Node available immediately, `nvm` loads on first use
- **Lazy-loaded Pyenv**: Python available immediately, pyenv loads on first use
- **Cached tool init**: Starship, zoxide, etc. cached for 7 days
- **PATH deduplication**: Prevents PATH bloat

### History Features

- Unlimited history (`HISTSIZE=-1`)
- Timestamps on all commands
- Multi-line commands preserved
- Security: passwords/tokens/secrets excluded from history
- Cross-terminal sync (or Atuin if installed)

### Shell Options

```bash
globstar    → ** matches recursively
cdspell     → autocorrect cd typos
dirspell    → autocorrect completion typos
autocd      → type dirname to cd into it
nocaseglob  → case-insensitive globbing
```

### Dependencies

Install for full functionality:

```bash
# Core (Ubuntu/Debian)
sudo apt install fzf fd-find ripgrep bat eza

# Optional enhancements
cargo install zoxide starship atuin

# Fish-like autosuggestions
git clone --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
```

---

## Tmux Configuration

Enhanced tmux with Catppuccin theme, vi-mode, and productivity plugins.

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
| Session picker | `prefix + o` |
| Help menu | `prefix + ?` |

### Window Management

| Action | Keybinding |
|--------|------------|
| New window | `prefix + c` |
| Close window | `prefix + &` |
| **Quick switch** | `Alt+1` to `Alt+9` |
| Last window | `prefix + Tab` |
| Rename | `prefix + ,` |

### Pane Management

| Action | Keybinding |
|--------|------------|
| Split horizontal | `prefix + \|` |
| Split vertical | `prefix + -` |
| Navigate | `Alt+h/j/k/l` |
| Resize | `prefix + H/J/K/L` (repeatable) |
| Zoom | `Alt+z` or `prefix + z` |
| Mark pane | `prefix + m` |
| Sync typing | `prefix + y` |

### Sessions

| Action | Keybinding |
|--------|------------|
| Session picker (FZF) | `prefix + o` |
| Last session | `prefix + BTab` |
| SSH menu | `prefix + S` |
| Save session | `prefix + Ctrl+s` |
| Restore session | `prefix + Ctrl+r` |

### Copy Mode (Vi-style)

Enter with `prefix + [`

| Action | Key |
|--------|-----|
| Start selection | `v` |
| Rectangle select | `Ctrl+v` |
| Copy to clipboard | `y` |
| Search forward | `/` |
| Search backward | `?` |

### Popup Tools

| Tool | Keybinding |
|------|------------|
| **Lazygit** | `prefix + g` |
| **LazyDocker** | `prefix + G` |
| **Htop** | `prefix + t` |

### Plugins

| Plugin | Key | Purpose |
|--------|-----|---------|
| tmux-fzf | `prefix + F` | Fuzzy find sessions/windows |
| extrakto | `prefix + Tab` | Extract URLs/paths from scrollback |
| tmux-sessionx | `prefix + o` | Enhanced session picker |
| tmux-thumbs | `prefix + Space` | Vimium-style text hints |
| tmux-resurrect | `Ctrl+s/r` | Save/restore sessions |
| tmux-continuum | automatic | Auto-save sessions |
| tmux-yank | automatic | Better clipboard |
| vim-tmux-navigator | `Ctrl+h/j/k/l` | Seamless vim/tmux navigation |

### Plugin Management (TPM)

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins (inside tmux)
prefix + I

# Update plugins
prefix + U
```

### Status Bar

- Top position with Catppuccin Mocha theme
- Git branch display (yellow)
- Clickable: `+` creates window, `×` closes window
- Middle-click tab closes that window

### Performance Settings

- `escape-time 0` - No vim delay
- `focus-events on` - Vim autoread works
- `history-limit 50000` - Large scrollback
- True color and undercurl support
- OSC 52 clipboard (works over SSH)

### SSH Remote Menu

`prefix + S` shows hosts from `~/.ssh/config`:
- Auto-connects and resumes tmux session on remote
- Creates new window per connection

### Mouse Support

- Scroll to browse history
- Click to select panes/windows
- Drag to select text (auto-copies)

---

## License

MIT
