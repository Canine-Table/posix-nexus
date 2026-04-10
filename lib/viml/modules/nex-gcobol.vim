function! NxCobolIndent()
	" Paragraphs and divisions → Area A (column 8)
	if getline(v:lnum) =~ '^\s*[A-Z0-9-]\+\.'
		return 7
	endif

	" Statements -> Area B (column 12)
	return 11
endfunction

function! NxCobolSettings()
	set tabstop=1 softtabstop=0 shiftwidth=1 autoindent
	set ruler
	inoremap *> <Esc>11li*>
endfunction

autocmd BufNewFile *.cob,*.cbl call append(0,
	\ '*----1----2----3----4----5----6----7----8----9----0----1----2----3----4----5----6----7')

autocmd BufNewFile *.cob,*.cbl call append(1, [
\ '	   IDENTIFICATION DIVISION.',
\ '	   PROGRAM-ID. SAMPLE.',
\ '',
\ '	   DATA DIVISION.',
\ '	   WORKING-STORAGE SECTION.',
\ '',
\ '	   PROCEDURE DIVISION.',
\ '		   *> Begin pseudo code here',
\ ''
\ ])

autocmd BufWinEnter *.cob,*.cbl setlocal colorcolumn=7,8,12,72
autocmd Filetype cob syntax keyword cobKeyword
	\ MOVE PERFORM UNTIL VARYING IF ELSE END-IF
	\ DISPLAY ACCEPT ADD SUBTRACT MULTIPLY DIVIDE
	\ OPEN CLOSE READ WRITE STOP RUN

autocmd Filetype cob call NxCobolSettings()
autocmd Filetype cob setlocal indentexpr=NxCobolIndent()
autocmd Filetype cob setlocal textwidth=72
autocmd Filetype cob call NxGCOBOLSettings()

