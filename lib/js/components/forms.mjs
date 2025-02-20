#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexForm
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexForm instances require a parent to append to");
		this.parent = obj.to;
		this.fields = [];
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}-form`;
		obj.id = this.id
		obj.prop.value = obj.text || 'Submit';
		delete obj.text;
		this.element = Dom.append(nexComponent.form(obj), this.parent);
		this.form = new nexContainer({
			'id': `${this.id}-layout`,
			'to': this.element,
		});
		obj.cls = `${obj.cls} btn`;
		obj.id = `${this.id}-submit`;
		obj.type = 'submit';
		this.submit = Dom.append(nexComponent.input(obj), this.element);
	}

	addInput(obj) {
		if (obj.type !== 'submit' && Dom.isElement(this.submit)) {
			this.form.addRows(1, {
				'type': obj.type,
				'true': [ 'form', 'switch' ]
			});
			let idx = this.form.children.length - 1;
			if (Type.isDefined(obj.label)) {
				Dom.append(nexComponent.label({
					'id': `${this.id}-inpt${idx}-label`,
					'for': `${this.id}-inpt${idx}`,
					'type': obj.type,
					'label': obj.label
				}), this.form.children[idx].element);
			}
			obj.id = `${this.id}-inpt${idx}`;
			Dom.append(nexComponent.input(obj), this.form.children[idx].element);
		}
	}
}
