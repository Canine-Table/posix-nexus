import { nxObj } from './nex-obj.mjs';
import { nxType } from './nex-type.mjs';

export function nxArr()
{
	return nxObj.methods(nxArr);
}

nxArr.toList = (v, d) => {
	if (nxType.isList(v))
		return d ? v : true;
	else if (nxType.defined(v) && ! nxType.isObject(v))
		return d ? String(v).split(new RegExp(`\\s*${d}\\s*`)) : false;
	else
		return d ? [] : false;
}

nxArr.getList = (v, d) => {
	return nxArr.toList(v, d ?? ',');
}

nxArr.merge = (f, t, c) => {
	const __ = c ?? ',';
	return nxArr.toList(t, __).concat(nxArr.toList(f, __));
}

nxArr.wrap = v => {
	return nxArr.getList((nxType.isList(v)) ? v : [v]);
}

nxArr.search = ({ find, from, chop, bind }) => {
	from = nxArr.getList(from, chop);
	if (nxType.defined(find)) {
		switch (bind) {
			case 'includes':
			case 'endsWith':
			case 'startsWith':
				break;
			default:
				bind = 'startsWith';
		}
		return from.filter(i => i[bind](find));
	}
	return from;

}

nxArr.start = ({ find, from, chop }) => {
	return nxArr.search({
		'find': find,
		'from': from,
		'chop': chop,
		'bind': 'startsWith'
	});
}

nxArr.end = ({ find, from, chop }) => {
	return nxArr.search({
		'find': find,
		'from': from,
		'chop': chop,
		'bind': 'endsWith'
	});
}

nxArr.in = ({ find, from, chop }) => {
	return nxArr.search({
		'find': find,
		'from': from,
		'chop': chop,
		'bind': 'includes'
	});
}

nxArr.isIn = ({ find, from, chop }) => {
	return nxArr.getList(from, chop).indexOf(find) !== -1;
}

nxArr.lengthLeader = ({ from, chop, bind }) => {
	if (! Type.isDefined(from))
		return 0;
	return nxArr.getList(from, chop).reduce((c, m) => {
		if (nxType.isTrue(bind))
			return c.length > m.length ? c : m;
		else
			return c.length < m.length ? c : m;
	}).length;
}

nxArr.maxLength = (from, chop) => {
	return nxArr.lengthLeader({
		'from': from,
		'bind': true,
		'chop': chop
	});
}

nxArr.minLength = (from, chop) => {
	return nxArr.lengthLeader({
		'from': from,
		'bind': false,
		'chop': chop
	});
}

nxArr.matchLength = ({ from, length, chop }) => {
	return ((length = Number(length)) && length > 0) ? nxArr.getList(from, chop).filter(i => i.length === length) : 0;
}

nxArr.compare = ({ left, right, bind, chop }) => {
	chop = nxType.defined(chop, ',');
	const mid = [];
	if ((left = nxArr.toList(left, chop)) && (right = nxArr.toList(right, chop))) {
		left.forEach(i => {
			if (nxArr.isIn({ 'find': i, 'from': right, 'chop': chop }) === (bind === 'intersect'))
				return mid.push(i);
		});
		if (bind === 'difference') {
			right.forEach(i => {
				if (! nxArr.isIn({ 'find': i, 'from': left, 'chop': chop }))
					return mid.push(i);
			});
		}
	}
	return mid;
}

nxArr.omit = ({ from, omit, chop }) => {
	const __ = new Set(nxArr.getList(omit, chop));
	return [ ... nxArr.getList(from, chop)].filter(i => ! __.has(i));
}

nxArr.defined = (from, chop) => {
	return nxArr.getList(from, chop).filter(i => i !== null && i !== undefined && !/^(null|undefined)$/.test(i));
}

/*
nxArr.flatten = (to, depth) => {
	if (! Array.isArray(to))
		return to;
	const flags = new Uint32Array(Number.isInteger(+depth) ? +depth * 2 + 4 : 2052);
	const stack = [to];
	flags[1] = stack[0].length - 1;
	flags[2] = 5;
	do {
		// for index is less than end step by 1
		for (; flags[0] <= flags[1]; ++flags[0]) {
			// if stack 0 (current list) flag 0 (current index) has a leaf
			if (Array.isArray(stack[0][flags[0]])) {
				if (flags[0] < flags[1]) {
					flags[flags[2]++] = flags[0]; // with the index
					flags[flags[2]++] = flags[1]; // and end of list
					stack.push(stack[0]); // push the rest of it for later
					flags[3]++
				}
				stack[0] = stack[0][flags[0]];
				flags[0] = -1; // new list reset index
				flags[1] = stack[0].length - 1; // new list, new length/end of list
			} else {
				console.dir(stack[0])
				to[flags[4]++] = stack[0][flags[0]];
			}
		}
		// if flag[0] (the active list index) is greater than 0, its not a been reset (had a leaf)
		// if flag[2] > 3 (non meta indexes) its still nested
		if (flags[0] > 0 && flags[3] > 0) {
			flags[1] = flags[--flags[2]]; // end
			flags[0] = flags[--flags[2]] + 1; // index
			stack[0] = stack.pop();
			flags[3]--;
		}
		// continue if nested or the popped stack list has not ended
	} while (flags[3] > 0 || flags[0] < flags[1]);
	return to;
}
*/
