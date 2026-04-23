
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
	\ 'lisp': ';',
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
	echo &filetype
	return get(s:comment_prefix, &filetype, '#')
endfunction

function! NxToggleCommentVisual(sep = ' ') range
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
		let multi_comment = v:false
		if a:lastline - a:firstline > 0
			let multi_comment = v:true
			let start = getpos("'<")
			let end = getpos("'>")
			let col_start = start[2] - 1
			let col_end = end[2] + 1
			let col_close = ''
			let col_open = ''
			if prefix == '//'
				let col_open = '\/*'
				let col_close = '*\/'
			elseif prefix == '%' && &filetype == 'tex'
				let col_open = a:sep . '\\begin{comment}\r'
				let col_close = 's/$/\r\\end{comment}/' . a:sep
				a:sep = ''
			elseif prefix == '--' && &filetype == 'lua'
				let col_open = '--[=['
				let col_close = ']=]'
			elseif prefix == ';' && &filetype == 'lisp'
				let col_open = '#|'
				let col_close = '|#'
			elseif prefix == '#' && &filetype == 'sh'
				let comment_suf = NxRandomChars()
				let col_open = '\r: <<- ' . "'COMMENT_" . comment_suf . "'" . '\r'
				let col_close = '\rCOMMENT_' . comment_suf . '\r'
				a:sep = ''
			else
				let multi_comment = v:false
			endif
		endif
		if multi_comment == v:false
			execute a:firstline . ',' . a:lastline . 's/^/' . prefix . ' /'
		elseif multi_comment == v:true
			execute a:firstline . 's/\%>' . col_start . 'c/' . a:sep . col_open . a:sep . '/'
			execute a:lastline . 's/\%<' . col_end . 'c/' a:sep . col_close . a:sep . '/'
		endif
	endif
endfunction

":nmap - Display normal mode maps
":imap - Display insert mode maps
":vmap - Display visual and select mode maps
":smap - Display select mode maps
":xmap - Display visual mode maps
":cmap - Display command-line mode maps
":omap - Display operator pending mode maps

"mapclear! - Clear all insert and command-line mode maps
"nmapclear - Clear all normal mode maps
"vmapclear - Clear all visual and select mode maps
"xmapclear - Clear all visual mode maps
"smapclear - Clear all select mode maps
"imapclear - Clear all insert mode maps
"cmapclear - Clear all command-line mode maps
"omapclear - Clear all operating pending mode mapsxnoremap 

"Commands                        Mode
"--------                        ----
"nmap, nnoremap, nunmap          Normal mode
"imap, inoremap, iunmap          Insert and Replace mode
"vmap, vnoremap, vunmap          Visual and Select mode
"xmap, xnoremap, xunmap          Visual mode
"smap, snoremap, sunmap          Select mode
"cmap, cnoremap, cunmap          Command-line mode
"omap, onoremap, ounmap          Operator pending mode


let g:mapleader = ","
xnoremap <leader>co :<C-u>silent!'<,'>s/^/\=NxGetCommentPrefix()/<CR>:nohlsearch<CR>

" Visual mode: Ctrl-/ toggles comments
xnoremap <leader>tc :silent! call NxToggleCommentVisual()<CR>
onoremap s t<space>
onoremap S T<space>
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

