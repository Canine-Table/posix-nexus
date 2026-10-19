local M = {}

function M:new(cls, inst)
	if M.oo == nil or type(M.oo) ~= 'table' then
		M.oo = { [cls] = { instance = {} }}
	elseif M.oo[cls] == nil or type(M.oo[cls]) ~= 'table' then
		M.oo[cls] = { instance = {} }
	end

	if M.oo[cls].instance[inst] == nil then
		M.oo[cls].instance[inst] = {}
		self.__index = self
		self.bucket = {}
		self.cached = {}
		setmetatable(M.oo[cls].instance[inst], self)
	end
	return self
end

function M:setProperties(tbl)
	if tbl ~= nil and type(tbl) == 'table' then
		for k,v in pairs(tbl) do
			self.bucket[k] = v
		end
	end
end

function M:pgfProperties()
	local b = self.bucket
	for k,v in pairs({
		linewidth = '10',
		baseline = '0',
		fill = 'black',
		fillOpacity = '1',
		draw = 'black',
		stroke = 'black',
		strokeOpacity = '2',
		path = 'stroke',
		radius = '1',
		arrow = '->',
		round = {'0','0'},
		rotate = '0',
		wrap = 'picture',
		nodeOptions = '',
		nodeContent = '',
		nodeLocation = 'center',
		layer = 'background layer'
	}) do
		b[k] = b[k] or v
	end
	return b
end

function M:pgfStartingPoint(b)
	p1 = b['p1']
	if p1 == nil then
		self.cached.origin = [[\pgfpointorigin]]
	else
		self.cached.origin = [[\pgfpoint{]] .. p1[1] .. [[cm}{]] .. p1[2] .. [[cm}]]
	end
	return self.cached.origin
end

function M:pgfBaseConfig()
	local b = self:pgfProperties()
	self:pgfStartingPoint(b)
	local round = b['round']

	local base = [[
		\pgfsetarrows{]] .. b.arrow .. [[}
		\color{]] .. b.draw .. [[}
		\pgftransformrotate{]] .. b.rotate .. [[}
		\pgfsetcornersarced{\pgfpoint{]] .. round[1] .. [[pt}{]] .. round[2] .. [[pt}}
		\pgfsetstrokecolor{]] .. b.stroke .. [[}
		\pgfsetstrokeopacity{]] .. b.strokeOpacity .. [[}
		\pgfsetfillcolor{]] .. b.fill .. [[}
		\pgfsetfillopacity{]] .. b.fillOpacity .. [[}
		\pgfsetlinewidth{]] .. b.linewidth .. [[pt}
		\pgfsetbaseline{]] .. b.baseline .. [[pt}
		\pgfpathmoveto{]] .. self.cached.origin .. [[}]]
	self.cached.store = base
	return b
end

function M:pgfScope(b)
	self.cached.store = self.cached.store .. [[
		\pgfusepath{]] .. b.path .. [[}]]

	if b.wrap == 'scope' then
		self.cached.store = [[
			\begin{pgfscope}
				]] .. self.cached.store .. [[
			\end{pgfscope}]]

	elseif b.wrap == 'picture' then
		self.cached.store = [[
			\begin{pgfpicture}
				]] .. self.cached.store .. [[
			\end{pgfpicture}]]
	elseif b.wrap == 'layer' then
		self.cached.store = [[
		\begin{pgfonlayer}{]] .. b.layer .. [[}
			]] .. self.cached.store .. [[
		\end{pgfonlayer}]]
	end
	tex.print(self.cached.store)
end

function M:pgfTriangle()
	local b = self:pgfBaseConfig()
	local p2 = b['p2']
	local p3 = b['p3']
	self.cached.store = self.cached.store .. [[
		\pgfpathlineto{\pgfpoint{]] .. p2[1] .. [[cm}{]] .. p2[2] .. [[cm}}
		\pgfpathlineto{\pgfpoint{]] .. p3[1] .. [[cm}{]] .. p3[2] .. [[cm}}
		\pgfpathclose]]
	self:pgfScope(b)
end

function M:pgfShape2D(shape)
	local b = self:pgfBaseConfig()
	local p2 = b['p2']
	self.cached.store = self.cached.store .. [[
		\pgfpath]] .. shape .. [[{]] .. self.cached.origin .. [[}{\pgfpoint{]] .. p2[1] .. [[cm}{]] .. p2[2] .. [[cm}}]]
	self:pgfScope(b)
end

function M:pgfRadialShape2D(shape)
	local b = self:pgfBaseConfig()
	self.cached.store = self.cached.store .. [[
		\pgfpath]] .. shape .. [[{]] .. self.cached.origin .. [[}{]] .. b.radius .. [[cm}]]
	self:pgfScope(b)
end

function M:pgfRectangle()
	self:pgfShape2D('rectangle')
end

function M:pgfCircle()
	self:pgfRadialShape2D('circle')
end

return M


