function! NxClipBackend(range)
	let l:clipcmd = 'xsel --clipboard --input'
	if a:range ==# 'buffer'
		execute '%write !' . l:clipcmd
	else
		execute "'<,'>write !" . l:clipcmd
	endif
endfunction

