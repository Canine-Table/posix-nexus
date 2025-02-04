function! Main()
	filetype plugin indent on
	set number textwidth=0 encoding=utf-8
	set incsearch ignorecase smartcase hlsearch
	set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab autoindent
	set ruler laststatus=2 showcmd showmode
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set wrap breakindent
	set title
	set hidden
	set belloff=all
	call CallFile(
		\ 'types.vim',
		\ 'str.vim',
		\ 'LaTeX.vim',
		\ 'mappings.vim',
		\ 'plugins.vim',
		\ 'misc.vim',
		\ 'snippets.vim',
	\)
	call SetupPlugins()
	call ColorTheme()
endfunction

function! CallFile(...)
	if ! exists('g:nex_mod_viml') && exists(getenv($G_NEX_MOD_LIB))
		let l:tmpa = $G_NEX_MOD_LIB . "/viml"
		if isdirectory(l:tmpa)
			let g:nex_mod_viml = l:tmpa . "/"
		endif
		unlet! l:tmpa
	endif
	for a in a:000
		if filereadable(a)
			execute "source " . a
		elseif exists('g:nex_mod_viml') && filereadable(g:nex_mod_viml . a)
			execute "source " . g:nex_mod_viml . a
		endif
	endfor
endfunction

function! SetupPlugins()
	let l:tmpa = glob('~/.local/share/nvim/site/autoload/plug.vim')
	if filereadable(l:tmpa)
		unlet! l:tmpa
		silent !mkdir -p ~/.config/nvim/plugged
		call CallFile("plugins.vim")
	else
		silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		PlugInstall
	endif
endfunction

function! ColorTheme()
	try
		colorscheme dracula
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme industry
	endtry
endfunction

call Main()

