#!/usr/bin/env bash
# Author: Nicolas Cuervo

# if not running interactively, do nothing

[ -z "$PS1" ] && return

# resolve DOTFILES_DIR


READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
    DOTFILES_DIR=$(dirname "(dirname "$SCRIPT_PATH")")
elif [-d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return # exit 1 would quit the shell itself
fi

# Source dotfiles - Order matters

for DOTFILE in "$DOTFILES_DIR"/system/.{function,alias}; do
    [ -f "$DOTFILE"] && . "$DOTFILE"
done

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

export DOTFILES_DIR
