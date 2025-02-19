#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Dom } from '../dom.mjs';
import { nexComponent } from '../components.mjs';
import { Arr } from '../arr.mjs';
import { nexList } from './lists.mjs';
import { Str } from '../str.mjs';
export class nexFooter
{
	constructor(obj) {
		obj = Dom.skel(obj);
		let tmp = '';
		if (! Dom.isHtml(obj.to))
			throw new Error("nexFooter instances require a parent to append to");
		this.parent = obj.to;
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}`;
		this.element = Dom.append(nexComponent.footer(obj), Dom.append(nexComponent.div({ 'size': 'fluid' }), this.parent));
		this.author = Type.isDefined(obj.author, Dom.meta({ 'val': 'author' }));
		this.cprt = Type.isDefined(obj.cprt, 'all rights reserved');
		this.list = new nexList({ 'cls': 'nav justify-content-center border-bottom pb-3 mb-3', 'to': this.element });
		Dom.append(nexComponent.p({
			'cls': 'text-center text-body-secondary',
			'text': `© ${new Date().getFullYear()} ${this.author}, ${this.cprt}`
		}), this.element);
	}
}

