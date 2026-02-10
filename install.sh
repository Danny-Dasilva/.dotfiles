#!/usr/bin/env bash
set -euo pipefail

# Danny's Dotfiles Installer
# Installs all packages and configures the development environment
# Usage: curl -fsSL https://raw.githubusercontent.com/Danny-Dasilva/.dotfiles/master/install.sh | bash
# Or:    git clone --bare ... && ./install.sh

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
section() { echo -e "\n${BOLD}=== $* ===${NC}"; }

# Track what was installed for summary
INSTALLED=()
SKIPPED=()

command_exists() { command -v "$1" &>/dev/null; }

#=============================================================================
# 1. DOTFILES REPO
#=============================================================================
section "Dotfiles Repository"

DOTFILES_GIT="$HOME/.dotfiles.git"
DOTFILES_REMOTE="https://github.com/Danny-Dasilva/.dotfiles.git"

if [ -d "$DOTFILES_GIT" ]; then
    ok "Dotfiles repo already exists at $DOTFILES_GIT"
    SKIPPED+=("dotfiles-repo")
else
    info "Cloning dotfiles bare repo..."
    git clone --bare "$DOTFILES_REMOTE" "$DOTFILES_GIT"

    # Create the dotfiles alias file
    echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' > "$HOME/.dotfiles"

    # Checkout files (force to overwrite defaults)
    /usr/bin/git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" checkout --force

    # Don't show untracked files (critical for bare repo in $HOME)
    /usr/bin/git --git-dir="$DOTFILES_GIT" --work-tree="$HOME" config status.showUntrackedFiles no

    ok "Dotfiles cloned and checked out"
    INSTALLED+=("dotfiles-repo")
fi

# Source the alias for this script
alias dotfiles="/usr/bin/git --git-dir=$DOTFILES_GIT/ --work-tree=$HOME"

#=============================================================================
# 2. SYSTEM PACKAGES (apt)
#=============================================================================
section "System Packages"

APT_PACKAGES=(
    # Core tools
    git curl wget build-essential

    # Modern CLI tools
    fzf fd-find ripgrep bat eza

    # Tmux and terminal
    tmux xclip xsel

    # System monitors
    btop

    # Neovim dependencies
    neovim python3-pynvim

    # Build dependencies (for ble.sh, native packages)
    make gawk

    # Python build deps (for pyenv)
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev
    libffi-dev liblzma-dev
)

info "Updating apt cache..."
sudo apt update -qq

info "Installing system packages..."
sudo apt install -y -qq "${APT_PACKAGES[@]}" 2>/dev/null
ok "System packages installed"
INSTALLED+=("apt-packages")

#=============================================================================
# 3. RUST & CARGO TOOLS
#=============================================================================
section "Rust & Cargo Tools"

if ! command_exists rustc; then
    info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    ok "Rust installed"
    INSTALLED+=("rust")
else
    ok "Rust already installed ($(rustc --version))"
    SKIPPED+=("rust")
    source "$HOME/.cargo/env"
fi

# Cargo tools installed via cargo
for tool in zoxide starship; do
    if ! command_exists "$tool"; then
        info "Installing $tool via cargo..."
        cargo install "$tool"
        ok "$tool installed"
        INSTALLED+=("$tool")
    else
        ok "$tool already installed"
        SKIPPED+=("$tool")
    fi
done

#=============================================================================
# 4. ATUIN (Shell History)
#=============================================================================
section "Atuin"

if ! command_exists atuin; then
    info "Installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    ok "Atuin installed"
    INSTALLED+=("atuin")
else
    ok "Atuin already installed ($(atuin --version))"
    SKIPPED+=("atuin")
fi

#=============================================================================
# 5. NVM & NODE.JS
#=============================================================================
section "NVM & Node.js"

NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    ok "NVM + Node.js LTS installed"
    INSTALLED+=("nvm" "node")
else
    ok "NVM already installed"
    SKIPPED+=("nvm")
    # Ensure nvm is loaded
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

#=============================================================================
# 6. PYENV & PYTHON
#=============================================================================
section "Pyenv & Python"

if ! command_exists pyenv; then
    info "Installing pyenv..."
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    ok "Pyenv installed"
    INSTALLED+=("pyenv")
