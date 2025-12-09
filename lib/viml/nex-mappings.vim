
let s:comment_prefix = {
  \ 'lua': '--',
  \ 'tex': '%',
  \ 'vim': '"',
  \ 'sql': '--',
  \ 'c': '//',
  \ 'cpp': '//',
  \ 'java': '//',
  \ 'javascript': '//',
  \ 'typescript': '//',
  \ 'asm': ';',
  \ 'nasm': ';',
  \ 'gas': '@',
\ }

function! NxTimeout()
  if !&timeout
    " timeout is currently off
    set timeout
    set timeoutlen=1000
    set ttimeoutlen=50
  else
    " timeout is currently on
    set notimeout
  endif
endfunction

function! NxGetCommentPrefix()
	return get(s:comment_prefix, &filetype, '#')
endfunction

function! NxToggleCommentVisual() range
  let prefix = NxGetCommentPrefix()
  let lines = getline(a:firstline, a:lastline)
  " Check if all lines start with prefix
  let all_commented = 1
  for l in lines
    if l !~ '^[ \t]*' . escape(prefix, '\')
      let all_commented = 0
      break
    endif
  endfor
  if all_commented
    " Uncomment: remove prefix
    execute a:firstline . ',' . a:lastline . 's/^[ \t]*' . escape(prefix, '\') . '\s\?//'
  else
    " Comment: add prefix
    execute a:firstline . ',' . a:lastline . 's/^/' . prefix . ' /'
  endif
endfunction

let g:mapleader = ","
xnoremap <leader>co :<C-u>silent!'<,'>s/^/\=NxGetCommentPrefix()/<CR>:nohlsearch<CR>

" Visual mode: Ctrl-/ toggles comments
xnoremap <leader>tc :silent! call NxToggleCommentVisual()<CR>
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

