function! NxXmlSettings()
	let g:xml_syntax_folding=1
	set tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab autoindent
	"let g:user_emmet_mode='n'
	let g:user_emmet_leader_key='<C-e>'
endfunction

autocmd Filetype json,nft,yml,yaml,htm,xml,html,svg,css call NxXmlSettings()


