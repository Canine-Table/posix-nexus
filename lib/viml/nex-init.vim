
function! s:NxVimInit()
	set number textwidth=0 encoding=utf-8
	set incsearch hlsearch
	set tabstop=8 softtabstop=0 shiftwidth=8
	set noexpandtab autoindent cindent smartindent
	behave xterm
	set ruler laststatus=2 showcmd showmode
	set fileformat=unix
	set wildmode=longest,list,full wildmenu
	set list listchars=trail:▓,tab:▒░
	set wrap breakindent
	set magic
	set title
	set hidden
	set history=10000
	set nowrap
	set belloff=all
	if has("termguicolors")
		set termguicolors
	endif
	set background=dark

	for s in getscriptinfo()
		let tmpa = split(s['name'], 'nex-init.')
		if len(tmpa) == 2 && tmpa[1] == 'vim'
			let g:nex_viml_root = tmpa[0]
			let g:nex_viml_init = s['name']
			break
		endif
	endfor

	call NxHasBool()
	call NxEnviron()
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
		\ 'modules/nex-TeX.vim',
		\ 'modules/nex-gcobol.vim',
	\ )
	"call after the pluggins are loader or bad things happen
	filetype plugin on
	filetype on
	filetype indent on

	if filereadable(fnamemodify(g:nex_vim_config . "autoload/plug.vim", ":p"))
		call NxCallFile("nex-plugins.vim")
		call s:NxColorTheme()
	endif
endfunction

function! NxDirectory(dir)
	let perms = getfperm(a:dir)
	return perms =~# 'r' && perms =~# 'x'
endfunction

function! NxEnviron()
	if ! (exists('g:nex_viml_root') && isdirectory(g:nex_viml_root))
		let g:nex_viml_init = fnamemodify(expand('<sfile>'), ':p')
		let tmpa = split(fnamemodify(g:nex_viml_init, ":h") . '/', 'VIMINIT..script ')
		let g:nex_viml_root = tmpa[1]
		let g:nex_cwd = tmpa[0]
	endif

	if ! (exists('g:nex_lib_root') && isdirectory(g:nex_lib_root))
		if ! empty(getenv('NEXUS_LIB')) && isdirectory(getenv('NEXUS_LIB'))
			let g:nex_lib_root = getenv('NEXUS_LIB')
		elseif exists('g:nex_viml_root') && isdirectory(g:nex_viml_root)
			let tmpa = split(g:nex_viml_root, '/lib/')
			if len(tmpa) == 2
				let g:nex_lib_root = tmpa[0]
			endif
		endif
	endif

	if exists('g:nex_lib_root') && isdirectory(g:nex_lib_root)
		let tmpa = fnamemodify(g:nex_lib_root . "/lua/vim/nex-init.lua", ":p")
		if NxHasLua() != g:null && filereadable(tmpa)
			echo 'loading lua extentions'
			let g:nex_lua_init = tmpa
			let g:nex_lua_root = fnamemodify(tmpa, ":h") . '/'
			execute 'luafile ' . tmpa
		endif
	endif

endfunction

function! NxHasBool()
	if exists('v:true')
		let g:true = v:true
		let g:false = v:false
		let g:null = v:null
	else
		let g:true = 1
		let g:false = 0
		let g:null = ""
	endif
endfunction

function! NxHasLua()
	if has('lua') || has('nvim')
		if exists('g:nex_lua_root')
			return g:true
		endif
		return g:false
	endif
	return g:null
endfunction

function! s:NxVimOs()
	let g:NxCmd = {x -> substitute(system("command -v " . x), '\n\+$', '', '')}
	let g:nex_path_separator = '/'
	let g:nex_escape = '\'
	if has('macunix')
		return 1
	elseif has("unix")
		return 2
	elseif has("win32")
		let g:NxCmd = {x -> substitute(system("where " . x), '\r\?\n\+$', '', '')}
		let g:nex_path_separator = '\'
		let g:nex_escape = '`'
		return 3
	else
		let g:NxCmd = {x -> ""}
		return 4
	endif
endfunction

function! NxClipboard()
	let g:nex_clip = NxBaseName(getenv("G_NEX_CLIPBOARD"))
	if !exists("g:nex_clipboard_mapped")
		if has("clipboard")
			nnoremap <silent> <leader>yy :%y+<CR>
			unlet! g:nex_clip
		elseif g:nex_clip != ""
			call NxCallFile("nex-clip.vim")
		endif
		let g:nex_clipboard_mapped = 1
	endif
endfunction

function! GetNxCmd(...)
	let tmpb = g:null
	for arg in a:000
		let tmpa = g:NxCmd(arg)
		if filereadable(tmpa)
			return arg
		elseif tmpa != ""
			tmpb = tmpa
		endif
	endfor
	return tmpb
endfunction

function! NxVimVersion()
	let g:nex_vim_os = s:NxVimOs()
	if has('nvim') && stridx($VIMRUNTIME, "nvim") >= 0
		let g:nex_vim = "nvim"
		return s:NxNeoVimPaths()
	elseif v:version < 900
		let g:nex_vim = "vim"
	else
		let g:nex_vim = "vim9"
		if filereadable($VIMRUNTIME . '/defaults.vim')
			echo 'loading defaults'
			source $VIMRUNTIME/defaults.vim
		endif
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
	if has('v:t_dict') && type(a:a) != v:t_dict
		echoerr "Error: dict expected for GetNxWww."
		return g:false
	endif
	for [key, val] in items(a:a)
		let target = fnamemodify(g:nex_vim_config . key, ":p")
		if ! filereadable(target)
			call g:NxWww(target, val)
		endif
	endfor
endfunction

function! NxVimLoader(file)
	if match(a:file, '\.vim$') >= 0
		if filereadable(g:nex_viml_root . a:file)
			execute 'source ' . g:nex_viml_root . a:file
		elseif filereadable(a:file)
			execute 'source ' . a:file
		endif
		return g:true
	endif
	return g:false
endfunction

function! NxLuaLoader(file)
	if match(a:file, '\.lua$') >= 0
		if filereadable(g:nex_lua_root . a:file)
			execute 'luafile ' . g:nex_viml_root . a:file
		elseif filereadable(a:file)
			execute 'luafile ' . a:file
		endif
		return g:true
	endif
	return g:false
endfunction

function! NxCallFile(...)
	if exists('g:nex_viml_root')
		if exists('g:nex_lua_root')
			for a in a:000
				if NxVimLoader(a) == g:false
					call NxLuaLoader(a)
				endif
			endfor
		else
			for a in a:000
				call NxVimLoader(a)
			endfor
		endif
	elseif exists('g:nex_lua_root')
		for a in a:000
			call NxLuaLoader(a)
		endfor
	endif
endfunction

function! s:NxColorTheme()
	try
		colorscheme nord
	catch /^Vim\%((\a\+)\)\=:E185/
		call NxPlugUpdateUpgrade()
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

