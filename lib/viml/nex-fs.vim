
function! NxLogger(f = '', v = '')
	" Open a log file for writing
	let logfile = expand(getenv('NEXUS_ENV') . '/log/' . strftime("%Y-%m-%d_%H_%M_%S-") . (type(a:f) == v:t_string && a:f != "" ? a:f : NxRandomChars()) . '.log')
	call writefile([], logfile)  " clear file first
	" Loop through all global variables
	for [name, Value] in items(g:)
		"if name =~# '^' . a:v
		" Format like awk: key => value
		call writefile([name . '  =>  ' . string(Value)], logfile, 'a')
		"endif
	endfor
	echo "variables written to " . logfile
endfunction

