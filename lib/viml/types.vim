function! IsDict(arg)
	return a:arg == v:t_dict
endfunction

function! Constant(a, b)
	if ! exists(a:a) && ! empty(a:b)
		execute 'let ' . a:a . ' = "' a:b '"'
	endif
endfunction

function! Default(a, b)
	if ! exists(a:a)
		if ! empty(a:b)
			return a:b
		endif
	else
		return eval(a:a)
	endif
endfunction

