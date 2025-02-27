#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Dom } from '../dom.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
export class nexButton
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexButton instances require a parent to append to");
		this.parent = obj.to;
		this.id = Dom.setId(`${this.parent.id || this.parent.getAttribute('id')}-group`);
		obj.id = this.id;
		obj.cls = `${obj.cls}`;
		this.element = new nexContainer({
			'id': this.id,
			'to': this.parent,
			'true': [ 'group', 'button' ],
			...obj
		});
		this.group = this.element;
		if (Type.isDefined(obj.toolbar)) {
			if (! Type.isObject(obj.bar))
				obj.bar = {};
			this.toolbar = this.element.addRows(1, {
				'to': this.element,
				'true': [ 'group' ],
				'toolbar': obj.toolbar,
				...obj.bar
			}).children[0];
			this.group = this.toolbar;
		}
		return this;
	}

	addButton(obj, glb) {
		if (Type.isArray(obj)) {
			if (! Type.isObject(glb))
				glb = {};
			let idx = this.group.children.length + 1;
			obj.forEach(i => {
				i.id = `${this.id}-b${idx++}`;
				switch (i.nexBtn) {
					default:
						Dom.append(nexComponent.button({
							...i,
							...glb,
						}), this.group.element);
				}
			});
		}
	}
}


