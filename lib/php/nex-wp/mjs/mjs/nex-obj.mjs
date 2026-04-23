import { nxType } from './nex-type.mjs';

export function nxObj()
{
	nxObj.methods(nxObj);
}

nxObj.toArray = (o, s = null, t = true) => {
	let a = [];
	if (!nxType(o))
		return a;
	if ((typeof o === 'string' || o instanceof String) && nxType.isDefined(s))
		return String(o).split(new RegExp(t === true ? `\\s*${s}\\s*` : s));
	if (typeof o !== 'object' && typeof o !== 'function')
		return [o];
	if (Array.isArray(o)) {
		a = [...o];
	} else if (o instanceof Map) {
		o.forEach((k,v) => { a.push(v,k)});
	} else if (o instanceof Set || typeof o[Symbol.iterator] === "function") {
		a = Array.from(o);
	} else if (typeof o.length === "number" && o.length >= 0) {
		try {
			a = Array.from(o);
		} catch {
			return [o];
		}
	} else if (typeof o === 'object') {
		a = [o];
	} else {
		return [o];
	}
	return a.filter(i => nxType(i));
}

nxObj.reflect = o => {
	if (o === null || o === undefined)
		return [];
	if (nxType.isPrimitive(o) && typeof o !== 'string') {
		o = {
			boolean: Boolean
		}[typeof o];
	} else if (o instanceof Object) {
		const p = Reflect.ownKeys(Object.getPrototypeOf(o));
		if (p.length === 1)
			return Reflect.ownKeys(o);
		else
			return p;
	}
	return Reflect.ownKeys(Object.getPrototypeOf(o).constructor.prototype);
}

nxObj.methods = v => {
	const ex = new Set(['length', 'name', 'arguments', 'caller', 'prototype', 'constructor']);
	console.log(nxObj.reflect(v)?.filter(i => !ex.has(i)));
}

nxObj.isProp = (o, p) => {
	return nxObj.toArray(nxObj.reflect(o)).indexOf(p) !== -1;
}

