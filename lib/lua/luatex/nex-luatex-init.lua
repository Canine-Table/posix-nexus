--[=[
	This function initializes a custom POSIX-based LuaTeX setup.
]=]

kpse.set_program_name("luatex")

local M = {}
package.loadlib(kpse.find_file("lsqlite3", "clua"), "luaopen_lsqlite3")()
M.db3 = require('lsqlite3')

M.module = require('nex-module')
M.system = M.module.load['nex-system']
M.int = M.module.load['nex-int']
M.data = M.module.load['nex-data']
M.str = M.module.load['nex-str']
M.bool = M.module.load['nex-bool']
--M.bit = M.module.load['nex-bit']

M.tex = {}
M.tex.var = {}
M.tex.unicode = M.module.load['luatex/nex-unicode']
M.tex.oop = M.module.load['luatex/nex-oop']
M.tex.ref = M.module.load['luatex/nex-ref']
M.tex.var.section = M.tex.ref.sec:new()
M.tex.loaded = function()
	for mod in M.module.loaded() do
		for k, v in pairs(mod) do
			tex.print("Loaded:", k, v)
			tex.print([[\\]])
		end
	end
end

M.sql = require('nex-db')
M.tex.var.db = M.sql:new(M.db3, "TeX")
M.tex.var.db:create({
	bib = "id TEXT PRIMARY KEY, author TEXT, title TEXT, year INTEGER, journal TEXT",
	gls = "term TEXT PRIMARY KEY, definition TEXT",
	acr = "short TEXT PRIMARY KEY, long TEXT",
	idx = "term TEXT, page INTEGER"
})

M.tex.var.db:insert("acr", "short,long", {
	"'foil', 'First Outer Inner Last'"
})

return M

