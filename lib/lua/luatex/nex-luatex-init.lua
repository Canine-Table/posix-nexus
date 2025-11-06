--[=[
	This function initializes a custom POSIX-based LuaTeX setup.
]=]

local M = {}

M.module = require('nex-module')
M.system = M.module.load['nex-system']
M.int = M.module.load['nex-int']
M.data = M.module.load['nex-data']
M.str = M.module.load['nex-str']
M.bool = M.module.load['nex-bool']

M.tex = {}

return M

