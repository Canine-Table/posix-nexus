local M = {}
M.oop = {}

function M:new(cls, inst)
	if type(M.oop[cls]) ~= "table" then
		M.oop[cls] = {}
	end

	--[=[self.__index = self
	setmetatable(this, self)
	return this--]=]
end

