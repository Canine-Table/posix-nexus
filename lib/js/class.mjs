#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
import { Int } from './int.mjs';
import { nexAnime } from './anime.mjs';
import { nexNode } from './components/nex-node.mjs';
import { Str } from './str.mjs';
export function nexClass()
{
	Obj.methods(nexClass);
}

nexClass.defaults = (def, obj, mth) => {
	nexNode.Skel(obj);
	if (Type.isObject(def)) {
		if (! Type.isObject(mth))
			mth = {};
		Object.entries(def).forEach(([k, v]) => {
			if (Type.isArray(mth[k]))
				obj[k] = Arr.shortStart(obj[k], mth[k]);
			if (Type.isDefined(obj[k]) && obj[k] !== false) {
				obj.prop[k] = obj[k];
				delete obj[k];
			} else if (Type.isDefined(v) && v !== false) {
				obj.prop[k] = v;
			}
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

nexClass.cherryPick = obj => {
	if (Type.isArray(obj))
		return obj[Int.loop(Int.wholeRandom(), 0, obj.length - 1)];
}

nexClass.alias = (als, opt, obj) => {
	if (Type.isObject(obj)) {
		const aliases = {};
		if (Type.isObject(als)) {
			nexClass.expand(als, aliases);
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
		}
		return obj;
	}
}

nexClass.back = (obj, num = 1) => {
	if (Type.isDefined(obj.parent) && Number(num) > 0)
		return nexClass.back(obj.parent, --num);
	else
		return obj;
}

