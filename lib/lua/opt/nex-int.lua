local M = {}

M.range = function(n1, n2, n3)
	return coroutine.wrap(function()
		for i = n2 or 1, n1 or 1, n3 or 1 do
			coroutine.yield(i)
		end
	end)
end

return M

