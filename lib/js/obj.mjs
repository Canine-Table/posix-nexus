#!/usr/bin/env node
function Obj()
{
	Obj.methods(Obj);
}

Obj.reflect = val => {
	if (val instanceof Object) {
		const prop = Reflect.ownKeys(val.prototype);
		if (prop.length === 1)
			return Reflect.ownKeys(val);
		else
			return prop;
	}
}

Obj.methods = val => {
	console.log(Arr.left(Obj.reflect(val), ['length', 'name', 'arguments', 'caller', 'prototype', 'constructor']));
}

Obj.isProp = (val, prop) => {
	if (Type.isDefined(prop))
		return Arr.in(prop, Obj.reflect(val));
}

Obj.assign = (val, prop, obj) => {
	if (Type.isObject(obj) && Type.isObject(val)) {
		if (Type.isDefined(prop))
			Object.entries(obj).forEach(([k, v]) => val[prop][k] = v);
		else
			Object.entries(obj).forEach(([k, v]) => val[k] = v);
	}
}

