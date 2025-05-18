function! NxJoinArgs(...)
	return join(a:000, ' ')
endfunction

function! NxBaseName(arg)
	return substitute(a:arg, '.*/', '', 'g')
endfunction

