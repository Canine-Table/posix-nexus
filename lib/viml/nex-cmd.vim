function! s:NxAutoLoad()
	let g:nex.os = NxVimOs()
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
	if has("python3")
		call NxCallFile("nex-snip.vim")
	endif
endfunction

function! NxVimOs()
	let g:NxCmd = {x -> substitute(system("command -v " . x), '\n\+$', '', '')}
	if has('macunix')
		return 'macunix'
	elseif has("unix")
		return 'unix'
	elseif has("win32")
		let g:NxCmd = {x -> substitute(system("where " . x), '\r\?\n\+$', '', '')}
		return 'win32'
	else
		let g:NxCmd = {x -> ""}
		return 418
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

function! GetNxWww(a)
	if has('v:t_dict') && type(a:a) != v:t_dict
		echoerr "Error: dict expected for GetNxWww."
		return g:false
	endif
	for [key, val] in items(a:a)
		let target = fnamemodify(g:nex_src.vim.config . key, ":p")
		if ! filereadable(target)
			call g:NxWww(target, val)
		endif
	endfor
endfunction

call s:NxAutoLoad()

