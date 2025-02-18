#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
import { Str } from './str.mjs';
export function Int()
{
	Obj.methods(Int);
}

Int.loop = (num, start = 0, stop) => {
	if (Type.isFloat(num)) {
		num = Number(num);
		if (Type.isFloat(stop)) {
			stop = Number(stop);
			if (! Type.isFloat(start))
				start = 0;
			start = Number(start);
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

Int.direction = function* (start = 0, stop, skip = 1)
{
	if (! Type.isFloat(skip))
		skip = 1;
	skip = Number(skip);
	if (! Type.isFloat(start))
		start = 0;
	start = Number(start);
	if (Type.isFloat(stop) && Number(stop) != start) {
		stop = Number(stop);
		if (start > stop) {
			for (; start >= stop; start -= Math.abs(skip))
				yield start;
		} else {
			for (; start <= stop; start += Math.abs(skip))
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

Int.randomRange = (stop, start = 0) => {
	if (Type.isIntegral(start) && Type.isIntegral(stop))
		return Int.loop(Int.wholeRandom(), start, stop - 1);
}

Int.wholeRandom = () => {
	return Number(Str.lastChar(`${Math.random()}`, '.'));
}

Int.odd = (num, val) => {
	if (! Type.isDefined(num))
		num = 0;
	num = Number(num);
	if (Type.isTrue(val))
		return num % 2 === 1 ? num : num + 1;
	else
		return num % 2 === 0 ? num : num - 1;
}

Int.isPos = val => {
	return Math.sign(val) >= 0;
}

Int.isNeg = val => {
	return Math.sign(val) <= -0;
}

