local M = {}

M.split = function(inpt, sep)
	local tbl = {}
	for str in string.gmatch(inpt, "([^" .. sep .. "]+)") do
		table.insert(tbl, str)
	end
	return tbl
end

M.join = function(str, inpt, sep)
	if str ~= '' then
		return str .. sep .. inpt
	end
	return str .. inpt
end

M.merge = function(inpt, sep)
	local str = ''
	for _, word in ipairs(inpt) do
		str = M.join(str, word, sep)
	end
	return str
end

M.title = function(inpt)
	return inpt:sub(1,1):upper() .. inpt:sub(2):lower()
end

M.totitle = function(inpt, sep, osep)
	osep = osep or sep
	local str = ''
	for _, word in ipairs(M.split(inpt, sep)) do
		str = M.join(str, M.title(word), osep)
	end
	return str
end

return M

