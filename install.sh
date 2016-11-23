#!/usr/bin/env bash
# Author: Nicolas Cuervo
# Based on install files from thoughtbot and a diversity of contributers

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >2; exit $ret' EXIT

set -e

fancy_echo(){
  printf "\n%b\n" "$1"
}

fancy_echo "Updating system packages ..."
if command -v aptitude >/dev/null; then
    fancy_echo "Using aptitude ..."
else
    fancy_echo "Installing aptitude ..."
    sudo apt-get install -y aptitude
fi

sudo aptitude update

fancy_echo "Installing vim ..."
  sudo aptitude install -y vim-gtk

fancy_echo "Installing curl ..."
  sudo aptitude install -y curl

fancy_echo "Installing zsh ..."
  sudo aptitude install -y zsh

silver_searcher_from_source() {
    git clone git://github.com/ggreer/the_silver_searcher.git /tmp/the_silver_searcher
    sudo aptitude install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    sh /tmp/the_silver_searcher/build.sh
    cd /tmp/the_silver_searcher
    sh build.sh
    sudo make install
    cd
    rm -rf /tmp/the_silver_searcher
}

if ! command -v ag >/dev/null; then
    fancy_echo "Installing The Silver Searcher ..."
    if aptitude show silversearcher-ag &>/dev/null; then
        sudo aptitude install silversearcher-ag
    else
        silver_searcher_from_source
    fi
fi

fancy_echo "Installing GitHub CLI client ..."
  if [[ ! -d "$HOME/.bin/" ]]; then
    mkdir "$HOME/.bin"
  fi
  curl http://hub.github.com/standalone -sLo ~/.bin/hub
  chmod +x ~/.bin/hub


fancy_echo "Installing dotfiles..."
fancy_echo "Checking current directory..."
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update dotfiles itself first
fancy_echo "Updating dotfiles from git..."
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

fancy_echo "Deleting current dotfiles"
rm ~/.bashrc ~/.bash_profile ~/.gitconfig ~/.gitignore_global

fancy_echo "Generating symbolic links..."
ln -sfv "$DOTFILES_DIR/home/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/home/.bashrc" ~

#fancy_echo "Sourcing .bashrc"
#source ~/.bashrc

fancy_echo "Changing main shell to zsh ..."
  chsh -s $(which zsh)


fancy_echo "Done!"
