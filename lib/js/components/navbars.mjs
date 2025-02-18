#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Component } from '../components.mjs';
import { List } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class Navbar
{
	#list = {};
	constructor(obj) {
		obj = Dom.skel(obj);
		let tmp = '';
		if (! Dom.isHtml(obj.to))
			throw new Error("List instances require a parent to append to");
		this.parent = obj.to;
		this.tabs = [];
		this.links = [];
		this.id = `${this.parent.getAttribute('id')}-navbar`;
		obj.id = this.id
		this.element = Dom.append(Component.navbar(obj), this.parent);
		obj.toggle = Component.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
		Dom.append(Component.div({
			'id': `${this.id}-body`,
			'size': 'fluid'
		}), this.element);
		if (Type.isDefined(obj.brand)) {
			this.tabs.push(Dom.append(Component.link({
				'id': `${this.id}-brand`,
				'true': [ 'nav', 'brand' ],
				'cls': 'tab-link active',
				'text': obj.brand,
				'fa': obj.fa,
				'prop': {
					'onclick': `switchTab(event, "${obj.link}")`,
					'href': `#${obj.link}`
				}
			}), Dom.byId(`${this.id}-body`)));
			this.tabs.push(Dom.append(Component.div({
				'id': obj.link,
				'size': 'fluid',
				'cls': `container-tab`,
				'css': {
					'display': 'flex'
				}
			}), this.parent));
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
				'cls': 'border-bottom',
				'toggle': obj.toggle,
			}), Dom.byId(`${this.id}-options`)));
			Dom.append(Component.button({
				'id': `${this.id}-options-close`,
				'toggle': obj.toggle,
				'true': [ 'nav', 'close' ],
				'label': 'Close'
			}), Dom.byId(`${this.id}-options-header`));
			this.content = Dom.append(Component.div({
				'id': `${this.id}-options-body`,
				'true': [ 'nav', 'body' ],
				'toggle': obj.toggle,
			}), Dom.byId(`${this.id}-options`));
		}
		this.#list = new List({
			'to': this.content,
			'location': obj.justify,
			'true': [ ...obj.bar, 'nav' ]
		})
	}
	addSep() {
		this.#list.addItem();
		this.links.push(Dom.append(Component.hrule({
			'true': [ 'dropdown' ]
		}), Dom.byId(`${this.id}-options-body-list-l${this.#list.item}`)));
	}
	addLink(obj) {
		obj = Dom.skel(obj);
		let tabState = 'none';
		let linkState = '';
		if (this.tabs.length === 0) {
			tabState = 'flex';
			linkState = 'active';
		}
		this.#list.addItem({ 'true': [ 'nav', 'item' ] });
		this.links.push(Dom.append(Component.link({
			'id': `${obj.id}-link`,
			'text': obj.text,
			'fa': obj.fa,
			'true': [ 'nav', 'link' ],
			'cls': `tab-link ${linkState}`,
			'prop': {
				'onclick': `switchTab(event, "${obj.id}")`,
				'href': `#${obj.id}`
			}
		}), Dom.byId(`${this.id}-options-body-list-l${this.#list.item}`)));
		obj.css.display = tabState;
		obj.cls = `${obj.cls} container-tab`;
		obj.size = 'fluid';
		delete obj.text
		this.tabs.push(Dom.append(Component.div(obj), this.parent));
	}
}

