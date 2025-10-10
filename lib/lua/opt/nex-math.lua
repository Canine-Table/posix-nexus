--[=[
	rt:	Right Angle Trigonometry
]=]


M = {}

M.trig_ratios = {}


M.t_pythagorean = function(n1, n2)
	return n1^2 + n2^2
end

M.rt_ratios = function(n1, n2)
	return math.sqrt(M.t_pythagorean(n1, n2))
end

M.t_angle = function(n1, n2)
	n2 = n2 or 90
	return 180 - n1 - n2
end

M.sin = function(n1, n2)
	return math.deg(math.sin(n1)) / n2
end

M.cos = function(n1, n2)
	return math.deg(math.cos(n1)) / n2
end

M.tan = function(n1, n2)
	return math.deg(math.tan(n1)) / n2
end

--[=[
	print(M.trig_ratios(25.6, 11.7))
	print(M.t_angle(62))
]=]


--print(M.sin(62, 24.1))


