local M = {}
M.oop = {}

function M:new(cls, inst)
	if type(M.oop[cls]) ~= "table" then
		M.oop[cls] = { "instance" = {} }
	end
	if M.oop[cls].instance[inst] == nil then
		M.oop[cls].instance[inst] = {}
		self.__index = self
		setmetatable(M.oop[cls].instance[inst], self)
	end
	return M.oop[cls].instance[inst]
end

return M
