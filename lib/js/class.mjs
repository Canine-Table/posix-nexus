#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { nexComponent } from './components.mjs';
import { Arr } from './arr.mjs';
import { nexAnime } from './anime.mjs';
import { Dom } from './dom.mjs';
import { Str } from './str.mjs';
export function nexClass()
{
	Obj.methods(nexClass);
}

nexClass.skel = obj => {
	if (! Type.isObject(obj))
		throw new Error('nexClass requires a reference object to modify');
	if (! Type.isObject(obj['prop']))
		obj['prop'] = {};
	if (! Type.isObject(obj['css']))
		obj['css'] = {};
}

nexClass.nodes = (val, obj) => {
	nexClass.skel(obj);
	if (! Type.isClass(val.inst))
		throw new Error('nexClass nodes require the inst attribute for instance validation');
	let state = false;
	let parent = undefined;
	if (obj.to instanceof val.inst) {
		if (! Type.isDefined(obj.tag))
			throw new Error('nodes require the tag attribute');
		if (! Type.isObject(obj.to.nodes))
			obj.to.nodes = {};
		if (! Type.isArray(obj.to.nodes[obj.tag]))
			obj.to.nodes[obj.tag] = [];
		obj.to.nodes[obj.tag].push(val.self);
		parent = obj.to;
		obj.to = obj.to.element;
		state = true;
	}
	if (! Dom.isElement(obj.to))
		throw new Error(`${obj.inst} instances require a parent to append to`);
	if (! Type.isDefined(parent))
		obj.tag = val.def;
	else
		val.self.parent = parent;
	val.self.nodes = {};
	nexClass.idx(obj);
	return state;
}

nexClass.idx = obj => {
	if (! (Type.isDefined(obj.id) || Type.isFalse(obj.id))) {
		let parent = obj.to.getAttribute('id') || Str.random(8);
		obj.id = Dom.setId(`${parent}-${obj.tag}${Dom.tagCount(obj.to, obj.tag) + 1}`);
	}
}

nexClass.defaults = (def, obj, mth) => {
	nexClass.skel(obj);
	if (Type.isObject(def)) {
		if (! Type.isObject(mth))
			mth = {};
		Object.entries(def).forEach(([k, v]) => {
			if (Type.isArray(mth[k]))
				obj[k] = Arr.shortStart(obj[k], mth[k]);
			if (Type.isDefined(obj[k]) && obj[k] !== false)
				obj.prop[k] = obj[k];
			else if (Type.isDefined(v) && v !== false)
				obj.prop[k] = v;
		});
	}
}

nexClass.prop = (ref, obj, cls) => {
	if (Type.isObject(obj) && Type.isArray(ref)) {
		ref.forEach(i => {
			if (Type.isArray(i)) {
				const val = obj[i[0]];
				obj[i[0]] = {};
				if (Type.isDefined(val)) {
					if (Type.isArray(i[1]))
						obj[i[0]][i[0]] = Arr.shortStart(val, i[1]) || i[2];
					else
						obj[i[0]][i[0]] = val;
				} else {
					obj[i[0]][i[0]] = i[2];
				}
				if (Type.isDefined(obj[i[0]][i[0]]))
					i = obj.prop[i[0]] = obj[i[0]][i[0]];
				delete obj[i[0]];
			} else if (Type.isObject(obj[i]) && Type.isClass(cls) && cls.hasOwnProperty(`p_${i}`)) {
				cls[`p_${i}`](obj[i]);
				obj.prop = { ...obj.prop, ...obj[i].prop };
				delete obj[i];
			}
		});
	}
}

nexClass.expand = (val, obj) => {
	if (Type.isObject(val) && Type.isObject(obj)) {
		Object.entries(val).forEach(([k, v]) => {
			if (Type.isArray(v)) {
				v.forEach(i => {
					obj[i] = k;
				});
			}
		});
	}
}

nexClass.alias = (als, opt, obj) => {
	if (Type.isObject(obj)) {
		const aliases = {};
		if (Type.isObject(als)) {
			nexClass.expand(als, aliases);
		}
		let val = undefined;
		Object.entries(obj).forEach(([k, v]) => {
			if (Type.isDefined(aliases[k])) {
				if (Type.isArray(opt[aliases[k]]))
					val = Arr.shortStart(obj[k], opt[aliases[k]]) || obj[k];
				else
					val = obj[k];
				obj[aliases[k]] = val;
				delete obj[k];
			}
		});
		return obj;
	}
}

nexClass.back = (obj, num = 1) => {
	if (Type.isDefined(obj.parent) && Number(num) > 0)
		return nexClass.back(obj.parent, --num);
	else
		return obj;
}

