
function NxClipboardSettings()
	if filereadable("/dev/clipboard") &&  system("test -c /dev/clipboard && printf '%s' 'char'") =~ 'char'
		nnoremap <silent> <leader>yy :write /dev/clipboard<CR>
	else
		let tmpa = NxMatchExec(g:nex_clip, {
			\ "xsel": "-ib",
			\ "lemonade": "",
			\ "tmux": "load-buffer -",
			\ "xclip": "-selection clipboard",
			\ "wl-copy": "",
			\ "wayclip": "",
			\ "clip": "",
			\ "pbcopy": ""
		\ })
		if tmpa == v:false
			echoerr "No clipboard backend available."
			return v:false
		else
			"set clipboard+=unnamedplus
			"let g:clipboard = tmpa
			execute 'nnoremap <silent> <leader>yy :write !' . tmpa . '<CR>'
		endif
	endif
endfunction

call NxClipboardSettings()

