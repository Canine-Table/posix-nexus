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

M.trim = function(s)
	return tostring(s):match("^%s*(.-)%s*$")
end

M.isZ = function(n, b)
	if tostring(b) == "true" then
		n = M.trim(n):match("^[-+]?%d+$")
	else
		n = M.trim(n):match("^%d+$")
	end
	return n or "NaN"
end

M.isQ = function(n, b)
	if tostring(b) == "true" then
		n = M.trim(n):match("^[-+]?%d+[.]%d+$")
	else
		n = M.trim(n):match("^%d+[.]%d+$")
	end
	return n or "NaN"
end

M.isR = function(n, b)
	local r = M.isZ(n, b)
	return r == "NaN" and M.isQ(n, b) or r
end

M.isZdn = function(n, s, e, b)
	return M.isDomain(M.isZ(n), M.isZ(s), M.isZ(e), b)
end

M.isQdn = function(n, s, e, b)
	return M.isDomain(M.isQ(n), M.isQ(s), M.isQ(e), b)
end

M.isRdn = function(n, s, e, b)
	return M.isDomain(M.isR(n), M.isR(s), M.isR(e), b)
end

M.isDomain = function(n, s, e, b)
	s = tonumber(s)
	e = tonumber(e)
	n = tonumber(n)
	return tostring(n ~= nil and (tostring(b) == "true" and (n == e or n == s) or e > n and n > s))
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

