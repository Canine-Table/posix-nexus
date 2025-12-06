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
M.tex.var = {}
M.tex.ref = require('luatex/nex-ref')
M.tex.var.section = M.tex.ref.sec:new()
M.tex.loaded = function()
	for mod in M.module.loaded() do
		for k, v in pairs(mod) do
			tex.print("Loaded:", k, v)
			tex.print([[\\]])
		end
	end
end




--print(M.var.section.depth)


--M.tex.slope = function(rise, run, intercept)
--	return run .. "/" .. rise .. "*x+" .. intercept
--end

return M

