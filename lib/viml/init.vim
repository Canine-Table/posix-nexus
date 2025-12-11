
function! s:NxVimInit()
	set number textwidth=0 encoding=utf-8
	set incsearch hlsearch
	"set ignorecase smartcase
	set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab autoindent
	set ruler laststatus=2 showcmd showmode
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set wrap breakindent
	set magic
	"set verbose=1
	set title
	set hidden
	set history=10000
	set nowrap
	set belloff=all
	if has("termguicolors")
		set termguicolors
	endif
	set background=dark
	call NxCallFile(
		\ "nex-mappings.vim",
		\ "nex-str.vim",
		\ "nex-fs.vim",
		\ "nex-misc.vim"
	\ )
	call NxVimVersion()
	let tmpa = GetNxCmd("curl", "wget")
	if tmpa == ""
		echoerr "Error: No curl or wget found."
	else
		if tmpa == "wget"
			let g:NxWww = {a,b -> (mkdir(fnamemodify(a, ':h'), 'p'); system("wget -O '" . a . "' '" . b . "'"))}
		elseif tmpa == "curl"
			let g:NxWww = {a,b -> system("curl -fLo '" . a . "' --create-dirs '" . b . "'")}
		endif
		call GetNxWww({
			\ 'autoload/plug.vim': 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		\ })
	endif
	call NxClipboard()
	if has("python3")
		call NxCallFile("nex-snippets.vim")
	endif
	call NxCallFile(
		\ 'modules/nex-xml.vim',
		\ 'modules/nex-TeX.vim'
	\ )
	filetype plugin on
	filetype on
	filetype indent on
	if filereadable(fnamemodify(g:nex_vim_config . "autoload/plug.vim", ":p"))
		call NxCallFile("nex-plugins.vim")
		call s:NxColorTheme()
	endif
endfunction

function! s:NxVimOs()
	let g:NxCmd = {x -> system("command -v " . x)}
	if has('macunix')
		return 1
	elseif has("unix")
		return 2
	elseif has("win32")
		let g:NxCmd = {x -> system("where " . x)}
		return 3
	else
		let g:NxCmd = {x -> ""}
		return 4
	endif
endfunction

function! NxClipboard()
	let g:nex_clip = NxBaseName(getenv("G_NEX_CLIPBOARD"))
	if has("clipboard")
		nnoremap <silent> <leader>yy :%y+<CR>
	elseif g:nex_clip != ""
		call NxCallFile("nex-clip.vim")
	endif
endfunction

function! GetNxCmd(...)
	for arg in a:000
		if g:NxCmd(arg) != ""
			return arg
		endif
	endfor
endfunction

function! NxVimVersion()
	let g:nex_vim_os = s:NxVimOs()
	if stridx($VIMRUNTIME, "nvim") >= 0
		let g:nex_vim = "nvim"
		return s:NxNeoVimPaths()
	elseif v:version < 900
		let g:nex_vim = "vim"
	else
		let g:nex_vim = "vim9"
	endif
	if g:nex_vim_os == 3
		let tmpa = getenv("HOME") . "/vimfiles/"
	else
		let tmpa = getenv("HOME") . "/.vim/"
	endif
	let g:nex_vim_data = tmpa
	let g:nex_vim_cache = tmpa
	let g:nex_vim_config = tmpa
	call NxContainer(g:nex_vim_config . "/pack/")
endfunction

function! s:NxNeoVimPaths()
	if g:nex_vim_os == 3
		let g:nex_vim_data = getenv("HOME") . '/AppData/Local/nvim/'
		let g:nex_vim_config = getenv("HOME") . '/AppData/Local/nvim-data/'
		let g:nex_vim_cache = getenv("HOME") . '/AppData/Local/nvim-cache/'
	else
		let g:nex_vim_data = getenv("HOME") . '/.local/share/nvim/'
		let g:nex_vim_config = getenv("HOME") . '/.config/nvim/'
		let g:nex_vim_cache = getenv("HOME") . '/.cache/nvim/'
	endif
endfunction

function! GetNxWww(a)
	if type(a:a) != v:t_dict
		echoerr "Error: dict expected for GetNxWww."
		return v:false
	endif
	for [key, val] in items(a:a)
		let target = fnamemodify(g:nex_vim_config . key, ":p")
		if ! filereadable(target)
			call g:NxWww(target, val)
		endif
	endfor
endfunction

function! NxCallFile(...)
	if ! exists('g:nex_mod_viml') && ! empty(getenv('NEXUS_LIB'))
		let l:tmpa = expand(getenv('NEXUS_LIB'))
		if isdirectory(l:tmpa)
			let g:nex_mod_viml = getenv('NEXUS_LIB') . '/viml/'
			if ! isdirectory(g:nex_mod_viml)
				unlet! g:nex_mod_viml
			endif
			let g:nex_mod_lua = getenv('NEXUS_LIB') . '/lua/nvim/'
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
		colorscheme nord
	catch /^Vim\%((\a\+)\)\=:E185/
		call PlugUpdateUpgrade()
		try
			colorscheme dracula-soft
		catch /^Vim\%((\a\+)\)\=:E185/
			try
				colorscheme dracula
			catch
				colorscheme industry
			endtry
		endtry
	endtry
endfunction

call s:NxVimInit()