else
    ok "Pyenv already installed"
    SKIPPED+=("pyenv")
fi

#=============================================================================
# 7. UV (Python package manager)
#=============================================================================
section "UV"

if ! command_exists uv; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ok "UV installed"
    INSTALLED+=("uv")
else
    ok "UV already installed ($(uv --version))"
    SKIPPED+=("uv")
fi

#=============================================================================
# 8. BUN (JavaScript runtime)
#=============================================================================
section "Bun"

if ! command_exists bun; then
    info "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    ok "Bun installed"
    INSTALLED+=("bun")
else
    ok "Bun already installed ($(bun --version))"
    SKIPPED+=("bun")
fi

#=============================================================================
# 9. DENO
#=============================================================================
section "Deno"

if ! command_exists deno; then
    info "Installing Deno..."
    curl -fsSL https://deno.land/install.sh | sh
    ok "Deno installed"
    INSTALLED+=("deno")
else
    ok "Deno already installed ($(deno --version | head -1))"
    SKIPPED+=("deno")
fi

#=============================================================================
# 10. GO
#=============================================================================
section "Go"

if ! command_exists go; then
    info "Installing Go..."
    GO_VERSION="1.23.5"
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    export PATH="/usr/local/go/bin:$PATH"
    ok "Go ${GO_VERSION} installed"
    INSTALLED+=("go")
else
    ok "Go already installed ($(go version))"
    SKIPPED+=("go")
fi

#=============================================================================
# 11. LAZYGIT
#=============================================================================
section "Lazygit"

if ! command_exists lazygit; then
    info "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    rm /tmp/lazygit.tar.gz
    ok "Lazygit installed"
    INSTALLED+=("lazygit")
else
    ok "Lazygit already installed"
    SKIPPED+=("lazygit")
fi

#=============================================================================
# 12. LAZYDOCKER
#=============================================================================
section "Lazydocker"

if ! command_exists lazydocker; then
    info "Installing lazydocker..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    ok "Lazydocker installed"
    INSTALLED+=("lazydocker")
else
    ok "Lazydocker already installed"
    SKIPPED+=("lazydocker")
fi

#=============================================================================
# 13. TLDR (llm-tldr - Code Analysis Tool)
#=============================================================================
section "TLDR (llm-tldr)"

if ! command_exists tldr; then
    info "Installing llm-tldr via uv..."
    uv tool install llm-tldr
    ok "llm-tldr installed (provides 'tldr' command)"
    INSTALLED+=("llm-tldr")
else
    ok "tldr already installed ($(tldr --version 2>/dev/null || echo 'installed'))"
    SKIPPED+=("llm-tldr")
fi

#=============================================================================
# 14. BLE.SH (Fish-like autosuggestions)
#=============================================================================
section "ble.sh"

if [ ! -f "$HOME/.local/share/blesh/ble.sh" ]; then
    info "Installing ble.sh..."
    git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX="$HOME/.local"
    rm -rf /tmp/ble.sh
    ok "ble.sh installed"
    INSTALLED+=("ble.sh")
else
    ok "ble.sh already installed"
    SKIPPED+=("ble.sh")
fi

#=============================================================================
# 15. COMPLETE-ALIAS (Tab completion for aliases)
#=============================================================================
section "complete-alias"

if [ ! -f "$HOME/.complete-alias/complete_alias" ]; then
    info "Installing complete-alias..."
    git clone https://github.com/cykerway/complete-alias.git "$HOME/.complete-alias"
    ok "complete-alias installed"
    INSTALLED+=("complete-alias")
else
    ok "complete-alias already installed"
    SKIPPED+=("complete-alias")
fi

#=============================================================================
# 16. TMUX PLUGIN MANAGER (TPM) + Plugins
#=============================================================================
section "Tmux Plugins"

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
    INSTALLED+=("tpm")
else
    ok "TPM already installed"
    SKIPPED+=("tpm")
fi

# Install catppuccin theme (manual install used by .tmux.conf)
CATPPUCCIN_DIR="$HOME/.tmux/plugins/tmux"
if [ ! -d "$CATPPUCCIN_DIR" ]; then
    info "Installing Catppuccin tmux theme..."
    git clone https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR"
    ok "Catppuccin theme installed"
    INSTALLED+=("catppuccin-tmux")
