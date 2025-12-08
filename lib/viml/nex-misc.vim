
function! NxBaseName(arg)
	return substitute(a:arg, '.*/', '', 'g')
endfunction

function! NxCallFunction(fn, ...)
	if exists('*' . a:fn)
		if a:000 == []
			execute 'call ' . a:fn . '()'
		else
			execute 'call ' . a:fn . '("' . join(a:000, '","') . '")'
		endif
	endif
endfunction

function! NxMatchExec(a, k)
	if type(a:a) != v:t_string
		echoerr "Error: string expected for NxMatchExec arg #1."
		return v:false
	endif
	if type(a:k) != v:t_dict
		echoerr "Error: dict expected for NxMatchExec arg #2."
		return v:false
	endif
	for [key, val] in items(a:k)
		if a:a ==# key && executable(key)
			if val == ""
				return key
			endif
			return key . " " . val
		endif
	endfor
	echoerr "Error: oups, no matches were executable if any matched at all :("
	return v:false
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

function! NxClientServer(arg)
	if ! empty(a:arg) && v:servername && exists('*remote_startserver')
		call remote_startserver(toupper(a:arg))
	endif
endfunction

