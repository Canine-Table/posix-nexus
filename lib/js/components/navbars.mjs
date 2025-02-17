#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Component } from '../components.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class Navbar
{
	constructor(obj) {
		obj = Dom.skel(obj);
		let tmp = '';
		if (! Dom.isHtml(obj.to))
			throw new Error("List instances require a parent to append to");
		this.parent = obj.to;
		this.id = `${this.parent.getAttribute('id')}-navbar`;
		obj.id = this.id
		this.element = Dom.append(Component.navbar(obj), this.parent);
		obj.toggle = Component.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
		Dom.append(Component.div({
			'id': `${this.id}-body`,
			'size': 'fluid'
		}), this.element);
		if (Type.isDefined(obj.brand)) {
			Dom.append(Component.link({
				'id': `${this.id}-brand`,
				'true': [ 'nav', 'brand' ],
				'text': obj.brand
			}), Dom.byId(`${this.id}-body`));
		}
		Dom.append(Component.span({
			'true': [ 'nav', 'icon' ],
			'id': `${this.id}-icon`
		}), Dom.append(Component.button({
			'id': `${this.id}-toggler`,
			'true': [ 'nav' ],
			'toggle': obj.toggle,
			'target': `${this.id}-options`,
			'label': 'Toggle navigation'
		}), Dom.byId(`${this.id}-body`)));
		Dom.append(Component.div({
			'id': `${this.id}-options`,
			'true': [ 'nav' ],
			'toggle': obj.toggle,
			'location': obj.location,
			'label': `${this.id}-options-label`,
		}), Dom.byId(`${this.id}-body`));
		if (obj.toggle === 'offcanvas') {
			Dom.append(Component.header({
				'header': obj.header,
				'id': `${this.id}-options-label`,
				'true': [ 'nav' ],
				'text': obj.title
			}), Dom.append(Component.div({
				'id': `${this.id}-options-header`,
				'true': [ 'nav', 'header' ],
				'toggle': obj.toggle,
			}), Dom.byId(`${this.id}-options`)));

			Dom.append(Component.button({
				'id': `${this.id}-options-close`,
				'toggle': obj.toggle,
				'true': [ 'nav', 'close' ],
				'label': 'Close'
			}),Dom.byId(`${this.id}-options-header`));
		}
	}
}
