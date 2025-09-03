function! NxRunCurrentFile()
	update
	if &filetype ==# 'java'
	elseif &filetype ==# 'python'
		execute '!python3 %'
	elseif &filetype ==# 'c'
		execute '!gcc % -o %:r && ./%:r'
	elseif &filetype ==# 'cpp'
		execute '!g++ % -o %:r && ./%:r'
	elseif &filetype ==# 'sh'
		execute '!bash %'
	else
		echoerr "No run command set for filetype: " . &filetype
	endif
endfunction


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
nnoremap <leader>u <Cmd>call UltiSnips#RefreshSnippets()<CR>
"nnoremap <leader><F5> :call NxRunCurrentFile()<CR>
echo "Nexus Mapping: enabled"

