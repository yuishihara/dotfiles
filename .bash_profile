# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$PATH:$HOME/bin"
fi

# Load dotfiles
# .path for extending PATHs
# .aliases for adding command aliases
# .exports for exporting settings
# .extra for additional settings
for file in ".exports" ".path" ".aliases" ".extra" ; do
 source "$HOME/$file"
done;
unset file;

OS=$(uname)
# Always load .bashrc on mac
if [ $OS = "Darwin" ]; then
    source $HOME/.bashrc
fi

