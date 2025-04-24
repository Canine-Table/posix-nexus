function! JoinArgs(...)
        return join(a:000, ' ')
endfunction

function! BaseName(arg)
	return substitute(a:arg, '.*/', '', 'g')
endfunction
