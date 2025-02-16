#!/usr/bin/env node
function Str()
{
	Obj.methods(Str);
}

Str.join = (val, str, sep = '') => {
	if (Type.isDefined(val))
		val = val + sep;
	return val + str;
}

Str.camelCase = val => {
	return val.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, (mth, i) => {
		if (+mth === 0)
			return "";
		return i === 0 ? mth.toLowerCase() : mth.toUpperCase();
	});
}

Str.titleCase = val => {
	let s = '';
	Type.isArray(val,  ' ').forEach(i => {
		s = Str.join(s, i.charAt(0).toUpperCase() + i.slice(1), ' ');
	});
	return s;
}

Str.remove = (val, mth = 'null|undefined') => {
	return val.replace(new RegExp(`(^ *| +)(${mth})( +| *$)`, "g"), " ").trim();
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

Str.conditional = (val, pre = '', post = '') => {
	if (Type.isDefined(val))
		return `${pre}${val}${post}`;
	return '';
}
