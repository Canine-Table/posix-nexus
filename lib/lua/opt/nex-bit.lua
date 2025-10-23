M.bit = {}

M.bit.odd = function(n)
	return (n & 1) == 1
end

M.bit.even = function(n)
	return (n & 1) == 0
end

return M
