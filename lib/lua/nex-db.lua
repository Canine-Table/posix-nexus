
local M = {}

local db3 = requires('lsqlite3')

function M:new(name)
	local p = os.getenv("NEXUS_CNF") .. "/db/" .. (name or "default") .. ".db"
	local this = {
		path = p,
		db = db3.open(p)
	}
	self.__index = self
	setmetatable(this, self)
	return this
end

function M:create(t)
	if type(t) ~= "table" then
		return false
	end
	for k, v in pairs(t) do
		self.db:exec(string.format("CREATE TABLE IF NOT EXISTS %s (%s);", k, v))
	end
	return true
end

return M

