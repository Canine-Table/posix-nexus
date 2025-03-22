#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Int } from '../int.mjs';
import { nexEvent } from '../event.mjs';
import { nexClass } from '../class.mjs';

export class nexNode
{
	constructor(obj) {
		this.#instance({
			'def': 'div',
			'inst': nexNode,
		}, obj);
		if (obj.tag !== 'frag') {
			if (obj.tag === 'html')
				this.#root(obj);
			else
				this.create(obj);
			this.setAttr(obj.prop);
			this.class(obj.cls);
			this.css(obj.css);
			this.idx(obj);
			if (! Type.isFalse(obj.attach))
				this.attach(obj);
			if (Type.isDefined(obj.text))
				this.text(obj.text);
			if (Type.isDefined(obj.html))
				this.element.innerHTML = obj.html;
		}
		return this;
	}

	static get Root() {
		return window.document.documentElement;
	}

	static get Head() {
		return window.document.head;
	}

	static get Body() {
		return window.document.body;
	}

	static get Doctype() {
		return window.document.doctype;
	}

	static get Mode() {
		return window.document.documentMode;
	}

	static Style(val = '') {
		return window.getComputedStyle(val);
	}

	static get Base() {
		return window.document.baseURI;
	}

	static get Uri() {
		return window.document.documentURI;
	}

	static get Href() {
		return window.document.links;
	}

	static get Script() {
		return window.document.scripts;
	}

	static get Form() {
		return window.document.forms;
	}

	static get Cookie() {
		return window.document.cookie;
	}

	static get Embed() {
		return window.document.embeds;
	}

	static get Image() {
		return window.document.images;
	}

	static get State() {
		return window.document.readyState;
	}

	static get Strict() {
		return window.document.strictErrorChecking;
	}

	static get Title() {
		return window.document.title;
	}

	static set Title(val) {
		if (Type.isDefined(val))
			window.document.title = val;
	}

	static get Hash() {
		return window.location.hash;
	}

	static set Hash(val) {
		if (Type.isDefined(val) && val != nexNode.Hash)
			window.location.hash = val;
	}
	static get Encode() {
		return window.document.inputEncoding;
	}

	static get Refer() {
		return window.document.referrer;
	}

	static get Implement() {
		return window.document.implementation;
	}

	static get Url() {
		return window.document.URL;
	}

	static DefaultNode(nd, def) {
		if (nexNode.IsNode(nd))
			return nd;
		if (nexNode.IsNode(def))
			return def;
		return nexNode.Body;
	}

	static #Defaults(val = '', arr = [], def1 = '', def2 = '') {
		return Arr.shortStart(Type.isDefined(val, def1), arr) || def2;
	}

	static ListTag(val, def1 = 'ul', def2 = 'ol') {
		return nexNode.#Defaults(val, [ 'ol', 'ul' ], def1, def2);
	}

	static HeaderTag(val, def1 = 'h3', def2 = 'h6') {
		return nexNode.#Defaults(val, [ 'h1', 'h2', 'h3', 'h4', 'h5', 'h6' ], def1, def2);
	}

	static ButtonTag(val, def1 = 'a', def2 = 'button') {
		return nexNode.#Defaults(val, [ 'a', 'button' ], def1, def2);
	}

	static ContainerTag(val, def1 = 'div', def2 = def1) {
		return nexNode.#Defaults(val, [ 'article', 'section', 'div', 'header', 'footer', 'main', 'aside', 'figure', 'nav' ], def1, def2);
	}

	static Variant(val, def1 = '', def2 = def1) {
		return nexNode.#Defaults(val, [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark' ], def1, def2);
	}

	static #Coords(elm, val) {
		if (nexNode.IsNode(elm)) {
			return [
				elm[`${val}Left`],
				elm[`${val}Top`],
				elm[`${val}Width`],
				elm[`${val}Height`]
			];
		}
	}

	#coords(val) {
		return nexNode.#Coords(this.element, val);
	}

	static ClientCoords(elm) {
		return nexNode.#Coords(elm, 'client');
	}

	get clientCoords() {
		return this.#coords('client');
	}

	static OffsetCoords(elm) {
		return nexNode.#Coords(elm, 'offset');
	}

	get offsetCoords() {
		return this.#coords('offset');
	}

	static ScrollCoords(elm) {
		return nexNode.#Coords(elm, 'scroll');
	}

	get scrollCoords() {
		return this.#coords('scroll');
	}

	static IsNode(val) {
		return val instanceof Node;
	}

	static IsElement(val) {
		return val instanceof Element;
	}

	static IsHtml(val) {
		return val instanceof HTMLElement || val instanceof HTMLDocument;
	}

	static IsDocument(val) {
		return val instanceof Document || val instanceof DocumentType || val instanceof DocumentFragment;
	}

	static IsSvg(val) {
		return val instanceof SVGElement;
	}

	static ById(val) {
		return window.document.getElementById(val);
	}

	static ByTag(elm, val) {
		return nexNode.DefaultNode(val).getElementsByTagName(elm);
	}

	byTag(val) {
		return nexNode.ByTag(this.element, val);
	}

	static ByName(elm, val) {
		return nexNode.DefaultNode(val).getElementsByName(elm);
	}

	byName(val) {
		return nexNode.ByName(this.element, val);
	}

	static ByClass(elm, val) {
		return nexNode.DefaultNode(val).getElementsByClassName(elm);
	}

	byClass(val) {
		return nexNode.ByClass(this.element, val);
	}

	static ByQuery(elm, val) {
		return nexNode.DefaultNode(val).querySelector(elm);
	}

	byQuery(val) {
		return nexNode.ByQuery(this.element, val);
	}

	static ByAll(elm, val) {
		return nexNode.DefaultNode(val).querySelectorAll(elm);
	}

	byAll(val) {
		return nexNode.ByAll(this.element, val);
	}

	static TagCount(elm, val) {
		if (nexNode.IsNode(elm) && Type.isDefined(val))
			return nexNode.ByAll(`:scope > ${val}`, elm).length;
	}

	get tagCount() {
		if (Type.IsNode(this.element))
			return nexNode.TagCount(this.element, this.tag);
	}

	static Skel(obj) {
		if (! Type.isObject(obj))
			throw new Error('nexNode requires a reference object to modify');
		if (! Type.isObject(obj['prop']))
			obj['prop'] = {};
		if (! Type.isObject(obj['cls']))
			obj['cls'] = {};
		if (! Type.isObject(obj['css']))
			obj['css'] = {};
	}

	get hasParent() {
		return Type.isDefined(this.parent) && nexNode.IsNode(this.parent.element);
	}
	
	get children() {
		if (this.nodes.length > 0) {
			Object.values(this.nodes).forEach(el => {
				console.log(el)
			});
		}
	}

	static Remove(elm) {
		if (nexNode.IsNode(elm))
			elm.remove();
	}

	get remove() {
		if (this.hasParent) {
			const idx = this.parent.nodes[this.tag].indexOf(this);
			if (idx !== -1)
				this.parent.nodes[this.tag].splice(idx, 1);
			nexNode.Remove(this.element);
			return this.parent;
		}
		return this;
	}

	static Tag(elm) {
		if (nexNode.IsNode(elm))
			return Str.toLower(elm.nodeName);
	}

	get tag() {
		return nexNode.Tag(this.element);
	}

	static Type(elm) {
		if (nexNode.IsNode(elm))
			return elm.nodeType
	}

	get type() {
		return nexNode.Type(this.element);
	}

	static Instance(elm) {
		if (nexNode.IsNode(elm)) {
			switch (nexNode.Type(elm)) {
				case 1:
					return 'Element';
				case 2:
					return 'Attr';
				case 3:
					return 'Text';
				case 4:
					return 'CDATASection';
				case 5:
					return 'EntityReference';
				case 6:
					return 'Entity';
				case 7:
					return 'ProcessingInstruction';
				case 8:
					return 'Comment';
				case 9:
					return 'Document';
				case 10:
					return 'DocumentType';
				case 11:
					return 'DocumentFragment';
				case 12:
					return 'Notation';
			}
		}
	}

	get instance() {
		return nexNode.Instance(this.element);
	}

	static Value(elm) {
		if (nexNode.IsNode(elm))
			return elm.nodeValue || elm.innerText;
	}

	get value() {
		return nexNode.Value(this.element);
	}

	static Idx(elm, len = 16) {
		len = Type.isIntegral(len) ? len : 16;
		let idx;
		if (nexNode.IsNode(elm)) {
			do {
				idx = `${Str.random(len++)}-${nexNode.Tag(elm)}0`;
			} while (nexNode.ById(idx));
			nexNode.SetAttr(elm, { 'id': idx });
		}
		return elm;
	}

	idx(obj = {}, len = 8) {
		nexNode.Skel(obj);
		if (! (Type.isDefined(obj.id) || Type.isFalse(obj.id))) {
			let parent = undefined;
			if (nexNode.IsNode(obj.to))
				parent = obj.to;
			else if (Type.isDefined(this.parent) && nexNode.IsNode(this.parent.element))
				parent = this.parent.element;
			if (Type.isDefined(parent) && Type.isDefined(this.element) && ! (this.element instanceof DocumentFragment)) {
				let tmp = 0;
				if (this.element.parentNode instanceof DocumentFragment)
					tmp = 1;
				len = Number(Type.isIntegral(len) ? len : 8);
				const tag = Type.isArray(obj.tag) ? obj.tag[1] : obj.tag;
				let idx = `${parent.id || Str.random(len)}-${tag}${nexNode.TagCount(parent, tag) + tmp}`;
				do {
					idx = nexNode.ById(idx) ? `${Str.random(len++)}-${tag}0` : idx;
				} while (nexNode.ById(idx));
				this.setAttr({ 'id': idx });
			}
		} else if (Type.isDefined(obj.id)) {
			if (! nexNode.ById(obj.id))
				this.setAttr({ 'id': obj.id });
			else
				nexNode.Idx(this.element);
		}
		return this;
	}

	#instance(val, obj) {
		nexNode.Skel(obj);
		obj.tag = obj.tag || val.def;
		obj.inst = obj.inst || nexNode
		let tag = obj.tag;
		if (Type.isDefined(obj.to)) {
			if (obj.to instanceof val.inst) {
				if (! Type.isDefined(obj.tag))
					throw new Error('nodes require the tag attribute');
				else if (Type.isArray(obj.tag))
					tag = obj.tag[1]
				if (! Type.isObject(obj.to.nodes))
					this.parent.nodes = {};
				if (! Type.isArray(obj.to.nodes[tag]))
					obj.to.nodes[tag] = [];
				obj.to.nodes[tag].push(this);
				this.parent = obj.to;
				obj.to = obj.to.element;
			}
		}
		if (! nexNode.IsNode(obj.to))
			obj.to = nexNode.body;
		this.nodes = {};
		return this;
	}

	static Xmlns(val) {
		if (Type.isDefined(val)) {
			switch (Arr.shortStart(Str.toLower(val), [
				'svg', 'rdf', 'xforms', 'xquery',
				'xml', 'xhtml', 'xslt', 'xlink',
				'mathml', 'xpath', 'xpointer',
				'xproc', 'xinclude'
			]) || null) {
				case 'svg':
					return 'http://www.w3.org/2000/svg';
				case 'rdf':
					return 'http://www.w3.org/1999/02/22-rdf-syntax-ns';
				case 'xforms':
					return 'http://www.w3.org/2002/xforms';
				case 'xquery':
					return 'http://www.w3.org/2005/xquery-local-functions';
				case 'xhtml':
					return 'http://www.w3.org/1999/xhtml';
				case 'xml':
					return 'http://www.w3.org/XML/1998/namespace';
				case 'xslt':
					return 'http://www.w3.org/1999/XSL/Transform';
				case 'xlink':
					return 'http://www.w3.org/1999/xlink';
				case 'mathml':
					return 'http://www.w3.org/1998/Math/MathML';
				case 'xpath':
					return 'http://www.w3.org/1999/XPath';
				case 'xpointer':
					return 'http://www.w3.org/2001/XPointers';
				case 'xproc':
					return 'http://www.w3.org/2005/XProc';
				case 'xinclude':
					return 'http://www.w3.org/2001/XInclude';
				default:
					return null;
			}
		}
	}

	static Dtd(val) {
		const dt = { 'qualifiedName': 'html' };
		switch (Str.toLower(val)) {
			case 'xs':
				dt.publicid = '-//W3C//DTD XHTML 1.0 Strict//EN';
				dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd';
				break;
			case 'xt':
				dt.publicid = '-//W3C//DTD XHTML 1.0 Transitional//EN';
				dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd';
				break;
			case 'xf':
				dt.publicid = '-//W3C//DTD XHTML 1.0 Frameset//EN';
				dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd';
				break;
			case 'x':
				dt.publicid = '-//W3C//DTD XHTML 1.1//EN';
				dt.systemid = 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd';
				break;
			case 's':
				dt.publicid = '-//W3C//DTD HTML 4.01//EN';
				dt.systemid = 'http://www.w3.org/TR/html4/strict.dtd';
				break;
			case 't':
				dt.publicid = '-//W3C//DTD HTML 4.01 Transitional//EN';
				dt.systemid = 'http://www.w3.org/TR/html4/loose.dtd';
				break;
			case 'f':
				dt.publicid = '-//W3C//DTD HTML 4.01 Frameset//EN';
				dt.systemid = 'http://www.w3.org/TR/html4/frameset.dtd';
				break;	
			case 'h':
				dt.publicid = '';
				dt.systemid = '';
				break;
			default:
				return document.doctype;
		}
		return document.implementation.createDocumentType(dt.qualifiedName, dt.publicid, dt.systemid)
	}

	#root(obj) {
		this.parent = window.document;
		if (nexNode.IsNode(nexNode.Root)) {
			this.element = nexNode.Create('html');
			nexNode.Attach({
				'element': this.element,
				'to': this.parent,
				'attach': {
					'place': 'replace',
					'ref': nexNode.Root
				}
			});
		} else {
			this.element = nexNode.Create('html', null, this.parent);
		}
		this.nodes = {};
		if (Type.isDefined(obj.doctype))
			nexNode.SetDoctype(obj.doctype);
		const content = [];
		obj.id = nexNode.Idx(this.element);
		if (Type.isObject(obj.head)) {
			obj.head.tag = 'head';
			obj.head.to = this;
			content.push(obj.head);
		}
		if (Type.isObject(obj.body)) {
			obj.body.tag = 'body';
			obj.body.to = this;
			content.push(obj.body);
		}
		if (content.length > 0)
			this.frag(content);
		obj.attach = false;
	}

	static Meta(elm, obj) {
		if (nexNode.IsNode(elm) && Type.isArray(obj)) {
			const metadata = []
			obj.forEach(i => {
				if (Type.isObject(i.paths)) {
					const attr = {};
					const prop = {};
					switch (Object.keys(i)[1]) {
						case 'script':
							attr.tag = 'script';
							attr.src = 'src';
							attr.mime = 'type';
							prop.charset = 'UTF-8';
							break;
						case 'link':
							attr.src = 'href';
							attr.tag = 'link';
							attr.mime = 'rel';
							break;
						default:
							return;
					}
					Object.entries(i.paths).forEach(([k, v]) => {
						if (Type.isArray(v)) {
							v.forEach(j => {
								if (Type.isObject(i[attr.tag][j])) {
									Obj.assign(prop, undefined, i[attr.tag][j]);
								}
								const mime = Str.lastChar(j, '.');
								switch (mime) {
									case 'mjs':
										prop[attr.mime] = 'module';
										break;
									case 'js':
										prop[attr.mime] = 'text/javascript';
										prop.defer = true;
										break;
									case 'css':
									case 'scss':
									case 'sass':
										prop[attr.mime] = 'stylesheet';
										prop.type = 'text/css';
										break;
									case 'png':
									case 'jpg':
									case 'jpeg':
									case 'tiff':
									case 'gif':
									case 'bmp':
									case 'webp':
									case 'heic':
										prop[attr.mime] = 'icon';
										prop.type = `image/${mime}`;
										break;
									case 'ico':
										prop[attr.mime] = 'icon';
										prop.type = 'image/x-icon';
										break;
									case 'svg':
										prop[attr.mime] = 'icon';
										prop.type = 'image/svg+xml';
										break;
									case 'pdf':
										prop.title = 'PDF';
									case 'json':
									case 'xml':
										prop[attr.mime] = 'alternate';
										prop.type = `application/${mime}`;
										break;
									default:
										return;
								}
								prop[attr.src] = `${k}/${j}`;
								metadata.push({
									'tag': attr.tag,
									'prop': { ...prop }
								});
							});
						}
					});
				}
			});
			return metadata;
		}
	}

	meta(obj) {
		if (Type.isArray(obj) && nexNode.IsNode(this.element))
			this.frag(nexNode.Meta(this.element, obj));
		return this;
	}

	static SetDoctype(val = 'h') {
		if (nexNode.IsDocument(nexNode.Doctype)) {
			nexNode.Attach({
				'element': nexNode.Dtd(val),
				'to': window.document,
				'attach': {
					'place': 'replace',
					'ref': nexNode.Doctype
				}
			})
		} else {
			if (nexNode.IsNode(nexNode.Root)) {
				nexNode.Attach({
					'element': nexNode.Dtd(val),
					'to': window.document,
					'attach': {
						'place': 'before',
						'ref': nexNode.Root
					}
				});
			} else {
				nexNode.Create('html', null, window.document);
				return nexNode.SetDoctype(val);
			}
		}
		return nexNode;
	}

	static Copy(from, to, deep = true) {
		if (nexNode.IsNode(from)) {
			const clone = from.cloneNode(Type.isTrue(deep));
			const idx = nexNode.Idx(clone);
			const name = nexNode.GetAttr(clone, 'name')
			if (Type.isDefined(name))
				nexNode.SetAttr(clone, { 'name': `${name}-${idx}` });
			if (nexNode.IsNode(to))
				to.appendChild(clone);
			return clone;
		}
	}

	copy(from, deep) {
		if (nexNode.IsNode(from))
			nexNode.Copy(from, this.element, deep);
		return this;
	}

	static Object(elm, tf = true) {
		if (nexNode.IsNode(elm)) {
			const nd = elm.toString();
			if (nd !== '[object HTMLUnknownElement]' || ! Type.isTrue(tf))
				return nd;
			else
				return false;
		}
	}

	get object() {
		if (Type.isDefined(this.element))
			return nexNode.Object(this.element);
	}

	static Text(txt = '', elm) {
		if (Type.isDefined(txt)) {
			const node = window.document.createTextNode(txt);
			if (nexNode.IsNode(elm))
				elm.appendChild(node);
			return node;
		}
	}

	text(txt = '') {
		if (nexNode.IsNode(this.element)) {
			if (! Type.isArray(this.nodes.txt))
				this.nodes.txt = [];
			this.nodes.txt.push(nexNode.Text(txt, this.element));
		}
		return this;
	}

	static GetClass(elm) {
		if (nexNode.IsNode(elm))
			return Type.isArray(elm.className, ' ') || [];
	}

	get getClass() {
		return nexNode.GetClass(this.element);
	}

	static SetClass(elm, obj) {
		if (Type.isDefined(obj) && nexNode.IsNode(elm)) {
			elm.className = Str.remove(Str.implode(Arr.set(Type.isArray(obj, ',')), ' '));
			return elm;
		}
	}

	setClass(obj) {
		nexNode.SetClass(this.element, obj);
		return this
	}

	static Class(elm, { add, del, set, tog }) {
		if (nexNode.IsNode(elm)) {
			if (Type.isDefined(set))
				nexNode.SetClass(elm, set);
			if (Type.isDefined(del))
				nexNode.SetClass(elm, Arr.left(nexNode.GetClass(elm), Type.isArray(del, ',')));
			if (Type.isDefined(add))
				nexNode.SetClass(elm, nexNode.GetClass(elm) + " " + Arr.left(Type.isArray(add, ','), nexNode.GetClass(elm)));
			if (Type.isDefined(tog)) {
				tog = Type.isArray(tog, ',');
				const lst = Arr.left(tog, nexNode.GetClass(elm));
				Type.isArray(nexNode.GetClass(elm), ',').forEach(i => {
					if (! Arr.in(i, tog))
						lst.push(i);
				});
				nexNode.SetClass(elm, lst);
			}
		}
		return elm;
	}

	class(obj) {
		if (! nexNode.IsSvg(this.element))
			nexNode.Class(this.element, obj);
		return this;
	}
	
	static Create(tag, ns, elm) {
		if (Type.isDefined(tag)) {
			let node = undefined;
			if (Type.isDefined(ns))
				node = window.document.createElementNS(nexNode.Xmlns(ns), tag);
			else
				node = window.document.createElement(tag);
			if (! Type.isFalse(nexNode.Object(node)) || tag === 'a') {
				if (nexNode.IsNode(elm))
					elm.appendChild(node);
				return node;
			}
		}
	}

	create(obj) {
		if (Type.isObject(obj) && Type.isDefined(obj.tag)) {
			if (Type.isArray(obj.tag))
				this.element = nexNode.Create(obj.tag[1], obj.tag[0]);
			else
				this.element = nexNode.Create(obj.tag);
		}
		return this;
	}

	static Attach(obj) {
		if (Type.isObject(obj) && nexNode.IsNode(obj.element)) {
			obj.to = nexNode.DefaultNode(obj.to, nexNode.Body);
			if (Type.isObject(obj.attach)) {
				const mode = Arr.shortStart(Str.toLower(obj.attach.place), [ 'first', 'last', 'before', 'after', 'replace', 'wrap' ]) || null;
				if (Type.isDefined(mode)) {
					switch (mode) {
						case 'first':
							obj.to.insertBefore(obj.element, obj.to.firstChild);
							break;
						case 'last':
							obj.to.appendChild(obj.element);
							break;
						default:
							if (nexNode.IsNode(obj.attach.ref)) {
								switch (mode) {
									case 'before':
										obj.to.insertBefore(obj.element, obj.attach.ref);
										break;
									case 'after':
										obj.to.insertBefore(obj.element, obj.attach.ref.nextSibling);
										break;
									case 'replace':
										obj.to.replaceChild(obj.element, obj.attach.ref);
										break;
									case 'wrap':
										obj.to.insertBefore(obj.element, obj.attach.ref);
										obj.element.appendChild(obj.attach.ref);
										break;
								}
						}
					}
				} else {
					console.warn(`Invalid mode: ${mode}`);
				}
			} else {
				obj.to.appendChild(obj.element);
			}
			return obj.element;
		}
	}

	attach(obj) {
		if (nexNode.IsNode(obj)) {
			obj = { 'element': obj, 'to': this.element };
		} else {
			if (Type.isDefined(obj.to) && ! nexNode.IsNode(obj.to) && Type.IsNode(obj.to.element))
				obj.to = obj.to.element;
			if (! nexNode.IsNode(obj.to) && Type.isDefined(this.parent) && nexNode.IsNode(this.parent.element))
				obj.to = this.parent.element;
		}
		if (nexNode.IsNode(this.element) && ! nexNode.IsNode(obj.element))
			obj.element = this.element;
		nexNode.Attach(obj);
		return this;
	}

	static GetAttr(elm, obj) {
		if (Type.isDefined(obj) && nexNode.IsNode(elm)) {
			const qry = {};
			Type.isArray(obj, ',').forEach(i => {
				let res = elm.getAttribute(i);
				if (Type.isDefined(res))
					qry[i] = res;
			});
			return qry;
		}
	}

	getAttr(obj) {
		return nexNode.GetAttr(this.element, obj);
	}

	static SetAttr(elm, obj) {
		if (Type.isObject(obj) && nexNode.IsNode(elm)) {
			Object.entries(obj).forEach(([k, v]) => {
				elm.setAttribute(k, v);
			});
		}
		return elm;
	}

	setAttr(obj) {
		nexNode.SetAttr(this.element, obj);
		return this;
	}

	static Css(elm, obj) {
		if (nexNode.IsNode(elm) && Type.isObject(obj))
			Obj.assign(elm, 'style', obj);
		return elm;
	}

	css(obj) {
		nexNode.Css(this.element, obj);
		return this;
	}

	back(cnt = 1) {
		if (Type.isDefined(this.parent) && nexNode.IsNode(this.parent.element) && Number(cnt) > 0)
			return this.parent.back(--cnt);
		else if (nexNode.IsNode(this.element))
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
		const nd = this.tag;
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

	#nexFragment = class extends nexNode {
		constructor(obj) {
			super(obj);
			if (nexNode.Instance(obj.to) === 'DocumentFragment' && obj.tag === 'frag') {
				this.element = obj.to;
				this.parent = obj.parent;
			} else if (Type.isDefined(this.parent) && nexNode.Instance(this.parent.element) === 'DocumentFragment') {
				this.parent = this.parent.parent;
				this.fragment = this.parent;
				obj.to = this.parent;
				this.#instance({
					'def': 'div',
					'inst': nexNode,
				}, obj);
				this.idx(obj);
			}
			if (Type.isObject(obj)) {
				if (Type.isObject(obj.child))
					obj.child = [ obj.child ];
				Type.isArray(obj.child, ',').forEach(el => {
					if (Type.isObject(el)) {
						el.to = this;
						new this.#nexFragment(el);
					}
				});
			}
			return this;
		}
	}

	frag(obj, loc) {
		const to = document.createDocumentFragment();
		if (Type.isObject(obj))
			obj = [ obj ];
		obj.forEach(el => {
			if (Type.isObject(el) && Type.isDefined(el.tag)) {
				new this.#nexFragment({
					'tag': 'frag',
					'child': el,
					'parent': this,
					'to': to,
				});
			}
		});
		this.attach(to);
		return this;
	}
}

