#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Dom } from '../dom.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexButton } from './buttons.mjs';
import { Arr } from '../arr.mjs';
import { nexList } from './lists.mjs';
import { Str } from '../str.mjs';
export class nexFooter
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexFooter instances require a parent to append to");
		this.parent = obj.to;
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}`;
		this.element = new nexContainer({
			'id': this.id,
			'to': this.parent,
			...obj
		});
		this.footer = Dom.append(nexComponent.footer(obj), this.element.element)
		this.author = Type.isDefined(obj.author, Dom.meta({ 'val': 'author' }));
		this.cprt = Type.isDefined(obj.cprt, 'all rights reserved');
		if (! Type.isObject(obj.button))
			obj.button = {};
		this.list = new nexButton({
			'to': this.footer,
			'toolbar': Type.isDefined(obj.toolbar, 'footer toolbar button group'),
			...obj.button
		});
		Dom.append(nexComponent.p({
			'text': `<hr>© ${new Date().getFullYear()} ${this.author}, ${this.cprt}`,
			...obj
		}), this.footer);
	}
}

