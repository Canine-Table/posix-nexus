#!/usr/bin/env node
function returnObjectType(obj)
{
	if (isObjectType(obj))
		return obj;
	return {};
}

function autoComplete(val, arr, obj)
{
	if (isDefinedType(val) && isDefinedType(arr)) {
		obj = returnObjectType(obj);
		arr = bestMatch(completeMatch(val, arr, obj), obj);
		if (arr.length === 1)
			return arr[0];
		else if (isDefinedType(obj.vrb))
			return arr;
	}
}

function bestMatch(arr, obj)
{
	if (isDefinedType(arr)) {
		obj = returnObjectType(obj);
		obj.get = completeMatch(isDefinedType(obj.get, 'shortest'), ['shortest', 'longest'])[0];
		arr = returnArrayType(arr, obj.sep);
		obj.get = arr.reduce((c, m) => {
			if (obj.get === 'shortest')
				return c.length < m.length ? c : m;
			else	
				return c.length > m.length ? c : m;
		}).length;
		return arr.filter(s => s.length === obj.get);
	}
}

function completeMatch(val, arr, obj)
{
	if (isDefinedType(val) && isDefinedType(arr)) {
		obj = returnObjectType(obj);
		switch (obj.look) {
			case 1:
				obj.look = 'includes';
				break;
			case 2:
				obj.look = 'endsWith';
				break;
			default:
				obj.look = 'startsWith';
		}
		return returnArrayType(arr, obj.sep).filter(i => i[obj.look](val));
	}
}

function DomElement(obj)
{
	if (isObjectType(obj)) {
	console.log(obj instanceof Object)
	}
}

