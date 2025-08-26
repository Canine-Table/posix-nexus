import { nxArr } from '../nex-arr.mjs';
import { nxObj } from '../nex-obj.mjs';
import { nxType } from '../nex-type.mjs';
import { nxStr } from '../nex-str.mjs';
import { nxBit } from '../nex-bit.mjs';



// Registry
const R = Symbol('registry');

// Fragments
const F = [
	Symbol('fragment'),
	nxObj.enum()
];
F[1].set([
	'attached',
	'initialized'
]);

// Dom Class
const D = [
	Symbol('document'),
	nxObj.enum()
];
D[1].set([
	'master',
	'rooted'
]);

export class nxDom
{
	static #Internal = new Uint32Array(1);

	static #Flags(k, s, v, o) {
		const __ = {
			[F[0]]: [ F[1], o ],
			[D[0]]: [ D[1], this.#Internal ]
		}?.[s];
		return (nxType.defined(__) && (__[2] = (Number.isInteger(+v) && +v < 32) ? +v : __[0].get(v)))
			? [ __[1], nxBit[k](__[1], __[2]) ]
			: [ __?.[1], undefined ];
	}

	static #getFlags(k, s, v, o) {
		const __ = this.#Flags(k, s, v, o);
		return __[1]
	}

	static onFlag(s, v, o) {
		return this.#getFlags('on', s, v, o);
	}

	static offFlag(s, v, o) {
		return this.#getFlags('off', s, v, o);
	}

	static isFlag(s, v, o) {
		return this.#getFlags('is', s, v, o);
	}

	static flipFlag(s, v, o) {
		return this.#getFlags('flip', s, v, o);
	}

	static Registry = Object.freeze([
		R, Object.seal({
			nodes: new WeakMap(),
			groups: {},
			ids: new Set(),
		})
	]);

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

	static set Title(v) {
		if (v != this.Title)
			window.document.title = v;
	}

	static get Hash() {
		return window.location.hash;
	}

	static set Hash(v) {
		if (v != this.Hash)
			window.location.hash = v;
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

	static Element(e) {
		return nxType.isElement(e) ? e : this.Root;
	}

	static ById(v) {
		return window.document.getElementById(v);
	}

	static ByTag(v, e) {
		return this.Element(e).getElementsByTagName(v);
	}

	static ByName(v, e) {
		return this.Element(e).getElementsByName(v);
	}

	static ByClass(v, e) {
		return this.Element(e).getElementsByClassName(v);
	}

	static ByQuery(v, e) {
		return this.Element(e).querySelector(v);
	}

	static ByAll(v, e) {
		return this.Element(e).querySelectorAll(v);
	}

	static TagCount(v, e) {
		return this.ByAll(`:scope > ${v}`, e).length;
	}

	static H(o, d = 'h5') {
		return Object.keys(o).find(k => /^h[1-6]$/.test(k)) || d;
	}

	static isNode(n) {
		return (nxType.isNode(n)) ? [
			'Element',
			'Attr',
			'Text',
			'CDATASection',
			'EntityReference',
			'Entity',
			'ProcessingInstruction',
			'Comment',
			'Document',
			'DocumentType',
			'DocumentFragment',
			'Notation'
		][n.nodeType - 1] : 'Unknown';
	}

	static Mime(v) {
		const __ = nxStr.lastChar({
			'from': nxStr.normalize(v),
			'chop': '.'
		});
		switch (__) {
			case 'mjs': return [ 'script', {
				'type': 'module',
				'charset': 'UTF-8',
				'crossorigin': 'anonymous',
				'src': v
			}]
			case 'js': return [ 'script', {
				'type': 'text/javascript',
				'crossorigin': 'anonymous',
				'src': v,
				'charset': 'UTF-8',
				'defer': true
			}]
			case 'css':
			case 'scss':
			case 'sass': return [ 'link', {
				'rel': 'stylesheet',
				'crossorigin': 'anonymous',
				'type': 'text/css',
				'href': v
			}]
			case 'png':
			case 'jpg':
			case 'jpeg':
			case 'tiff':
			case 'gif':
			case 'bmp':
			case 'webp':
			case 'heic': return [ 'link', {
				'rel': 'icon',
				'type': `image/${__}`,
				'href': v
			}]
			case 'ico': return [ 'link', {
				'rel': 'icon',
				'type': 'image/x-icon',
				'href': v
			}]
			case 'pdf': return [ 'link', {
				'title': 'PDF',
				'href': v
			}]
			case 'json':
			case 'xml': return [ 'link', {
				'rel': 'alternate',
				'href': v
			}]
			default: return []
		}
	}

	static Path(v) {
		const __ = nxStr.normalize(v);
		switch (__) {
			case 'null':
			case 'undefined':
				return null;
			default:
				return {
					'svg': 'http://www.w3.org/2000/svg',
					'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
					'xforms': 'http://www.w3.org/2002/xforms',
					'xquery': 'http://www.w3.org/2005/xquery-local-functions',
					'xhtml': 'http://www.w3.org/1999/xhtml',
					'xml': 'http://www.w3.org/XML/1998/namespace',
					'xslt': 'http://www.w3.org/1999/XSL/Transform',
					'xlink': 'http://www.w3.org/1999/xlink',
					'mathml': 'http://www.w3.org/1998/Math/MathML',
					'xpath': 'http://www.w3.org/1999/XPath',
					'xpointer': 'http://www.w3.org/2001/XPointers',
					'xproc': 'http://www.w3.org/2005/XProc',
					'xinclude': 'http://www.w3.org/2001/XInclude'
				}[__] || 'http://www.w3.org/1999/xhtml';
		}
	}

	static Dtd(v) {
		const __ = {
			'1.0s': [
				'-//W3C//DTD XHTML 1.0 Strict//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
			],
			'1.0t': [
				'-//W3C//DTD XHTML 1.0 Transitional//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
			],
			'1.1f': [
				'-//W3C//DTD XHTML 1.0 Frameset//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'
			],
			'1.1': [
				'-//W3C//DTD XHTML 1.1//EN',
				'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
			],
			'4.01s': [
				'-//W3C//DTD HTML 4.01//EN',
				'http://www.w3.org/TR/html4/strict.dtd'
			],
			'4.01t': [
				'-//W3C//DTD HTML 4.01 Transitional//EN',
				'http://www.w3.org/TR/html4/loose.dtd'
			],
			'4.01f': [
				'-//W3C//DTD HTML 4.01 Frameset//EN',
				'http://www.w3.org/TR/html4/frameset.dtd'
			],
			'5.0': [
				'',
				''
			]
		}?.[nxStr.normalize(v)] || [ '', '' ];
		return window.document.implementation.createDocumentType('html', ... __);
	}

	static Frame(o) {
		if (nxDom.isFlag(F[0], 'initialized', o?.[R]?.[0]))
			return o;
		const __ = { ... (o || {}) };
		o[R] = [ new Uint32Array(1), Symbol('node'), Symbol('hook') ]
		o[o[R][2]] = new WeakMap();
		o[o[R][1]] = __;
		o[o[R][2]].set(o[o[R][1]], { 'a': 'b'});
		o[R][0] = this.onFlag(F[0], 'initialized', o[R][0]);
		return o;
	}

	static Create(o) {
		if (! nxType.defined(o)
			return;
		if (nxType.isString(o))
			return window.document.createTextNode(o);
		const __ = [ nxType.defined(o?.tag, 'div'), this.Path(o?.path) ];
		__[0] = nxType.defined(__[0]) === nxType.isPrimitive(__[0]) ? String(__[0]) : 'div';
		if (/^nx:\w+$/.test(o?.tag))
			return o;
		return (nxType.defined(__[1])) ? window.document.createElementNS(__[1], __[0]) : window.document.createElement(__[0]);
	}

}

/*

const REGISTRY = Symbol('registry');

export class nxDom {

	static Registry = Object.freeze([
		REGISTRY,
		Object.seal({
			'flags': 0,
			'title': this.Title,
			'tabs': {},
			'saved': {},
			'ids': new Set()
		}),
		Object.freeze({
			'registry': 0
		}),
		Object.freeze({
			'master': 0,
			'rooted': 1
		})
	]);

	static #getFlags(k, v) {
		return nxBit[k](this.Flags, (Number.isInteger(+v) && +v < 32) ? +v : this.mapFlag(v, true));
	}

	static #setFlags(k, v) {
		this.Registry[1].flags = this.#getFlags(k, v);
	}

	static set flipFlag(v) {
		this.#setFlags('flip', v);
	}

	static set onFlag(v) {
		this.#setFlags('on', v);
	}

	static set offFlag(v) {
		this.#setFlags('off', v);
	}

	static isFlag(v) {
		return this.#getFlags('is', v);
	}

	static mapFlag(v, d = false) {
		if (d)
			return this.Registry[3][v] || 0;
		return this.Registry[2][v] || 0;
	}

	static get Flags() {
		return this.Registry[1].flags;
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

	static set Title(v) {
		if (nxType.defined(v)) {
			this.Registry[1].title = nxDom.Title;
			window.document.title = v;
		}
	}

	static get Hash() {
		return window.location.hash;
	}

	static set Hash(v) {
		if (v != this.Hash)
			window.location.hash = v;
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

	static Element(e) {
		return nxType.isElement(e) ? e : this.Root;
	}

	static ById(v) {
		return window.document.getElementById(v);
	}

	static ByTag(v, e) {
		return this.Element(e).getElementsByTagName(v);
	}

	static ByName(v, e) {
		return this.Element(e).getElementsByName(v);
	}

	static ByClass(v, e) {
		return this.Element(e).getElementsByClassName(v);
	}

	static ByQuery(v, e) {
		return this.Element(e).querySelector(v);
	}

	static ByAll(v, e) {
		return this.Element(e).querySelectorAll(v);
	}

	static TagCount(v, e) {
		return this.ByAll(`:scope > ${v}`, e).length;
	}

	static H(o, d = 'h5') {
		return Object.keys(o).find(k => /^h[1-6]$/.test(k)) || d;
	}

	static Mime(v) {
		const __ = nxStr.lastChar({
			'from': nxStr.normalize(v),
			'chop': '.'
		});
		switch (__) {
			case 'mjs': return [ 'script', {
				'type': 'module',
				'charset': 'UTF-8',
				'crossorigin': 'anonymous',
				'src': v
			}]
			case 'js': return [ 'script', {
				'type': 'text/javascript',
				'crossorigin': 'anonymous',
				'src': v,
				'charset': 'UTF-8',
				'defer': true
			}]
			case 'css':
			case 'scss':
			case 'sass': return [ 'link', {
				'rel': 'stylesheet',
				'crossorigin': 'anonymous',
				'type': 'text/css',
				'href': v
			}]
			case 'png':
			case 'jpg':
			case 'jpeg':
			case 'tiff':
			case 'gif':
			case 'bmp':
			case 'webp':
			case 'heic': return [ 'link', {
				'rel': 'icon',
				'type': `image/${__}`,
				'href': v
			}]
			case 'ico': return [ 'link', {
				'rel': 'icon',
				'type': 'image/x-icon',
				'href': v
			}]
			case 'pdf': return [ 'link', {
				'title': 'PDF',
				'href': v
			}]
			case 'json':
			case 'xml': return [ 'link', {
				'rel': 'alternate',
				'href': v
			}]
			default: return []
		}
	}

	static Path(v) {
		const __ = nxStr.normalize(v);
		switch (__) {
			case 'null':
			case 'undefined':
				return null;
			default:
				return {
					'svg': 'http://www.w3.org/2000/svg',
					'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
					'xforms': 'http://www.w3.org/2002/xforms',
					'xquery': 'http://www.w3.org/2005/xquery-local-functions',
					'xhtml': 'http://www.w3.org/1999/xhtml',
					'xml': 'http://www.w3.org/XML/1998/namespace',
					'xslt': 'http://www.w3.org/1999/XSL/Transform',
					'xlink': 'http://www.w3.org/1999/xlink',
					'mathml': 'http://www.w3.org/1998/Math/MathML',
					'xpath': 'http://www.w3.org/1999/XPath',
					'xpointer': 'http://www.w3.org/2001/XPointers',
					'xproc': 'http://www.w3.org/2005/XProc',
					'xinclude': 'http://www.w3.org/2001/XInclude'
				}[__] || 'http://www.w3.org/1999/xhtml';
		}
	}

	static Dtd(v) {
		const __ = {
			'1.0s': [
				'-//W3C//DTD XHTML 1.0 Strict//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
			],
			'1.0t': [
				'-//W3C//DTD XHTML 1.0 Transitional//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
			],
			'1.1f': [
				'-//W3C//DTD XHTML 1.0 Frameset//EN',
				'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'
			],
			'1.1': [
				'-//W3C//DTD XHTML 1.1//EN',
				'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
			],
			'4.01s': [
				'-//W3C//DTD HTML 4.01//EN',
				'http://www.w3.org/TR/html4/strict.dtd'
			],
			'4.01t': [
				'-//W3C//DTD HTML 4.01 Transitional//EN',
				'http://www.w3.org/TR/html4/loose.dtd'
			],
			'4.01f': [
				'-//W3C//DTD HTML 4.01 Frameset//EN',
				'http://www.w3.org/TR/html4/frameset.dtd'
			],
			'5.0': [
				'',
				''
			]
		}?.[nxStr.normalize(v)] || [ '', '' ];
		return window.document.implementation.createDocumentType('html', ... __);
	}

	static Create(o = {}) {
		if (nxType.isString(o))
			return window.document.createTextNode(o);
		const __ = [ nxType.defined(o?.gate?.tag, 'div'), this.Path(o?.gate?.path) ];
		__[0] = nxType.defined(__[0]) === nxType.isPrimitive(__[0]) ? String(__[0]) : 'div';
		if (/^nx:\w+$/.test(o?.gate?.tag))
			return o;
		return (nxType.defined(__[1])) ? window.document.createElementNS(__[1], __[0]) : window.document.createElement(__[0]);
	}

	static #Document(o, n) {
		if (this.isFlag('rooted'))
			return window.document;
		n.stem = window.document;
		n.self = this.Create(o);
		this.Root instanceof HTMLHtmlElement
			? n.stem.replaceChild(n.self, this.Root)
			: n.stem.appendChild(n.self);
		const dt = this.Dtd(o.gate?.doctype ?? '5.0');
		this.DocType instanceof DocumentType
			? n.stem.replaceChild(dt, this.Doctype)
			: n.stem.insertBefore(dt, n.self);
		this.Register = 'rooted';
		return window.document;
	}

	static #Created({ from, type }) {
		const __ = this.getHook({
			'from': from,
			'gate': 'node'
		});
		return (__[0] === true && this.isNode(__[1].self) === type) ? __ : [ false, __[1] ];
	}

	static #Identity(from) {
		let len = 8;
		let id = (from?.gate?.id) ? from.gate.id : undefined;
		let idx = id;
		if (nxType.isUndefined(idx) || this.ById(idx) || nxDom.Registry[1].ids.has(idx)) {
			id = nxType.isUndefined(idx) ? '' : `-${id}`;
			do {
				idx = `${nxStr.random(len++)}${id}`;
			} while (this.ById(idx) || nxDom.Registry[1].ids.has(idx));
		}
		if (from?.gate) {
			this.Registry[1].ids.add(idx);
			this.Symbol(from, 'data').id = idx;
		}
		return idx;
	}

	static #InsertClone({ bind, leaf, to }) {
		let clone;
		bind.forEach(i => {
			clone = leaf;
			if (nxType.isArray(i) && this.isNode(i[0]) === nxDom.isNode(i[1])) {
				clone = i[1];
				stem = i[0];
			}
			if (this.isNode(i) === 'Element')
				to(clone.cloneNode(true), i);
		});
	}

	static Bind({ leaf, bind }) {
		if (! nxType.isPrimitive(bind) && leaf instanceof Node) {
			for (const k of nxArr.compare({
				'left': [ 'wrap', 'in', 'on', 'pre', 'post' ],
				'right': Object.keys(bind),
				'bind': 'intersect'
			})) {
				Object.freeze({
					'on': o => {
						this.#InsertClone({
							'leaf': leaf,
							'bind': o,
							'to': (l, b) => {
								b.parentNode.replaceChild(l, b);
							}
						});
					},
					'in': o => {
						this.#InsertClone({
							'leaf': leaf,
							'bind': o,
							'to': (l, b) => {
								b.appendChild(l);
							}
						});
					},
					'pre': o => {
						this.#InsertClone({
							'leaf': leaf,
							'bind': o,
							'to': (l, b) => {
								b.parentNode.insertBefore(l, b);
							}
						});
					},
					'post': o => {
						this.#InsertClone({
							'leaf': leaf,
							'bind': o,
							'to': (l, b) => {
								b.parentNode.insertBefore(l, b.nextSibling);
							}
						});
					},
				})?.[k](nxArr.wrap(nxArr.getList(bind[k])));
			}
		}
	}

	static Css({ from, self }) {
		if (this.isNode(self) === 'Element')
			return this.#Css({ from, self });
	}

	static #Css({ from, self }) {
		const __ = this.Symbol(from, 'css') || from;
		if (nxType.isObject(__) && ! nxObj.isEmpty(__)) {
			nxObj.assign({
				'to': self,
				'from': __,
				'bind': 'style'
			});
		}
	}

	static Pin({ from, self }) {
		if (this.isNode(self) === 'Element')
			return this.#Pin({ from, self });
	}

	static #Pin({ from, self }) {
		const __ = [
			this.Symbol(from, 'pin') || from,
			new Set(nxArr.getList(self.className, ' ')),
			[]
		];

		if (nxType.isObject(__[0]) && ! nxObj.isEmpty(__[0])) {
			for (const k of nxArr.compare({
				'left': [ 'set', 'add', 'swap', 'omit' ],
				'right': Object.keys(__[0]),
				'bind': 'intersect'
			})) {
				switch (k) {
					case 'set':
						if (! nxType.isObject(__[0][k]))
							__[1] = nxArr.getList(__[0][k], ' ');
						break;
					case 'add':
						if (! nxType.isObject(__[0][k]))
							__[1] = new Set([ ... __[1], ... nxArr.getList(__[0][k], ' ') ]);
						break;
					case 'swap':
						if (nxType.isObject(__[0][k])) {
							__[2] = __[0][k];
							const u = new Set();
							for (const cls of __[1])
								u.add(__[2][cls] || cls);
							__[1] = u;
							break;
						}
					case 'omit':
						if (! nxType.isObject(__[0][k])) {
							__[1] = nxArr.omit({
								'from': __[1],
								'omit' : nxArr.getList(__[0][k], ' '),
								'chop': ' '
							});
						}
				}
			}
			if (__[2] = [ ... __[1] ].join(' '))
				try {
				self.className = __[2];
				} catch (Exception) {
					this.#Data({
						'self': self,
						'class': __[2]
					});
				}
		}
		return __[2];
	}

	static Data({ from, self }) {
		if (this.isNode(self) === 'Element')
			this.#Data({ from, self });
	}

	static #Data({ from, self }) {
		const __ = this.Symbol(from, 'data') || from;
		if (nxType.isObject(__)) {
			Object.entries(__).forEach(([k, v]) => {
				self.setAttribute(k, v);
			});
		}
	}

	static #Linker(o, n) {
		let __;
		const linking = [];
		nxArr.wrap(o.gate.linker).forEach(i => {
			if (nxType.isObject(i)) {
				Object.entries(i).forEach(([k, v]) => {
					nxArr.wrap(v).forEach(s => {
						if (nxType.isObject(s)) {
							Object.entries(s).forEach(([f, p]) => {
								if ((__ = this.Mime(`${k}/${f}`)) && nxType.defined(__[0]))
									linking.push({ 'tag': __[0], 'data': { ... __[1], ... p } });
							})
						} else {
							if ((__ = this.Mime(`${k}/${s}`)) && nxType.defined(__[0]))
								linking.push({ 'tag': __[0], 'data': __[1] });
						}
					})
				})
			} else {
				if ((__ = this.Mime(i)) && nxType.defined(__[0]))
					linking.push({ 'tag': __[0], 'data': __[1] });
			}
		});

		nxArr.getList(linking).forEach(l => {
			__ = [
				window.document.createElement(l.tag),
				this.Frame(l)
			];
			n.stem.appendChild(__[0]);
			this.#Data({
				'from': __[1],
				'self': __[0]
			});
		});
	}

	static #Registry = Object.freeze({
		'id': o => this.#Identity(o)
	});

	static [REGISTRY](v) {
		return this.#Registry[v];
	}

	static Value(n) {
		if (this.isNode(n) === 'Element')
			return n.nodeValue || n.innerText;
	}

	static Append(o) {
		const __ = this.getHook({
			'from': o,
			'gate': 'node'
		});
		if (__[0] === true) {
			const route = new Map([
				[ 'html', (o, n) => this.#Document(o, n) ],
				[ 'nx:linker', (o, n) => this.#Linker(o, n) ]
			]).get(o.gate.tag);
			if (route) {
				route(o, __[1]);
			} else {
				__[1].self = this.Create(o);
				__[1].stem.appendChild(__[1].self);
			}
		}
	}

	static Frame(o = {}) {
		if (nxBit.is(o?.[REGISTRY], this.mapFlag('registry'))
		|| nxBit.is(o?.gate?.[REGISTRY], this.mapFlag('registry')))
			return;
		const self = Symbol('self'),
		      reg = { 'hook': Symbol('hook') };
		for (const k of [
			'pin', 'stem',
			'data', 'css',
			'node', 'rule',
			'emit'
		]) {
			const sym = reg[k] = Symbol(k);
			if (nxType.isUndefined(o[k]) && ! nxArr.isIn({ 'from': [ 'node' ], 'find': k }))
				o[k] = {};
			o[sym] = (nxType.isObject(o[k])) ? o[k] : {};
		}
		o[reg['hook']] = new WeakMap();
		o[self] = reg;
		o[REGISTRY] = nxBit.on(o[REGISTRY], this.mapFlag('registry'));
		return {
			'key': o[self],
			'gate': o
		};
	}

	static Symbol(o, s) {
		return o?.gate?.[o?.key?.[s]];
	}

	static Hook({ from, gate }) {
		return [
			this.Symbol(from, 'hook'),
			this.Symbol(from, gate)
		];
	}

	static orHook({ from, gate, data, key }) {
		const __ = this.getHook({
			'from': from,
			'gate': gate,
			'hook': true
		});
		if (! nxType.defined(__[0]))
			return __;
		if (__[0].has(__[1])) {
			const v = __[0].get(__[1]);
			v[key] = nxType.defined(v[key], data);
		} else {
			__[0].set(__[1], { [key]: data });
		}
	}

	static getHook({ from, gate, hook }) {
		const __ = this.Hook({
			'from': from,
			'gate': gate
		});
		if (! nxType.defined(__[0]))
			return [ undefined, from ]
		if (! nxType.defined(__[1]))
			return [ null, from ]
		if (hook === true)
			return __;

		return (__[0].has(__[1])) ? [ true, __[0].get(__[1]) ] : [ false, __[0] ];
	}

	static Apply(o) {
		const __ = this.#Created({
			'from': o,
			'type': 'Element'
		});
		if (__[0] === false)
			return __[0];

		const s = __[1].self;

		if (o?.gate?.text) {
			s.innerText = String(o.gate.text);
		}

		if (o?.gate?.id) {
			this.#Identity(o);
		}

		if (o?.gate?.emit && nxType.isFunction(o.gate.emit)) {
			o.gate.emit(__[1]);
		}

		this.#Css({
			'from': o,
			'self': s
		});

		this.#Pin({
			'from': o,
			'self': s
		});

		this.#Data({
			'from': o,
			'self': s
		});

		return __[0];
	}

	static isNode(n) {
		return (nxType.isNode(n)) ? [
			'Element',
			'Attr',
			'Text',
			'CDATASection',
			'EntityReference',
			'Entity',
			'ProcessingInstruction',
			'Comment',
			'Document',
			'DocumentType',
			'DocumentFragment',
			'Notation'
		][n.nodeType - 1] : 'Unknown';
	}
}

*/
