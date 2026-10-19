import { TypeCheck } from "./nex-type-check.mjs";

export const Pair = {};

Pair.getPair = function(instance)
{
	const map = new Map();
	if ((instance ?? '') === '' || !(
		TypeCheck.isObject(instance) ||
		instance instanceof Map))
		return map
	return instance;
}
Pair.getMap = function(instance, deep = true)
{
	const map = new Map();
	if ((instance ?? '') === '' || !(
		TypeCheck.isObject(instance) ||
		instance instanceof Map))
		return map;
	if (instance instanceof Map)
		return instance;
	if (deep !== false) {
		for (const key of Reflect.ownKeys(instance))
			map.set(key, instance[key]);
	} else {
		for (const [key, value] of Object.entries(instance))
			map.set(key, value);
	}
	return map;
}
Pair.getObject = function(instance)
{
	const object = Object.create(Object.prototype);
	if (TypeCheck.isObject(instance))
		return instance;
	if ((instance ?? '') === '' || ! (instance instanceof Map))
		return object;
	for (const [key, value] of instance)
		object[key] = value;
	return object;
}
Pair.entries = function(instance)
{
	if (instance instanceof Map)
		return instance;
	if (TypeCheck.isObject(instance))
		return Object.entries(instance);
	return [];
}
Pair.explode = function(input, pair) {
	const cache = Pair.getPair(pair);
	const cacheSet = Pair.set(cache);
	if (TypeCheck.isList(input)) {
		for (const entries of input) {
			if (TypeCheck.isList(entries)) {
				const sym = Symbol('LIST');
				for (const item of entries)
					cacheSet(item, sym);
			} else if (TypeCheck.isPair(entries)) {
				const sym = Symbol('PAIR');
				for (const [key, value] of Pair.entries(entries)) {
					cacheSet(key, sym);
					cacheSet(sym, value);
				}
			} else if (TypeCheck.isNormalPrimitive(entries)) {
				cacheSet(entries, Symbol('SCALAR'));
			}
		}
	} else if (TypeCheck.isPair(input)) {
		for (const [key, value] of Pair.entries(input)) {
			if (TypeCheck.isList(value)) {
				for (const item of value)
					cacheSet(item, key);
			} else {
				cacheSet(key, value);
			}
		}
	}
	pair = cache;
	return pair;
}
Pair.set = function(instance, key, value)
{
	if (TypeCheck.isObject(instance)) {
		if (key === undefined)
			return (key, value) => instance[typeof key === 'symbol' ? key : String(key)] = value;
		key = typeof key === 'symbol' ? key : String(key);
		if (value === undefined)
			return (value) => instance[key] = value;
		return instance[key] = value;
	}
	if (instance instanceof Map || instance instanceof WeakMap) {
		if (key === undefined)
			return (key, value) => instance.set(key, value);
		if (value === undefined)
			return (value) => instance.set(key, value);
		return instance.set(key, value);
	}
	return (key === undefined)
		? () => null
		: null;
}
Pair.size = function(instance)
{
	if (TypeCheck.isObject(instance))
		return Object.keys(instance).length;
	if (instance instanceof Map)
		return instance.size;
	return -1;
}
Pair.get = function(instance, key)
{
	if (TypeCheck.isObject(instance)) {
		return (key === undefined)
		? (key) => instance[typeof key === 'symbol' ? key : String(key)]
		: instance[typeof key === 'symbol' ? key : String(key)];
	}

	if (instance instanceof Map || instance instanceof WeakMap) {
		return (key === undefined)
			? (value) => instance.get(value)
			: instance.get(key);
	}
	return (key === undefined)
		? () => null
		: null;
}
Pair.has = function(instance, key)
{
	if (TypeCheck.isObject(instance))
		return (key === undefined)
			? (key) => Object.prototype.hasOwnProperty.call(instance, key)
			: Object.prototype.hasOwnProperty.call(instance, key);
	if (instance instanceof Map || instance instanceof WeakMap)
		return (key === undefined)
			? (value) => instance.has(value)
			: instance.has(key);
	return (key === undefined)
		? () => null
		: null;
}
Pair.remove = function(instance, key)
{
	if (TypeCheck.isObject(instance)) {
		return (key === undefined)
		? (key) => {
			if (Object.prototype.hasOwnProperty.call(instance, key))
				delete instance[key];
		} : delete instance[key];
	}
	if (instance instanceof Map || instance instanceof WeakMap) {
		return (key === undefined)
			? (key) => instance.delete(key)
			: instance.delete(key);
	}
	return (key === undefined)
		? () => null
		: null;
}
Pair.delete = Pair.remove;
Pair.keys = function(instance)
{
	if (TypeCheck.isObject(instance))
		return Object.keys(instance);
	if (instance instanceof Map)
		return instance.keys();
	return [];
}
Pair.values = function(instance)
{
	if (TypeCheck.isObject(instance))
		return Object.values(instance);
	if (instance instanceof Map)
		return instance.values();
	return [];
}
Pair.log = function(instance)
{
	for (const [k,v] of Pair.entries(Pair.getPair(instance)))
		console.log([k],'=',[v]);
}

