# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/.local/bin:$HOME/bin
export TZ='America/Vancouver'
export TZDIR=/usr/share/zoneinfo

if [ -e /home/jeff/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jeff/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
