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
LOCAL_BIN_PATH=${HOME}/bin
SCRIPT_FILES_PATH=${DOTFILES_PATH}/scripts
PECO_DIRECTORY_NAME=peco_linux_386
PECO_ARCHIVE_NAME=${PECO_DIRECTORY_NAME}.tar.gz
PECO_LINUX_DOWNLOAD_URL=https://github.com/peco/peco/releases/download/v0.5.1/${PECO_ARCHIVE_NAME}
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
FILES="$1/*"
TARGET_DIRECTORY="$2"
if [ "$1" == "" ]; then
    echo "Base directory not specified"
fi
if [ "$2" == "" ]; then
    echo "Target directory not specified"
fi
cd $1
for file in ${FILES}; do
    file=$(basename ${file})
    TARGET_FILE=${TARGET_DIRECTORY}/${file}
    if [ -e ${TARGET_FILE} ] ; then
        echo "Symbolik link: ${TARGET_FILE} already exists"
        continue
    fi
    echo "making symbolic link: ${TARGET_FILE} -> $1/${file}"
    ln -si $1/${file} ${TARGET_FILE}
done
}

function link_all_dotfiles () {
TARGET_DIRECTORY=${HOME}
cd $1
for file in .??*; do
    if should_exclude ${file} ; then
        continue
    fi
    TARGET_FILE=${TARGET_DIRECTORY}/${file}
    if [ -e ${TARGET_FILE} ] ; then
        echo "Symbolik link: ${TARGET_FILE} already exists"
        continue
    fi
    echo "making symbolic link: ${TARGET_FILE} -> $1/${file}"
    ln -si $1/${file} ${TARGET_FILE}
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

link_all_dotfiles ${DOTFILES_PATH}
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
    $(git clone https://github.com/yyuu/pyenv.git ${PYENV_PATH})
    $(${PYENV_PATH}/bin/pyenv install anaconda3-4.3.0)
    $(${PYENV_PATH}/bin/pyenv rehash)
    $(${PYENV_PATH}/bin/pyenv global anaconda3-4.3.0)
fi

if ! $(command_exists adb-peco) ; then
    printf "sudo password: "
    read -s password
    echo "Installing adb-peco"
    echo ${password} | $(sudo -S gem install adb-peco)
fi

BASH_COMPLETION_DIR_PATH=${HOME}/bash_completion.d
GRADLE_BASH_COMPLETION_PATH=${BASH_COMPLETION_DIR_PATH}/gradle-tab-completion.bash
if ! [ -e ${GRADLE_BASH_COMPLETION_PATH} ] ; then
    mkdir -p ${BASH_COMPLETION_DIR_PATH}
    $(curl -LA gradle-completion https://edub.me/gradle-completion-bash -o ${GRADLE_BASH_COMPLETION_PATH})
fi

link_all ${SCRIPT_FILES_PATH} ${LOCAL_BIN_PATH}
}

function linux_installation () {
if ! [ -e ${LOCAL_BIN_PATH} ] ; then
    mkdir -p ${LOCAL_BIN_PATH}
fi
link_all_dotfiles ${DOTFILES_PATH}/${OS}
if ! $(command_exists peco) ; then
    cd ${HOME}
    echo "Downloading peco..."
    $(wget ${PECO_LINUX_DOWNLOAD_URL})
    echo "Installing peco..."
    $(tar xzvf ${PECO_ARCHIVE_NAME})
    cd ${HOME}/${PECO_DIRECTORY_NAME}
    mv peco ${HOME}/bin
    chmod +x ${HOME}/bin/peco
fi
# Change gtk key binds to emacs
gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
}

function mac_installation () {
if ! $(command_exists brew) ; then
    echo "installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if [ ! -f /usr/local/etc/bash_completion ]; then
    $(brew install bash_completion)
fi
if ! $(command_exists peco) ; then
    echo "installing peco"
    $(brew install peco)
    echo "finish installing peco"
fi
link_all_dotfiles ${DOTFILES_PATH}/${OS}
}

if ! $(command_exists gem) ; then
    echo "Please install gem before proceeding installation"
fi

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
