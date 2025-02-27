#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Dom } from '../dom.mjs';
import { nexComponent } from '../components.mjs';
export class nexList
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("List instances require a parent to append to");
		this.parent = obj.to;
		this.children = [];
		this.id = Dom.setId(`${this.parent.id || this.parent.getAttribute('id')}-list`);
		obj.id = this.id;
		this.element = Dom.append(nexComponent.list(obj), this.parent);
		return this;
	}

	addItem(obj) {
		if (Type.isArray(obj)) {
			let idx = this.children.length;
			obj.forEach(i => {
				if (! Type.isDefined(i.item))
					i.item = {};
				if (! Type.isDefined(i.item))
					i.element = {};
				if (! Type.isDefined(i.item.id))
					i.item.id = `${this.id}-l${idx + 1}`;
				if (! Type.isDefined(i.element.id))
					i.element.id = `${i.item.id}-e1`;
				if (! Arr.in(i.element.component, [ 'link', 'button' ]))
					i.element.component = 'button';
				this.children.push({ 'element': Dom.append(nexComponent.item(i.item), this.element), 'children': [] });
				this.children[idx].children.push(Dom.append(nexComponent[i.element.component](i.element), this.children[idx++].element));
			});
		}
		return this;
	}
}

