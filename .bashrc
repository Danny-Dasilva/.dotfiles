# ble.sh must load first for autosuggestions
[[ $- == *i* ]] && [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach

# My bash config configured for xterm and x11 
# PATH="$HOME/.local/bin${PATH:+:${PATH}}"  # adding .local/bin to $PATH


# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration (optimized)
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=-1                    # Unlimited history
HISTFILESIZE=-1                # Unlimited history file
HISTTIMEFORMAT="%F %T  "
# Security: ignore commands containing sensitive patterns
HISTIGNORE="*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]*:*[Tt][Oo][Kk][Ee][Nn]*:*[Ss][Ee][Cc][Rr][Ee][Tt]*:*[Aa][Pp][Ii][_-][Kk][Ee][Yy]*:*AWS_*=*:*export *KEY*:*export *SECRET*"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist               # Multi-line commands as single entry
shopt -s lithist               # Preserve newlines in multi-line commands
# Real-time history sync across terminals
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND:-}"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar   # ** matches recursively
shopt -s cdspell    # Autocorrect minor cd typos
shopt -s dirspell   # Autocorrect directory typos in completion
shopt -s autocd     # Type directory name to cd into it
shopt -s nocaseglob # Case-insensitive globbing

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#:force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
IP=$(hostname -I | awk '{print $1}')

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
# 	PS1="\[\033[38;5;197m\]\u\[$(tput sgr0)\]\[\033[38;5;254m\]@\h\[$(tput sgr0)\]:\[$(tput sgr0)\]\[\033[38;5;27m\]\w\[$(tput sgr0)\]\\$ \[$(tput sgr0)\]"
	PS1="\[\033[38;5;32m\]┌(\[$(tput sgr0)\]\[\033[38;5;197m\]\u\[$(tput sgr0)\]\[\033[38;5;254m\]@\h\[$(tput sgr0)\]\[\033[38;5;32m\])—\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;32m\]—(\[\033[38;5;78m\]\w\[$(tput sgr0)\]\[\033[38;5;32m\])—\[$(tput sgr0)\]\[\033[38;5;32m\]—(\[$(tput sgr0)\] $IP \[$(tput sgr0)\]\[\033[38;5;32m\])\n\[$(tput sgr0)\]\[\033[38;5;32m\]└─>\[$(tput sgr0)\]"

    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#----------------- linebreak for default ubuntu stuff

### ARCHIVE EXTRACTION
# usage: ex <file>
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

#export WORKON_HOME=~/.environments
#source /usr/local/bin/virtualenvwrapper.sh
#export GOROOT=/usr/local/go
#export PATH=$PATH:$GOROOT/bin

#export GOPATH=/home/tech-garage/Documents/go
#export PATH=$PATH:$GOPATH/bin
#export GOPATH=$GOPATH:/home/tech-garage/Documents/GOCODE
### ALIASES ###

# navigation
alias ..='cd ..' 
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'


# grep alias already defined above in dircolors block

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'


alias aptup='sudo apt update && sudo apt upgrade'
alias docker-compose="docker compose"
alias vim=lvim
alias pip=pip3
#set faster speed for  scroll
[[ -n "$DISPLAY" ]] && xset r rate 300 50 
export TERM=xterm-256color
#source dotfiles
[[ -f ~/.dotfiles ]] && source ~/.dotfiles 
export LS_COLORS='di=0;36:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=0;32:*.rpm=0:*.tar=0;31'
#curl -u 'USER' https://api.github.com/user/repos -d '{"name":"REPO"}'

# NVM setup with lazy loading (faster shell startup)
export NVM_DIR="$HOME/.nvm"

# Add default node bin to PATH immediately (for global packages like claude)
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

# Lazy load NVM itself (for nvm commands like `nvm use`, `nvm install`)
_load_nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { _load_nvm; nvm "$@"; }
force_color_prompt=yes
# Pyenv setup with lazy loading (faster shell startup)
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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# <<< conda initialize <<<


# pnpm
export PNPM_HOME="/home/danny/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH


export ENCORE_INSTALL="/home/danny/.encore"
export PATH="$ENCORE_INSTALL/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin
. "$HOME/.local/bin/env"


# This alias runs the Cursor Setup Wizard, simplifying installation and configuration.
# For more details, visit: https://github.com/jorcelinojunior/cursor-setup-wizard
alias cursor-setup="/home/danny/cursor-setup-wizard/cursor_setup.sh"
export PATH="$HOME/.local/bin:$PATH"

