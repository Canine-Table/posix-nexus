#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Dom } from '../dom.mjs';
import { Str } from '../str.mjs';
import { nexEvent } from '../event.mjs';
import { nexButton } from './buttons.mjs';
import { nexSvg } from './svg.mjs';
import { nexList } from './lists.mjs';
import { nexComponent } from '../components.mjs';
import { nexClass } from '../class.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
export class nexDrop
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isElement(obj.to))
			throw new Error("nexDrop instances require a parent to append to");
		this.parent = obj.to;
		this.svgs = [];
		this.id = `${Dom.setId(this.parent.id || this.parent.getAttribute('id'))}-drop`;
		obj.id = this.id;
		if (! Type.isObject(obj.button))
			obj.button = {};
		this.element = new nexButton({
			'id': this.id,
			'to': this.parent,
			...obj.button
		});

		if (Type.isTrue(obj.split)) {
			this.element.addButton([
				{
					'id': `${this.id}-dropdown`,
					'nexBtn': 'button',
					'cls': `${obj.cls}`,
					...obj
				},
				{
					'id': `${this.id}-dropdown-split`,
					'nexBtn': 'button',
					'text': '<span class="visually-hidden">Toggle Dropdown</span>',
					'cls': `${obj.cls} btn`,
					'true': [ 'split', 'dropdown' ],
					'variant': obj.variant
				},
			]);
		} else {
			this.element.addButton([
				{
					'id': `${this.id}-dropdown`,
					'nexBtn': 'button',
					'cls': `${obj.cls} btn`,
					'true': [ 'dropdown' ],
					...obj
				}
			]);
		}
		this.list = new nexList({
			'to': this.element.element.element,
			'true': [ 'dropdown' ],
			'location': obj.location,
			'size': obj.size
		});
		return this;
	}

	addItem(obj, lst) {
		obj = Dom.skel(obj);
		const text = obj.text;
		delete obj.text;
		lst = Dom.skel(lst);
		this.list.addItem([
			{
				'item': lst,
				'element': {
					'component': Type.isDefined(lst.component, 'link'),
					'true': [ 'dropdown', 'item' ],
					...obj,
				}
			}
		]);
		const idx = this.list.children.length - 1;	
		const to = this.list.children[idx].children[0];
		if (Type.isArray(lst.evt)) {
			nexEvent.add({
				'to': to,
				'evt': lst.evt
			});
		}
		let svg = undefined;
		if (Type.isObject(obj.svg)) {
			new nexSvg({
				'to': to,
				'size': {
					'h': '16px',
					'w': '16px',
					'v': '0 0 16 16'
				}
			}).use({
				'clsAdd': 'bi',
				'color': {
					'f': 'currentColor'
				},
				'prop': {
					'href': obj.svg.id
				}
			});
		}

		if (Type.isDefined(text)) {
			new nexSvg({
				'to': to,
				'size': {
					'h': '24px',
					'w': '100%',
				}
			}).text({
				'txt': text,
				'clsAdd': 'bi',
				'color': {
					'f': 'currentColor'
				},
				'axis': {
					'y': '12px',
					'x': '24px'
				},
				'text': {
					's': '16px'
				}
			});
		}

		return this;
	}
}

