#!/bin/sh

#USE_VUNDLE=1

# vim-plug
PLUG_PLUGIN_PATH=".vim/plugged"

if [ ! -z "$USE_VUNDLE" ] ; then
  PLUGIN_URL="https://github.com/VundleVim/Vundle.vim.git"
  PLUGIN_PATH=".vim/bundle"
  PLUGIN_INSTALL="+PluginInstall"
else
  PLUGIN_PATH=${PLUG_PLUGIN_PATH}
  PLUGIN_INSTALL="+PlugInstall"
fi

if [ -z "$1" ] ; then
	HOME_PATH="$HOME"
else
	HOME_PATH="$1"
fi

PLUGIN_FULL_PATH="${HOME_PATH}/${PLUGIN_PATH}/Vundle.vim"
HIGHLIGHT_PLUGIN_PATH="${HOME_PATH}/${PLUGIN_PATH}/vim-cpp-enhanced-highlight/"

if [ ! -e "$PLUGIN_URL" ] ; then
	git clone "$PLUGIN_URL" "$PLUGIN_FULL_PATH"
fi

if [ ! -d "$HOME_PATH/.fzf" ] ; then
  echo "[FZF] Clone and install fzf."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

vim $PLUGIN_INSTALL +qall

# patch for syntax Highlighting
C_VIM_FILE="$HIGHLIGHT_PLUGIN_PATH/after/syntax/c.vim"
CPP_VIM_FILE="$HIGHLIGHT_PLUGIN_PATH/after/syntax/cpp.vim"

if [ ! -z "$(grep Macro $C_VIM_FILE)" ] ; then
	echo "[VIM] Syntax files are already updated."
	exit 0
fi

#	vim c/c++ syntax...
echo "C_VIM_FILE: $C_VIM_FILE"
cat << EOF >> $C_VIM_FILE
" Delimiters
syn match cDelimiter    "[();\\\\]"
" foldmethod=syntax fix, courtesy of Ivan Freitas
syn match cBraces display "[{}]"

" Links
hi def link cDelimiter Delimiter
" foldmethod=syntax fix, courtesy of Ivan Freitas
hi def link cBraces Delimiter

"	Macro Function by jyhuh
"	Paste this code to ~/.vim/bundle/vim-cpp-enhanced.../syntax/c.vim
syn match cOperator	"[.!~*&%<>^|=,+-]"
syn match       cMacro           display "\<\u[[:upper:][:digit:]_]*\s*("me=e-1
hi def link cMacro		Macro

"	Comment Highlighting"
syn keyword cTodo		contained NOTE INFO DEBUG ERROR FATAL
hi def link cppSTLnamespace		cppStatement
"hi def link cppSTLtype			cppType
EOF

echo "CPP_VIM_FILE: $CPP_VIM_FILE"
cat << EOF >> $CPP_VIM_FILE
syn match       cppMacro           display "\<\u[[:upper:][:digit:]_]*\s*("me=e-1
hi def link cppMacro		Macro
EOF
