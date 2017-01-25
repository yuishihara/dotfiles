# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# Load dotfiles
# .path for extending PATHs
# .aliases for adding command aliases
# .exports for exporting settings
# .extra for additional settings
for file in ".path" ".aliases" ".exports" ".extra" ; do
 source "$HOME/$file"
done;
unset file;
