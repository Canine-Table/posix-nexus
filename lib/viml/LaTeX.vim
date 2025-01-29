function! LaTeXSettings()
	call Constant("g:vimtex_view_method", "zathura")
	call Constant("g:vimtex_compiler_method", "latexmk")
endfunction

autocmd Filetype tex call LaTeXSettings()

