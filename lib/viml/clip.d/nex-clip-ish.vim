" clip.d/nex-clip-ish.vim
function! NxClipBackend(cmd, range)
    if a:range ==# 'buffer'
        execute '%write !cat > /dev/clipboard'
    else
        execute "'<,'>write !cat > /dev/clipboard"
    endif
endfunction


