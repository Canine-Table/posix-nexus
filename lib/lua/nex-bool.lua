local M = {}

M.xor = function(a, b)
	return (a and not b) or (not a and b)
end

return M
