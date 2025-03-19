#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { nexEvent } from '../event.mjs';
import { nexNode } from './nex-node.mjs';
import { nexSvg } from './nex-svg.mjs';
import { nexClass } from '../class.mjs';
export class nexDrop extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexDrop;
		obj.tag = Arr.shortStart(Type.isDefined(obj.tag, 'div'), [ 'div', 'li' ]) || 'div';
		super(obj);
		if (! Type.isObject(obj['toggle']))
			obj['toggle'] = {};
		obj['toggle'].tag = Arr.shortStart(Type.isDefined(obj['toggle'].tag, 'button'), [ 'a', 'button' ]) || 'a';
		let toggle = obj['toggle'].tag;
		if (Type.isObject(obj['split'])) {
			obj['split'].tag = Arr.shortStart(Type.isDefined(obj['split'].tag, obj['toggle'].tag), [ 'a', 'button' ]) || obj['toggle'].tag;
			toggle = obj['split'].tag;
			if (! Type.isObject(obj['split']['span']))
				obj['split']['span'] = {};
			obj['split']['span'].tag = 'span';
			this.button = this.class({
				'add': 'btn-group'
			}).frag([
				{
					...obj['toggle']
				},
				{
					...obj['split']
				}
			]).nodes[obj['split'].tag][this.nodes[obj['split'].tag].length - 1].class({
				'add': 'dropdown-toggle dropdown-toggle-split'
			}).setAttr({
				'data-bs-toggle': 'dropdown',
				'aria-expanded': 'false'
			}).frag({
				...obj['split']['span']
			}).nodes.span[0].class({
				'add': 'visually-hidden'
			}).text('Toggle Dropdown').back(2).nodes[obj['toggle'].tag][0].setAttr({
				'type': 'button'
			}).frag({
				'tag': 'span',
				'cls': {
					'add': 'd-lg-none d-flex'
				}
			});
		} else {
			this.button = this.class({
				'add': 'dropdown'
			}).frag({
				...obj['toggle']
			}).nodes[obj['toggle'].tag][0].class({
				'add': 'dropdown-toggle'
			}).setAttr({
				'type': 'button',
				'data-bs-toggle': 'dropdown',
				'aria-expanded': 'false'
			}).frag([
				{
					'tag': 'span',
					'cls': {
						'add': 'd-flex d-lg-none'
					}
				}
			]);
		}
		if (! Type.isObject(obj['list']))
			obj['list'] = {};
		obj['list'].tag = Arr.shortStart(Type.isDefined(obj['list'].tag, 'ul'), [ 'ol', 'ul' ]) || 'ol';
		this.list = this.frag({
			...obj['list']
		}).nodes[obj['list'].tag][0].class({
			'add': 'dropdown-menu'
		});
		this.nodes[toggle][this.nodes[toggle].length - 1].setAttr({
			'data-bs-auto-close': Arr.shortStart(Type.isDefined(obj.close, 'true'), [ 'inside', 'outside','true', 'false' ]) || 'true',
		});
		this.items = [];
		return this;
	}

	item(obj) {
		nexNode.Skel(obj);
		obj.tag = 'li';
		if (! Type.isObject(obj['item']))
			obj['item'] = {};
		obj['item'].tag = Arr.shortStart(Type.isDefined(obj['item'].tag, 'button'), [ 'a', 'button' ]) || 'a';
		const item = this.list.frag({
			...obj
		}).nodes.li[this.list.nodes.li.length - 1].frag({
			...obj['item']
		}).nodes[obj['item'].tag][0].class({
			'add': `dropdown-item ${this.items.length === 0 ? 'active' : ''}`
		})
		this.items.push(item);
		if (Type.isArray(obj['item'].evt)) {
			nexEvent.add({
				'to': item.element,
				'evt': obj['item'].evt
			});
		}
		if (Type.isDefined(obj['item'].svg)) {
			new nexSvg({
				'to': this.items[this.items.length - 1],
				'attach': {
					'place': 'first'
				},
				'prop': {
					'viewbox': '0 0 16 16',
					'height': '24px',
					'width': '24px',
					'class': 'me-2 mx-lg-2',
					'fill': 'currentColor'
				}
			}).svg({
				'svg': 'use',
				'href': obj['item'].svg
			})
		}
		this.#activeItem(item);
		if (this.items.length === 1)
			this.items[this.items.length - 1].element.click();
		return this;
	}

	#activeItem(itm) {
		itm.element.addEventListener('click', () => {
			for (let i = 0; i < this.items.length; i++)
				this.items[i].class({ 'del': 'active' });
			itm.class({ 'add': 'active' });
			if (Type.isArray(itm.nodes.svg)) {
				const ref = this.button.element.childNodes[0]
				nexNode.Attach({
					'to': this.button.element,
					'element': nexNode.Copy(itm.nodes.svg[0].element),
					'attach': ref.nodeName === 'svg' ? { 'place': 'replace', 'ref': ref } : { 'place': 'first' }
				})
			}
			this.button.nodes.span[0].element.innerText = itm.value;
		});
	}

	#item(obj) {
		return this.list.frag({
			...obj
		}).nodes.li[this.list.nodes.li.length - 1].frag({
			...obj['item']
		}).nodes[obj['item'].tag][0];
	}

	header(obj = {}) {
		nexNode.Skel(obj);
		obj.tag = 'li';
		if (! Type.isObject(obj['item']))
			obj['item'] = {};
		obj['item'].tag = Arr.shortStart(Type.isDefined(obj['item'].tag , 'h6'), [
			'h1', 'h2', 'h3', 'h4', 'h5', 'h6'
		]) || 'h6';
		this.#item(obj).class({
			'add': 'dropdown-header'
		});
		return this;
	}

	hr(obj = {}) {
		nexNode.Skel(obj);
		obj.tag = 'li';
		if (! Type.isObject(obj['item']))
			obj['item'] = {};
		obj['item'].tag = 'hr';
		this.#item(obj).class({
			'add': 'dropdown-divider'
		});
		return this;
	}
	
	text(obj = {}) {
		nexNode.Skel(obj);
		obj.tag = 'li';
		if (! Type.isObject(obj['item']))
			obj['item'] = {};
		obj['item'].tag = 'span';
		this.#item(obj).class({
			'add': 'dropdown-item-text'
		});
		return this;
	}
}
