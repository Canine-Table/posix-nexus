function! s:NxVimInit()
	let g:nex_has = {
		\ 'nvim': exists('*nvim_get_option'),
		\ 'lua': has('lua') || has('nvim') || has('luajit'),
		\ 'jobs': exists('*jobstart'),
		\ 'popup': exists('*popup_create'),
		\ 'timers': exists('*timer_start'),
		\ 'terminal': exists('*termopen') || exists('*term_start'),
	\ }
	let g:nex = {
		\ 'vim': {},
		\ 'lua': {},
		\ 'tex': {},
	\ }
	let g:nex_src = {
		\ 'lua': {},
		\ 'vim': {},
		\ 'tex': {},
	\ }
	call s:NxHasBool()
	call s:NxEnviron()
	call NxCallFile(
		\ "nex-ab.vim",
		\ "nex-clip.vim",
		\ "nex-map.vim",
		\ "nex-str.vim",
		\ "nex-fs.vim",
		\ "nex-misc.vim",
		\ "nex-cfg.vim",
		\ "nex-source.vim",
		\ "nex-cmd.vim",
		\ "nex-plug.vim",
	\ )

	call NxSourceModules()
	call NxPlug()
endfunction

function! s:NxEnviron()
	call s:NxResolveVimlRoot()
	call s:NxResolveLibRoot()
	call s:NxLoadLua()
endfunction

function! s:NxResolveVimlRoot()
	" Case 1: already set and valid
	if has_key(g:nex_src.vim, 'root') && isdirectory(g:nex_src.vim.root)
		return g:nex_src.vim.root
	endif

	" Case 2: resolve from <sfile>
	let l:init = fnamemodify(expand('<sfile>'), ':p')
	let l:parts = split(l:init, '\.vim')
	if len(l:parts) == 2
		let l:parts = split(l:parts[0], 'VIMINIT..script ')
		let g:nex_src.vim.cwd = l:parts[0]
		let g:nex_src.vim.init = l:parts[1] . '.vim'
		let g:nex_src.vim.root = split(fnamemodify(l:init, ":h") . '/', 'VIMINIT..script ')[1]
		return g:nex_src.vim.root
	endif

	" Case 3: resolve from getscriptinfo()
	for s in getscriptinfo()
		let l:tmpa = split(s['name'], 'nex-init.')
		if len(l:tmpa) == 2 && l:tmpa[1] ==# 'vim'
			let g:nex_src.vim.init = l:tmpa[0]
			let g:nex_src.vim.root  = s['name']
			return g:nex_src.vim.root
		endif
	endfor
	return g:null
endfunction

function! s:NxResolveLibRoot()
	" Case 1: already set
	if has_key(g:nex_src, 'lib') && isdirectory(g:nex_src.lib)
		return g:nex_src.lib
	endif

	" Case 2: environment variable
	let l:env = getenv('NEXUS_LIB')
	if !empty(l:env) && isdirectory(l:env)
		let g:nex_src.lib = l:env
		return g:nex_src.lib
	endif

	" Case 3: derive from viml root
	if has_key(g:nex_src.vim, 'root') && isdirectory(g:nex_src.vim.root)
		let l:parts = split(g:nex_src.vim.root, '/lib/')
		if len(l:parts) == 2
			let g:nex_src.lib = l:parts[0]
			return g:nex_src.lib
		endif
	endif
	return g:null
endfunction

function! s:NxLoadLua()
	if NxHasLua() == g:null || !(has_key(g:nex_src, 'lib') && isdirectory(g:nex_src.lib))
		return
	endif
	let l:path = fnamemodify(g:nex_src.lib . '/lua/vim/nex-init.lua', ':p')
	if filereadable(l:path)
		let g:nex_src.lua.init = l:path
		let g:nex_src.lua.root = fnamemodify(l:path, ':h') . '/'
		execute 'luafile ' . l:path
	endif
endfunction

function! s:NxHasBool()
	if exists('v:true')
		let g:true = v:true
		let g:false = v:false
		let g:null = v:null
	else
		let g:true = 1
		let g:false = 0
		let g:null = ""
	endif
endfunction

function! NxHasLua()
	if g:nex_has.lua
		if has_key(g:nex_src.lua, 'root') && isdirectory(g:nex_src.lua.root)
			return g:true
		endif
		return g:false
	endif
	return g:null
endfunction

function! NxVimLoader(file)
	if match(a:file, '\.vim$') >= 0
		if has_key(g:nex_src.vim, 'root') && isdirectory(g:nex_src.vim.root) && filereadable(g:nex_src.vim.root . a:file)
			execute 'source ' . g:nex_src.vim.root . a:file
		elseif filereadable(a:file)
			execute 'source ' . a:file
		endif
		return g:true
	endif
	return g:false
endfunction

function! NxLuaLoader(file)
	if match(a:file, '\.lua$') >= 0
		if has_key(g:nex_src.lua, 'root') && isdirectory(g:nex_src.lua.root) && filereadable(g:nex_src.lua.root . a:file)
			execute 'luafile ' . g:nex_src.lua.root . a:file
		elseif filereadable(a:file)
			execute 'luafile ' . a:file
		endif
		return g:true
	endif
	return g:false
endfunction

function! NxCallFile(...)
	if has_key(g:nex_src.vim, 'root') && isdirectory(g:nex_src.vim.root)
		if has_key(g:nex_src.lua, 'root') && isdirectory(g:nex_src.lua.root)
			for a in a:000
				if NxVimLoader(a) == g:false
					call NxLuaLoader(a)
				endif
			endfor
		else
			for a in a:000
				call NxVimLoader(a)
			endfor
		endif
	elseif has_key(g:nex_src.lua, 'root') && isdirectory(g:nex_src.lua.root)
		for a in a:000
			call NxLuaLoader(a)
		endfor
	endif
endfunction

call s:NxVimInit()

