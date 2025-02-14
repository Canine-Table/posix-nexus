#!/usr/bin/env node
function isObjectType(val)
{
	return (typeof val === 'object' && val !== null && ! Array.isArray(val));
}

function isTrueType(val)
{
	return (val === true);
}

function isFalseType(val)
{
	return (val === false);
}

function isBoolType(val)
{
	return isTrueType(val) || isFalseType(val);
}

function isArrayType(arr)
{
	return Array.isArray(arr);
}

function isIntegerType(num)
{
	return Number.isInteger(num);
}

function isFloatType(num)
{
	return typeof num === 'number' && ! Number.isInteger(num);
}

function isNumeric(num)
{
	return ! isNaN(parseFloat(num)) && isFinite(num);
}

function isUnsigned(num)
{
	return num === Math.abs(num);
}

function isSignedInteger(num)
{
	return isIntegerType(num) && ! isUnsigned(num);
}

function isUnsignedInteger(num)
{
	return isIntegerType(num) && isUnsigned(num);
}

function isSignedFloat(num) {
	return isFloatType(num) && ! isUnsigned(num);
}

function isUnsignedFloat(num) {
	return isFloatType(num) && isUnsigned(num);
}

function isNullType(val)
{
	return (val === null);
}

function isDefinedType(val, def)
{
	if (val === undefined) {
		if (def !== undefined)
			return def;
		else
			return false;
	} else {
		if (def !== undefined)
			return val;
		else
			return true;
	}
}

function isString(val)
{
	return typeof val === 'string' || val instanceof String;
}

function isJson(val)
{
	try {
		JSON.parse(val);
	} catch (e) {
		return false;
	}
	return true;
}

function isEmpty(val)
{
	return (! isDefinedType(val) || isNullType(val) || val === '');
}

function isEven(num)
{
	if (isIntegerType(num))
		return num % 2 === 0;
}

function getSubProp(obj, fnd, rpl)
{
	if (isObjectType(obj) && isDefinedType(fnd)) {
		let mth = {};
		mth = matchProp(obj, fnd, rpl);
		mth.css = matchProp(obj.css, fnd, rpl);
		mth.prop = matchProp(obj.prop, fnd, rpl);
		return mth;
	}
}

function matchProp(obj, fnd, rpl)
{
	if (isObjectType(obj) && isDefinedType(fnd)) {
		let mth = {};
		let str = null;
		if (! isDefinedType(rpl))
			rpl = '';
		let keys = Object.keys(obj);
		for (let k in keys) {
			str = keys[k].replace(new RegExp(`${fnd}$`), rpl);
			if (str !== keys[k] && isDefinedType(obj[keys[k]])) {
				mth[str] = obj[keys[k]];
				delete obj[keys[k]];
			}
		}
		return mth;
	}
}

function camelCase(str)
{
	 return str.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function (mth, i) {
		 if (+mth === 0)
			 return "";
		return i === 0 ? mth.toLowerCase() : mth.toUpperCase();
	 });
}

function joinStr(str, substr, sep = '')
{
	if (! isEmpty(substr)) {
		if (! isEmpty(str))
			str = `${str}${sep}`;
		return `${str}${substr}`;
	} else if (! isEmpty(str)) {
		return str;
	}
}

function titleCase(str)
{
	let arr = returnArrayType(str, ' ');
	str = '';
	for (let i = 0; i < arr.length; i++)
		str = joinStr(str, `${arr[i].charAt(0).toUpperCase()}${arr[i].slice(1)}`, ' ');
	return str;
}

function returnArrayType(arr, sep = ',')
{
	if (isArrayType(arr))
		return arr;
	else
		return arr.split(new RegExp(`\\s*${sep}\\s*`));
}

function trimMatch(str, mth)
{
	mth = isDefinedType(mth, 'null|undefined');
	return str.replace(new RegExp(`(^ *| +)(${mth})( +| *$)`, "g"), " ").replace(/(^ *| *$)/g, "");
}

function arrToObj(arr, key, sep)
{
	if (isDefinedType(arr[key]))  {
		arr = returnArrayType(arr[key], sep);
		let obj = {};
		for (let i = 0; i < arr.length; i++) {
			if (! isEmpty(arr[i]))
				obj[arr[i]] = key;
		}
		return obj;
	}
}

function expandBool(obj)
{
	if (isObjectType(obj)) {
		if (isDefinedType(obj.true))
			obj.true = arrToObj(obj, true);
		if (isDefinedType(obj.false))
			obj.false = arrToObj(obj, false);
		return obj;
	}
}

function getPropList(obj, tag)
{
	if (isObjectType(obj)) {
		expandBool(obj)
		if (tag !== false)
			obj.id = getTagId(obj.id, tag);
		if (! isDefinedType(obj.prop))
			obj.prop = {};
		expandBool(obj.prop);
		if (! isDefinedType(obj.css))
			obj.css = {};
		expandBool(obj.css);
		return obj;
	}
}

function sanitizeString(val)
{
	return val.replace(/[^a-zA-Z0-9]/g, "");
}

function randomString(length)
{
	const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	let result = '';
	const charactersLength = characters.length;
	for (let i = 0; i < length; i++) {
		result += characters.charAt(Math.floor(Math.random() * charactersLength));
	}
	return result;
}

