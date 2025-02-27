function! XmlSettings()
	let g:xml_syntax_folding=1
	set tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab autoindent
endfunction

autocmd Filetype xml,html,svg call XmlSettings()

