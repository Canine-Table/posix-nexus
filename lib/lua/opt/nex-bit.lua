M = {}

M.odd = function(n)
	return (n & 1) == 1
end

M.even = function(n)
	return (n & 1) == 0
end

return M

