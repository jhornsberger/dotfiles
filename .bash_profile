# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/.local/bin:$HOME/bin
export TZ='America/Vancouver'

if [ -e /home/jeff/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jeff/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
