function! s:AutoCompileJava(file)
	call jobstart(['javac', a:file], {
		\ 'on_stdout': {j,d,e -> execute('echo join(d, "\n")')},
        	\ 'on_stderr': {j,d,e -> execute('cgetexpr d | copen')},
	\ })
endfunction

function s:NxJavaSettings()
	if g:nx_editor == 'nvim'
		call NxCallFile('nex-java.lua')
		echo "Java loaded"
	endif
	augroup NxJava
		autocmd!
		autocmd BufWritePost *.java call s:AutoCompileJava(expand('%:p'))
	augroup END
	nnoremap <buffer> <leader>ll :terminal java -cp %:p:h %:t:r<CR>
endfunction

autocmd Filetype java call s:NxJavaSettings()

