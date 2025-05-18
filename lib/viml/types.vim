function! NxIsDict(arg)
	return a:arg == v:t_dict
endfunction

function! NxConstant(a, b)
	if ! exists(a:a) && ! empty(a:b)
		execute 'let ' . a:a . ' = "' a:b '"'
	endif
endfunction

function! NxDefault(a, b)
	if ! exists(a:a)
		if ! empty(a:b)
			return a:b
		endif
	else
		return eval(a:a)
	endif
endfunction

