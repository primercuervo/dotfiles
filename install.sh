#!/bin/sh
# Author: Nicolas Cuervo
# Based on install files from thoughtbot and a diversity of contributers

set -e

#Using formatting for print statements. For this I use the ANSI escape codes.
#you can choose different formatting of choice.

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
#Bold         1m       Underline     4m
#Blink        5m       Revers color  7m
#Dim          2m       Hidden        8m
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
GREEN='\033[0;32m'
END='\033[0m'

fancy_echo(){
  printf "${BLUE}${BOLD}\n%b\n${END}" "$1"
}

warning_echo(){
  printf "${YELLOW}\n%b\n${END}" "$1"
}

done_echo(){
  printf "${GREEN}${BOLD}\n%b\n${END}" "$1"
}
# Checks if the file exists. If yes, deletes it
delete_files(){
    if [ -f "$1" ]; then
        warning_echo "Removing $1"
        rm "$1"
    fi
}

inst(){
  if [ -f /etc/lsb-release ]; then
      sudo aptitude install -y "$1"
  elif [ -f /etc/redhat-release ]; then
      sudo dnf install -y "$1"
  else
      warning_echo "Your OS distribution is not yet supported by this script"
  fi
}

fedora_warning(){
  if [ -f /etc/redhat-release ]; then
      warning_echo "$1"
  fi
}

