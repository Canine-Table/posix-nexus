#!/usr/bin/env node
function Arr()
{
	Obj.methods(Arr);
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
	return 	Arr.search(val, arr, 0, sep);
}

Arr.end = (val, arr, sep) => {
	return 	Arr.search(val, arr, 2, sep);
}

Arr.within = (val, arr, sep) => {
	return 	Arr.search(val, arr, 1, sep);
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
	if (Type.isDefined(val)) {
	opt = Type.isArray(opt, sep)
	console.log(opt);
	opt = Arr.start(val, opt, sep);
	console.log(opt);
	opt = Arr.shortest(opt, sep);
	console.log(opt);
	return opt;
	}
}
