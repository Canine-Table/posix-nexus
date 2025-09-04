function! s:NxTeXSettings()
	set tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab autoindent
	if empty(v:servername) && exists('*remote_startserver')
		call remote_startserver('VIM')
	endif
	let g:nex_tex_root = expand('%:p:h')
	let g:nex_tex_aux = g:nex_tex_root . '/contents/' . expand('%:t:r') . '/meta'
	let g:vimtex_latexmk_build_dir = g:nex_tex_aux
	let g:vimtex_compiler_method = NxBaseName(getenv('G_NEX_TEX_BACKEND'))
	let g:nex_tex_compiler = NxBaseName(getenv('G_NEX_TEX_COMPILER'))
	let g:vimtex_view_method = NxBaseName(getenv('G_NEX_TEX_VIEWER'))
	let l:backends = {
		\ 'latexmk': 'NxConfigureLaTeXMK',
		\ 'latexrun': 'NxConfigureLaTeXRun',
		\ 'tectonic': 'NxConfigureTectonic',
		\ 'arara': 'NxConfigureArara',
	\}
	let g:vimtex_quickfix_open_on_warning = 0
	let g:vimtex_view_enabled = 1
	let g:vimtex_fold_manual = 1
	let g:tex_flavor = 'latex'
	let g:vimtex_quickfix_ignore_filters = [
		\ 'Underfull \\hbox',
		\ 'Overfull \\hbox',
		\ 'LaTeX Warning: .\+ float specifier changed to',
		\ 'LaTeX hooks Warning',
		\ 'Package siunitx Warning: Detected the "physics" package:',
		\ 'Package hyperref Warning: Token not allowed in a PDF string',
	\]
	if has_key(l:backends, g:vimtex_compiler_method)
		if g:nx_editor == 'nvim'
			let g:vimtex_compiler_progname = 'nvr'
			let vimtex_parser_bib_backend = 'lua'
		else
			let vimtex_parser_bib_backend = BaseName(getenv('G_NEX_BIB_BACKEND'))
		endif
		call NxCallFunction(l:backends[g:vimtex_compiler_method])
		echo 'VimTeX Compiler:' g:vimtex_compiler_method
		echo 'VimTex Executable:' g:nex_tex_compiler
	else
		echoerr "Unknown compiler method:" g:vimtex_compiler_method
	endif
endfunction

function! NxConfigureLaTeXMK()
	let g:vimtex_compiler_latexmk_engines = {
		\ '_'				: '-lualatex',
		\ 'pdfdvi'		   : '-pdfdvi',
		\ 'pdfps'			: '-pdfps',
		\ 'pdflatex'		 : '-pdf',
		\ 'luatex'		   : '-lualatex',
		\ 'lualatex'		 : '-lualatex',
		\ 'xelatex'		  : '-xelatex',
		\}
	let g:vimtex_compiler_lualatex = {
		\ 'aux_dir' : g:nex_tex_aux,
		\ 'out_dir' : g:nex_tex_aux,
		\ 'callback' : 1,
		\ 'continuous' : 1,
		\ 'executable' : g:vimtex_compiler_method,
		\ 'hooks' : [],
		\ 'options' : [
			\  '--verbose',
			\  '--synctex=1',
			\  '--interaction=nonstopmode',
			\ '--pdflua',
			\ '--file-line-error',
			\ '--halt-on-error',
			\ '--reorder',
			\ '--shell-escape',
			\ '--auxdir=' .  g:nex_tex_aux,
			\ '--outdir=' . g:nex_tex_aux,
		\ ],
\}
endfunction

function! NxConfigureLaTeXRun()
	let g:vimtex_compiler_latexrun = {
		\ 'out_dir' : g:nex_tex_aux,
		\ 'options' : [
			\ '-verbose-cmds',
			\ '--latex-args="-synctex=1"',
		\ ],
	\}
	let g:vimtex_compiler_latexrun_engines = {
		\ '_' : 'lualatex',
		\ 'pdflatex' : 'pdflatex',
		\ 'lualatex' : 'lualatex',
		\ 'xelatex' : 'xelatex',
	\}
endfunction

function! NxConfigureTectonic()
	let g:vimtex_compiler_tectonic = {
		\ 'out_dir' : g:nex_tex_aux,
		\ 'hooks' : [],
		\ 'options' : [
			\ '--keep-logs',
			\ '--synctex'
		\ ],
	\}
endfunction

function! NxConfigureArara()
	let g:vimtex_compiler_arara = {
		\ 'options' : ['--log'],
		\ 'hooks' : [],
	\}
endfunction

autocmd Filetype tex call s:NxTeXSettings()

		nnoremap <Leader>lv :VimtexView<CR>
		nnoremap <Leader>ll :VimtexCompile<CR>
		noremap <Leader>lL :VimtexCompileSS<CR>
		nnoremap <Leader>LL :VimtexCompileSelected<CR>
		nnoremap <Leader>lq :VimtexStop<CR>
		noremap <Leader>lm :VimtexToggleMain<CR>
		noremap <Leader>lt :VimtexLog<CR>
		noremap <leader>wc <Cmd>VimtexCountWords<CR>
