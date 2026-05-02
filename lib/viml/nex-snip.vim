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
		if has_key(g:nex_src.vim, 'root') && isdirectory(g:nex_src.vim.root)
			let g:nex_src.vim.snip = g:nex_src.vim.root . '/snip.d'
			call NxContainer(g:nex_src.vim.snip)
			call add(g:UltiSnipsSnippetDirectories, g:nex_src.vim.snip)
		endif
	endif
endfunction

call s:NxSnippetSettings()

