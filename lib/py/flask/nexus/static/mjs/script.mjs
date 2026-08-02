/*import { NxNav } from "./mjs/nex-nav.mjs"
import { nxObj } from "./mjs/nex-obj.mjs"
import { NxCSSOM } from "./mjs/nex-css.mjs"
import { NxForm } from "./mjs/nex-form.mjs"
*/

const Bit32 = {};

Bit32.on = function(b, s)
{
	return b | (1 << s);
}

Bit32.off = function(b, s)
{
	return b & ~(1 << s);
}

Bit32.flip = function(b, s)
{
	return b ^ (1 << s);
}

Bit32.abs = function(b)
{
	return (b ^ (b >> 31)) - (b >> 31);
}


Bit32.log2 = function(b)
{
	let a = 0;
	while ((b >>= 1) ^ 0)
		a++;
	return a;
}

Bit32.is = function(b, s)
{
	return b & (1 << s);
}

Bit32.diverge = function(b, s)
{
	return b ^ b >> s;
}

Bit32.cascade = function(b, s)
{
	return b | b >> s;
}

Bit32.alignDown = function(x, y)
{
	return x - (x & (y - 1));
}

Bit32.bump = function(b)
{
	b--;
	b |= b >> 1;
	b |= b >> 2;
	b |= b >> 4;
	b |= b >> 8;
	b |= b >> 16;
	return b + 1;
}

Bit32.range = function(n, s, e)
{
	return (n - s) >>> 0 < (e - s) >>> 0;
}

Bit32.ceil = function(b)
{
	return -((-b) >> 0);
}

Bit32.floor = function(b)
{
	return -b >> 0;
}

Bit32.mod = function(b, s)
{
	return b & (s - 1);
}

Bit32.modNext = function(b, s)
{
	return this.mod(b, this.bump(s));
}

Bit32.parity = function(b) {
	b ^= b >> 16;
	b ^= b >> 8;
	b ^= b >> 4;
	b ^= b >> 2;
	b ^= b >> 1;
	return (b & 1) ^ 0;
}

Bit32.count = function(b) {
	let c = 0;
	while (b ^ 0) {
		b = b & (b - 1);
		c++;
	}
	return c;
}

Bit32.isOdd = function(b)
{
	return b & 1;
}

const TypeCheck = {};
TypeCheck.isNormal = function(value)
{
	return (
		value !== "" &&
		value !== null &&
		value !== undefined &&
		value !== Infinity &&
		value !== -Infinity &&
		!Number.isNaN(value)
	);
}
TypeCheck.isObject = function(value)
{
	return (
		typeof value === 'object' &&
		value !== null &&
		!Array.isArray(value)
	);
}
TypeCheck.isPrimitive = function(value)
{
	return value === null || (typeof value !== 'object' && typeof value !== 'function');
}
TypeCheck.isClass = function(value)
{
	return typeof value === 'function' && /^\s*class\s+/.test(value.toString());
}
TypeCheck.isImage = function(value)
{
	return (
		value &&
		typeof value === 'object' &&
		typeof value.getContentType === 'function' &&
		/^image\/.*$/i.test(value.getContentType())
	);
}
TypeCheck.isDocument = function(value)
{
	if (
		!value ||
		typeof value !== 'object' ||
		typeof value.getContentType !== 'function'
	) return false;

	const mime = value.getContentType().toLowerCase();

	return (
		mime === 'application/pdf' ||
		mime === 'application/msword' ||
		mime === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
		mime === 'text/plain' ||
		mime === 'text/markdown' ||
		mime === 'application/rtf' ||
		mime === 'application/vnd.oasis.opendocument.text'
	);
}
TypeCheck.isUrl = function(value) {
	try {
		new URL(value);
		return true;
	} catch {
		return false;
	}
}
TypeCheck.isList = function(value)
{
	return value instanceof Array || value instanceof Set;
}
TypeCheck.isPair = function(value)
{
	return TypeCheck.isObject(value) || value instanceof Map;
}

const Pair = {}
Pair.getMap = function(values)
{
	const map = new Map();
	if ((values ?? '') === '')
		return map;
	if (values instanceof Map)
		return values;
	if (!TypeCheck.isObject(values))
		return map;
	for (const [key, value] of Object.entries(values))
		map.set(key, value);
	return map;
}
Pair.getObject = function(values)
{
	const object = {};
	if ((values ?? '') === '')
		return object;
	if (TypeCheck.isObject(values))
		return values;
	if (!(values instanceof Map))
		return object;
	for (const [key, value] of values)
		map.set(key, value);
	return object;
}
Pair.entries = function(value)
{
	if (value instanceof Map)
		return value;
	if (TypeCheck.isObject(value))
		return Object.entries(value);
	return [];
}
Pair.expandObjectMap = function(object, map)
{
	map = Pair.getMap(map);
	for (const [key, value] of Pair.entries(object)) {
		if (TypeCheck.isList(value)) {
			for (const item of value)
				map.set(item, key);
		} else {
			map.set(key, value);
		}
	}
	return map;
}
Pair.set = function(object) {
	if (TypeCheck.isObject(object))
		return (key, value) => object[key] = value;
	if (object instanceof Map)
		return object.set;
	return null;
}

