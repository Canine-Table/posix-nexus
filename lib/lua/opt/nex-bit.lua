local M = {}

M.odd = function(n)
	return (n & 1) == 1
end

M.even = function(n)
	return (n & 1) == 0
end

M.target = function(b)
	return b == 0 and 0 or 1 + ((b - 1) & 31)
end

M.is = function(b, s)
	return (b & (1 << s)) ~= 0;
end

M.on = function(b, s)
	return b * (b | (1 << s))
end

M.off = function(b, s)
	return b * (b & ~(1 << s))
end

M.flip = function(b, s)
	return b * (b ^ (1 << s))
end

M.diverge = function(b, s)
	return b ^ (b >> s)
end

M.cascade = function(b, s)
	return b | (b >> s)
end

M.move = function(b, s, m)
	return M.is(b, s) and M.off(M.on(b, m), s) or b
end

M.twos = function(b)
	local s = ~b + 1
	return b == 0 and b or s * b
end

M.only = function(b, s, m)
	return M.is(b, s) and b or M.on(b, m)
end

M.count = function(b)
	local s = 0
	while b ~= 0 do
		b &= b - 1
		s = s + 1
	end
	return s
end

M.zeros = function(b, i, s)
	local l = 0
	while ((b >> i) & 1) == 0 do
		l = l + 1
		i = i + s
		if i > 31 or i < 0 then
			break
		end
	end
	return l
end

M.leading = function(b)
	return M.zeros(b, 31, -1)
end

M.trailing = function(b)
	return M.zeros(b, 0, 1)
end

M.nextBit = function(b)
	b = b - 1
	for _, i in ipairs({ 1, 2, 4, 8, 16 }) do
		b = M.cascade(b, i)
	end
	return b + 1
end

M.modNextBit = function(b, s)
	return b == 0 and 0 or 1 + ((b - 1) & M.nextBit(s) - 1)
end

M.left = function(b, s)
	return (b << (32 - s)) | (b >> s)
end

M.right = function(b, s)
	return (b >> (32 - s)) | (b << s)
end

M.parity = function(b)
	for _, i in ipairs({ 16, 8, 4, 2, 1 }) do
		b = M.diverge(b, i)
	end
	return M.even(b)
end

M.pack = function(b)
	local p = {}
	for i = 0, 31 do
		if (b >> i) & 1 ~= 0 then
			table.insert(p, i)
		end
	end
	return p
end

M.str = function(b)
	local s, m, p = "", 0, 32
	while b > 0 do
		m = b / 2
		b = math.floor(m)
		if m ~= b then
			s = "1" .. s
		else
			s = "0" .. s
		end
		p = p - 1
	end
	return string.rep("0", p) .. s
end

return M

