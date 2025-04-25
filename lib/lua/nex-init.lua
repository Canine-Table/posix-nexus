--[=[
	This function initializes a custom POSIX-based Neovim setup.
]=]

function nx_location(B)
	local nx_path = debug.getinfo(1, 'S').source:sub(2)
	local nx_slash = '/'
	if nx_system() == 'Windows' then
		nx_slash = '\\'
	end
	if B == nil then
		return nx_path
	elseif B == true then
		return nx_path:match('.*' .. nx_slash)
	else
		return nx_path:match('[^' .. nx_slash .. ']+$')
	end
end

function nx_system()
	local nx_home = os.getenv('HOME') or os.getenv('USERPROFILE') or os.getenv('HOMEDRIVE') or os.getenv('HOMEPATH') or ''
	if nx_home:match('^[A-Za-z]:\\') == nil then
		return 'Unix'
	else
		return 'Windows'
	end
end

function nx_list_files(cont, ext)
	cont = cont or nx_location(true)
	ext = ext or 'lua'
	return nx_system() == 'Unix' and 'ls ' .. cont .. '*.' .. ext or 'dir /b ' .. cont .. ' | findstr \\.' .. ext
end

function nx_init(cont, leaf, lib, ext)
	lib = lib or os.getenv('G_NEX_MOD_LIB')
	ext = ext or 'lua'
	cont = cont or nx_location(true)
	leaf = leaf or nx_location(false)
	local path = cont .. leaf
	local nex = nx_location()
	if path and path:match('^' .. lib) then
		local fh = assert(io.popen(nx_list_files(cont, ext)), 'error opening file: ')
		for ln in fh:lines() do
			if not (ln == path or ln == nex) then
				vim.cmd('source ' .. ln)
			end
		end
		fh:close()
	end
end

nx_init()

