#!/bin/sh

PLUGIN_URL="https://github.com/VundleVim/Vundle.vim.git"

if [ -z "$1" ] ; then
	HOME_PATH="$HOME"
	PLUGIN_PATH="$HOME/.vim/bundle/Vundle.vim"
else
	HOME_PATH="$1"
	PLUGIN_PATH="$1/.vim/bundle/Vundle.vim"
fi

if [ ! -e "$PLUGIN_PATH" ] ; then
	git clone $PLUGIN_URL $PLUGIN_PATH
fi
