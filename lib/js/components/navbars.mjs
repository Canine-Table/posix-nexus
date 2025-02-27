#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexNavbar
{
	#list = {};
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexNavbar instances require a parent to append to");
		this.parent = obj.to;
		this.tabs = [];
		this.links = [];
		this.title = document.title;
		this.id = `${Dom.setId(this.parent.id || this.parent.getAttribute('id'))}-navbar`;
		obj.id = this.id;
		obj.cls = `${obj.cls}`;
		this.element = Dom.append(nexComponent.navbar(obj), this.parent);
		obj.toggle = nexComponent.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
		Dom.append(nexComponent.div({
			'id': `${this.id}-body`,
			'size': 'fluid'
		}), this.element);
		if (Type.isDefined(obj.brand)) {
			obj.link = Str.camelCase(obj.link);
			this.links.push(Dom.append(nexComponent.link({
				'id': `${this.id}-${obj.link}-link`,
				'true': [ 'nav', 'brand' ],
				'cls': 'active',
				'text': obj.brand,
				'fa': obj.fa,
				'href': `#${obj.link}`
			}), Dom.byId(`${this.id}-body`)));
			this.tabs.push(new nexContainer({
				'id': `${this.id}-${obj.link}`,
				'size': 'fluid',
				'to': this.parent,
				'css': {
					'display': 'flex'
				}
			}));
			this.tabSwitch(`${this.id}-${obj.link}`);
			document.title = `${this.title} - ${obj.brand}`
		}
		Dom.append(nexComponent.span({
			'true': [ 'nav', 'icon' ],
			'id': `${this.id}-icon`
		}), Dom.append(nexComponent.button({
			'id': `${this.id}-toggler`,
			'true': [ 'nav' ],
			'toggle': obj.toggle,
			'target': `${this.id}-options`,
			'label': 'Toggle navigation'
		}), Dom.byId(`${this.id}-body`)));
		Dom.append(nexComponent.div({
			'id': `${this.id}-options`,
			'true': [ 'nav' ],
			'toggle': obj.toggle,
			'location': obj.location,
			'label': `${this.id}-options-label`,
		}), Dom.byId(`${this.id}-body`));
		if (obj.toggle === 'offcanvas') {
			Dom.append(nexComponent.h({
				'h': obj.h,
				'id': `${this.id}-options-label`,
				'true': [ 'nav' ],
				'text': obj.title,
			}), Dom.append(nexComponent.div({
				'id': `${this.id}-options-header`,
				'true': [ 'nav', 'header' ],
				'cls': 'border-bottom',
				'toggle': obj.toggle,
			}), Dom.byId(`${this.id}-options`)));
			Dom.append(nexComponent.button({
				'id': `${this.id}-options-close`,
				'toggle': obj.toggle,
				'true': [ 'nav', 'close' ],
				'label': 'Close'
			}), Dom.byId(`${this.id}-options-header`));
			this.content = Dom.append(nexComponent.div({
				'id': `${this.id}-options-body`,
				'true': [ 'nav', 'body' ],
				'toggle': obj.toggle,
			}), Dom.byId(`${this.id}-options`));
		}
		this.#list = new nexList({
			'to': this.content,
			'justifyy': obj.justify,
			'true': [ ...obj.bar, 'nav' ]
		});
	}

	addLink(obj) {
		obj = Dom.skel(obj);
		let tabState = 'none';
		let linkState = '';
		if (this.tabs.length === 0) {
			tabState = 'flex';
			linkState = 'active';
		}
		obj.id = Str.camelCase(obj.id);
		this.#list.addItem([
			{
				'item': {
					'true': [ 'nav', 'item' ]
				},
				'element': {
					'component': 'link',
					'id': `${this.id}-${obj.id}-link`,
					'text': obj.text,
					'fa': obj.fa,
					'true': [ 'nav', 'link' ],
					'cls': linkState,
					'href': `#${obj.id}`
				}
			}
		]);
		obj.css.display = tabState;
		obj.cls = obj.cls;
		obj.size = 'fluid';
		delete obj.text
		obj.id = `${this.id}-${obj.id}`;
		this.tabs.push(new nexContainer({...obj, 'to': this.parent }));
		this.links.push(this.#list.children[this.#list.children.length - 1].children[0]);
		this.tabSwitch(obj.id);
	}

	get list() {
		return this.#list.element;
	}

	tabSwitch(id) {
		Dom.byId(`${id}-link`).addEventListener('click', () => {
			for (let i = 0; i < this.tabs.length; i++) {
				Dom.css(this.tabs[i].element, { 'display': 'none' });
				Dom.class(this.links[i], { 'clsDel': 'active' });
			}
			Dom.css(Dom.byId(id), { 'display': 'flex' });
			Dom.class(Dom.byId(`${id}-link`), { 'clsAdd': 'active' });
			document.title = `${this.title} - ${Dom.byId(`${id}-link`).innerText}`;
		});
	}

	getTab(name) {
		for (let i = 0; i < this.tabs.length; i++) {
			if (this.tabs[i].id === `${this.id}-${Str.camelCase(name)}`)
				return this.tabs[i];
		}
	}

	getLink(name) {
		return Dom.byId(`${this.id}-${Str.camelCase(name)}-link`);
	}
}

