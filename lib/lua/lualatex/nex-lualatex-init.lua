--[=[
	This function initializes a custom POSIX-based LuaLaTeX setup.
]=]

local nx_root = os.getenv('G_NEX_MOD_LIB') .. '/lua/opt/nex-'
local nex = {}

nex.module = dofile(nx_root .. 'module.lua')
nex.os = dofile(nx_root .. 'os.lua')
nex.int = dofile(nx_root .. 'int.lua')
nex.data = dofile(nx_root .. 'data.lua')

nex.tex = {}

nex.tex.hello_world = function()
	return 'hello world this is tom'
end

return nex

