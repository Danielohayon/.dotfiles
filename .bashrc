
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend


# HISTTIMEFORMAT="%F %T "
export HISTTIMEFORMAT='%d/%m %H:%M '



# -- Premade Init:

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# Add kubectl shortcuts
alias k=kubectl
complete -o default -F __start_kubectl k
# kubectl auto completion
source <(kubectl completion bash)
if ! command -v hl-smi &> /dev/null
then
    source ~/.virtualenvs/vm/bin/activate
fi

# fzf initialization:
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


export OPENAI_API_KEY=""


#Attempt to fix yanking problem in tmux 
export DISPLAY=:0

export HF_HOME=""
# Mount Workdisk
if [ ! $(ls -l /mnt/workdisk | wc -l) -gt 1 ]; then
    echo "mounting workdisk"
    # sudo mount <fill> /mnt/workdisk
fi

# Zoxide setup 
eval "$(zoxide init bash)"
alias cd='z'


# Add tree view when itterating over directories
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

# A better watch that By aliasing watch itself, as alias watchh='watch ' (with a trailing space) and then using watchh gpu, you force the current interactive shell to expand gpu before it's passed to watch.
alias watchh='watch '

