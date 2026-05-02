function! s:NxColorScheme()
        try
                colorscheme nord
        catch /^Vim\%((\a\+)\)\=:E185/
                call NxPlugUpdateUpgrade()
                try
                        colorscheme dracula-soft
                catch /^Vim\%((\a\+)\)\=:E185/
                        try
                                colorscheme dracula
                        catch
                                colorscheme industry
                        endtry
                endtry
        endtry
endfunction

call s:NxColorScheme()
