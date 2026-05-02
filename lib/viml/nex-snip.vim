function! s:NxSnippetSettings()
	if exists('python3')
		" use Tab to expand snippets
		let g:UltiSnipsExpandTrigger = '<Tab>'
		" use Tab to move forward through tabstops
		let g:UltiSnipsJumpForwardTrigger = '<Tab>'
		" use Shift-Tab to move backward through tabstops
		let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
		let g:UltiSnipsEditSplit = 'vertical'
		let g:UltiSnipsSnippetDirectories = [ g:nex_src.vim.config . 'UltiSnips' ]
		if exists('g:nex_mod_viml')
			call NxContainer(g:nex_src.vim.root . '/snip.d')
			call add(g:UltiSnipsSnippetDirectories, g:nex_src.vim.root . '/snip.d')
		endif
	endif
endfunction

call s:NxSnippetSettings()

