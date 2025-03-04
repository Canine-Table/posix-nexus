#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Dom } from '../dom.mjs';
import { Str } from '../str.mjs';
import { nexEvent } from '../event.mjs';
import { nexButton } from './buttons.mjs';
import { nexSvg, nexSvgCanvas } from './svg.mjs';
import { nexList } from './lists.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
export class nexDrop
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
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
		if (Type.isObject(obj.svg)) {
			obj.svg.in = Dom.skel(obj.svg.in);
			obj.svg.out = Dom.skel(obj.svg.out);
			obj.svg.out.prop.viewBox = obj.svg.box;
			obj.svg.out.prop.width = obj.svg.width;
			obj.svg.out.prop.height = obj.svg.height;
			obj.svg.in.prop.href = obj.svg.id;
			obj.svg.in.prop.width = '100%';
			obj.svg.in.prop.height = '100%';
			if (! Type.isDefined(obj.svg.out.prop.fill))
				obj.svg.out.prop.fill = Dom.styles(to).color;
			obj.svg.out.prop = {
				...obj.svg.out.prop,
				'height': obj.svg.height || '16',
				'width': obj.svg.width || '16',
				'viewBox': obj.svg.box || '0 0 16 16'
			}
			let svg = new nexSvgCanvas({
					'to': to,
					...obj.svg.out
			}).use(obj.svg.in).parent.element;
			if (obj.svg.out.prop.fill === Dom.styles(to).color)
				this.svgs.push(svg);
		}

		nexEvent.add({
			'to': to,
			'evt': [
				{
					'on': 'c',
					'act': () => {
						this.svgs.forEach(i => {
							Dom.css(i, { 'fill': Dom.styles(Dom.root()).color });
						});
					}
				}
			]
		});

		if (Type.isDefined(text)) {
			Dom.append(nexComponent.span({
				'text': text,
				'cls': Type.isDefined(obj.padText, 'ms-2')
			}), to);
		}
		return this;
	}
}

