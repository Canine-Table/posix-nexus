#!/usr/bin/env node
import { Obj } from './obj.mjs';
export function Type()
{
	Obj.methods(Type);
}

Type.isObject = val => {
	return (typeof val === 'object' && val !== null && ! Array.isArray(val));
}

Type.isFunction = val => {
	return typeof val === 'function';
}

Type.isClass = val => {
	return Type.isFunction(val) && /^\s*class\s+/.test(val.toString());
}

Type.isFloat = val => {
	return /^[-+]?\d+(\.\d+)?([eE][-+]?\d+)?$/.test(val);
}

Type.isIntegral = val => {
	return /^[-+]?\d+$/.test(val);
}

Type.isString = val => {
	return typeof val === 'string' || val instanceof String;
}

Type.isBoolean = val => {
	return typeof val === 'boolean' || val instanceof Boolean;
}

Type.isPrimitive = val => {
    return (val === null) || (typeof val !== 'object' && typeof val !== 'function');
}

Type.isEmpty = val => {
	return val === '';
}

Type.isTrue = val => {
	return val == true;
}

Type.isFalse = val => {
	return val == false;
}

Type.isUndefined = val => {
	return val === undefined;
}

Type.isNull = val => {
	return val === null;
}

Type.isAbsolute = val => {
	return val === Math.abs(val);
}

Type.isJson = val => {
	try {
		JSON.parse(val);
		return true;
	} catch (e) {
		return false;
	}
}

Type.isDefined = (val, def) => {
	if (val == undefined || val === '')
		return def || false;
	else
		return def ? val : true;
}

Type.isArray = (val, def) => {
	if (Array.isArray(val) || val instanceof Set)
		return def ? val : true;
	else if (Type.isDefined(val) && ! Type.isObject(val))
		return def ? String(val).split(new RegExp(`\\s*${def}\\s*`)) : false;
	else
		return def ? [] : false;
}

