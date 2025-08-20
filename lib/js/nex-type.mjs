
import { nxObj } from './nex-obj.mjs';

export function nxType()
{
	return nxObj.methods(nxType);
}

nxType.isObject = v => {
	return ((typeof v === 'object' || v instanceof Object) && v !== null && ! Array.isArray(v));
}

nxType.isFunction = v => {
	return typeof v === 'function';
}

nxType.isClass = v => {
	return nxType.isFunction(v) && /^\s*class\s+/.test(v.toString());
}

nxType.isFloat = v => {
	return /^[-+]?\d+(\.\d+)?([eE][-+]?\d+)?$/.test(v);
}

nxType.isIntegral = v => {
	return /^[-+]?\d+$/.test(v);
}

nxType.isString = v => {
	return typeof v === 'string' || v instanceof String;
}

nxType.isBoolean = v => {
	return typeof v === 'boolean' || v instanceof Boolean;
}

nxType.isNumber = v => {
	return typeof v === 'number' || v instanceof Number;
}

nxType.isPrimitive = v => {
    return (v === null) || (typeof v !== 'object' && typeof v !== 'function');
}

nxType.isEmpty = v => {
	return v === '';
}

nxType.isTrue = v => {
	return v == true;
}

nxType.isFalse = v => {
	return v == false;
}

nxType.isUndefined = v => {
	return v === undefined;
}

nxType.isNull = v => {
	return v === null;
}

nxType.isAbsolute = v => {
	return v === Math.abs(v);
}

nxType.isJson = (v, e) => {
	try {
		JSON.parse(v);
		return true;
	} catch (e) {
		return false;
	}
}

nxType.defined = (v, d) => {
	if (v == undefined || v === '')
		return d || false;
	else
		return d ? v : true;
}

nxType.isMap = v => {
	return v instanceof Map;
}

nxType.isSet = v => {
	return v instanceof Set;
}

nxType.isArray = v => {
	return Array.isArray(v);
}

nxType.isList = v => {
	return nxType.isArray(v) || nxType.isSet(v);
}


nxType.isNode = v => {
	return v !== null && nxType.isObject(v) && nxType.isNumber(v.nodeType) && nxType.isString(v.nodeName);
}

nxType.isElement = v => {
	return v instanceof Element;
}

nxType.isHtml = v => {
	return v instanceof HTMLElement || v instanceof HTMLDocument;
}

nxType.isDocument = v => {
	return v instanceof Document || v instanceof DocumentType || v instanceof DocumentFragment;
}

nxType.isSvg = v => {
	return v instanceof SVGElement;
}

