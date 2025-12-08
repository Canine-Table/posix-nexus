
function! NxTexLogger()
	" Open a log file for writing
	let logfile = expand(getenv('NEXUS_ENV') . '/log/vimtex_vars.log')
	call writefile([], logfile)  " clear file first
	" Loop through all global variables
	for [name, value] in items(g:)
	  if name =~# '^vimtex'
	    " Format like awk: key => value
	    call writefile([name . '  =>  ' . string(value)], logfile, 'a')
	  endif
	endfor

	echo "VimTeX variables written to " . logfile
endfunction

function! s:NxTeXSettings()
	set tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab autoindent
	if empty(v:servername) && exists('*remote_startserver')
		call remote_startserver('VIM')
	endif
	let g:nex_tex_root = expand('%:p:h')
	"let g:nex_tex_aux = g:nex_tex_root . '/auxiliary'
	"let g:vimtex_latexmk_build_dir = g:nex_tex_aux
	call NxConfigureLaTeXMK()
	let g:vimtex_view_automatic = 1
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


function! NxConfigureLaTeXMK()
	"let g:Tex_DefaultTargetFormat="pdf"

	"let g:Tex_CompileRule_pdf='pdflatex --output-directory=' . g:nex_tex_aux . ' -aux-directory=' . g:nex_tex_aux . ' -interaction=nonstopmode $*'
	"let g:vimtex_compiler_latexmk = {
		\ 'callback' : 1,
		\ 'continuous' : 1,
		\ 'out_dir' : g:nex_tex_aux,
		\ 'aux_dir' : g:nex_tex_aux,
		\ 'executable' : g:vimtex_compiler_method,
		\ 'hooks' : [{ 'name': 'copy-pdf', 'callback': {-> system('cp ' . g:nex_tex_aux . '/' . expand('%:t:r') . '.pdf .') } } ],
		\ 'options' : [
			\ '-emulate-aux-dir=' . g:nex_tex_aux,
			\  '-verbose',
			\ '-shell-escape',
		\ ],
	\ }

	let g:vimtex_compiler_method = 'latexmk'
	let g:vimtex_compiler_latexmk = {
		\ 'callback' : 1,
		\ 'continuous' : 0,
		\ 'executable' : g:vimtex_compiler_method,
		\ 'options' : [
			\ '-shell-escape'
		\ ],
	\ }

endfunction

autocmd Filetype tex call s:NxTeXSettings()

