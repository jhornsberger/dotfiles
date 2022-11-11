# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jeff/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/jeff/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jeff/linuxbrew/.linuxbrew/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/jeff/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.bash"
