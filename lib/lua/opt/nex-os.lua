local M = {}

M.system = function()
	return package.config:sub(1,1) == '/'
end

M.path = function(b)
	local p = debug.getinfo(1, 'S').source:sub(2)
	local s = '/'
	if not M.system() then
		s = '\\'
	end
	if b == nil then
		return p
	elseif b == true then
		return p:match('.*' .. s)
	else
		return p:match('[^' .. s .. ']+$')
	end
end

M.ls = function(c, e)
	c = c or M.path(true)
	e = e or 'lua'
	return M.system() and 'ls ' .. c .. '*.' .. e or 'dir /b ' .. c .. ' | findstr \\.' .. e
end

M.leafs = function(c, l, e)
	e = e or 'lua'
	c = c or M.path(true)
	l = l or M.path(false)
	local r = M.path()
	local p = c .. l
	local fh = assert(io.popen(M.ls(c, e)), 'error listing files')
	return coroutine.wrap(function()
		for ln in fh:lines() do
			if not (ln == p or ln == r) then
				coroutine.yield(ln)
			end
		end
		fh:close()
		return true
	end)
end

M.fh = function(p, m, b)
	local f = io.open(p, m or 'r')
	if f then
		if not b then
			return f
		else
			f:close()
			return true
		end
	end
	return false, 'Error: Could not open file ' .. p .. ' in ' .. (m or 'r') .. ' mode!'
end

M.fwrite = function(p, m, d, b)
	local f, e = M.fh(p, m or 'a')
	if not f then
		return false, e
	end
	b = b and "" or "\n"
	f:write(d .. b)
	f:close()
	return true
end

M.fread = function(p, m)
	return coroutine.wrap(function()
		local f, e = M.fh(p, m or 'r')
		if not f then
			coroutine.yield(nil)
			coroutine.yield(e)
			return
		end
		for l in f:lines() do
			coroutine.yield(l)
		end
		f:close()
		return true
	end)
end

return M

