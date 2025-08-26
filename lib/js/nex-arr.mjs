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
