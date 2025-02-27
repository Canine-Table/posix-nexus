#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
import { nexComponent } from '../components.mjs';
import { Str } from '../str.mjs';
export class nexTable
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexTable instances require a parent to append to");
		this.parent = obj.to;
		this.id = Dom.setId(`${this.parent.id}-table`);
		obj.id = this.id;
		this.element = Dom.append(nexComponent.table({
			'id': this.id,
			'true': [ 'table' ],
			...obj
		}), this.parent);
		this.thead = [];
		this.tbody = [];
		this.head = Dom.append(Dom.apply({
			'tag': 'thead',
			'id': `${this.id}-thead`
		}), this.element);
		this.body = Dom.append(Dom.apply({
			'tag': 'tbody',
			'id': `${this.id}-tbody`
		}), this.element);
		return this;
	}

	addCaption(obj) {
		Dom.append(nexComponent.caption({
			...obj,
			'true': [ 'table' ]
		}), this.element);
		return this;
	}

	addRow(obj, rtn) {
		obj = Dom.skel(obj);
		let parent = this.body;
		let arr = this.tbody;
		if (Type.isTrue(obj.thead)) {
			parent = this.head;
			arr = this.thead;
		}
		arr.push({
			'tr': Dom.append(nexComponent.tr({
				'id': `${parent.id}-tr${arr.length + 1}`,
				'true': [ 'table' ],
				...obj
			}), parent),
			'th': [],
			'td': []
		});
		return this;
	}

	#addData(obj, key) {
		obj = Dom.skel(obj);
		if (Type.isDefined(obj.tag))
			obj.tag = 'th';
		else
			obj.tag = 'td';
		let elm = this.tbody;
		if (key === 'thead') {
			elm = this.thead;
		}
		if (Type.isDefined(elm[obj.tr].tr)) {
			elm[obj.tr][obj.tag].push(Dom.append(nexComponent.tr({
				'tag': obj.tag,
				'true': [ 'table' ],
				...obj
			}), elm[obj.tr].tr));
		}
		return this;
	}

	addThead(obj) {
		return this.#addData(obj, 'thead');
	}

	addTbody(obj) {
		return this.#addData(obj, 'tbody');
	}
}

