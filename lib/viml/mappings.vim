function! s:NxNexMap()
	if exists('g:nex_map')
		call s:NxUnMapNex()
	else
		call s:NxMapNex()
	endif
endfunction

function! s:NxMapNex()
	let g:nex_map = v:true
	let g:mapleader = ","
	nnoremap x d$
	nnoremap X d^
	onoremap s t<space>
	onoremap S T<space>
	noremap b ^
	noremap e $
	nnoremap T :tabnew<CR>
	nnoremap Q :quit<CR>
	inoremap jk <esc>
	nnoremap <leader>t :tabnew<CR>
	nnoremap <leader>T :tabclose<CR>
	nnoremap <leader>to :tab<CR>
	nnoremap <leader>J :tabprevious<CR>
	nnoremap <leader>K :tabnext<CR>
	nnoremap <leader>w :write<CR>
	nnoremap <leader>q :quit<CR>
	nnoremap <leader>wq :wq<CR>
	nnoremap <leader>wqa :wqall<CR>
	nnoremap <Leader>e :Explore<CR>
	nnoremap <Leader>r :retab!<CR>
	nnoremap <leader>, :nohlsearch<CR>
	nnoremap <leader>/ :set invhlsearch<CR>
	nnoremap <leader>\ :vsplit<CR>
	nnoremap <leader>1 :bnext<CR>
	nnoremap <leader>2 :bprevious<CR>
	nnoremap <leader>n :call NexMap()<CR>
	nnoremap <leader>pi :PlugInstall<CR>
	nnoremap <leader>pu :call PlugUpdateUpgrade()<CR>
	nnoremap <Leader>lv :VimtexView<CR>
	nnoremap <Leader>ll :VimtexCompile<CR>
	noremap <Leader>lL :VimtexCompileSS<CR>
	nnoremap <Leader>LL :VimtexCompileSelected<CR>
	nnoremap <Leader>lq :VimtexStop<CR>
	noremap <Leader>lm :VimtexToggleMain<CR>
	noremap <Leader>lt :VimtexLog<CR>
	noremap <leader>wc <Cmd>VimtexCountWords<CR>
	nnoremap <leader>u <Cmd>call UltiSnips#RefreshSnippets()<CR>
	echo "Nexus Mapping: enabled"
endfunction

function! s:NxUnMapNex()
	unlet! g:nex_map
	nunmap x
	nunmap X
	ounmap s
	ounmap S
	iunmap jk
	unmap e
	unmap b
	nunmap T
	nunmap Q
	echo "Nexus Mapping: disabled"
endfunction

call s:NxNexMap()

