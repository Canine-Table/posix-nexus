
let s:tmpa = NxBaseName(expand(getenv('G_NEX_CLIPBOARD')))

if s:tmpa != ''
	"set clipboard+=unnamedplus
	let g:clipboard = s:tmpa
endif

