#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { nexNode } from './node.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexForm
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexForm instances require a parent to append to");
		this.parent = obj.to;
		this.id = Dom.setId(`${this.parent.id}-form${this.parent.children.length + 1}`);
		obj.id = this.id
		obj.prop.value = obj.text || 'Submit';
		delete obj.text;
		if (Type.isDefined(obj.submit))
			obj.submit = this.#onSubmit(obj.submit);
		this.element = Dom.append(nexComponent.form(obj), this.parent);
		this.form = new nexContainer({
			'id': `${this.id}-layout`,
			'to': this.element
		}).addRows(1).children[0];
		return this;
	}
	
	#onSubmit(val) {
		if (/\w+\(.*\)\s*\{.*\}/s.test(val)) {
			const act = /\w+\(.*\)/.exec(val)[0];
			Dom.apply({
				'to': nexNode.body,
				'tag': 'script',
				'htmlIn': `function ${val}`
			});
			return act;
		}
		return '';
	}

	addInput(arr, obj) {
		if (Type.isArray(arr)) {
			obj = Dom.skel(obj);
			let tmp = 0
			if (Type.isDefined(this.form.parent.children[obj.idx]))
				tmp = obj.idx;
			const form = this.form.parent.children[tmp];
			form.addCols(1, {
				...obj,
				'true': [ 'form', 'group' ]
			});
			let idx = form.children.length - 1;
			for (let i = 0; i < arr.length; i++) {
				arr[i].true = Type.isArray(arr[i].true, Type.isDefined(Type.isDefined(arr[i].sep, obj.sep)), ',');
				if (! Type.isObject(arr[i].prop))
					arr[i].prop = {};
				if (Type.isDefined(arr[i].label)) {
					form.children[idx].append(nexComponent.label({
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
					}), form.children[idx].element);
				} else {
					tmp = form.children[idx].element;
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
		return this;
	}

}
