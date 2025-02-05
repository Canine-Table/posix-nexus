" Main LaTeX ettings function
function! LaTeXSettings()
	let g:vimtex_compiler_method = BaseName($TEXCPL)
	let g:vimtex_docs_directory = $G_NEX_MOD_DOCS
	let g:vimtex_view_method = BaseName($VPDF)
	" Define a dictionary mapping compiler methods to configuration functions
	let l:compiler_config = {
		\ 'pdflatex': 's:ConfigurePDFLaTeX',
		\ 'latexmk': 's:ConfigureLateXMK',
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
autocmd Filetype tex call LaTeXSettings()
