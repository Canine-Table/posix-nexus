function! NxVimVersion()
	if has('nvim') && stridx($VIMRUNTIME, "nvim") >= 0
		let g:nex.vim.version = "nvim"
		return NxNeoVimPaths()
	elseif v:version < 900
		let g:nex.vim.version = "vim"
	else
		let g:nex.vim.version = "vim9"
		if filereadable($VIMRUNTIME . '/defaults.vim')
			echo 'loading defaults'
			source $VIMRUNTIME/defaults.vim
		endif
	endif
	if g:nex.os == 'win32'
		let tmpa = getenv("HOME") . "/vimfiles/"
	else
		let tmpa = getenv("HOME") . "/.vim/"
	endif
	let g:nex_src.vim.data = tmpa
	let g:nex_src.vim.cache = tmpa
	let g:nex_src.vim.config = tmpa
	call NxContainer(g:nex_src.vim.config . "/pack/")
endfunction

function! NxBaseName(arg)
	return substitute(a:arg, '.*/', '', 'g')
endfunction

function! NxContainer(...)
	if a:000 != []
		for a in a:000
			if ! (empty(a) || isdirectory(a))
				call mkdir(a, 'p')
			endif
		endfor
	endif
endfunction

function! NxDirectory(dir)
	let perms = getfperm(a:dir)
	return perms =~# 'r' && perms =~# 'x'
endfunction

function! NxNeoVimPaths()
	if g:nex.os == 'win32'
		let g:nex_src.vim.data = getenv("HOME") . '/AppData/Local/nvim/'
		let g:nex_src.vim.config = getenv("HOME") . '/AppData/Local/nvim-data/'
		let g:nex_src.vim.cache = getenv("HOME") . '/AppData/Local/nvim-cache/'
	else
		let g:nex_src.vim.data = getenv("HOME") . '/.local/share/nvim/'
		let g:nex_src.vim.config = getenv("HOME") . '/.config/nvim/'
		let g:nex_src.vim.cache = getenv("HOME") . '/.cache/nvim/'
	endif
endfunction

function! NxGlobalVariableLogger(f = '', v = '')
	" Open a log file for writing
	let logfile = expand(g:nex_src.log . strftime("%Y-%m-%d_%H_%M_%S-") . (type(a:f) == v:t_string && a:f != "" ? a:f : NxRandomChars()) . '.log')
	call writefile([], logfile)  " clear file first
	" Loop through all global variables
	for [name, Value] in items(g:)
		"if name =~# '^' . a:v
		" Format like awk: key => value
		call writefile([name . '  =>  ' . string(Value)], logfile, 'a')
		"endif
	endfor
	echo "variables written to " . logfile
endfunction

