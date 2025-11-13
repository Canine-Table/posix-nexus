function s:NxGitSettings()
	if g:nx_editor == 'nvim'
		call NxCallFile('nex-git.lua')
		echo "Git loaded"
	endif
	"augroup NxJava
	"	autocmd!
	"	autocmd BufWritePost *.java call s:AutoCompileJava(expand('%:p'))
	"augroup END
	"nnoremap <buffer> <leader>ll :terminal java -cp %:p:h %:t:r<CR>
endfunction

" call s:NxGitSettings()

