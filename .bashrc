# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Shell options
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# append to the history file, don't overwrite it
shopt -s histappend

# Set shell as vi mode
set -o vi

# Load dotfiles
# .path for extending PATHs
# .aliases for adding command aliases
# .exports for exporting settings
# .extra for additional settings
for file in  ".exports" ".path" ".aliases" ".extra" ; do
 source "$HOME/$file"
done;
unset file;

# shell prompt setting
# Customize shell prompt
source $HOME/dotfiles/.bash_prompt_color.sh
source $HOME/dotfiles/.git-prompt.sh
PS1="\[$Red\]\t\[$White\]-\[$Blue\]\u\[$Yellow\]\[$Yellow\]\w\[\033[m\]\[$White\]\$(__git_ps1)\[$White\]\n\$ "

if [ -f $HOME/.local_bashrc ]; then
    source $HOME/.local_bashrc
fi
