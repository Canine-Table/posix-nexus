#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexCarousel
{
	constructor(obj) {
		obj = Dom.skel(obj);
		let tmp = '';
		if (! Dom.isHtml(obj.to))
			throw new Error("nexCarousel instances require a parent to append to");
		this.parent = obj.to;
		this.slides = [];
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}-carousel`;
		obj.id = this.id;
		this.element = new nexContainer({
			'id': this.id,
			'to': this.parent,
			'true': [ 'carousel' ]
		});
		if (Type.isTrue(obj.indicators)) {
			this.indicators = true;
			this.element.addRows(1, {
				'true': [ 'carousel', 'indicators' ]
			});
		}
		this.element.addRows(1, {
			'true': [ 'carousel', 'inner' ]
		});

		if (Type.isTrue(obj.next)) {
			// TODO
		}
		if (Type.isTrue(obj.prev)) {
			// TODO
		}
	}
}

