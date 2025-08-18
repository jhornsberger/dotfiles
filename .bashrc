# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# nix configuration
if [[ $- == *i* ]]; then  # check if interactive shell
   export XDG_CONFIG_HOME="$HOME/.config"
   if [ -x "$HOME/bin/nix-enter" ]; then
      if [ ! -e /nix/var/nix/profiles ] && [ -z ${NIX_ENTER} ]; then
         export NIX_ENTER="TRUE"
         exec "$HOME/bin/nix-enter"
      fi
   fi
   if [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
   fi
   if [[ -z ${BASH_EXECUTION_STRING} && -t 1 && -f ~/.local/bin/fish && $(realpath ~/.local/bin/fish) && $(readlink -f /proc/$$/exe) != *nix* ]]; then
      export SHELL=~/.local/bin/fish
      exec ~/.local/bin/fish
   fi
   if [[ -z ${BASH_EXECUTION_STRING} && -t 1 && -x /opt/homebrew/bin/fish ]]; then
      export SHELL=/opt/homebrew/bin/fish
      exec /opt/homebrew/bin/fish
   fi
fi

# User specific aliases and functions
# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi

if [ -z ${ARTOOLS_NOPROMPTMUNGE} ] && [[ $- == *i* ]]; then  # check if interactive shell
   export HISTSIZE=50000
   export HISTCONTROL=ignoreboth:erasedups
   shopt -s histappend
   PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

   unset VISUAL
   export PATH=$HOME/.local/bin:$PATH
   export TZ='America/Vancouver'
   export TZDIR=/usr/share/zoneinfo
   export EDITOR=nvim
   export P4MERGE=amergeVim
   export NOTI_PB=o.xXcIRDklt4berjLHFbbiwOe7f8QjRDml
   export P4_AUTO_LOGIN=1
   export SKIPTACGO=1

   if [ -n "${NVIM}" ] && [ -x "$(command -v nvr)" ]; then
      EDITOR="nvr --servername ${NVIM} --remote-wait +'set bufhidden=wipe'"
      alias nvim=${EDITOR}
   fi
fi

# Colors
if [ -x "$(command -v dircolors)" ]; then
   eval `dircolors ~/.dircolors`
fi

# Aliases
alias vi='nvim -u NONE'
alias pb='curl -F c=@- pb'
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Functions
newdir() {
   mkdir -p "$1"
   echo -n "$1"
}

# Fzf
export FZF_DEFAULT_OPTS="
  --ansi
  --color light
  --bind alt-a:select-all
  --bind alt-p:toggle-preview
  --height 50%
"
export RIPGREP_CONFIG_PATH=~/.ripgreprc

if command -v fzf >/dev/null; then
  eval "$(fzf --bash)"
fi
