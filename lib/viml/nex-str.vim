let g:nex_char = {
  \ 'digit': '0123456789',
  \ 'lower': 'abcdefghijklmnopqrstuvwxyz',
  \ 'upper': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
\ }

" extend dictionary with new keys
let g:nex_char['alpha'] = g:nex_char['lower'] . g:nex_char['upper']
let g:nex_char['alnum'] = g:nex_char['alpha'] . g:nex_char['digit']

function! NxCtrl()
  let out = ''
  for code in range(char2nr(' '), char2nr('@'))
    let out .= nr2char(code)
  endfor
  for code in range(char2nr('['), char2nr('_'))
    let out .= nr2char(code)
  endfor
  for code in range(char2nr('{'), char2nr('`'))
    let out .= nr2char(code)
  endfor
  return out
endfunction

let g:nex_char['ctrl'] = NxCtrl()

function! RandomAlnumChar()
  return chars[rand() % 62]
endfunction

