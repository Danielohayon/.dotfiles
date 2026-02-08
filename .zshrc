
# Dotfiles location
export DOTFILES="$HOME/Documents/Projects/.dotfiles"

# Homebrew setup (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# History timestamp format
HIST_STAMPS='%d/%m %H:%M '

# -- Premade Init:

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable colors
autoload -U colors && colors

# Git branch for prompt
git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo "($branch) "
}

# Short path - last 3 directories
short_path() {
    local p="${PWD/#$HOME/~}"
    echo "$p" | awk -F/ '{if(NF<=3) print $0; else print $(NF-2)"/"$(NF-1)"/"$NF}'
}

# Enable prompt substitution
setopt PROMPT_SUBST

# Set prompt
if [[ "$TERM" == xterm-color || "$TERM" == *-256color ]]; then
    PROMPT='%F{yellow}$(git_branch)%f%F{blue}$(short_path)%f$ '
else
    PROMPT='$(git_branch)$(short_path)$ '
fi

# Enable color support and aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ============================================
# Aliases (from .bash_aliases)
# ============================================

# Lazygit alias
alias lz='lazygit'

# eza init
alias ll='eza -lhF --icons --group-directories-first'
alias ls='eza -lhF --icons --group-directories-first'
alias la='eza -lhaF --icons --group-directories-first'
alias l='eza -F --icons --group-directories-first'
alias tree='eza -T --icons --group-directories-first'

alias v=nvim

# Claude Code
alias c='claude --allow-dangerously-skip-permissions'
alias cr='claude --resume --allow-dangerously-skip-permissions'

# Assistant init
alias chat='gpt --model claude-3-opus-20240229 --no_price'
alias gcbc='gpt --model claude-3-opus-20240229 bash --prompt'
alias gcdr='gpt --model claude-3-opus-20240229 --no_price --prompt'
alias g=$'chatgpt \'(Remember you are and expert software engineer and you provide to the point replies withtout needles expansions. You are concise and to the point)\''
alias ge='chatgpt'
alias gt='OPENAI_OMIT_HISTORY=True chatgpt'

# Git aliases
[ -f "$DOTFILES/.git_aliases" ] && source "$DOTFILES/.git_aliases"

# ============================================
# Enable completion (must be before kubectl completion)
# ============================================
autoload -Uz compinit && compinit

# ============================================
# Kubectl shortcuts
# ============================================
# Use kubecolor for colorized output (brew install kubecolor)
if command -v kubecolor &> /dev/null; then
    alias kubectl=kubecolor
    alias k=kubecolor
    # Make kubecolor use kubectl completions
    compdef kubecolor=kubectl
else
    alias k=kubectl
fi

# kubectl auto completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
    compdef k=kubectl
fi

# kubectl fzf aliases
[ -f "$DOTFILES/.kubectl_aliases" ] && source "$DOTFILES/.kubectl_aliases"

# mutagen fzf aliases
[ -f "$DOTFILES/.mutagen_aliases" ] && source "$DOTFILES/.mutagen_aliases"

# ============================================
# fzf initialization
# ============================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================
# Google Cloud SDK / gsutil completion
# ============================================
# Homebrew install location
if [ -f "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then
    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
# Standard install location
elif [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# ============================================
# Environment variables
# ============================================
export HF_HOME="/Users/danielohayon/.cache/huggingface"

# Use ~/.config for apps that support XDG (lazygit, etc.)
export XDG_CONFIG_HOME="$HOME/.config"

# Attempt to fix yanking problem in tmux
export DISPLAY=:0

# ============================================
# Zoxide setup (only in interactive shells)
# ============================================
if [[ -o interactive ]] && command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# ============================================
# fzf tree preview for cd
# ============================================
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
        *)            fzf "$@" ;;
    esac
}

# A better watch that expands aliases before passing to watch
alias watchh='watch '

# ============================================
# Zsh-specific options
# ============================================
# Enable command auto-correction
setopt CORRECT

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Better globbing
setopt EXTENDED_GLOB

# No beep
setopt NO_BEEP

# cd without typing cd
setopt AUTO_CD

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive completion

alias mutsync='mutagen sync create --ignore=".venv" --ignore="venv" --ignore="node_modules" --ignore="__pycache__" --ignore=".pytest_cache"
  --ignore=".mypy_cache" --ignore=".ruff_cache" --ignore="*.pyc" --ignore="*.pyo" --ignore="*.egg-info" --ignore=".eggs" --ignore="*.db-shm"
  --ignore="*.db-wal" --ignore="*.db-journal" --ignore=".git" --ignore=".DS_Store" --ignore="Thumbs.db" --ignore="*.swp" --ignore="*.swo"
  --ignore="*~" --ignore=".idea" --ignore="*.log" --ignore="dist" --ignore="build" --ignore="target" --ignore=".tox" --ignore=".nox"
  --ignore=".coverage" --ignore="htmlcov" --ignore=".cache" --ignore="*.so" --ignore="*.dylib"'



## Set vim keybindings in terminal
bindkey -v
# Change cursor shape for different vi modes
zle-keymap-select() {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[2 q'  # Block cursor
  else
    echo -ne '\e[6 q'  # Beam cursor
  fi
}
zle -N zle-keymap-select

# Start with beam cursor
zle-line-init() {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

bindkey '^H' backward-delete-char   # Ctrl+H (alternate backspace)
bindkey '^W' backward-kill-word     # Ctrl+W to delete word
bindkey '^U' backward-kill-line     # Ctrl+U to delete to start of line
bindkey '^?' backward-delete-char
