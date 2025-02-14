#!/usr/bin/env node
function Obj()
{
	Obj.methods(Obj);
}

Obj.reflect = val => {
	if (val instanceof Object) {
		let prop = Reflect.ownKeys(val.prototype);
		if (prop.length === 1)
			return Arr.left(Reflect.ownKeys(val), ['length', 'name', 'arguments', 'caller', 'prototype']);
		else
			return prop;
	}
}

Obj.methods = val => {
	console.log(Obj.reflect(val));
}

Obj.isProp = (val, prop) => {
	if (Type.isDefined(prop))
		return Arr.in(prop, Obj.prop(val));
}

Obj.assign = (val, prop, obj) => {
	Object.entries(obj).forEach(([k, v]) => {
		val[prop][k] = v;
	});
}
