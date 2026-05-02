function! NxSourceModules()
	filetype on
	call NxCallFile(
		\ 'module.d/nex-xml.vim',
		\ 'module.d/nex-gcobol.vim',
		\ 'module.d/nex-TeX.vim',
		\ 'module.d/nex-menus.vim',
	\ )
endfunction

