
function! NxCallFunction(fn, ...)
	if exists('*' . a:fn)
		if a:000 == []
			execute 'call ' . a:fn . '()'
		else
			execute 'call ' . a:fn . '("' . join(a:000, '","') . '")'
		endif
	endif
endfunction

function! NxClientServer(arg)
	if ! empty(a:arg) && v:servername && exists('*remote_startserver')
		call remote_startserver(toupper(a:arg))
	endif
endfunction

