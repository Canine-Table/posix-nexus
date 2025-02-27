#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexAccordion
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexAccordion instances require a parent to append to");
		this.parent = obj.to;
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}-accordiation`;
		obj.id = this.id;
		this.accordion = [];
		this.element = new nexContainer({
			...obj,
			'true': [ 'accordion' ],
			'to': this.parent
		});
		return this;
	}

	addAccordion(obj) {
		obj = Dom.skel(obj);
		const idx = this.element.children.length;
		let show = '';
		if (Type.isDefined(obj.show)) {
			if (! Type.isDefined(this.show)) {
				this.show = idx;
				show = 'show'
			}
		}
		if (! Type.isObject(obj.in))
			obj.in = {};
		if (! Type.isObject(obj.header))
			obj.header = {};
		if (! Type.isObject(obj.button))
			obj.button = {};
		this.element.addRows(1, {
			'true': [ 'accordion', 'item' ]
		}).children[idx].addCols(1, {
			'id': `${this.id}-clp${idx + 1}-clp`,
			'true': [ 'accordion', 'collapse', show ],
			'for': this.id
		});

		Dom.append(nexComponent.button({
			...obj.button,
			'active': show,
			'id': `${this.id}-clp${idx + 1}-btn`,
			'for': `${this.id}-clp${idx + 1}-clp`,
			'true': [ 'accordion' ]
		}), Dom.insert({
			'elm': nexComponent.h({
				...obj.header,
				'id': `${this.id}-clp${idx + 1}-hdr`,
				'true': [ 'accordion' ]
			}),
			'to': this.element.children[idx].element,
			'ref': this.element.children[idx].children[0].element,
			'b4': ! Type.isTrue(obj.above)
		}));
		this.accordion.push(new nexContainer({
			...obj.in,
			'id': `${this.id}-clp${idx + 1}`,
			'to': this.element.children[idx].children[0].element,
			'true': [ 'accordion', 'body' ],
		}));
		return this;
	}
}
