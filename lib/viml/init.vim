function! s:Main()
	filetype plugin indent on
	set number textwidth=0 encoding=utf-8
	set incsearch ignorecase smartcase hlsearch
	set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab autoindent
	set ruler laststatus=2 showcmd showmode
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set wrap breakindent
	set magic
	set title
	set hidden
	set history=10000
	set nowrap
	set belloff=all
	call s:CallFile(
		\ 'types.vim',
		\ 'str.vim',
		\ 'LaTeX.vim',
		\ 'xml.vim',
		\ 'mappings.vim',
		\ 'plugins.vim',
		\ 'misc.vim',
		\ 'snippets.vim',
	\)
	call s:SetupPlugins()
	call s:LoadInit()
	call s:ColorTheme()
endfunction

function! s:CallFile(...)
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
	endif,w
	for a in a:000
        	let l:file = expand(a)
		if exists('g:nex_mod_viml') && filereadable(g:nex_mod_viml . a) && match(a, '\.vim$') >= 0
			execute "source " . g:nex_mod_viml . a
		elseif exists('g:nex_mod_lua') && filereadable(g:nex_mod_lua . a) && match(a, '\.lua$') >= 0
			execute 'luafile ' . g:nex_mod_lua . a
		elseif filereadable(l:file)
			if match(a, '\.vim$') >= 0
				execute 'source ' . a
			elseif match(a, '\.lua$') >= 0
				execute 'luafile ' . a
			endif

		endif
	endfor
endfunction

function! s:LoadInit()
	if has('nvim')
		call s:CallFile('/lua/nvim/init.lua', expand(stdpath('config') . '/lua/nvim/init.lua'))
	endif
endfunction

function! s:SetupPlugins()
	let l:plug_path = glob(stdpath('data') . '/site/autoload/plug.vim')
	if filereadable(l:tmpa)
		call mkdir('~/.config/nvim/plugged', 'p')
		call s:CallFile('plugins.vim')
	else
		if has('curl')
			let l:download_cmd = 'curl -fLo '
			let l:options = '--create-dirs'
		elseif has('wget')
			let l:download_cmd = 'wget -O '
			let l:options = ''
		else
			echoerr 'Error: No curl or wget found.'
			return
		endif
		execute l:download_cmd . l:plug_path . ' ' . l:options . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		call s:CallFile('plugins.vim')
		execute 'PlugInstall'
	endif
endfunction

function! ColorTheme()
	try
		colorscheme dracula
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme industry
	endtry
endfunction

call s:Main()

