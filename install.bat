@echo off
set TARGET_DIRECTORY=%HOMEPATH%"\dotfiles"
set BUNDLE_DIRECTORY=%TARGET_DIRECTORY%"\CustomVimFiles\.vim\bundle"

if not exist %TARGET_DIRECTORY% (
    cd %HOMEPATH%
    git clone https://github.com/yuishihara/dotfiles.git
)

mklink %HOMEPATH%"\.vimrc" %TARGET_DIRECTORY%"\CustomVimFiles\.vimrc"
mklink /D %HOMEPATH%"\.vim" %TARGET_DIRECTORY%"\CustomVimFiles\.vim"
mkdir %BUNDLE_DIRECTORY%

echo "DOWNLOADING NEOBUNDLE"
if exist %BUNDLE_DIRECTORY% (
    cd %BUNDLE_DIRECTORY%
    git clone https://github.com/Shougo/neobundle.vim.git
) else (
    echo "NO BUNDLE DIRECTORY FOUND"
)

pause