#=============================================================================
# MODERN CLI IMPROVEMENTS (Added by Claude)
#=============================================================================

# Modern tool aliases (eza, bat, fd, ripgrep)
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
# FZF - Fuzzy Finder (Ctrl+R history, Ctrl+T files, Alt+C directories)
#-----------------------------------------------------------------------------
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# FZF configuration
if command -v fzf &>/dev/null; then
    # Use fd if available for better performance
    if command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --hidden --follow --exclude .git'
    fi

    # Preview with bat if available
    if command -v batcat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --line-range :500 {}' --preview-window=right:50%"
    elif command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}' --preview-window=right:50%"
    fi

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

#-----------------------------------------------------------------------------
# Zoxide - Smart directory jumping (use 'j' command)
#-----------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash --cmd j)"
fi

#-----------------------------------------------------------------------------
# Starship Prompt (configured to match original prompt style)
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

# Git functions
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

# Docker shell into container
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

# Quick edit bashrc
alias bashrc='${EDITOR:-vim} ~/.bashrc && source ~/.bashrc'

#-----------------------------------------------------------------------------
# Safety Aliases
#-----------------------------------------------------------------------------
alias rm='rm -I'               # Prompt before removing more than 3 files

#-----------------------------------------------------------------------------
# Tool Completions
#-----------------------------------------------------------------------------
# kubectl completion (if installed)
if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash) 2>/dev/null
    alias k=kubectl
    complete -o default -F __start_kubectl k 2>/dev/null
fi

# Docker completion (if installed)
command -v docker &>/dev/null && source <(docker completion bash 2>/dev/null)

# gh CLI completion (if installed)
command -v gh &>/dev/null && eval "$(gh completion -s bash 2>/dev/null)"

#-----------------------------------------------------------------------------
# Security
#-----------------------------------------------------------------------------
# Note: umask 077 was removed - it breaks GNOME (icons, themes, window decorations)
# by making cache files unreadable to other GNOME processes
chmod 600 ~/.bash_history 2>/dev/null
export PATH="$HOME/.deno/bin:$PATH"

#=============================================================================
# ENHANCED SHELL CONFIGURATION (2026)
#=============================================================================

# Load helper functions
[[ -f ~/.config/bash/lib/helpers.sh ]] && source ~/.config/bash/lib/helpers.sh
[[ -f ~/.config/bash/lib/detect-env.sh ]] && source ~/.config/bash/lib/detect-env.sh

# Load modular configs
for f in ~/.config/bash/bashrc.d/*.sh; do
    [[ -r "$f" ]] && source "$f"
done

#-----------------------------------------------------------------------------
# Atuin - Modern shell history (replaces PROMPT_COMMAND history sync)
#-----------------------------------------------------------------------------
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash --disable-up-arrow)"
    # Remove old history sync from PROMPT_COMMAND
    PROMPT_COMMAND="${PROMPT_COMMAND/history -a; history -c; history -r; /}"
fi

#-----------------------------------------------------------------------------
# ble.sh - Fish-like autosuggestions (attach at end)
#-----------------------------------------------------------------------------
[[ ${BLE_VERSION-} ]] && ble-attach

#-----------------------------------------------------------------------------
# Complete-alias - Tab completion for aliases
#-----------------------------------------------------------------------------
if [[ -f ~/.complete-alias/complete_alias ]]; then
    source ~/.complete-alias/complete_alias
    # Enable for common aliases
    complete -F _complete_alias k dc gs gd ga gc gp 2>/dev/null
fi

#-----------------------------------------------------------------------------
# Cached tool initialization (faster startup)
#-----------------------------------------------------------------------------
_init_cache() {
    local tool="$1" cache="$HOME/.cache/${tool}-init.bash"
    if [[ ! -f "$cache" ]] || [[ $(find "$cache" -mtime +7 2>/dev/null) ]]; then
        "$@" > "$cache" 2>/dev/null
    fi
    [[ -f "$cache" ]] && source "$cache"
}

#-----------------------------------------------------------------------------
# Additional aliases and functions
#-----------------------------------------------------------------------------
alias top='btop' 2>/dev/null
alias lg='lazygit' 2>/dev/null

# mkcd - create and enter directory
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Quick system info
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
