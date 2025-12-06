
local M = {}

M.sec = {}

function M.sec:new()
	local this = {
		[1] = {
			index = 0,
			label = "",
			name = "section"
		},
		[2] = {
			index = 0,
			label = "",
			name = "sub section"
			
		},
		[3] = {
			index = 0,
			label = "",
			name = "sub sub section"
		},
		label = "section",
		name = "section",
		macro = "section",
		footer = [[\fancyfoot[LE, RO]{}]]
	}
	self.__index = self
	setmetatable(this, self)
	return this
end

function M.sec:set(n, l)
	local f = self[n]
	local b
	if f then
		if l ~= nil then
			self[n].name = l
			self.name = l
		end
		self[n].index = self[n].index + 1
		self.macro = "section"
		local s = self[1].name .. "<" .. self[1].index .. ">"
		self.footer = [[\fancyfoot[LE, RO]{\nxLnBox{\hyperref[]] .. s .. [[]{]] .. self[1].index .. [[}}]]
		if n > 1 then
			self.macro = "sub" .. self.macro
			s = s .. ":" .. self[2].name .. "<" .. self[2].index .. ">"
			self.footer = self.footer .. [[$\;\cdot\;$\nxLnBox{\hyperref[]] .. s .. [[]{]] .. self[2].index .. [[}}]]
		else
			self[2].index = 0
		end
		if n > 2 then
			self.macro = "sub" .. self.macro
			s = s .. ":" .. self[3].name .. "<" .. self[3].index .. ">"
			self.footer = self.footer .. [[$\;\cdot\;$\nxLnBox{\hyperref[]] .. s .. [[]{]] .. self[3].index .. [[}}]]
		else
			self[3].index = 0
		end
		self[n].label = s
		self.footer = self.footer .. [[}]]
		self.label = s
		self:write(n)
	end
end

function M.sec:write(n)
	local f = self
	if f then
		tex.print([[\label{]] .. f.label .. [[}\]] .. f.macro .. [[{]] .. f.name .. [[}]] .. f.footer)
	end
end

return M