const List = {};
List.getArray = function(value)
{
	if ((value ?? '') === '')
		return [];
	if (value instanceof Set)
		return Array.from(value);
	return Array.isArray(value) ? value : [value];
}
List.getSet = function(value)
{
	if ((value ?? '') === '')
		return new Set();
	if (value instanceof Set)
		return value;
	return new Set(Array.isArray(value) ? value : [value]);
}
List.add = function(value)
{
	if (Array.isArray(value))
		return value.push;
	if (value instanceof Set)
		return value.add;
	return null;
}

const Validate = {};
Validate.scalarCompare = function(reference)
{
	return (reference instanceof RegExp)
		? (value) => reference.test(String(value))
		: (value) => String(reference) === String(value);
}
Validate.returnInstance = function(fn, ...args)
{
	if (!TypeCheck.isNormal(fn))
		return args;
	const cls = Object.getPrototypeOf(fn);
	if (typeof cls === 'object' && typeof cls.constructor === 'function')
			return new cls.constructor(...args);
	if (typeof fn === 'function')
		return fn(...args);
	return args;
}

const Fallback = {};
Fallback.firstMatch = function(list, type, fallback)
{
	for(const item of List.getArray(list)) {
		if (typeof item === type)
			return item;
	}
	return fallback;
}
Fallback.firstRange = function(list, range, fallback)
{
	const start = parseInt(range[0] ?? 0);
	const end = parseInt(range[1] ?? 0);
	const skip = parseInt(range[2] ?? 1);
	for(const item of List.getArray(list)) {
		const number = parseInt(item);
		if (number >= start && number <= end && number % skip === 0)
			return number;
	}
	return fallback;
}

class SoARegistry
{
	static getOrSetMap({
		registry,
		instance,
		values,
		key,
		log
	}) {
		const old = registry;
		const condA = TypeCheck.isPair(registry);
		registry = Pair.getMap(registry);

		if (!TypeCheck.isNormal(key)) {
				if (parseInt(log) > 1)
					console.warn('the key must be defined to get or set its value');
			return {
				ok: null,
				registry: registry,
				leaf: null,
				oldValue: old
			}
		}

		let ok = true;
		if (!(condA && registry.has(key))) {
			registry.set(key, Validate.returnInstance(instance, values));
			ok = false;
		}
		return {
			ok: ok,
			registry: registry,
			value: registry.get(key),
			oldValue: old
		};
	}

	static loadDirective({
		registry,
		key,
		scalars,
		lists,
		objects,
		singletons,
		log
	}) {

		const struct = [
			[ 'scalars', List.getSet(scalars)],
			[ 'lists', Pair.getMap(lists)],
			[ 'objects', Pair.getMap(objects)],
			[ 'singletons', Pair.expandObjectMap(singletons)]
		];

		const result = this.getOrSetMap({
			registry: registry,
			values: struct,
			instance: new Map,
			key: key,
			log: log
		});

		if (result.ok === true) {
			this.storeDirective({
				map: result.value,
				entries: struct,
				log: log
			});
		}
		return result.registry;
	}

	static storeDirective({ map, entries, log }) {
		map = Pair.getMap(map);
		for (const item of List.getArray(entries)) {
			const entry = List.getArray(item);
			if (Bit32.isOdd(entry.length))
				entry.push(null);
			log = parseInt(log);
			for (let index = 0; index < entry.length; index += 2) {
				const slot = entry[index];
				if (!TypeCheck.isNormal(slot))
					continue;
				const values = entry[index + 1];
				if (map.has(slot)) {
					const current = map.get(slot);
					if (List.isList(current)) {
						const setter = List.add(current);
						for (const value of List.getSet(values))
							setter(value);
					} else if (Pair.isPair(current)) {
						const setter = Pair.set(current);
						for (const [key, value] of Pair.getMap(values))
							setter(key, value);
					} else if (log > 1) {
						console.warn(
							`storeDirective: slot '${slot}' already exists but is not a List or Pair; ` +
							`leaving existing value unchanged`
						);
					}
				} else {
					map.set(slot, values);
				}
			}
		}
		return map;
	}

