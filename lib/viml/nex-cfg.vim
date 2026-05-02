
function! s:NxConfig()
	let tmpa = expand('$USER')
	if tmpa == ""
		let tmpa = expand('$LOGNAME'),
	endif
	let g:nex.user = tmpa

	let tmpa = expand('$NEXUS_ENV')
	if tmpa != g:null && g:nex.user != g:null
		let g:nex_src.run = tmpa . '/run/' . g:nex.user . '/'
		let g:nex_src.log = tmpa . '/log/' . g:nex.user . '/'
		call NxContainer(g:nex_src.run, g:nex_src.log)
		if has('persistent_undo')
			let g:nex_src.vim.undo = g:nex_src.run . 'undo'
			call NxContainer(g:nex_src.vim.undo)
			set undodir=g:nex_src.vim.undo
			set undofile
		endif
	endif

	set number textwidth=0 encoding=utf-8
	set incsearch hlsearch
	set tabstop=8 softtabstop=0 shiftwidth=8
	set noexpandtab autoindent cindent smartindent
	behave xterm
	set pastetoggle=<F3>
	set ruler laststatus=2 showcmd showmode
	set fileformat=unix
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set breakindent
	set magic
	set title
	set hidden
	set history=10000
	set nowrap
	set belloff=all
	filetype detect
	syntax enable
	if has("termguicolors")
		set termguicolors
	endif
	set background=dark
	filetype indent on

	let g:vimtex_disable_autoload = 1
	let g:emmet_leader_key = '<C-e>'
endfunction

call s:NxConfig()

