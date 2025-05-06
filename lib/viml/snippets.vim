function! NxSnippetSettings()
	if has("python3")
		" use Tab to expand snippets
		let g:UltiSnipsExpandTrigger = '<Tab>'
		" use Tab to move forward through tabstops
		let g:UltiSnipsJumpForwardTrigger = '<Tab>'
		" use Shift-Tab to move backward through tabstops
		let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
		let g:UltiSnipsEditSplit = 'vertical'
		let g:UltiSnipsSnippetDirectories = [ g:nx_config_path . 'UltiSnips' ]
		if exists('g:nex_mod_viml')
			call NxContainer(g:nex_mod_viml . '/snippets')
			call add(g:UltiSnipsSnippetDirectories, g:nex_mod_viml . '/snippets')
		endif
	else
		echoerr 'required: python3, pynvim or pyvim'
		return
	endif
endfunction

"call NxSnippeptSettings()

