#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
import { nexComponent } from '../components.mjs';
import { Str } from '../str.mjs';
export class nexCard
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexCard instances require a parent to append to");
		this.parent = obj.to;
		this.children = {
			'header': [],
			'body': [],
			'footer': [],
			'image': []
		}
		this.self = this;
		this.id = Dom.setId(`${this.parent.id}-card`);
		obj.id = this.id;
		this.element = Dom.append(nexComponent.div({
			'id': this.id,
			'true': [ 'card' ],
			...obj
		}), this.parent);
		return this;
	}

	#addElement(obj, key, rtn) {
		if (Type.isDefined(key) && Type.isArray(this.children[key])) {
			const cnt = this.children[key].length + 1;
			if (key === 'image')
				obj.tag = 'image';
			else
				obj.tag = 'div';
			this.children[key].push({
				'element': Dom.append(nexComponent[obj.tag]({
					'id': `${this.id}-${key}${cnt}`,
					'true': [ 'card', key ],
					...obj
				}), this.element),
				'title': [],
				'body': [],
				'parent': this
			});
			if (Type.isObject(obj.title))
				this.addTitle(obj.title, this.children[key][cnt - 1]);
			if (Type.isObject(obj.body))
				this.addText(obj.body, this.children[key][cnt - 1]);
			if (Type.isTrue(rtn))
				return this.children[key][cnt - 1];
			else
				return this;

		}
	}

	#addToElement(obj, key, ref, rtn) {
		if (Dom.isElement(ref.element) && Type.isDefined(key) && Type.isArray(ref[key])) {
			const cnt = ref[key].length + 1;
			switch (key) {
				case 'title':
					obj.tag = 'h';
					break;
				case 'body':
					obj.tag = 'p';
					break;
			}
			ref[key].push(Dom.append(nexComponent[obj.tag]({
				'id': `${ref.element.id}-${obj.tag}${cnt}`,
				'true': [ 'card' ],
				...obj
			}), ref.element));
			if (Type.isTrue(rtn))
				return ref[key][cnt - 1];
		}
		return this;
	}

	addHeader(obj, rtn) {
		return this.#addElement(obj, 'header', rtn);
	}

	addBody(obj, rtn) {
		return this.#addElement(obj, 'body', rtn);
	}

	addFooter(obj, rtn) {
		return this.#addElement(obj, 'footer', rtn);
	}

	addImage(obj, rtn) {
		return this.#addElement(obj, 'image', rtn);
	}

	addTitle(obj, ref, rtn) {
		return this.#addToElement(obj, 'title', ref, rtn);
	}

	addText(obj, ref, rtn) {
		return this.#addToElement(obj, 'body', ref, rtn);
	}
}

