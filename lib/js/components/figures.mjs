#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Dom } from '../dom.mjs';
import { nexEvent } from '../event.mjs';
import { nexComponent } from '../components.mjs';

export class nexFigure
{
	constructor(obj) {
		obj = Dom.skel(obj);
		const attr = {};
		if (obj.to instanceof nexFigure) {
			if (! Type.isArray(obj.to.nodes[obj.tag]))
				obj.to.nodes[obj.tag] = [];
			obj.to.nodes[obj.tag].push(this);
			attr.parent = obj.to;
			obj.to = obj.to.element;
		}
		if (! Dom.isElement(obj.to))
			throw new Error("nexSvg instances require a parent to append to");
		if (! Type.isDefined(attr.parent))
			obj.tag = 'figure';
		this.nodes = {};
		this.element = Dom.apply(obj);
		return this
	}
}
