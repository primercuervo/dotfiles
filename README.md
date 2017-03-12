#dotfiles#
Setting up files to automate my custom settings.

#Install.sh script#
This script runs the whole configuration I need in a new machine to start working
right away. If you want to use it, feel free to do so, but DO IT UNDER YOUR OWN RESPONSIBILITY!

Please be sure that you need the whole configuration that the script is providing you,
or just use it as an example to automate your own process!

The script has been tested on Ubuntu 14.04, Ubuntu 16.04 and Fedora 25. (which are the OS I'm using currently)

##What does this script do?##
Basically it does all the work for me on a new machine and lets it ready for me to start working
- Updates system packages
- Installs some dependencies for stuff that needs to be installed further up in the process
- Installs stuff that I need in my day-by-day work, such as:
    - cpufrequtils
    - git
    - gitk
    - vim
    - exuberant-ctags
    - curl
    - zsh
    - meld
    - pylint
    - gbd
    - htop
    - cmake
    - Shutter
    - oh-my-zsh
    - tmux
    - the silver searcher
    - python-pip
- Downloads and installs my custom VIM configuration: https://github.com/primercuervo/vimfiles
- Downloads and installs fonts for vim-airline and Powerlevel9k
- Swaps the ESC and capslock keys
- Downloads and sets my custom dotfiles for bash, git and zshrc
- Changes the main shell to zsh

#"It ain't working!"#
    ¯\_(ツ)_/¯ It works on my machine!

However please feel free to report any problems or suggest improvements!

