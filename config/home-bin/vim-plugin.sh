#!/bin/sh

PLUGIN_URL="https://github.com/VundleVim/Vundle.vim.git"

if [ -z "$1" ] ; then
	HOME_PATH="$HOME"
	PLUGIN_PATH="$HOME/.vim/bundle/Vundle.vim"
	HIGHLIGHT_PLUGIN_PATH="$HOME/.vim/bundle/vim-cpp-enhanced-highlight/"
else
	HOME_PATH="$1"
	PLUGIN_PATH="$1/.vim/bundle/Vundle.vim"
	HIGHLIGHT_PLUGIN_PATH="$1/.vim/bundle/vim-cpp-enhanced-highlight"
fi

if [ ! -e "$PLUGIN_PATH" ] ; then
	git clone $PLUGIN_URL $PLUGIN_PATH
fi

vim +PluginInstall +qall

C_VIM_FILE="$HIGHLIGHT_PLUGIN_PATH/after/syntax/c.vim"
CPP_VIM_FILE="$HIGHLIGHT_PLUGIN_PATH/after/syntax/cpp.vim"

if [ ! -z "`grep Macro $C_VIM_FILE`" ] ; then
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
