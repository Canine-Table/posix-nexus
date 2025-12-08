local M = {}

M.os = function()
	return package.config:sub(1,1) == '/'
end

M.path = function(b)
	local p = debug.getinfo(1, 'S').source:sub(2)
	local s = '/'
	if not M.os() then
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

M.cat = function(f)
	return M.os() and 'cat "' .. f .. '"' or 'pwsh -c \'Get-Content -Path "' .. f .. '"\''
end

M.pwd = function()
	return M.os() and 'pwd' or 'pwsh -c "(Get-Location).Path"'
end

M.ls = function(p)
	return M.os() and 'ls "' .. p .. '"' or 'pwsh -c \'(Get-ChildItem -Path "'.. p ..'").VersionInfo.FileName\''
end

M.pfh = function(c)
	local p = io.popen(c)
	if p then
		return p
	end
	return false, 'Error: Could not run command ' .. c
end

M.fh = function(p)
	local f = io.open(p, m or 'r')
	if f then
		return f
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

M.leafs = function(c, l)
	c = c or M.path(true)
	l = l or M.path(false)
	local r = M.path()
	local p = c .. l
	local fh = assert(M.pfh(M.ls(c)), 'error listing files')
	return coroutine.wrap(function()
		for ln in fh:lines() do
			if not (ln == p or ln == r) then
				coroutine.yield(ln)
			end
		end
		fh:close()
		return false
	end)
end

return M

