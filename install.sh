#!/bin/bash
######### ######## ######## ######## ######## ######## ######## ########
##    ### #####    ###      ##       ###      ###   ## ##       ####
##  #  ## ###   ## ######   ##   ### ######   ###   ## ##   ### ###   ##
##  ##  # ##   ### ######   ##       ######   ###   ## ##       ####
##  ##  # ##   ### ######   ##   ### ######   ###   ## ##   ### ########
##  #  ## ###   ## ######   ##   ### ######   ###   ## ##   ### ###   ##
##    ### #####    ######   ##   ### ###      ###      ##       ####
######### ######## ######## ######## ######## ######## ######## ########

# Variable definitions
DOTFILES_PATH=${HOME}/dotfiles
case $(uname) in
    Linux)
        echo "This is an linux environment. Setting up for linux"
        OS=linux
        ;;
    Darwin)
        echo "This is an mac os environment. Setting up for mac"
        OS=mac
        ;;
esac
# End variable definitions

function command_exists () {
hash $1 2>/dev/null
return $?
}

function should_exclude () {
for f in ".git" ".DS_Store" ".gitignore" ".gitconfig" ; do
    if [ $f = $1 ]; then
        return 0
    fi
done
for f in ".swp" ".swo" ; do
    if [[ $1 == *"$f"* ]]; then
        return 0
    fi
done
return 1
}

function link_all () {
cd $1
for file in .??*; do
    if should_exclude ${file} ; then
        continue
    fi
    echo "making symbolic link: ${HOME}/${file} -> $1/${file}"
    ln -si $1/${file} ${HOME}/${file}
done
}

function general_installation () {
if [ -d ${DOTFILES_PATH} ]; then
    echo "Dotfiles are alredy cloned"
else
    echo "Cloning dotfiles from github"
    cd $HOME
    $(git clone https://github.com/yuishihara/dotfiles.git)
fi

link_all ${DOTFILES_PATH}
BUNDLE_PATH=${HOME}/.vim/bundle
NEOBUNDLE_PATH=${BUNDLE_PATH}/neobundle.vim
if ! [ -e ${BUNDLE_PATH} ]; then
    mkdir -p ${BUNDLE_PATH}
    cd ${BUNDLE_PATH}
    if ! [ -e ${NEOBUNDLE_PATH} ]; then
        echo "Downloading neobundle"
        $(git clone https://github.com/Shougo/neobundle.vim.git)
    fi
fi

PYENV_PATH=${HOME}/.pyenv
if ! [ -e ${PYENV_PATH} ]; then
    cd ${HOME}
    $(git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv)
fi
}

function linux_installation () {
link_all ${DOTFILES_PATH}/${OS}
}

function mac_installation () {
if ! $(command_exists brew) ; then
    echo "installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if [ ! -f /usr/local/etc/bash_completion ]; then
    $(brew install bash_completion)
fi
echo "installing homebrew"
link_all ${DOTFILES_PATH}/${OS}
}

# Check git installed
if ! $(command_exists git) ; then
    echo "Please install git before proceeding installation"
    exit
fi

# Start installation
echo "Start installing dotfiles"

general_installation
case ${OS} in
    linux)
        linux_installation
        ;;
    mac)
        mac_installation
        ;;
esac

echo "Complete installing dotfiles"
# End installation
