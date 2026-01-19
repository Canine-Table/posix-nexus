
local M = {}

M.visibleSpaces = function(s)
	s = string.gsub(s, [[ ]], [[{\textvisiblespace}]])
	tex.print(s)
end

return M
