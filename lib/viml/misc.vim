function! CallFunction(fn, ...)
	if exists('*' . a:fn)
		execute "call " . a:fn . '("' . join(a:000, '","') . '")'
	endif
endfunction
