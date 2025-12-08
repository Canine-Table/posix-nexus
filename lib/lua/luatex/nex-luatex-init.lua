--[=[
	This function initializes a custom POSIX-based LuaTeX setup.
]=]

kpse.set_program_name("luatex")

local M = {}
M.module = require('nex-module')
M.system = M.module.load['nex-system']
M.int = M.module.load['nex-int']
M.data = M.module.load['nex-data']
M.str = M.module.load['nex-str']
M.bool = M.module.load['nex-bool']

M.tex = {}
M.tex.var = {}
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

M.clua = {
	lsqlite3 = kpse.find_file("lsqlite3", "clua")
}
package.loadlib(M.clua.lsqlite3, "luaopen_lsqlite3")()

--assert(open, "luaopen_lsqlite3 symbol not found in lsqlite3.so")
--local mod = open()
--package.preload["lsqlite3"] = function() return mod end
--M.db3 = M.module.load['lsqlite3']
--db3 = require("lsqlite3")

--local db3 = require("lsqlite3")
-- Add LuaRocks local install paths


--local db3 = require("luasql/sqlite3")
-- local db3 = require("/home/user/.luarocks/lib/lua/6.4/lsqlite3")

--[=[


local ver = _VERSION:match("%d+%.%d+")
local home = os.getenv("HOME")
package.path  = home .. "/.luarocks/share/lua/" .. ver .. "/?.lua;" ..
	home .. "/.luarocks/share/lua/" .. ver .. "/?/init.lua;" ..
	package.path
package.cpath = home .. "/.luarocks/lib/lua/" .. ver .. "/?.so;" ..
	"/usr/lib/lua/" .. ver .. "/?.so;" ..
	package.cpath



M.sql = M.module.load['nex-db']
M.tex.var.db = M.sql:new("TeX")
M.tex.var.db:create({
	bib = "id TEXT PRIMARY KEY, author TEXT, title TEXT, year INTEGER, journal TEXT",
	gls = "term TEXT PRIMARY KEY, definition TEXT",
	acr = "short TEXT PRIMARY KEY, long TEXT",
	idx = "term TEXT, page INTEGER"
})


--]=]
--]=]

return M

