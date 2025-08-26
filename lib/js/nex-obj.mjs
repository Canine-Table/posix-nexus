
import { nxType } from './nex-type.mjs';
import { nxArr } from './nex-arr.mjs';

export function nxObj()
{
	return nxObj.methods(nxObj);
}

nxObj.reflect = v => {
	if (nxType.isObject(v)) {
		const __ = Reflect.ownKeys(v.prototype);
		return (__.length === 1) ? Reflect.ownKeys(v) : __;
	}
}

nxObj.methods = v => {
	return nxArr.compare({
		'left': nxObj.reflect(v),
		'right': ['length', 'name', 'arguments', 'caller', 'prototype', 'constructor']
	});
}

nxObj.isProp = ({ from, find }) => {
	if (nxType.defined(find) && nxType.isObject(from))
		return nxArr.isIn({
			'from': nxObj.reflect(from),
			'find': find
		});
}


nxObj.assign = ({ to, from, bind }) => {
	if (nxType.isObject(to) && nxType.isObject(from)) {
		if (nxType.defined(bind))
			Object.entries(from).forEach(([k, v]) => to[bind][k] = v);
		else
			Object.entries(from).forEach(([k, v]) => to[k] = v);
	}
}

nxObj.isEmpty = (o) => {
	return	nxType.defined(o)
		&& nxType.isObject(o)
		&& Object.getPrototypeOf(o) === Object.prototype
		&& Object.keys(o).length === 0;
}

nxObj.index = o => {
	if (nxType.isArray(o)) {
		const __ = Object.create(null);
		o.forEach((v, k) => {
			__[k] = v;
		});
		return __;
	}
	if (nxType.isObject(o))
		return Object.fromEntries(Object.entries(o).filter(([k, v]) => Number.isInteger(+k)));
	return nxType.defined(o) ? { '-0': o } : {};
}

nxObj.defined = o => {
	return (nxType.isObject(o)) ? Object.fromEntries(
		Object.entries(o).filter(([_, v]) => v !== null && v !== undefined && !/^(null|undefined)$/.test(v))
	) : nxArr.defined(nxArr.getList(o));
}


nxObj.toPath = ({ path, or }) => {
	const refer = String(path ?? or).split('.');
	const depth = refer.length - 1;
	return function(o) {
		let stem = o;
		const leaf = refer[depth];
		for (let i = 0; i < depth; i++) {
			const k = refer[i];
			stem[k] ??= {};
			stem = stem[k];
		}
		return [ stem, leaf ];
	}
}

nxObj.path = ({ path, or }) => {
	const refer = String(path ?? or).split('.');
	return function(o) {
		return refer.reduce((a, k) => a?.[k], o);
	}
}

nxObj.link = p => {
	p = p.split('.');
	const __ = Object.freeze([ p, p.length - 1 ]);
	return {
		get: (o) => { return __[0].reduce((a, k) => a?.[k], o) },
		set: (o, v) => {
		    for (let i = 0; i <= __[1]; ++i)
			o[__[0][i]] ??= {};
		    o[__[0].at(-1)] = v;
		}
	};
}

nxObj.enum = () => {
	const __ = new Uint32Array(1);
	const e = {};
	return {
		get: (v) => {
			return e?.[v] ? e[v] : undefined;
		},
		set: (o) => {
			nxArr.getList(o).forEach(i => {
				if (! e?.[i])
					e[i] = __[0]++;
			});
		}
	}
}

nxObj.isPlain = o => {
	return Object.prototype.toString.call(o) === '[object Object]';
}

nxObj.merge = ({ from, to }) => {
	const __ = {
		'handler': nxObj.handler.get('test'),
		'from': from,
		'to': to
	};
	__.merge = __.handler(from, to);
	if (__.merge[0] !== 'object')
		return __.merge[1];
	__.flag = {
		'top': 0,
		'keys': 0
	};
	__.stack = [];
	__.list = [];
	do {
		__.list = __.merge[1];
		if (__.merge[0] === 'primitive') {
			if (nxType.defined(__.merge[1]))
				__.to = __.merge[1];
			__.flag.keys = 0;
		} else {
			__.flag.keys = __.list.length;
			while (__.flag.keys > 0) {
				__.flag.keys--;
				const k = __.list.pop();
				__.merge = __.handler(from[k], to[k]);
				if (__.merge[0] === 'object') {
					if (__.list.length > 0) {
						__.stack.push(__.list, __.from, __.to);
						__.flag.top += 3;
					}
					__.from = __.from[k];
					__.to = __.to[k];
					break;
				} else {
					__.to[k] = __.merge[1];
				}
			}
		}
		if (__.flag.keys === 0 && __.flag.top > 0) {
			__.to = __.stack.pop();
			__.from = __.stack.pop();
			__.list = __.stack.pop();
			__.flag.keys = __.list.length;
			__.flag.top -= 3;
		}
	} while (__.flag.top > 0 || __.flag.keys > 0);
	return to;
}

nxObj.handler = new Map([
	[
		'test', (... a) => {
		    const [ f, t ] = a;
		    if (nxType.isObject(t))
			return [ 'object', nxObj.handler.get('object')(f, t) ];
		    if (nxType.isArray(t))
			return [ 'array', nxObj.handler.get('array')(f, t) ];
		    if (nxType.isSet(t))
			return [ 'set', nxObj.handler.get('set')(f, t) ];
		    return [ 'primitive', nxObj.handler.get('primitive')(f, t) ];
		}
	],
	[
		'primitive', (f, t) => {
			return (nxType.defined(f)) ? f : t;
		}
	],
	[
		'array', (f, t) => {
			nxType.isList(f) ? t.concat(f) : t.push(f);
			return t;
		}
	],
	[
		'set', (f, t) => {
			nxType.isPrimitive(f) ? t.add(f) : t = new Set([ ... t, ... f ]);
			return t;
		}
	],
	[
		'object', (f, t) => {
			f = nxType.isObject(f) ? f : nxObj.index(f);
			if (nxObj.isEmpty(f))
				return [];
			const __ = [];
			Object.entries(f).forEach(([k, v]) => {
				if (t.hasOwnProperty(k)) {
					__.push(k);
				} else {
					t[k] = v;
				}
			});
			return __;
		}
	]
]);

nxObj.explode = ({ from, list, chop }) => {
	const lst = nxArr.getList(list ?? [ 'true', 'false', 'null' ], chop ?? ',');
	if (nxType.isObject(from) && lst.length > 0) {
		Object.entries(from).forEach(([k, v]) => {
			if (nxType.isArray(v) && nxArr.isIn({ 'from': lst, 'find': k })) {
				const __ = [];
				v.forEach(i => {
					if (nxType.isPrimitive(i)) {
						if (nxType.defined(i))
							from[i] = k
					} else {
						__.push(i);
					}
					from[k] = __;
					if (from[k].length === 0)
						delete from[k];
				});
			}
		})
	}
	return from;
}

