M = {}

M.stack = {}

function M.stack:new()
	local this = { items = {} }
	setmetatable(this, self)
	self.__index = self
	return this
end

function M.stack:push(i)
	table.insert(self.items, i)
end

function M.stack:pop()
	return table.remove(self.items)
end

function M.stack:peek()
	return self.items[#self.items]
end

function M.stack:isEmpty()
	return #self.items == 0
end

function M.stack:size()
	return #self.items
end

M.queue = {}

function M.queue:new()
	local this = { items = {} }
	setmetatable(this, self)
	self.__index = self
	return this
end

function M.queue:enqueue(i)
	table.insert(self.items, i)
end

function M.queue:dequeue()
	return table.remove(self.items, 1)
end

function M.queue:peek()
	return self.items[1]
end

function M.queue:isEmpty()
	return #self.items == 0
end

function M.queue:size()
	return #self.items
end

M.heap = {}

function M.heap:new()
	return setmetatable({ items = {} }, { __index = self })
end

function M.heap:insert(v)
	table.insert(self.items, v)
	self:heapify_up(#self.items)
end

function M.heap:heapify_up(i)
	local p = math.floor(i / 2)
	if p > 0 and self.items[p] > self.items[i] then
		self.items[p], self.items[i] = self.items[i], self.items[p]
		self:heapify_up(p)
	end
end

M.btree = {}

function M.btree:new(v)
	local this = { value = v, left = nil, right = nil }
	setmetatable(this, self)
	self.__index = self
	return this
end

function M.btree:insert(v)
	if v < self.value then
		if self.left then
			self.left:insert(v)
		else
			self.left = M.btree:new(v)
		end
	else
		if self.right then
			self.right:insert(v)
		else
			self.right = M.btree:new(v)
		end
	end
end

function M.btree:search(v, b)
	local h, l = b and 'left', 'right' or 'right', 'left'
	if self.value == v then
		return self
	elseif v < self.value and self[h] then
		return self[h]:search(v)
	elseif v > self.value and self[l] then
		return self[l]:search(v)
	end
	return nil
end

function M.btree:order()
	local s = M.stack:new()
	local r = M.stack:new()
	local c = self
	while c or not s:isEmpty() do
		while c do
			s:push(c)
			c = c.left
		end
		c = s:pop()
		r:push(c.value)
		c = c.right
	end
	return r
end

function M.btree:prePost(b)
	local s = M.stack:new()
	local r = M.stack:new()
	local h, l = b and 'left', 'right' or 'right', 'left'
	s:push(self)
	while not s:isEmpty() do
		local n = s:pop()
		r:push(n.value)
		if n[h] then
			s:push(n[h])
		end
		if n[l] then
			s:push(n[l])
		end
	end
	return r
end

function M.btree:rotate(b)
	local h, l = b and 'left', 'right' or 'right', 'left'
	local r = self[l]
	if not r then
		return self
	end
	self[l] = r[h]
	r[h] = self
	return r
end

M.tree = {}

function M.tree:new(v)
	local this = { value = v, left = nil, right = nil, height = 1 }
	setmetatable(this, self)
	self.__index = self
	return this
end

function M.tree:rotate(b)
	local h, l = b and 'left', 'right' or 'right', 'left'
	local r = self[l]
	if not r then
		return self
	end
	self[l] = r[h]
	newRoot[h] = self
	self.height = math.max(self.left and self.left.height or 0, self.right and self.right.height or 0) + 1
	r.height = math.max(newRoot.left and newRoot.left.height or 0, newRoot.right and newRoot.right.height or 0) + 1
	return r
end

function M.tree:rebalance()
	local b = (self.left and self.left.height or 0) - (self.right and self.right.height or 0)
	if b > 1 then
		if (self.left.left and self.left.left.height or 0) < (self.left.right and self.left.right.height or 0) then
			self.left = self.left:rotate(false)
		end
		return self:rotate(true)
	elseif b < -1 then
		if (self.right.right and self.right.right.height or 0) < (self.right.left and self.right.left.height or 0) then
			self.right = self.right:rotate(true)
		end
		return self:rotate(false)
	end
	return self
end

function M.tree:insert(v)
	if v < self.value then
		if self.left then
			self.left = self.left:insert(v)
		else
			self.left = M.tree:new(v)
		end
	else
		if self.right then
			self.right = self.right:insert(v)
		else
			self.right = M.tree:new(v)
		end
	end
	self.height = math.max(self.left and self.left.height or 0, self.right and self.right.height or 0) + 1
	return self:rebalance()
end

return M

