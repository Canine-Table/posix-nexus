import { nxObj } from './nex-type.mjs';

export function nxLog()
{
	nxObj.methods(nxLog);
}

nxLog.pretty = (...args) =>
	console.log(...args.map(v =>
		JSON.stringify(structuredClone(v), null, 2))
	);

nxLog.freeze = (...args) =>
	console.log(...args.map(v =>
		Object.freeze(structuredClone(v)))
	);

nxLog.traceVM = (label, obj) =>
	console.log(`[${performance.now().toFixed(3)}] ${label}`,
		structuredClone(obj)
	);

nxLog.inspect = (...args) => {
	const clean = v => {
		if (v instanceof Node)
			return `[DOM:${v.nodeName}]`;
		if (Array.isArray(v))
			return v.map(clean);
		if (v && typeof v === 'object') {
			const o = {};
			for (const k in v)
				o[k] = clean(v[k]);
			return o;
		}
		return v;
	};
	console.log(...args.map(clean));
};

