function s:NxClipboardSettings()
	" iSH clipboard
	if filereadable('/dev/clipboard')
		call NxCallFile('clip.d/nex-clip-ish.vim')
		return 'ish:/dev/clipboard'
	endif

	" SSH + lemonade
	if exists('$SSH_CLIENT') && executable('lemonade')
		call NxCallFile('clip.d/nex-clip-lemonade.vim')
		return 'lemonade'
	endif

	" Wayland
	if exists('$WAYLAND_DISPLAY')
		if executable('wl-copy')
			call NxCallFile('clip.d/nex-clip-wayland.vim')
			return 'wl-copy'
		elseif executable('wayclip')
			call NxCallFile('clip.d/nex-clip-wayclip.vim')
			return 'wayclip'
		endif
	endif

	" X11
	if exists('$DISPLAY')
		if executable('xsel')
			call NxCallFile('clip.d/nex-clip-xsel.vim')
			return 'xsel'
		elseif executable('xclip')
			call NxCallFile('clip.d/nex-clip-xclip.vim')
			return 'xclip'
		endif
	endif

	" tmux OSC52
	if exists('$TMUX')
		call NxCallFile('clipd.d/nex-clip-osc52.vim')
		return 'tmux'
	endif

	" Vim built-in clipboard (rare)
	if has('clipboard')
		return 'vim'
	endif

	return 'none'
endfunction

let g:nex_has.clip = s:NxClipboardSettings()

