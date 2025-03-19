#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';

export class nexCard extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexCard;
		obj.tag = 'div';
		return super(obj).class({
			'add': 'card nex-card'
		});
	}

	static #nexCardFragment(obj) {
		if (Type.isDefined(obj)) {
			if (Type.isObject(obj))
				obj = [ obj ];
			Type.isArray(obj, ',').forEach(el => {
				if (Type.isObject(el) && (Type.isDefined(el.tag) || Type.isDefined(el.card))) {
					nexNode.Skel(el);
					switch (el.card) {
						case 'body':
							el.tag = nexNode.ContainerTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-body');
							break;
						case 'title':
							el.tag = nexNode.HeaderTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-title');
							break;
						case 'subtitle':
							el.tag = nexNode.HeaderTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-subtitle mb-2 text-body-secondary');
							break;
						case 'text':
							el.tag = 'p';
							el.cls.add = Str.merge(el.cls.add, 'card-text');
							break;
						case 'image':
							el.cls.add = Str.merge(el.cls.add, `card-img-${Arr.shortStart(Type.isDefined(obj.tag, 'top'), [ 'top', 'bottom' ]) || 'bottom'}`);
							el.tag = 'img';
							break;
						case 'header':
							el.tag = nexNode.ContainerTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-header bg-body-tertiary');
							break;
						case 'list':
							let tmpa = Array.shortStart(Type.isDefined(obj.tabs, ''), [ 'tabs', 'pills' ]);
							if (tmpa !== '')
								tmpa = `nav-${tmpa} card-header-${tmpa}`;
							else
								tmpa = undefined;
							el.tag = nexNode.ListTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, Type.isDefined(tmpa, 'card-header'));
							break;
						case 'footer':
							el.tag = nexNode.ContainerTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-footer bg-body-tertiary');
							break;
						case 'link':
							el.tag = nexNode.ButtonTag(el.tag);
							el.cls.add = Str.merge(el.cls.add, 'card-link');
							break;
					}
					if (Type.isObject(el.child))
						el.child = [ el.child ];
					if (Type.isArray(el.child))
						el.child = nexCard.#nexCardFragment(el.child);
				}
			});
			return obj;
		}
	}

	card(obj) {
		if (Type.isObject(obj))
			obj = [ obj ];
		Type.isArray(obj, ',').forEach(el => {
			if (Type.isObject(el))
				el = nexCard.#nexCardFragment(el);
		});
		return this.frag(obj);
	}
}
