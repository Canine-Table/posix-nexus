function! SnippetSettings()
	" use Tab to expand snippets
	let g:UltiSnipsExpandTrigger       = '<Tab>'
	" use Tab to move forward through tabstops
	let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
	" use Shift-Tab to move backward through tabstops
	let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
	let g:UltiSnipsEditSplit = "vertical"
	let g:UltiSnipsSnippetDirectories = [
		\ $HOME . '/.vim/UltiSnips',
		\ $HOME . '/.config/nvim/UltiSnips',
		\ $G_NEX_MOD_LIB . '/viml/snippets'
	\]
endfunction

if has("python3")
	call SnippetSettings()
else
	echo "required:	python3, python-pynvim:
endif

":pacman -Ss pynvoii:qi
