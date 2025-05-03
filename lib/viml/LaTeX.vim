" Main LaTeX Settings function
function! s:NxTeXSettings()
	if has('nvim') && BaseName(getenv('EDITOR')) == 'nvim'
		call CallFile('nex-nvim-lualatex-init.lua')
	else
		let g:vimtex_compiler_method = 'latexmk'
		let g:nx_executable = BaseName(getenv('TEXCPL'))
		let g:nx_outdir = expand('%:p:h') . '/contents/' . expand('%:t:r') . '/meta'
		let g:vimtex_view_enabled = 1
		let g:vimtex_fold_manual = 1
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
		if has_key(l:compiler_config, g:nx_executable)
			if has('nvim') " Uses Neovim's async capabilities
				let g:vimtex_compiler_progname = 'nvr'
			endif
			let g:vimtex_view_forward_search_on_start = 1
			call CallFunction(l:compiler_config[g:nx_executable])
			echo 'VimTeX Compiler:' g:vimtex_compiler_method
			echo 'VimTex Executable:' g:nx_executable
		else
			echoerr "Unknown compiler method:" g:vimtex_compiler_method
		endif
	endif
endfunction

" Helper function for PDFLaTeX configuration
function! ConfigureLaTeXMK()
	let g:vimtex_compiler_latexmk = {
		\ 'executable' : 'latexmk',
		\ 'options' : [
			\ '-pdf',
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
			\ '-interaction=nonstopmode',
			\ '-file-line-error',
			\ '-socket',
			\ '-debug-format',
			\ '-synctex=1',
			\ '-shell-escape',
		\],
	\}
endfunction

" Function to configure VimTeX for LuaLaTeX
function! ConfigureLuaLaTeX()

	let g:vimtex_compiler_latexmk = {
		\ 'aux_dir' : g:nx_outdir,
		\ 'out_dir' : g:nx_outdir,
		\ 'callback' : 1,
		\ 'continuous' : 1,
		\ 'executable' : 'lualatex',
		\ 'options' : [
			\ '-verbose',
			\ '-lualatex',
			\ '-pdflua',
			\ '-synctex=1',
			\ '-interaction=nonstopmode',
			\ '-output-directory=' . g:nx_outdir,
			\ '-file-line-error',
			\ '-halt-on-error',
			\ '-reorder',
			\ '-shell-escape',
		\ ],
	\}
endfunction

" Helper function for LatexMK configuration
function! ConfigurePDFLaTeX()
	let g:vimtex_compiler_pdflatex = {
		\ 'executable' : 'pdflatex',
		\ 'options' : [
			\ '-interaction=nonstopmode',
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
			\ '-synctex=1',
			\ '-shell-escape',
		\ ],
	\}
endfunction

" Call the main function to set up all configurations
autocmd Filetype tex call s:NxTeXSettings()

