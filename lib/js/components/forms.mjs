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
		this.id = Dom.setId(`${this.parent.id}-form${this.parent.children.length + 1}`);
		obj.id = this.id
		obj.prop.value = obj.text || 'Submit';
		delete obj.text;
		this.element = Dom.append(nexComponent.form(), this.parent);
		this.form = new nexContainer({
			'id': `${this.id}-layout`,
			'to': this.element,
			'cls': 'row mb-3',
		});
		obj.cls = `${obj.cls} btn order-last`;
		obj.id = `${this.id}-submit`;
		obj.type = 'submit';
		this.submit = Dom.append(nexComponent.input(obj), this.form.element);
	}

	addInput(arr, obj) {
		if (Type.isArray(arr)) {
			obj = Dom.skel(obj);
			this.form.addRows(1, {
				...obj,
				'true': [ 'form', 'group' ]
			});
			let idx = this.form.children.length - 1;
			let tmp = '';
			for (let i = 0; i < arr.length; i++) {
				arr[i].true = Type.isArray(arr[i].true, Type.isDefined(Type.isDefined(arr[i].sep, obj.sep)), ',');
				if (! Type.isObject(arr[i].prop))
					arr[i].prop = {};
				if (Type.isDefined(arr[i].label)) {
					this.form.children[idx].append(nexComponent.label({
						'id': `${this.id}-inpt${idx}-${i}-label`,
						'for': `${this.id}-inpt${idx}-${i}`,
						'type': arr[i].type,
						'label': arr[i].label,
						'true': arr[i].true
					}));
				}
				if (Type.isDefined(arr[i].float)) {
					tmp = Dom.append(nexComponent.div({
						'id': `${this.id}-inpt${idx}-${i}-float`,
						'true': [...arr[i].true, 'float' ]
					}), this.form.children[idx].element);
				} else {
					tmp = this.form.children[idx].element;
				}
				arr[i].id = `${this.id}-inpt${idx}-${i}`;
				Dom.append(nexComponent.input(arr[i]), tmp);
				if (Type.isDefined(arr[i].float)) {
					Dom.text(Dom.append(nexComponent.label({
						'id': `${this.id}-inpt${idx}-${i}-float-label`,
						'for': `${this.id}-inpt${idx}-${i}`
					}), tmp), { 'textIn': arr[i].float });
				}
			}
		}
	}
}
