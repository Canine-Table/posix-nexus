#!/usr/bin/env node
function isObjectType(param)
{
	return (typeof param === 'object' && param !== null && ! Array.isArray(param));
}

function returnArrayType(arr, sep = ',')
{
	if (Array.isArray(arr))
		return arr
	else
		return arr.split(new RegExp(`\\s*${sep}\\s*`));
}

function trimMatch(str, mth)
{
	mth = isDefinedType(mth, 'null|undefined');
	return str.replace(new RegExp(`(^ *| +)?(${mth})( +| *$)`, "g"), " ").replace(/(^ *| *$)/g, "");
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

function isNullType(val)
{
	return (val === null);
}

function isTrueType(val)
{
	return (val === true);
}

function isFalseType(val)
{
	return (val === false);
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

