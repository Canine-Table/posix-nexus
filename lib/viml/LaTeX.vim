" Main LaTeX Settings function
function! s:NxTeXSettings()
	let g:vimtex_compiler_method = BaseName(getenv('TEXCPL'))
	let g:vimtex_docs_directory = getenv('G_NEX_MOD_DOCS')
	let g:vimtex_view_enabled = 1
	let g:vimtex_fold_manual = 1
	let g:vimtex_latexmk_continuous = 1
	let g:tex_flavor = 'latex'
	let g:vimtex_view_method = BaseName(getenv('VPDF'))
	let g:vimtex_quickfix_open_on_warning = 0
	let g:vimtex_quickfix_ignore_filters = [
		\ 'Underfull \\hbox',
		\ 'Overfull \\hbox',
		\ 'LaTeX Warning: .\+ float specifier changed to',
		\ 'LaTeX hooks Warning',
		\ 'Package siunitx Warning: Detected the "physics" package:',
		\ 'Package hyperref Warning: Token not allowed in a PDF string',
	\]
	" Define a dictionary mapping compiler methods to configuration functions
	let l:compiler_config = {
		\ 'lualatex': 'ConfigureLuaLaTeX',
		\ 'luatex': 'ConfigureLuaTeX',
		\ 'pdflatex': 'ConfigurePDFLaTeX',
		\ 'latexmk': 'ConfigureLateXMK',
		\ 'xelatex': 'ConfigureXeLaTeX'
	\}
	if has_key(l:compiler_config, g:vimtex_compiler_method)
		let g:vimtex_compiler_progname = g:vimtex_compiler_method
		call CallFunction(l:compiler_config[g:vimtex_compiler_method])
		echo 'VimTeX Compiler:' g:vimtex_compiler_method
	else
		echoerr "Unknown compiler method:" g:vimtex_compiler_method
	endif
endfunction

" Helper function for PDFLaTeX configuration
function! ConfigureLaTeXMK()
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
function! ConfigureLuaTeX()
	let g:vimtex_compiler_luatex = {
		\ 'executable' : 'luatex',
		\ 'options' : [
			\ '--interaction=nonstopmode',
			\ '--file-line-error',
			\ '--socket',
			\ '--debug-format',
			\ '--output-directory=' . g:vimtex_docs_directory,
			\ '--synctex=1',
			\ '--shell-escape',
		\],
	\}
endfunction

" Function to configure VimTeX for LuaLaTeX
function! ConfigureLuaLaTeX()
	"let g:vimtex_compiler_lualatex = {
	let g:vimtex_compiler_latexmk = {
		\ 'executable' : 'lualatex',
		\ 'options' : [
			\ '--interaction=nonstopmode',
			\ '--file-line-error',
			\ '--socket',
			\ '--debug-format',
			\ '--output-directory=' . g:vimtex_docs_directory,
			\ '--synctex=1',
			\ '--shell-escape',
		\],
	\}
endfunction

" Helper function for LatexMK configuration
function! ConfigurePDFLaTeX()
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
function! ConfigureXeLaTeX()
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
autocmd Filetype tex call s:NxTeXSettings()

