let g:nex_char = {
  \ 'digit': '0123456789',
  \ 'lower': 'abcdefghijklmnopqrstuvwxyz',
  \ 'upper': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
\ }

" extend dictionary with new keys
let g:nex_char['alpha'] = g:nex_char['lower'] . g:nex_char['upper']
let g:nex_char['alnum'] = g:nex_char['alpha'] . g:nex_char['digit']

function! NxPunct()
  let out = ''
  for code in range(char2nr(':'), char2nr('@'))
    let out .= nr2char(code)
  endfor
  for code in range(char2nr(' '), char2nr('/'))
    let out .= nr2char(code)
  endfor
  for code in range(char2nr('['), char2nr('`'))
    let out .= nr2char(code)
  endfor
  for code in range(char2nr('{'), char2nr('~'))
    let out .= nr2char(code)
  endfor
  return out
endfunction

let g:nex_char['punct'] = NxPunct()
let g:nex_char['print'] = g:nex_char['punct'] . g:nex_char['alnum']

function! NxRandomChars(n = 8, a = 'alnum')
	let str = ''
	if type(a:a) == v:t_list
		let nx_char = deepcopy(g:nex_char)
		for i in a:a
			if has_key(nx_char, i)
				let str .= get(nx_char, i)
				call remove(nx_char, i)
			endif
		endfor
	endif
	if str == ''
		let str = g:nex_char['alnum']
	endif
	let num = (type(a:n) == v:t_number ? a:n : 8)
	let chars = strlen(str)
	let out = ''
	while num > 0
		let out .= str[rand() % chars]
		let num -= 1
	endwhile
	return out
endfunction

