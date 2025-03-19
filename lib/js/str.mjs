#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
export function Str()
{
	Obj.methods(Str);
}

Str.join = (val, str, sep = '') => {
	if (Type.isDefined(val))
		val = val + sep;
	return val + str;
}

Str.merge = (val1, val2, def1 = ' ', def2 = ' ', sep = ' ') => {
	return Str.join(Type.isDefined(val1, def1), Type.isDefined(val2, def2), sep);
}

Str.toLower = val => {
	if (Type.isDefined(val))
		return val.toLowerCase();
}

Str.toUpper = val => {
	if (Type.isDefined(val))
		return val.toUpperCase();
}

Str.camelCase = val => {
	const s = val.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, (mth, i) => {
		if (+mth === 0)
			return "";
		return i === 0 ? mth.toLowerCase() : mth.toUpperCase();
	});
	return s.charAt(0).toLowerCase() + s.slice(1);
}

Str.titleCase = val => {
	let s = '';
	Type.isArray(val,  ' ').forEach(i => {
		s = Str.join(s, i.charAt(0).toUpperCase() + i.slice(1).toLowerCase(), ' ');
	});

	return s;
}

Str.camelTitleCase = val => {
	if (Type.isDefined(val)) {
		let str = '';
		for (const match of val.matchAll(/(\B[A-Z][a-z]+|^[a-z]+)/g))
			str = Str.join(str, match[0], ' ');
		return str.charAt(0).toUpperCase() + str.slice(1);
	}
}

Str.joinCase = (val, rpl = '', fnd = '\\s+') => {
	let s = '';
	Type.isArray(val, fnd).forEach(i => {
		s = Str.join(s, Str.toLower(i), rpl);
	});
	return s;
}

Str.kebabCase = val => {
	return Str.joinCase(val, '-');
}

Str.snakeCase = val => {
	return Str.joinCase(val, '_');
}

Str.remove = (val, mth = 'null|undefined') => {
	return String(val).replace(new RegExp(`(^ *| +)${mth}( +| *$)`, "g"), " ").replace(/ +/g, ' ').trim();
}

Str.upper = () => {
	return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
}

Str.lower = () => {
	return 'abcdefghijklmnopqrstuvwxyz';
}

Str.digit = () => {
	return '0123456789';
}

Str.xdigit = val => {
	let str = '';
	if (Type.isTrue(val) || ! Type.isDefined(val))
		str = Str.lower().slice(0, 6);
	if (Type.isFalse(val) || ! Type.isDefined(val))
		str += Str.upper().slice(0, 6);
	return str + Str.digit();
}

Str.punct = () => {
	return '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
}

Str.alpha = () => {
	return Str.upper() + Str.lower();
}

Str.alnum = () => {
	return Str.alpha() + Str.digit();
}

Str.graph = () => {
	return Str.alnum() + Str.punct();
}

Str.random = (val, chars = 'alnum', sep = ',') => {
	if (Type.isIntegral(val) && val > 0) {
		let c = '';
		Type.isArray(chars, sep).forEach(a => {
			if (Arr.in(a, ['alnum', 'digit', 'xdigit', 'graph', 'lower', 'upper', 'alpha', 'punct']))
				c += Str[a]();
		});
		c = Arr.explode(Type.isDefined(c, Str.alnum()));
		const l = c.length;
		let r = '';
		for (let i = 0; i < val; i++)
			r += c[Math.floor(Math.random() * l)];
		return r;
	}
}

Str.implode = (val, sep = '') => {
	if (Type.isArray(val))
		return val.join(sep);
	return '';
}

Str.sanitize = val => {
	return val.replace(/[^a-zA-Z0-9]/g, "");
}

Str.lastChar = (str, val) => {
	if (Type.isDefined(str) && Type.isDefined(val)) {
		const idx = str.lastIndexOf(val) + 1;
		if (idx > 0)
			return str.slice(idx);
	}
}

Str.conditional = (val, pre = '', post = '') => {
	if (Type.isDefined(val))
		return `${pre}${val}${post}`;
	return '';
}

Str.numericWords = val => {
	if (Type.isIntegral) {
		const to19 =  [
			'zero',  'one',   'two',  'three', 'four',  'five', 'six',
			'seven', 'eight', 'nine', 'ten',   'eleven', 'twelve',
			'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen',
			'eighteen', 'nineteen'
		];
		const tens = [
			'twenty', 'thirty', 'forty', 'fifty',
			'sixty', 'seventy', 'eighty', 'ninety'
		];
		const denom = [
			'', 'thousand', 'million', 'billion', 'trillion', 'quadrillion',
			'quintillion', 'sextillion', 'septillion', 'octillion', 'nonillion',
			'decillion', 'undecillion', 'duodecillion', 'tredecillion',
			'quattuordecillion', 'sexdecillion', 'septendecillion',
			'octodecillion', 'novemdecillion', 'vigintillion'
		];
	}
}
