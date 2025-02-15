#!/usr/bin/env node
function Int()
{
	Obj.methods(Int);
}

Int.loop = (num, start = 0, stop) => {
	if (Type.isIntegral(num)) {
		if (Type.isIntegral(stop)) {
			if (! Type.isIntegral(start))
				start = 0;
			if (stop > start) {
				if (num < start)
					num = start + (num - start + stop) % (stop - start + 1);
				else if (num > stop)
					num = start + (num - start) % (stop - start + 1);
			}
		}
		return num;
	}
	return 0;
}

Int.range = function* (start = 0, stop, skip = 1)
{
	if (! Type.isIntegral(skip))
		skip = 1;
	if (! Type.isIntegral(start))
		start = 0;
	if (Type.isIntegral(stop) && stop != start) {
		if (start > stop) {
			for (; start >= stop; start -= Math.abs(skip))
				yield start;
		} else {
			for (; start <= stop; start += skip)
				yield start;
		}
	} else {
		while (true) {
			yield start += skip;
		}
	}
}

Int.distribute = (low, up, range) => {
	return Math.ceil((low - range) / (up - range));
}

Int.odd = (num, val) => {
	if (! Type.isDefined(num))
		num = 0;
	if (Type.isTrue(val))
		return num % 2 === 1 ? num : num + 1;
	else
		return num % 2 === 0 ? num : num - 1;
}

