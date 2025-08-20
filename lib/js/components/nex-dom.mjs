import { nxArr } from '../nex-arr.mjs';
import { nxObj } from '../nex-obj.mjs';
import { nxType } from '../nex-type.mjs';
import { nxStr } from '../nex-str.mjs';
import { nxBit } from '../nex-bit.mjs';

export class nxDom {

	constructor(o) {
		return this;
	}

	static Registry = Symbol('registry');

	static Flag(k) {
		return {
			'registry': 0,
			'visited': 1,
			'done': 2,
			'dirty': 3,
			'locked': 4
		}[k] || 0;
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

	static get Hash() {
		return window.location.hash;
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
		}?.[nxStr.normalize(v)];
		if (nxType.isUndefined(__))
			return nxDom.Doctype;
		return window.document.implementation.createDocumentType('html', ... __);
	}

	static Create(o = {}) {
		if (nxType.isString(o))
			return window.document.createTextNode(o);
		if (/^nx:\w+$/.test(o?.gate?.tag))
			return __[0].stem.self;
		const __ = [ nxType.defined(o?.gate?.tag, 'div'), nxDom.Path(o?.gate?.path) ];
		return (nxType.defined(__[1])) ? window.document.createElementNS(__[1], __[0]) : window.document.createElement(__[0]);
	}

	static #Document(o, n) {
		n.stem = window.document;
		n.self = nxDom.Create(o);
		console.log(nxDom.Root)
		nxDom.Root instanceof HTMLHtmlElement
			? n.stem.replaceChild(n.self, nxDom.Root)
			: n.stem.appendChild(n.self);
		const dt = nxDom.Dtd(o.gate?.doctype ?? '5.0');
		nxDom.DocType instanceof DocumentType
			? n.stem.replaceChild(dt, nxDom.Doctype)
			: n.stem.insertBefore(dt, n.self);
	}

	static #Created({ from, type }) {
		const __ = nxDom.getHook({
			'from': from,
			'gate': 'node'
		});
		return (__[0] === true && nxDom.isNode(__[1].self) === type) ? __ : [ false, __[1] ];
	}

	static #Css({ from, self }) {
		nxObj.assign({
			'to': self,
			'from': nxDom.Symbol(from, 'css'),
			'bind': 'style'
		});
	}

	static #Pin({ from, self }) {
		const __ = [
			nxDom.Symbol(from, 'pin'),
			new Set(nxArr.getList(self.className, ' ')),
			[]
		];
		if (nxType.isObject(__[0])) {
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
				self.className = __[2];
		}
		return __[2];
	}

	static #Data({ from, self }) {
		const __ = nxDom.Symbol(from, 'data');
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
								if ((__ = nxDom.Mime(`${k}/${f}`)) && nxType.defined(__[0]))
									linking.push({ 'tag': __[0], 'data': { ... __[1], ... p } });
							})
						} else {
							if ((__ = nxDom.Mime(`${k}/${s}`)) && nxType.defined(__[0]))
								linking.push({ 'tag': __[0], 'data': __[1] });
						}
					})
				})
			} else {
				if ((__ = nxDom.Mime(i)) && nxType.defined(__[0]))
					linking.push({ 'tag': __[0], 'data': __[1] });
			}
		});

		nxArr.getList(linking).forEach(l => {
			__ = [
				window.document.createElement(l.tag),
				nxDom.Frame(l)
			];
			n.stem.appendChild(__[0]);
			nxDom.#Data({
				'from': __[1],
				'self': __[0]
			});
		});
	}

	static Append(o) {
		const __ = nxDom.getHook({
			'from': o,
			'gate': 'node'
		});
		if (__[0] === true) {
			const route = new Map([
				[ 'html', (o, n) => nxDom.#Document(o, n) ],
				[ 'nx:linker', (o, n) => nxDom.#Linker(o, n) ]
			]).get(o.gate.tag);
			if (route) {
				route(o, __[1]);
			} else {
				__[1].self = nxDom.Create(o);
				__[1].stem.appendChild(__[1].self);
			}
		}
	}

	/* Most Important function, required by most methods */
	static Frame(o = {}) {
		if (nxBit.is(o?.[nxDom.Registry], nxDom.Flag('registry'))
		|| nxBit.is(o?.gate?.[nxDom.Registry], nxDom.Flag('registry')))
			return;
		const self = Symbol('self'),
		      reg = { 'hook': Symbol('hook') };
		for (const k of [
			'pin', 'stem',
			'data', 'css',
			'node', 'rule'
		]) {
			const sym = reg[k] = Symbol(k);
			if (nxType.isUndefined(o[k]) && k !== 'node')
				o[k] = {};
			o[sym] = (nxType.isObject(o[k])) ? o[k] : { '??': o[k] };
		}
		o[reg['hook']] = new WeakMap();
		o[self] = reg;
		o[nxDom.Registry] = nxBit.on(o[nxDom.Registry], nxDom.Flag('registry'));
		return {
			'key': o[self],
			'gate': o
		};
	}

	static Symbol(o, s) {
		return o.gate[o.key[s]];
	}

	static Hook({ from, gate }) {
		return [
			nxDom.Symbol(from, 'hook'),
			nxDom.Symbol(from, gate)
		];
	}

	static orHook({ from, gate, data, key }) {
		const __ = nxDom.Hook({
			'from': from,
			'gate': gate
		});
		if (__[0].has(__[1])) {
			const v = __[0].get(__[1]);
			v[key] = nxType.defined(v[key], data);
		} else {
			__[0].set(__[1], { [key]: data });
		}
	}

	static getHook({ from, gate }) {
		const __ = nxDom.Hook({
			'from': from,
			'gate': gate
		});
		return (__[0].has(__[1])) ? [ true, __[0].get(__[1]) ] : [ false, __[0] ];
	}

	/* Needed? */
	static setHook({ from, gate, data }) {
		const __ = nxDom.Hook({
			'from': from,
			'gate': gate
		});
		__[0].set(__[1], data);
	}

	static Apply(o) {
		const __ = nxDom.#Created({
			'from': o,
			'type': 'Element'
		});
		if (__[0] === false)
			return __[0];
		const s = __[1].self;

		if (o?.gate?.text) {
			s.innerText = String(o.gate.text);
		}

		nxDom.#Css({
			'from': o,
			'self': s
		});

		nxDom.#Pin({
			'from': o,
			'self': s
		});

		nxDom.#Data({
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

	/* Needed? 
	static Stem(n) {
		if (! nxType.isNode(n))
			return 'Unknown';
		if (n.parentNode instanceof DocumentFragment)
			return 'DocumentFragment';
		if (n.parentNode === nxDom.Body || n.isConnected)
			return 'Document';
		if (nxType.isNull(n.parentNode))
        		return 'Detached';
		return 'Element';
	}
	 */


