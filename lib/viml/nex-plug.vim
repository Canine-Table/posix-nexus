function! NxPlugUpdateUpgrade()
	execute 'PlugUpdate'
	execute 'PlugUpgrade'
endfunction

function! NxPlug()
	if filereadable(fnamemodify(g:nex_src.vim.config . "autoload/plug.vim", ":p"))
		filetype plugin on
		call NxCallFile("plug.d/nex-autoload.vim")
		call NxCallFile("nex-theme.vim")
	endif
endfunction

