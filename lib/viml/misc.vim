function! CallFunction(fn, ...)
	if exists('*' . a:fn)
		if a:000 == []
			execute 'call ' . a:fn . '()'
		else
			execute 'call ' . a:fn . '("' . join(a:000, '","') . '")'
		endif
	endif
endfunction

function! NxContainer(...)
	if a:000 != []
		for a in a:000
			if ! (empty(a) || isdirectory(a))
				mkdir(a, 'p')
			endif
		endfor
	endif
endfunction

function! NxClientServer(arg)
	if ! empty(a:arg) && v:servername && exists('*remote_startserver')
		call remote_startserver(toupper(a:arg))
	endif
endfunction

