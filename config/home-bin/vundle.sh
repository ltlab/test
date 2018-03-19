#!/bin/sh

PLUGIN_URL="https://github.com/VundleVim/Vundle.vim.git"
PLUGIN_PATH="~/.vim/bundle/Vundle.vim"

if [ ! -e "$PLUGIN_PATH" ] ; then
	git clone $PLUGIN_URL $PLUGIN_PATH
fi
