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
	Object.entries(obj).forEach(([k, v]) => {
		val[prop][k] = v;
	});
}