create_dir(){
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

fancy_echo "Updating system packages ..."
if command -v aptitude >/dev/null; then
    fancy_echo "Using aptitude ..."
else
    if [ -f /etc/lsb-release ]; then
      warning_echo "Ubuntu detected!"
      warning_echo "Installing aptitude ..."
      sudo apt-get install -y aptitude
      sudo aptitude -y update
      fancy_echo "Installing basic dependencies needed further in the process..."
      inst build-essential
      inst libcppunit-dev
      inst libcppunit-doc
      inst python-requests
      inst python-apt
      inst python3-pyqt4
      inst python3-tk
      inst exuberant-ctags
      inst shellcheck
    elif [ -f /etc/redhat-release ]; then
      warning_echo "Fedora Detected! Using dnf ..."
      sudo dnf -y update
      fancy_echo "Installing basic dependencies needed further in the process..."
      inst python-devel
      inst python3-PyQt4
      inst cppunit-devel
      inst gcc-c++
      inst ctags
      inst ShellCheck
      inst util-linux-user
    fi
fi

fancy_echo "Installing python-lxml"
  inst python-lxml

fancy_echo "Installing cpufrequtils ..."
  inst cpufrequtils

fancy_echo "Installing git ..."
  inst git

fancy_echo "Installing gitk ..."
  inst gitk

fancy_echo "Installing vim ..."
  inst vim

fancy_echo "Installing curl ..."
  inst curl

fancy_echo "Installing zsh ..."
  inst zsh

fancy_echo "Installing meld ..."
  inst meld

fancy_echo "Installing gdb ..."
  inst gdb

fancy_echo "Installing htop ..."
  inst htop

fancy_echo "Installing cmake ..."
  inst cmake

fancy_echo "Installing bpython ..."
  inst bpython

fancy_echo "Installing shutter ..."
  fedora_warning "This application is known not to work well in Fedora. It will be installed anyways..."
  inst shutter

fancy_echo "Setting up custom vim configuration ..."
  if [ -d ~/.vim ]; then
    warning_echo ".vim found! Creating backup file."
    if [ -d ~/.vim.bak ]; then
        rm -rf ~/.vim.bak
    fi
    mv ~/.vim ~/.vim.bak
  fi

  if [ -h ~/.vimrc ]; then
    warning_echo ".vimrc found! Creating backup file."
    if [ -h ~/.vimrc.bak ]; then
        rm ~/.vimrc.bak
    fi
    mv ~/.vimrc ~/.vimrc.bak
  fi

  git clone https://github.com/primercuervo/vimfiles ~/.vim
  ln -s ~/.vim/vimrc ~/.vimrc
  sh ~/.vim/install.sh

fancy_echo "Creating vim working directories..."
  create_dir ~/.backup
  create_dir ~/.swp
  create_dir ~/.undo

fancy_echo "Retrieving external fonts for Airline..."
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  create_dir ~/.config/fontconfig/conf.d/
  create_dir ~/.fonts/
  mv PowerlineSymbols.otf ~/.fonts/
  mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

fancy_echo "Installing Adobe-fonts needed for Powerline9k..."
  if [ ! -d ~/.fonts/adobe-fonts/source-code-pro ]; then
    git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro
  fi
  fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro

fancy_echo "Installing tmux ..."
  inst tmux

fancy_echo "Swapping ESC and Capslock ..."
  dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"

silver_searcher_from_source() {
    git clone git://github.com/ggreer/the_silver_searcher.git /tmp/the_silver_searcher
    inst automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    sh /tmp/the_silver_searcher/build.sh
    cd /tmp/the_silver_searcher
    sh build.sh
    sudo make install
    cd
    rm -rf /tmp/the_silver_searcher
}

fancy_echo "Installing The Silver Searcher ..."
if [ -f /etc/lsb-release ]; then
  if aptitude show silversearcher-ag &>/dev/null; then
    sudo aptitude install -y silversearcher-ag
  else
    silver_searcher_from_source
  fi
elif [ -f /etc/redhat-release ]; then
  sudo dnf install -y the_silver_searcher
fi

fancy_echo "Installing oh my zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/primercuervo/oh-my-zsh/master/tools/install.sh)"

fancy_echo "Installing Powerline9k for Oh-My-ZSH..."
  if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  fi

fancy_echo "Installing pip..."
  inst python-pip python-dev build-essential

fancy_echo "Installing pip..."
  inst python3-pip

fancy_echo "Updating setuptools ..."
  sudo pip install --upgrade setuptools

fancy_echo "Installing pylint ..."
  sudo pip install --upgrade pylint

fancy_echo "Installing pylint3 ..."
  sudo pip3 install --upgrade pylint

fancy_echo "Installing Awesome Terminal fonts for Powerlevel9k..."
  if [ ! -d ~/.awesome_fonts ]; then
    git clone https://github.com/gabrielelana/awesome-terminal-fonts.git ~/.awesome_fonts
  fi
  cp ~/.awesome_fonts/build/* ~/.fonts
  fc-cache -fv ~/.fonts
  cp ~/.awesome_fonts/config/10-symbols.conf ~/.config/fontconfig/conf.d/

fancy_echo "Installing dotfiles..."
fancy_echo "Checking current dotfile directory..."
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update dotfiles itself first
fancy_echo "Updating dotfiles from git..."
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

fancy_echo "Backing up current dotfiles, if any..."
delete_files ~/.bashrc
delete_files ~/.gitconfig
delete_files ~/.gitignore_global
delete_files ~/.zshrc
delete_files ~/.alias
delete_files ~/.pylintrc

fancy_echo "Generating symbolic links..."
ln -sfv "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
ln -sfv "$DOTFILES_DIR/git/gitignore_global" ~/.gitignore_global
ln -sfv "$DOTFILES_DIR/home/bashrc" ~/.bashrc
ln -sfv "$DOTFILES_DIR/home/zshrc" ~/.zshrc
ln -sfv "$DOTFILES_DIR/system/alias" ~/.alias
ln -sfv "$DOTFILES_DIR/system/pylintrc" ~/.pylintrc

fancy_echo "Changing main shell to zsh ..."
  chsh -s "$(which zsh)"

fedora_warning "Bpython seems to complain about integer import,
and that has to do with requests. In order to solve that, uninstall pip
requests with pip and install again with RPM

sudo pip uninstall requests
sudo dnf install -y python2-requests"

fancy_echo "Installing clang-6 for YCM ..."
  sudo apt-get remove libclang*
  inst clang-6.0
  inst clant-format-6.0
  sudo update-alternatives --remove-all clang
  sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 90 --slave /usr/bin/clang++ clang++ /usr/bin/gclang++-6.0
  sudo update-alternatives --remove-all clang-format
  sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-6.0 90

fancy_echo "Updating gcc to a newer version..."
# http://tuxamito.com/wiki/index.php/Installing_newer_GCC_versions_in_Ubuntu
  sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
  sudo apt-get update
  inst gcc g++ gcc-5 g++-5 gcc-6 g++-6 gcc-7 g++-7
  sudo update-alternatives --remove-all gcc
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 90 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 80 --slave /usr/bin/g++ g++ /usr/bin/g++-6
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7
  sudo update-alternatives --set gcc /usr/bin/gcc-7

fancy_echo "Setting up  clang completer for you-complete-me"
  ~/.vim/bundle/YouCompleteMe/install.py --clang-completer --system-libclang

unset BLUE BOLD YELLOW DOTFILES_DIR

done_echo "Done!"
