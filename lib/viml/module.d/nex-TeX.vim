
function! NxTeXSettings()
	set tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab autoindent
	if empty(v:servername) && exists('*remote_startserver')
		call remote_startserver('VIM')
	endif

	let g:nex_src['tex']['root'] = expand('%:p:h')
	let g:nex_src['tex']['aux'] = g:nex_src['tex']['root'] . '/aux'
	let g:nex_src['tex']['out'] = g:nex_src['tex']['root'] . '/out'

	let g:nex['tex']['backend'] = NxBaseName(getenv('G_NEX_TEX_BACKEND'))
	let g:nex['tex']['compiler'] = NxBaseName(getenv('G_NEX_TEX_COMPILER'))
	let g:nex['tex']['viewer'] = NxBaseName(getenv('G_NEX_TEX_VIEWER'))
	let g:nex['tex']['bib'] = NxBaseName(getenv('G_NEX_BIB_BACKEND'))

	let g:vimtex_latexmk_build_dir = g:nex_src['tex']['aux']
	let g:vimtex_view_automatic = 1
	let g:vimtex_compiler_method = g:nex['tex']['backend']
	let g:nex_tex_compiler = g:nex['tex']['compiler']
	let g:vimtex_view_method = g:nex['tex']['viewer']
	let l:backends = {
		\ 'latexmk': 'NxConfigureLaTeXMK',
		\ 'latexrun': 'NxConfigureLaTeXRun',
		\ 'tectonic': 'NxConfigureTectonic',
		\ 'arara': 'NxConfigureArara',
	\ }

	let g:vimtex_compiler_clean_paths = [
		\ g:nex_src['tex']['root'],
		\ g:nex_src['tex']['aux'],
		\ g:nex_src['tex']['out'],
	\ ]
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
		if g:nex.vim.version == 'nvim'
			let g:vimtex_compiler_progname = 'nvr'
			let vimtex_parser_bib_backend = 'lua'
		else
			let vimtex_parser_bib_backend = g:nex['tex']['bib']
		endif
		call NxCallFunction(l:backends[g:vimtex_compiler_method])
		autocmd Filetype tex call NxTeXKeyMap()
		echo 'VimTeX Compiler:' g:vimtex_compiler_method
		echo 'VimTex Executable:' g:nex['tex']['compiler']
	else
		echoerr "Unknown compiler method:" g:vimtex_compiler_method
	endif
endfunction

function! NxConfigureLaTeXMK()
	let g:vimtex_compiler_latexmk_engines = {
		\ '_' : '-lualatex',
		\ 'pdfdvi' : '-pdfdvi',
		\ 'pdfps' : '-pdfps',
		\ 'pdflatex' : '-pdf',
		\ 'luatex' : '-lualatex',
		\ 'lualatex' : '-lualatex',
		\ 'xelatex' : '-xelatex',
	\ }

	let g:vimtex_compiler_latexmk = {
		\ 'out_dir' : g:nex_src['tex']['out'],
		\ 'aux_dir' : g:nex_src['tex']['aux'],
		\ 'executable' : g:vimtex_compiler_method,
		\ 'options' : [
			\ '-pdf',
			\ '-lualatex',
			\ '-shell-escape',
			\ '-verbose',
			\ '-file-line-error',
			\ '-synctex=1',
			\ '-interaction=nonstopmode',
		\ ],
		\ 'continuous' : 1,
		\ 'callback' : 1,
	\ }
endfunction

function! NxConfigureLaTeXRun()
	let g:vimtex_compiler_latexrun = {
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
		\ 'hooks' : [],
		\ 'options' : [
			\ '--keep-logs',
			\ '--synctex'
		\ ],
	\ }
endfunction

function! NxConfigureArara()
	let g:vimtex_compiler_arara = {
		\ 'options' : ['--log'],
		\ 'hooks' : [],
	\ }
endfunction

function! NxTeXKeyMap()
		augroup NxVimKeyMap autocmd!
			nnoremap <buffer> <Leader>lv :VimtexView<CR>
			nnoremap <buffer> <Leader>ll :VimtexCompile<CR>
			noremap  <buffer> <Leader>lL :VimtexCompileSS<CR>
			nnoremap <buffer> <Leader>LL :VimtexCompileSelected<CR>
			nnoremap <buffer> <Leader>lq :VimtexStop<CR>
			noremap  <buffer> <Leader>lm :VimtexToggleMain<CR>
			noremap  <buffer> <Leader>lt :VimtexLog<CR>
			noremap  <buffer> <Leader>wc <Cmd>VimtexCountWords<CR>
		augroup END
endfunction

call NxTeXSettings()

