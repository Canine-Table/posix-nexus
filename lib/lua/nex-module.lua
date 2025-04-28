M = {}

M.load = setmetatable({}, {
	__index = function(t, k)
		if package.loaded[k] then
			package.loaded[k] = nil
		end
		local s, m = pcall(require, k)
		if s then
			rawset(t, k, {
				module = m,
				count = (t[k] and t[k].count or 0) + 1,
				last = os.time()
			})
			return t[k].module
		else
			return nil, "Error loading module: " .. k
		end
	end
})

M.last = function(p)
	return os.date("%Y-%m-%d %H:%M:%S", M.load[p].last)
end

M.loaded = function()
	return coroutine.wrap(function()
		for k, v in pairs(package.loaded) do
			coroutine.yield({ [k] = v })
		end
	end)
end

M.path = function()
	return coroutine.wrap(function()
		for p in string.gmatch(package.path, "[^;]+") do
			coroutine.yield(p)
		end
	end)
end

return M

