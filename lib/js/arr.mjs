#!/usr/bin/env node
function Arr()
{
	Obj.methods(Arr);
}

Arr.add = (val, arr, sep = ',') => {
	return Type.isArray(val, sep).concat(Type.isArray(arr, sep));
}

Arr.search = (val, arr, act, sep = ',') => {
	if (Type.isDefined(val)) {
		arr = Type.isArray(arr, sep);
		if (Type.isArray(arr)) {
			switch (act) {
				case 1:
					act = 'includes';
					break;
				case 2:
					act = 'endsWith';
					break;
				default:
					act = 'startsWith';
			}
			return arr.filter(i => i[act](val));
		}
	}
}

Arr.start = (val, arr, sep) => {
	return	Arr.search(val, arr, 0, sep);
}

Arr.end = (val, arr, sep) => {
	return	Arr.search(val, arr, 2, sep);
}

Arr.within = (val, arr, sep) => {
	return	Arr.search(val, arr, 1, sep);
}

Arr.in = (val, arr, sep = ',') => {
	return Type.isArray(arr, sep).indexOf(val) !== -1;
}

Arr.lengths = (val, sep = ',', act) => {
	if (! Type.isDefined(val))
		return 0;
	return Type.isArray(val, sep).reduce((c, m) => {
		if (Type.isTrue(act))
			return c.length > m.length ? c : m;
		else
			return c.length < m.length ? c : m;
	}).length;
}

Arr.lengthMatch = (val, sep, len) => {
	if (Type.isIntegral(len) && len > 0) {
		return Type.isArray(val, sep).filter(s => s.length === len);
	}
}

Arr.extremeMatch = (val, sep = ',', ext) => {
	val = Type.isArray(val, sep);
	val = Arr.lengthMatch(val, sep, Arr.lengths(val, sep, ext));
	return val.length > 1 ? val : val[0];
}
Arr.shortest = (val, sep = ',') => {
	return Arr.extremeMatch(Type.isArray(val, sep), sep, 0);
}

Arr.longest = (val, sep = ',') => {
	return Arr.extremeMatch(Type.isArray(val, sep), sep, 1);
}

Arr.explode = val => {
	if (Type.isDefined(val))
		return val.split('');
}

Arr.difference = (arrA, arrB, side, sep = ',') => {
	let tmp = '';
	if (Type.isTrue(side)) {
		tmp = Type.isArray(arrB, sep);
		arrB = Type.isArray(arrA, sep);
		arrA = tmp;
	} else {
		arrA = Type.isArray(arrA, sep);
		arrB = Type.isArray(arrB, sep);
	}
	tmp = [];
	arrA.forEach(i => {
		if (! Arr.in(i, arrB))
			tmp.push(i);
	});
	if (! Type.isDefined(side)) {
		arrB.forEach(i => {
			if (! Arr.in(i, arrA))
				tmp.push(i);
		});
	}
	return tmp;
}

Arr.left = (arrA, arrB, sep = ',') => {
	return Arr.difference(arrA, arrB, 0, sep);
}

Arr.right = (arrA, arrB, sep = ',') => {
	return Arr.difference(arrA, arrB, 1, sep);
}

Arr.shortStart = (val, opt, sep = ',', def) => {
	if (Type.isDefined(val))
		return Arr.shortest(Arr.start(val, Type.isArray(opt, sep), sep), sep);
}

Arr.rotate = (arr, steps, sep = ',') => {
	const res = [];
	arr = Type.isArray(arr, sep);
	const len = arr.length;
	for (let i = 0; i < len; i++) {
		res[Int.loop(i + steps, 0, len - 1)] = arr[i];
	}
	return res;
}

Arr.query = function* (val, obj, sep = ',')
{
	val = Type.isArray(val, sep);
	if (Type.isArray(obj)) {
		obj.forEach(i => {
			if (Type.isDefined(val[i]))
				yield val[i];
		});
	} else {
		if (Type.isObject(obj)) {
			if (! Type.isDefined(obj.stop) || obj.stop < 1)
				obj.stop = val.length
			if (! Type.isDefined(obj.start) || obj.start === obj.start || obj.start >= val.length)
				obj.start = 0;
			if (Type.isDefined(obj.odd)) {
				obj.start = Int.odd(obj.start, obj.odd);
				obj.skip = 2;
			}
		} else {
			obj = {
				'start': 0,
				'stop': val.length - 1,
				'skip': 1
			}
		}
		for (let i of Int.range(obj.start, obj.stop - 1, obj.skip)) {
			yield val[i];
	}
}
