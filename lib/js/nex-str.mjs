
import { nxObj } from './nex-obj.mjs';
import { nxType } from './nex-type.mjs';
import { nxArr } from './nex-arr.mjs';
import { nxRegx } from './nex-regx.mjs';

export function nxStr()
{
	return nxObj.methods(nxStr);
}

nxStr.normalize = v => {
	return String(v).trim().toLowerCase();
}

nxStr.sanitize = v => {
	return v.replace(/[^a-zA-Z0-9]/g, '');
}

nxStr.join = ({ from, to, chop }) => {
	return (nxType.defined(to)) ? `${to}${chop ?? ''}${from}` : `${from}`;
}

nxStr.replace = ({ from, find, set }) => {
	const __ = new RegExp(`(^\\s*|\\s+)${find ?? 'null|undefined'}(\\s+|\\s*$)`, "g");
	return String(from).replace(__, ' ').replace(/ +/g, set ?? ' ').trim();
}

nxStr.camelCase = v => {
	const __ = [ nxRegx.wordSeparator(v).toLowerCase(), 0 ];
	__[1] = __[0].indexOf(' ');
	return __[0].slice(0, __[1]) + __[0].slice(__[1]).replace(/ .?/g, (m, _) => {
		return m.charAt(1).toUpperCase();
	});
}

nxStr.upper = () => {
	return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
}

nxStr.lower = () => {
	return 'abcdefghijklmnopqrstuvwxyz';
}

nxStr.digit = () => {
	return '0123456789';
}

nxStr.punct = () => {
	return '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
}

nxStr.alpha = () => {
	return nxStr.upper() + nxStr.lower();
}

nxStr.alnum = () => {
	return nxStr.alpha() + nxStr.digit();
}

nxStr.graph = () => {
	return nxStr.alnum() + nxStr.punct();
}

nxStr.random = ({ from, chop, size }) => {
	const __ = [ chop ?? ',', [], 0, '' ];
	nxArr.compare({
		'left': new Set(nxArr.getList(from ?? 'alnum', __[0])),
		'right': [ 'alnum', 'digit', 'graph', 'lower', 'upper', 'alpha', 'punct' ],
		'bind': 'intersect',
		'chop': __[0]
	}).forEach(i => __[1].push(... nxStr[i]().split('')));
	__[2] = __[1].length;
	for (let i = (Number(size) > 0) ? Number(size) : 16; i > 0; --i)
		__[3] += __[1][Math.floor(Math.random() * __[2])];
	return __[3];
}

nxStr.lastChar = ({ from, chop }) => {
	if (nxType.defined(from))
		return from.slice(from.lastIndexOf(chop ?? ' ') + 1);
	return '';
}

