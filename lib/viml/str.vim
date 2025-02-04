function! JoinArgs(...)
        return join(a:000, ' ')
endfunction

function! BaseName(arg)
	 return substitute($TEXCPL, ".*/", "", "g")
endfunction

function! Split(str, sep=",")
		let l:idx = stridx(a:str, a:sep)
		if l:idx == -1 && a:str != ""
			echo a:str
		elseif l:idx > 0
			echo strpart(a:str, a:sep, l:idx)
			call Split(strpart(a:str, l:idx + 1), a:sep)
		endif
endfunction

