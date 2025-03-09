#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Int } from '../int.mjs';
import { Dom } from '../dom.mjs';
import { nexEvent } from '../event.mjs';
import { nexComponent } from '../components.mjs';
import { nexClass } from '../class.mjs';

export class nexNode
{
	constructor(obj) {
		this.#instance({
			'def': obj.def || 'div',
			'inst': obj.inst || nexNode,
		}, obj);
		if (obj.tag !== 'frag') {
			this.#xmlns(obj);
			this.css(obj);
			if (Type.isObject(obj.prop))
				this.attr({ 'set': obj.prop });
			if (Type.isObject(obj.ns))
				this.attr({ 'xmlns': obj.ns });
			this.add(obj.to);
			this.idx(obj);
		}
		return this;
	}

	static get root() {
		return document.documentElement;
	}

	static get head() {
		return document.head;
	}

	static get body() {
		return document.body;
	}

	static defaultNode(nd, def) {
		if (nexNode.isNode(nd))
			return nd;
		if (nexNode.isNode(def))
			return def;
		return nexNode.body;
	}

	#coords(val) {
		return [
			this.element[`${val}Left`],
			this.element[`${val}Top`],
			this.element[`${val}Width`],
			this.element[`${val}Height`]
		];
	}

	static #coord(elm, val) {
		if (nexNode.isNode(elm)) {
			return [
				elm[`${val}Left`],
				elm[`${val}Top`],
				elm[`${val}Width`],
				elm[`${val}Height`]
			];
		}
	}

	get clientCoords() {
		return this.#coords('client');
	}

	static clientCoords(elm) {
		return nexNode.#coord(elm, 'client');
	}

	get offsetCoords() {
		return this.#coord('offset');
	}

	static offsetCoords(elm) {
		return nexNode.#coord(elm, 'offset');
	}

	get scrollCoords() {
		return this.#coords('scroll');
	}

	static scrollCoords(elm) {
		return nexNode.#coord(elm, 'scroll');
	}

	static isNode(val) {
		return val instanceof Node;
	}

	static isElement(val) {
		return val instanceof Element;
	}

	static isHtml(val) {
		return val instanceof HTMLElement || val instanceof HTMLDocument;
	}

	static isSvg(val) {
		return val instanceof SVGElement;
	}

	static byId(val) {
		return document.getElementById(val);
	}

	static byTag(elm, val) {
		return nexNode.defaultNode(val).getElementsByTagName(elm);
	}

	static byName(elm, val) {
		return nexNode.defaultNode(val).getElementsByName(elm);
	}

	static byClass(elm, val) {
		return nexNode.defaultNode(val).getElementsByClassName(elm);
	}

	static byQuery(elm, val) {
		return nexNode.defaultNode(val).querySelector(elm);
	}

	static byAll(elm, val) {
		return nexNode.defaultNode(val).querySelectorAll(elm);
	}

	static tagCount(elm, val) {
		if (nexNode.isNode(elm) && Type.isDefined(val))
			return nexNode.byAll(`:scope > ${val}`, elm).length;
	}

	static skel(obj) {
		if (! Type.isObject(obj))
			throw new Error('nexNode requires a reference object to modify');
		if (! Type.isObject(obj['prop']))
			obj['prop'] = {};
		if (! Type.isObject(obj['css']))
			obj['css'] = {};
	}

	get hasParent() {
		return Type.isDefined(this.parent) && nexNode.isNode(this.parent.element);
	}
	
	get children() {
		if (this.nodes.length > 0) {
			Object.values(this.nodes).forEach(el => {
				console.log(el)
			});
		}
	}

	get remove() {
		if (this.hasParent()) {
			this.element.remove();
				return this.parent
			}
		}
		return this;
	}
	idx(obj = {}, len = 8) {
		nexNode.skel(obj);
		if (! (Type.isDefined(obj.id) || Type.isFalse(obj.id))) {
			let parent = undefined;
			if (nexNode.isNode(obj.to))
				parent = obj.to;
			else if (Type.isDefined(this.parent) && nexNode.isNode(this.parent.element))
				parent = this.parent.element;
			if (Type.isDefined(parent) && ! (this.element instanceof DocumentFragment)) {
				let tmp = 0;
				if (this.element.parentNode instanceof DocumentFragment)
					tmp = 1;
				len = Number(Type.isIntegral(len) ? len : 8);
				let idx = `${parent.id || Str.random(len)}-${obj.tag}${nexNode.tagCount(parent, obj.tag) + tmp}`;
				do {
					idx = nexNode.byId(idx) ? `${Str.random(len++)}-${obj.tag}0` : idx;
				} while (nexNode.byId(idx));
				this.attr({ 'set': { 'id': idx } });
			}
		}
		return this;
	}

	#instance(val, obj) {
		nexNode.skel(obj);
		obj.tag = obj.tag || val.def;
		val.inst = val.inst || nexNode;
		if (Type.isDefined(obj.to)) {
			if (obj.to instanceof val.inst) {
				if (! Type.isDefined(obj.tag))
					throw new Error('nodes require the tag attribute');
				if (! Type.isObject(obj.to.nodes))
					this.parent.nodes = {};
				if (! Type.isArray(obj.to.nodes[obj.tag]))
					obj.to.nodes[obj.tag] = [];
				obj.to.nodes[obj.tag].push(this);
				this.parent = obj.to;
				obj.to = obj.to.element;
			}
		}
		if (! nexNode.isNode(obj.to))
			obj.to = nexNode.body;
		this.nodes = {};
		return this;
	}

	#xmlns(obj) {
		const xml = [];
		nexNode.skel(obj);
		if (Type.isDefined(obj.xmlns)) {
			Type.isArray(obj.xmlns, ',').forEach(ns => {
				switch (Arr.shortStart(Str.toLower(ns), [
					'svg', 'rdf', 'xforms', 'xquery',
					'xml', 'xhtml', 'xslt', 'xlink',
					'mathml', 'xpath'
				]) || null) {
					case 'svg':
						xml.push({ 'svg': 'http://www.w3.org/2000/svg' });
						break;
					case 'rdf':
						xml.push({ 'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns' });
						break;
					case 'xforms':
						xml.push({ 'xforms': 'http://www.w3.org/2002/xforms' });
						break;
					case 'xquery':
						xml.push({ 'xquery': 'http://www.w3.org/1999/XPath' });
						break;
					case 'xhtml':
						xml.push({ 'xhtml': 'http://www.w3.org/1999/xhtml' });
						break;
					case 'xml':
						xml.push({ 'xml': 'http://www.w3.org/XML/1998/namespace' });
						break;
					case 'xslt':
						xml.push({ 'xml': 'http://www.w3.org/1999/XSL/Transform' });
						break;
					case 'xlink':
						xml.push({ 'xlink': 'http://www.w3.org/1999/xlink' });
						break;
					case 'mathml':
						xml.push({ 'mathml': 'http://www.w3.org/1998/Math/MathML' });
						break;
					case 'xpath':
						xml.push({ 'xpath': 'http://www.w3.org/1999/XPath' });
						break;
					default:
						return null;
				}
			});
		}
		if (xml.length > 0) {
			for (let i = 0; i < xml.length; i++) {
				Object.entries(xml[i]).forEach(([k, v]) => {
					if (i === 0)
						this.element = document.createElementNS(v, obj.tag);
					this.attr({ 'xmlns': { v: { k: v } } });
				});
			}
		} else {
			this.element = document.createElement(obj.tag);
		}
		return this;
	}

	add(elm) {
		if (Type.isDefined(this.parent))
			this.parent.element.appendChild(this.element);
		else if (nexNode.isElement(elm))
			elm.appendChild(this.element);
	}

	attr(obj) {
		if (Type.isObject(obj) && Type.isDefined(this.element)) {
			Object.entries(obj).forEach(([k, v]) => {
				switch (k) {
					case'has':
						break;
					case 'get':
						break;
					case 'remove':
						break;
					case 'xmlns':
						if (Type.isObject(v)) {
							Object.entries(v).forEach(([l, w]) => {
								if (Type.isObject(w)) {
									Object.entries(w).forEach(([m, x]) => {
										this.element.setAttributeNS(l, `xmlns:${m}`, x);
									});
								}
							});
						}
						break;
					case 'set':
						if (Type.isObject(v))
							Object.entries(v).forEach(([l, w]) => {
								this.element.setAttribute(l, w);
							});
						break;
				}
			});
		}
	}

	css(obj) {
		if (nexNode.isElement(this.element) && Type.isObject(obj))
			Obj.assign(this.element, 'style', obj);
	}

	style(obj) {

	}

	back(cnt = 1) {
		if (Type.isDefined(this.parent) && nexNode.isNode(this.parent.element) && Number(cnt) > 0)
			return this.parent.back(--cnt);
		else if (nexNode.isNode(this.element))
			return this;
	}

	sibling(cnt = 1) {
		if (Type.isDefined(this.parent) && nexNode.isNode(this.parent.element)) {
			cnt = Type.isIntegral(cnt) ? cnt: 1;
			const nd = this.parent.nodes[Str.toLower(this.element.nodeName)];
			if (nd.length === 1)
				return nd[0];
			else
				return nd[Int.loop(nd.indexOf(this) + cnt, 0, nd.length)];
		}
		return this;
	}

	get leafs() {
		const nd = Str.toLower(this.element.nodeName);
		const leafs = [];
		function branch(elm, nd) {
			if (Type.isArray(elm.nodes[nd])) {
				elm.nodes[nd].forEach(n => {
					branch(n, nd);
				});
			} else {
				leafs.push(elm);
			}
		}
		branch(this, nd);
		return leafs;
	}

	get root() {
		let cur = this;
		if (Type.isDefined(cur.parent)) {
			do {
				cur = cur.back(1);
			} while (Type.isDefined(cur.parent));
		}
		return cur;
	}

	append(obj) {
		let ref = undefined;
		if (Type.isDefined(this.parent) && nexNode.isNode(this.parent.element))
			ref = this.parent.element
		else if (nexNode.isNode(this.element))
			ref = this.element.parentNode;
		if (Type.isDefined(ref)) {
			if (Type.isTrue(obj.pre)) {
				console.log(ref.firstChild)
			}
		}
			//console.log(this.parent)
			console.log(ref);
		//}
	}

	#nexFrag = class extends nexNode {
		constructor(obj) {
			super(obj);
			if (Type.isUndefined(this.element)) {
				this.parent = obj.parent;
				this.element = obj.to;
			} else if (this.parent.element instanceof DocumentFragment && nexNode.isNode(this.parent.parent.element)) {
				obj.to = this.parent.parent;
				this.#instance({
					'def': obj.def || 'div',
					'inst': obj.inst || nexNode
				}, obj);
				this.fragment = this.parent;
				this.idx(obj);
			}
			if (Type.isObject(obj.element)) {
				obj.element.to = this;
				new this.#nexFrag(obj.element);
			}
			return this;
		}
	}

	frag(obj) {
		if (Type.isObject(obj)) {
			if (Type.isFalse(this.element instanceof DocumentFragment)) {
				obj.to = document.createDocumentFragment();
				obj.parent = this;
				obj.tag = 'frag';
				const frag = new this.#nexFrag(obj);
				if (Type.isFalse(obj.append))
					return frag;
				Dom.append(frag.element, this.element);
			}
		}
		return this;
	}
}

