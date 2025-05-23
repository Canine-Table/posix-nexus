function! s:NxInit()
	filetype on
	filetype plugin on
	filetype indent on
	set number textwidth=0 encoding=utf-8
	set incsearch ignorecase smartcase hlsearch
	set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab autoindent
	set ruler laststatus=2 showcmd showmode
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set wrap breakindent
	set magic
	set verbose=1
	set title
	set hidden
	set history=10000
	set nowrap
	set belloff=all
	call NxCallFile(
		\ 'misc.vim',
		\ 'types.vim',
		\ 'TeX.vim',
		\ 'str.vim',
		\ 'xml.vim',
		\ 'mappings.vim',
	\)
	if NxBaseName(getenv('G_NEX_WEB_FETCH')) == 'curl'
		let g:nx_download_cmd = 'silent !curl -fLo '
		let g:nx_download_cmd_options = ' --create-dirs '
	elseif NxBaseName(getenv('G_NEX_WEB_FETCH')) == 'wget'
		let g:nx_download_cmd = 'silent !wget -O '
		let g:nx_download_cmd_options = ' '
	else
		echoerr 'Error: No curl or wget found.'
	endif
	if stridx($VIMRUNTIME, 'nvim') >= 0
		let g:nx_editor = 'nvim'
		call s:NxNeoVimInit()
		call NxCallFile('nex-nvim-init.lua')
	else
		if v:version < 900
			let g:nx_editor = 'vim'
		else
			let g:nx_editor = 'vim9'
		endif
		call s:NxVimInit()
	endif
	call NxPath({
		\ 'autoload/plug.vim': 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	\})
	call NxCallFile('plugins.vim', 'snippets.vim')
	call s:NxColorTheme()
endfunction

function! s:NxNeoVimInit()
	if empty(getenv('LOCALAPPDATA'))
		let g:nx_data_path = glob('~/local/.share/nvim/')
		let g:nx_config_path = glob('~/.config/nvim/')
		let g:nx_cache_path = glob('~/.cache/nvim/')
	else
		let g:nx_data_path = glob('~/AppData/Local/nvim/')
		let g:nx_config_path = glob('~/AppData/Local/nvim-data/')
		let g:nx_cache_path = glob('~/AppData/Local/nvim-cache/')
	endif
endfunction

function! s:NxVimInit()
	if empty(getenv('LOCALAPPDATA'))
		let g:nx_data_path = glob('~/.vim/')
		let g:nx_config_path = glob('~/.vim/')
		let g:nx_cache_path = glob('~/.vim/')
	else
		let g:nx_data_path = glob('~/vimfiles/')
		let g:nx_config_path = glob('~/vimfiles/')
		let g:nx_cache_path = glob('~/vimfiles/')
	endif
	call NxPath({
		\ 'colors/dracula.vim': 'https://raw.githubusercontent.com/dracula/vim/master/colors/dracula.vim',
	\})
endfunction

function! NxPath(args)
	for [key, val] in items(a:args)
		if ! filereadable(g:nx_config_path . key)
			execute l:nx_download_cmd . g:nx_config_path . key . l:nx_download_cmd_options . val
		endif
	endfor
endfunction

function! NxCallFile(...)
	if ! exists('g:nex_mod_viml') && ! empty(getenv('G_NEX_MOD_LIB'))
		let l:tmpa = expand(getenv('G_NEX_MOD_LIB'))
		if isdirectory(l:tmpa)
			let g:nex_mod_viml = getenv('G_NEX_MOD_LIB') . '/viml/'
			if ! isdirectory(g:nex_mod_viml)
				unlet! g:nex_mod_viml
			endif
			let g:nex_mod_lua = getenv('G_NEX_MOD_LIB') . '/lua/nvim/'
			if ! isdirectory(g:nex_mod_lua)
				unlet! g:nex_mod_lua
			endif
		endif
	endif
	for a in a:000
		if exists('g:nex_mod_viml') && filereadable(g:nex_mod_viml . a) && match(a, '\.vim$') >= 0
			execute 'source ' . g:nex_mod_viml . a
		elseif exists('g:nex_mod_lua') && filereadable(g:nex_mod_lua . a) && match(a, '\.lua$') >= 0
			execute 'luafile ' . g:nex_mod_lua . a
		elseif filereadable(a)
			if match(a, '\.vim$') >= 0
				execute 'source ' . a
			elseif match(a, '\.lua$') >= 0
				execute 'luafile ' . a
			endif
		endif
	endfor
endfunction

function! s:NxColorTheme()
	try
		colorscheme dracula-soft
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme dracula
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme nord
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme industry
	endtry
endfunction

call s:NxInit()

