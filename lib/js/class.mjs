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
	if (! (val.inst instanceof Object))
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
		throw new Error(`${obj.to} instances require a parent to append to`);
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


nexClass.ternary = (obj, res = true, mth = false) => {
	if (Type.isArray(obj) {
		obj.forEach(i => {
			if (Type.isArray(i)) {
				 if (mth === false) {
					 if (i[0] != res) {
						return
					}
				} else {
					 if (i[0] !== res) {
						 return
					}
				}
			}
		}
	}
}
