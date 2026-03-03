#=============================================================================
# RE-ENTRY GUARD - prevents double-sourcing (login shell sources both
# .bash_profile and .bashrc, causing all init commands to run twice)
#=============================================================================
[[ -n "$_BASHRC_LOADED" ]] && return
_BASHRC_LOADED=1

# ble.sh must load first for autosuggestions (--noattach defers heavy init)
[[ $- == *i* ]] && [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %T  "
HISTIGNORE="*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]*:*[Tt][Oo][Kk][Ee][Nn]*:*[Ss][Ee][Cc][Rr][Ee][Tt]*:*[Aa][Pp][Ii][_-][Kk][Ee][Yy]*:*AWS_*=*:*export *KEY*:*export *SECRET*"

shopt -s histappend
shopt -s cmdhist
shopt -s lithist

# History sync - set once, not appended (prevents PROMPT_COMMAND snowball)
_bash_history_sync() { history -a; history -c; history -r; }
PROMPT_COMMAND="_bash_history_sync"

shopt -s checkwinsize
shopt -s globstar
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s nocaseglob

# lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# chroot detection
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Prompt setup
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Cache IP once per shell session (avoid subprocess every prompt)
_CACHED_IP=$(hostname -I 2>/dev/null | awk '{print $1}')

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\033[38;5;32m\]┌(\[$(tput sgr0)\]\[\033[38;5;197m\]\u\[$(tput sgr0)\]\[\033[38;5;254m\]@\h\[$(tput sgr0)\]\[\033[38;5;32m\])—\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;32m\]—(\[\033[38;5;78m\]\w\[$(tput sgr0)\]\[\033[38;5;32m\])—\[$(tput sgr0)\]\[\033[38;5;32m\]—(\[$(tput sgr0)\] $_CACHED_IP \[$(tput sgr0)\]\[\033[38;5;32m\])\n\[$(tput sgr0)\]\[\033[38;5;32m\]└─>\[$(tput sgr0)\]"
    ;;
esac

# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#----------------- Custom stuff below -----------------

### ARCHIVE EXTRACTION
ex ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   unzstd "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Safety
alias cp="cp -i"
alias mv='mv -i'

alias aptup='sudo apt update && sudo apt upgrade'
alias docker-compose="docker compose"
alias vim=lvim
alias pip=pip3

# xset - only run once per X session, not every shell
if [[ -n "$DISPLAY" ]] && [[ -z "$_XSET_DONE" ]]; then
    xset r rate 300 50 2>/dev/null
    export _XSET_DONE=1
fi

export TERM=xterm-256color
[[ -f ~/.dotfiles ]] && source ~/.dotfiles
export LS_COLORS='di=0;36:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=0;32:*.rpm=0:*.tar=0;31'

# NVM setup with lazy loading
export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR/versions/node" ]; then
  NVM_DEFAULT=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
  if [ -n "$NVM_DEFAULT" ]; then
    for _nvm_node_dir in "$NVM_DIR/versions/node/v${NVM_DEFAULT}"* "$NVM_DIR/versions/node/${NVM_DEFAULT}"*; do
      if [ -d "$_nvm_node_dir/bin" ]; then
        export PATH="$_nvm_node_dir/bin:$PATH"
        break
      fi
    done
    unset _nvm_node_dir
  fi
  unset NVM_DEFAULT
fi

_load_nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { _load_nvm; nvm "$@"; }

# Pyenv setup with lazy loading
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
_load_pyenv() {
  unset -f pyenv python python3 pip pip3
  command -v pyenv &>/dev/null && eval "$(command pyenv init -)"
}
for _pyenv_cmd in pyenv python python3 pip pip3; do
  eval "${_pyenv_cmd}() { _load_pyenv; ${_pyenv_cmd} \"\$@\"; }"
done
unset _pyenv_cmd

. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/danny/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

export ENCORE_INSTALL="/home/danny/.encore"
export PATH="$ENCORE_INSTALL/bin:$PATH"

# Go PATH - cache GOPATH instead of running `go env` every shell start
if command -v go &>/dev/null; then
    _GO_CACHE="$HOME/.cache/go-path.cache"
    if [[ ! -f "$_GO_CACHE" ]] || [[ $(find "$_GO_CACHE" -mtime +7 2>/dev/null) ]]; then
        go env GOPATH > "$_GO_CACHE" 2>/dev/null
    fi
    [[ -f "$_GO_CACHE" ]] && export PATH="$PATH:$(cat "$_GO_CACHE")/bin"
    unset _GO_CACHE
fi

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

alias cursor-setup="/home/danny/cursor-setup-wizard/cursor_setup.sh"
export PATH="$HOME/.local/bin:$PATH"

#=============================================================================
# MODERN CLI IMPROVEMENTS
#=============================================================================

if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -la --group-directories-first --git'
    alias la='eza -a --group-directories-first'
    alias lt='eza --tree --level=2'
    alias tree='eza --tree'
fi

if command -v batcat &>/dev/null; then
    alias cat='batcat --paging=never'
    alias bat='batcat'
elif command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

#-----------------------------------------------------------------------------
# FZF
#-----------------------------------------------------------------------------
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if command -v fzf &>/dev/null; then
    if command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --hidden --follow --exclude .git'
    fi

    if command -v batcat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --line-range :500 {}' --preview-window=right:50%"
    elif command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}' --preview-window=right:50%"
    fi

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

#-----------------------------------------------------------------------------
# Zoxide
#-----------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash --cmd j)"
fi

#-----------------------------------------------------------------------------
# Starship Prompt
#-----------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

#-----------------------------------------------------------------------------
# Git Aliases
#-----------------------------------------------------------------------------
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git log --oneline -20'
alias glog='git log --graph --oneline --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'
alias gf='git fetch --all --prune'

gac() { git add "${@:-.}" && git commit; }
gacp() { git add "${@:-.}" && git commit && git push; }

#-----------------------------------------------------------------------------
# Docker Aliases
#-----------------------------------------------------------------------------
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dclf='docker compose logs -f'
alias dex='docker exec -it'

dsh() { docker exec -it "$1" /bin/bash 2>/dev/null || docker exec -it "$1" /bin/sh; }

#-----------------------------------------------------------------------------
# System Aliases
#-----------------------------------------------------------------------------
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me && echo'
alias localip='hostname -I | awk "{print \$1}"'
alias mem='free -h'
alias disk='df -h'
alias usage='du -sh * 2>/dev/null | sort -h'
alias psg='ps aux | grep -v grep | grep -i'

alias bashrc='${EDITOR:-vim} ~/.bashrc && source ~/.bashrc'

#-----------------------------------------------------------------------------
# Safety
#-----------------------------------------------------------------------------
alias rm='rm -I'

#-----------------------------------------------------------------------------
# Completions - LAZY LOADED (docker completion was loading eagerly, ~5MB)
#-----------------------------------------------------------------------------
# Docker completion - load on first tab-complete, not at startup
_lazy_docker_completion() {
    unset -f _lazy_docker_completion
    complete -r docker 2>/dev/null
    source <(docker completion bash 2>/dev/null)
    return 124  # retry completion
}
command -v docker &>/dev/null && complete -F _lazy_docker_completion docker

# gh CLI completion - lazy loaded
_lazy_gh_completion() {
    unset -f _lazy_gh_completion
    complete -r gh 2>/dev/null
    eval "$(gh completion -s bash 2>/dev/null)"
    return 124
}
command -v gh &>/dev/null && complete -F _lazy_gh_completion gh

#-----------------------------------------------------------------------------
# Security
#-----------------------------------------------------------------------------
chmod 600 ~/.bash_history 2>/dev/null
export PATH="$HOME/.deno/bin:$PATH"

#=============================================================================
# ENHANCED SHELL CONFIGURATION (2026)
#=============================================================================
[[ -f ~/.config/bash/lib/helpers.sh ]] && source ~/.config/bash/lib/helpers.sh
[[ -f ~/.config/bash/lib/detect-env.sh ]] && source ~/.config/bash/lib/detect-env.sh

for f in ~/.config/bash/bashrc.d/*.sh; do
    [[ -r "$f" ]] && source "$f"
done

#-----------------------------------------------------------------------------
# Atuin - Modern shell history (replaces PROMPT_COMMAND history sync)
#-----------------------------------------------------------------------------
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash --disable-up-arrow)"
    # Atuin manages history, remove our sync from PROMPT_COMMAND
    PROMPT_COMMAND="${PROMPT_COMMAND/_bash_history_sync/true}"
fi

#-----------------------------------------------------------------------------
# ble.sh - attach at end (OPTIONAL - comment out if memory is still too high)
# ble.sh uses 200-500MB RAM for autosuggestions/syntax highlighting
#-----------------------------------------------------------------------------
[[ ${BLE_VERSION-} ]] && ble-attach

#-----------------------------------------------------------------------------
# Complete-alias
#-----------------------------------------------------------------------------
if [[ -f ~/.complete-alias/complete_alias ]]; then
    source ~/.complete-alias/complete_alias
    complete -F _complete_alias k dc gs gd ga gc gp 2>/dev/null
fi

#-----------------------------------------------------------------------------
# Additional aliases
#-----------------------------------------------------------------------------
alias top='btop' 2>/dev/null
alias lg='lazygit' 2>/dev/null

mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

sysinfo() {
    echo "=== CPU ===" && lscpu | grep -E "^(Model name|CPU\(s\))"
    echo "=== Memory ===" && free -h | head -2
    echo "=== Disk ===" && df -h / | tail -1
    echo "=== Load ===" && uptime
}

#-----------------------------------------------------------------------------
# PATH deduplication (run at end)
#-----------------------------------------------------------------------------
PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '!a[$0]++' | sed 's/:$//')
export PATH

. "$HOME/.atuin/bin/env"
export PATH="$HOME/bin:$PATH"
