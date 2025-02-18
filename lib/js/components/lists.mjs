#!/usr/bin/env node
import { Dom } from '../dom.mjs';
import { Component } from '../components.mjs';
export class List
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("List instances require a parent to append to");
		this.parent = obj.to;
		this.items = 0;
		this.children = [];
		this.id = `${this.parent.id}-list`;
		obj.id = this.id;
		this.element = Dom.append(Component.list(obj), this.parent);
	}

	#nextItem() {
		return ++this.items;
	}
	get item() {
		return this.items;
	}
	addLink(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-b${item}`;
		this.children.push(Dom.append(Component.link(obj), this.element));
	}

	addItem(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-l${item}`;
		this.children.push(Dom.append(Component.item(obj), this.element));
	}

	addButton(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-i${item}`;
		this.children.push(Dom.append(Component.button(obj), this.element));
	}
}

