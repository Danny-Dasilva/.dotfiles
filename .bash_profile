export PATH="$PATH:$HOME/.local/bin"

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$PATH:/home/danny/Documents/jarvis"

export ENCORE_INSTALL="/home/danny/.encore"
export PATH="$ENCORE_INSTALL/bin:$PATH"
. "$HOME/.cargo/env"

. "$HOME/.atuin/bin/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Source .bashrc for interactive shells
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
