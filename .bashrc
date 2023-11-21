# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# nix configuration
if [[ $- == *i* ]]; then  # check if interactive shell
   if [ -x "$HOME/bin/nix-enter" ]; then
      if [ ! -e /nix/var/nix/profiles ] || [ -z ${NIX_ENTER} ]; then
         export NIX_ENTER="TRUE"
         exec "$HOME/bin/nix-enter"
      fi
   fi
   if [[ -f ~/.local/bin/bash && $(realpath ~/.local/bin/bash) && $(readlink -f /proc/$$/exe) != *nix* ]]; then
      exec ~/.local/bin/bash
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
   export EDITOR=nvim
   export P4MERGE=amergeVim
   export NOTI_PB=o.xXcIRDklt4berjLHFbbiwOe7f8QjRDml
   export P4_AUTO_LOGIN=1
   export SKIPTACGO=1

   # Set bash prompt
   if [ -f ~/.local/share/liquidprompt ]; then
      . ~/.local/share/liquidprompt
   fi

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
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Comment and uncomment below for the light theme.

  ## Solarized Dark color scheme for fzf
  #export FZF_DEFAULT_OPTS="
  #  --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
  #  --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  #"
  # Solarized Light color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue,border:$base2
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
    --bind alt-a:select-all
    --bind alt-p:toggle-preview
    --height 50%
  "
}
_gen_fzf_default_opts
export FZF_DEFAULT_COMMAND='rg --files'
export RIPGREP_CONFIG_PATH=~/.ripgreprc

if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