	static mapLoaderDispatch({
		key,
		value,
		singletonMap,
		groupedSlotOrder,
		refer,
		check,
		log
	}) {

		const bool = typeof TypeCheck[check ?? ''] === 'function'
			&& !TypeCheck[check](value);

		log = parseInt(log);
		if (bool || !refer.has(key)) {
			if (log > 1) {
				if (bool) {
					console.warn(
						`mapLoaderDispatch: type check '${check}' failed for key '${key}' with value:`,
						value
					);
				} else {
					console.warn(
						`mapLoaderDispatch: key '${key}' is not allowed in this directive`
					);
				}
			}
			return null;
		}

		value = value ?? '';
		const groups = groupedSlotOrder.groups;
		const order = groupedSlotOrder.order;
		const slots = groupedSlotOrder.slots;

		if (singletonMap.has(key)) {
			const label = singletonMap.get(key);
			if (groups.has(label)) {
				groups.get(label).entry = [key, value];
			} else {
				groups.set(label, {
					index: order.length,
					entry: [key, value]
				});
				order[order.length] = label;
			}
			return true;
		} else {
			order[order.length] = key;
			slots[key] = value;
			return false;
		}
	}

	static mapDirective(input, reference) {
		if (! (reference instanceof Map))
			return this;
		const singletonMap = reference.get('singletons');
		const scalarSet = reference.get('scalars');
		const listMap = reference.get('lists');
		const objectMap = reference.get('objects');
		const stateStack = [];
		const rowSlots = [];
		let state = '';
		for (const directives of List.getArray(input)) {
			if (!TypeCheck.isNormal(input)) {
				rowSlots.push('');
				continue;
			}

			state = 'scalar';
			stateStack.push([ false, null ]);
			let pointer = directives;
			const groups = new Map();
			const columnSlots = new Map();
			const loopGuard = new Set();
			const order = [];
			const slots = {};
			const groupedSlotOrder = {
				order: order,
				slots: slots,
				groups: groups
			};

			let index = 0;

			while (state) {

				switch (state) {
					case 'scalar':
						if (TypeCheck.isObject(pointer)) {
							state = 'object';
						} else if (Array.isArray(pointer)) {
							state = 'array';
						} else {
							this.mapLoaderDispatch({
								key: pointer,
								refer: scalarSet,
								check: 'isPrimitive',
								singletonMap: singletonMap,
								groupedSlotOrder: groupedSlotOrder
							});
							state = 'ready';
						}
						break;

					case 'object':
						for (const [key, value] of Pair.getMap(pointer)) {
							this.mapLoaderDispatch({
								key: key,
								value: value,
								refer: objectMap,
								singletonMap: singletonMap,
								groupedSlotOrder: groupedSlotOrder
							});
						}
						state = 'ready';
						break;

					case 'list':
						break;

					case 'array':
						for (; index < pointer.length; ++index) {
							const value = pointer[index];
							if (TypeCheck.isObject(value)) {
									stateStack.push([ state, {
										index: index,
										value: pointer
									}]);
									state = 'object';
									pointer = value;
									break;
							} else if (Array.isArray(value)) {
								if (!loopGuard.has(value)) {
									loopGuard.add(value);
									pointer = [...pointer.slice(index + 1), ...value];
									index = -1;
									continue;
								}
							} else {
								this.mapLoaderDispatch({
									key: value,
									refer: scalarSet,
									check: 'isPrimitive',
									singletonMap: singletonMap,
									groupedSlotOrder: groupedSlotOrder
								});
							}
						}
						if (state === 'array')
							state = 'ready';
						break;

					case 'ready':
						const [prevState, frame] = stateStack.pop();
						state = prevState;
						if (state) {
							index = frame.index + 1;
							pointer = frame.value;
						}	
						break;

					default:
						break;
				}
			}
			
			for (let slot = 0; slot < order.length; ++slot) {
				const slotKey = order[slot];
				if (groups.has(slotKey)) {
					const group = groups.get(slotKey).entry;
					columnSlots.set(group[0], group[1]);
				} else {
					columnSlots.set(slotKey, slots[slotKey])
				}
			}
			rowSlots.push(columnSlots);
		}
		return rowSlots;
	}
}

document.addEventListener('DOMContentLoaded', () => {
function headerDiff({ left, right }) {
  left = List.getSet(left);
  right = List.getSet(right);
  const results = {
    left: left,
    right: right
  };
  let source;
  let reference;
  if (left.size > right.size) {
    source = 'right';
    reference = 'left';
  } else {
    source = 'left';
    reference = 'right';
  }

  for (const s of results[source]) {
    if (results[reference].has(s)) {
      results[reference].delete(s);
      results[source].delete(s);
    }
  }

  return results;
}


const results = headerDiff({
  left: ['Full Legal Name (per ID)',
      'Date of Birth',
      'Start date',
      'Timestamp',
      'Personal email address',
      'Country of Residence',
      'Country of Origin',
      'Photo',
      'Phone number',
      'Consent (combined)',
      'Pro Bono Agreement',
      'Solution Email',
      'Consumer Link'],

      right: ['Full Legal Name (per ID)',
      'Date of Birth',
      'Start date',
      'Timestamp',
      'Personal email address',
      'Country of Residence',
      'Country of Origin',
      'Photo',
      'Phone number',
      'CV',
      'NDA',
      'Consent (combined)',
      'Pro Bono Agreement',
      'Solution Email',
      'Consumed Link']
});
console.log(results);
});

/*
*/