else
    ok "Catppuccin tmux theme already installed"
    SKIPPED+=("catppuccin-tmux")
fi

# Install all TPM plugins
info "Installing tmux plugins via TPM..."
"$TPM_DIR/bin/install_plugins" 2>/dev/null || warn "TPM plugin install failed (run 'prefix + I' inside tmux)"

#=============================================================================
# 17. NEOVIM PLUGINS
#=============================================================================
section "Neovim"

PLUG_FILE="$HOME/.config/nvim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
    info "Installing vim-plug..."
    curl -fLo "$PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "vim-plug installed"
    INSTALLED+=("vim-plug")
else
    ok "vim-plug already installed"
    SKIPPED+=("vim-plug")
fi

info "Installing neovim plugins..."
nvim --headless +PlugInstall +qall 2>/dev/null || warn "Neovim PlugInstall failed (run :PlugInstall manually)"

#=============================================================================
# 18. CLAUDE CODE
#=============================================================================
section "Claude Code"

if ! command_exists claude; then
    info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    ok "Claude Code installed"
    INSTALLED+=("claude-code")
else
    ok "Claude Code already installed ($(claude --version 2>/dev/null | head -1))"
    SKIPPED+=("claude-code")
fi

# Build Claude hooks (TypeScript -> JavaScript)
if [ -f "$HOME/.claude/hooks/build.sh" ]; then
    info "Building Claude Code hooks..."
    if [ -d "$HOME/.claude/hooks/node_modules" ]; then
        ok "Hook node_modules exists"
    else
        info "Installing hook dependencies..."
        (cd "$HOME/.claude/hooks" && npm install)
    fi
    bash "$HOME/.claude/hooks/build.sh" 2>/dev/null && ok "Claude hooks built" || warn "Hook build failed (run manually: bash ~/.claude/hooks/build.sh)"
    INSTALLED+=("claude-hooks")
fi

#=============================================================================
# 19. GITHUB CLI
#=============================================================================
section "GitHub CLI"

if ! command_exists gh; then
    info "Installing GitHub CLI..."
    (type -p wget >/dev/null || sudo apt install wget -y) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli-stable.list > /dev/null \
        && sudo apt update -qq && sudo apt install gh -y -qq
    ok "GitHub CLI installed"
    INSTALLED+=("gh")
else
    ok "GitHub CLI already installed ($(gh --version | head -1))"
    SKIPPED+=("gh")
fi

#=============================================================================
# 20. FZF (manual install for keybindings)
#=============================================================================
section "FZF Keybindings"

if [ ! -f "$HOME/.fzf.bash" ]; then
    info "Installing FZF keybindings..."
    if [ -d "$HOME/.fzf" ]; then
        "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
    elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
        # Debian/Ubuntu puts it here
        ln -sf /usr/share/doc/fzf/examples/key-bindings.bash "$HOME/.fzf.bash"
    fi
    ok "FZF keybindings configured"
else
    ok "FZF keybindings already set up"
    SKIPPED+=("fzf-keybindings")
fi

#=============================================================================
# 21. FONTS
#=============================================================================
section "Fonts"

info "Refreshing font cache..."
fc-cache -fv 2>/dev/null
ok "Font cache updated"

#=============================================================================
# SUMMARY
#=============================================================================
echo ""
section "Installation Summary"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
    echo -e "${GREEN}Installed:${NC}"
    for item in "${INSTALLED[@]}"; do
        echo -e "  ${GREEN}+${NC} $item"
    done
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
    echo -e "${YELLOW}Already present:${NC}"
    for item in "${SKIPPED[@]}"; do
        echo -e "  ${YELLOW}-${NC} $item"
    done
fi

echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Restart your terminal (or run: source ~/.bashrc)"
echo "  2. Open tmux and press prefix + I to install tmux plugins"
echo "  3. Run 'claude' and authenticate with your Anthropic API key"
echo "  4. Run 'atuin login' if you want cross-device history sync"
echo ""
ok "Done!"
