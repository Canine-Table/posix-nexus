
function! NxCallFunction(fn, ...)
	if exists('*' . a:fn)
		if a:000 == []
			execute 'call ' . a:fn . '()'
		else
			execute 'call ' . a:fn . '("' . join(a:000, '","') . '")'
		endif
	endif
endfunction


function! NxRegisterEnvironsToMap(mp, ky, ...)
	if ! has_key(a:mp, a:ky)
		let a:mp[a:ky] = {}
	endif

	for [k,v] in a:000
		let l:path = getenv('G_NEX_' . v)
		if l:path != g:null
			let a:mp[a:ky][k] = NxBaseName(l:path)
		endif
	endfor
endfunction

function! NxRegisterGlobalsFromMap(mp, ky, ...)
	for [k,v] in a:000
		if has_key(a:mp[a:ky], k)
			execute 'let g:' . v . ' = ' . string(a:mp[a:ky][k])
		endif
	endfor
endfunction

function! NxClientServer(arg)
	if ! empty(a:arg) && v:servername && exists('*remote_startserver')
		call remote_startserver(toupper(a:arg))
	endif
endfunction

