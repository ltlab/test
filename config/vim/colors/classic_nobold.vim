set bg=dark
let colors_name = "classic"
hi clear

"hi Normal         guifg=Grey80  guibg=black

"hi SpecialKey     guifg=#666666
"hi NonText        guifg=#666666
"hi Directory      guifg=#99FFFF
"hi ErrorMsg       guifg=#FFFFFF guibg=#FF9999
"hi IncSearch      gui=reverse
"hi Search         guifg=#000000 guibg=#999933
"hi MoreMsg        guifg=#99FF99
"hi LineNr         guifg=#FFFF99 guibg=DarkCyan
"hi Question       guifg=#99FF99
"highlight StatusLine guifg=blue		guibg=yellow
"hi StatusLineNC   gui=reverse
"hi VertSplit      gui=reverse
"hi Title          guifg=#FF99FF
"hi Visual         gui=reverse
"hi VisualNOS      gui=underline
"hi WarningMsg     guifg=#FF9999
"hi WildMenu       guifg=#000000 guibg=#999933
"hi Folded         guifg=#99FFFF guibg=#666666
"hi FoldColumn     guifg=#99FFFF guibg=#666666
"hi DiffAdd        guibg=#9999FF
"hi DiffChange     guibg=#FF99FF

highlight Normal     ctermfg=LightGrey	ctermbg=Black guifg=lightgrey guibg=#000010

hi	Visual			cterm=none ctermbg=17 gui=none guibg=#000050
hi	Search			ctermbg=brown gui=none guibg=#ac6600
hi LineNr         ctermfg=darkgreen guifg=#009700
hi DiffDelete     term=bold guifg=#9999FF guibg=#99FFFF
hi DiffText       term=reverse guibg=#FF9999
"hi Comment        term=bold guifg=#99FFFF
hi Comment        term=bold ctermfg=darkcyan guifg=#1ca4a4
hi Constant       term=underline guifg=magenta
"hi Special        term=bold guifg=#FF9999
hi Special        term=bold cterm=bold ctermfg=red guifg=red
"hi Identifier     term=underline guifg=#99FFFF
hi Statement      term=bold gui=none guifg=yellow
hi	cStatement		ctermfg=lightyellow guifg=#ffffc0
hi Type           term=underline  ctermfg=green gui=none guifg=green
"hi Underlined     term=underline gui=underline guifg=#9999FF
"hi Ignore         guifg=#000000
"hi Error          term=reverse guifg=#FFFFFF guibg=#FF9999
"hi Todo           term=standout guifg=#000000 guibg=#999933
highlight StatusLine cterm=reverse,bold ctermfg=darkblue	ctermbg=yellow gui=reverse,bold guifg=darkblue guibg=yellow
hi Title          cterm=bold ctermfg=Magenta gui=bold guifg=magenta
hi	Label			ctermfg=brown guifg=#ac6600
hi cIncluded      ctermfg=red guifg=red
hi	cPPIncludeFile	ctermfg=red guifg=red
hi cConstant		ctermfg=red  guifg=red
hi	Structure		ctermfg=lightgreen guifg=lightgreen
hi	StorageClass	ctermfg=lightgreen guifg=lightgreen
hi SpecialChar    ctermfg=red guifg=red
hi	cIdentifier		ctermfg=lightgrey guifg=grey60
hi	cOperator		ctermfg=216 guifg=#ff8360
hi	cSizeofOperator	ctermfg=red guifg=red
hi	Boolean			ctermfg=red guifg=red
hi	Function		cterm=none ctermfg=white guifg=white
hi PreProc        term=underline ctermfg=blue guifg=#6060ff
hi PreCondit		ctermfg=cyan guifg=#1ca4a4
hi	cPPOperator		ctermfg=cyan guifg=#1ca4a4
"hi	WarningMsg		ctermfg=darkred
hi	ModeMsg			ctermfg=red guifg=red
hi	TagListTagname	cterm=bold ctermfg=yellow ctermbg=darkred gui=bold guifg=yellow guibg=darkred
hi	MatchParen		ctermfg=yellow ctermbg=blue guifg=yellow guibg=blue
hi	Folded			ctermfg=yellow ctermbg=22 guifg=yellow guibg=#326400

"hi	def	link	cOctalZero	cOctal
