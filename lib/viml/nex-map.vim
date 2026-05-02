if g:nex_has.clip == 'ish'
	call NxCallFile('map.d/nex-mobile.vim')
else
	call NxCallFile('map.d/nex-desktop.vim')
endif

if g:nex_has.clip != 'none'
	nnoremap <silent> <leader>yy :call NxClipBackend('buffer')<CR>
	vnoremap <silent> <leader>yy :call NxClipBackend('visual')<CR>
	xnoremap <silent> <leader>yy :call NxClipBackend('visual')<CR>
endif

