
export function nxType(v)
{
	return (
		v !== "" &&
		v !== null &&
		v !== undefined &&
		v !== Infinity &&
		v !== -Infinity &&
		!Number.isNaN(v)
	);
}

nxType.isDefined = v => {
	return v === "" || nxType(v)
}

nxType.isObject = v => {
	return (typeof v === 'object' && v !== null && ! Array.isArray(v));
}

nxType.isFunction = v => {
	return typeof v === 'function';
}

nxType.isClass = v => {
	return Type.isFunction(v) && /^\s*class\s+/.test(v.toString());
}

nxType.isString = v => {
	return typeof v === 'string' || v instanceof String;
}

nxType.isBoolean = v => {
	return typeof v === 'boolean' || v instanceof Boolean;
}

nxType.isPrimitive = v => {
	return (v === null) || (typeof v !== 'object' && typeof v !== 'function');
}

