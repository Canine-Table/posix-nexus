function! CallFunction(fn, ...)
	if exists('*' . a:fn)
		execute "call " . a:fn . '("' . join(a:000, '","') . '")'
	endif
endfunction

function! CapsLockStatus()
	return systemlist('xset -q | grep "Caps Lock" | awk ''{print $4}''')[0]
endfunction
