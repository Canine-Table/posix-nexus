function! NxTabMenu()
    let items = ['Select a tab:']
    let g:nx_tab_map = []

    for i in range(1, tabpagenr('$'))
        let bufnr = tabpagebuflist(i)[0]
        let name = bufname(bufnr)
        if empty(name)
            let name = '[No Name]'
        endif

        call add(items, printf('%d. %s', i, name))
        call add(g:nx_tab_map, i)
    endfor

    let choice = inputlist(items)

    if choice > 0 && choice <= len(g:nx_tab_map)
        execute 'tabnext' g:nx_tab_map[choice - 1]
    endif
endfunction

command! NxTabMenu call NxTabMenu()

