# if running bash
# include .bash_profile if it exists
if [ -f "$HOME/.bash_profile" ]; then
 source "$HOME/.bash_profile"
fi
if [ -n "$BASH_VERSION" ]; then
 # include .bashrc if it exists
 if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
 fi
fi
