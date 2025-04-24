" Main LaTeX Settings function
function! NxTeXSettings()
	let g:vimtex_compiler_method = BaseName($TEXCPL)
	let g:vimtex_docs_directory = $G_NEX_MOD_DOCS
	let g:vimtex_quickfix_ignore_filters = [
		\ 'Underfull \\hbox',
		\ 'Overfull \\hbox',
		\ 'LaTeX Warning: .\+ float specifier changed to',
		\ 'LaTeX hooks Warning',
		\ 'Package siunitx Warning: Detected the "physics" package:',
		\ 'Package hyperref Warning: Token not allowed in a PDF string',
	\]
	let g:vimtex_quickfix_open_on_warning = 0
	" Define a dictionary mapping compiler methods to configuration functions
	let l:compiler_config = {
		\ 'pdflatex': 's:ConfigurePDFLaTeX',
		\ 'latexmk': 's:ConfigureLateXMK',
		\ 'lualatex': 's:ConfigureLuaLaTeX',
		\ 'luatex': 's:ConfigureLuaTeX',
		\ 'xelatex': 's:ConfigureXeLaTeX'
	\}
	if has_key(l:compiler_config, g:vimtex_compiler_method)
		call CallFunction(l:compiler_config[g:vimtex_compiler_method])
		echo 'VimTeX Compiler:' g:vimtex_compiler_method
	else
		echo "Unknown compiler method:" g:vimtex_compiler_method
	endif
endfunction

" Helper function for PDFLaTeX configuration
function! s:ConfigureLaTeXMK()
	let g:vimtex_compiler_latexmk = {
		\ 'executable' : 'latexmk',
		\ 'options' : [
			\ '-pdf',
			\ '-output-directory=' . g:vimtex_docs_directory,
			\ '-interaction=nonstopmode',
			\ '-shell-escape',
		\ ],
	\}
endfunction

" Helper function for LuaTeX configuration
function! s:ConfigureLuaTeX()

	echo 'lu'
	let g:vimtex_compiler_luatex = {
		\ 'executable' : 'luatex',
		\ 'options' : [
			\ '-interaction=nonstopmode',
			\ '-output-directory=' . g:vimtex_docs_directory,
			\ '-synctex=1',
			\ '-shell-escape',
		\ ],
	\}
endfunction

" Function to configure VimTeX for LuaLaTeX
function! s:ConfigureLuaLaTeX()
	let g:vimtex_compiler_luatex = {
	    \ 'name' : 'lualatex',
	    \ 'exe' : 'lualatex',
	    \ 'opts' : [
		\ '-interaction=nonstopmode',
		\ '-output-directory=' . g:vimtex_docs_directory,
		\ '-synctex=1',
		\ '-shell-escape',
	    \ ],
	\}
	g:vimtex_compiler_method = 'luatex'

endfunction

" Helper function for LatexMK configuration
function! s:ConfigurePDFLaTeX()
	let g:vimtex_compiler_pdflatex = {
		\ 'executable' : 'pdflatex',
		\ 'options' : [
			\ '-interaction=nonstopmode',
			\ '-output-directory=' . g:vimtex_docs_directory,
			\ '-synctex=1',
			\ '-shell-escape',
		\ ],
	\}
endfunction

" Helper function for XeLaTeX configuration
function! s:ConfigureXeLaTeX()
	let g:vimtex_compiler_xelatex = {
		\ 'executable' : 'xelatex',
		\ 'options' : [
			\ '-interaction=nonstopmode',
			\ '-output-directory=' . g:vimtex_docs_directory,
			\ '-synctex=1',
			\ '-shell-escape',
		\ ],
	\}
endfunction


" Call the main function to set up all configurations
autocmd Filetype tex call NxTeXSettings()
