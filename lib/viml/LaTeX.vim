
function! LaTeXSettings(args)
	call Constant("g:vimtex_view_method", get(a:args, "view", "zathura"))
	call Constant("g:vimtex_compiler_method", get(a:args, "compiler", "latexmk"))
	call Constant("g:tex_flavor" get(a:args, 'flavor', "latex"))
endfunction

autocmd Filetype tex call LaTeXSettings({
	\ "view": getenv($PDF_VIEWER),
	\ "compiler": getenv($TEX_COMPILER)
	\ "compiler": getenv($TEX_FLAVOR)
\})

