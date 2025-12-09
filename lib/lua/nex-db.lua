
local M = {}

function M:new(db3, name)
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

function M:insert(s, p, t)
	if type(t) ~= "table" or type(s) ~= "string" then
		return false
	end
	local val = ""
	for k, v in pairs(t) do
		if val ~= "" then
			val = val .. ",(" .. v .. ")"
		else
			val = "(" .. v .. ")"
		end
	end
	self.db:exec(string.format("INSERT INTO %s (%s) VALUES %s;", s, p, val))
	return true
end

-- (1, 'Alice', 25) ON CONFLICT(%s) DO UPDATE SET


return M

