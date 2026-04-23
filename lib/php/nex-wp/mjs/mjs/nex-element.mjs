import { nxObj } from "./nex-obj.mjs";
import { NxCSSOM } from "./nex-css.mjs";
import { nxType } from "./nex-type.mjs";

const NODE_TYPES = {
	1: 'Element',              // 1
	2: 'Attr',                 // 2
	3: 'Text',                 // 3
	4: 'CDATASection',         // 4
	5: 'EntityReference',      // 5 (obsolete)
	6: 'Entity',               // 6 (obsolete)
	7: 'ProcessingInstruction',// 7
	8: 'Comment',              // 8
	9: 'Document',             // 9
	10: 'DocumentType',         // 10
	11: 'DocumentFragment',     // 11
	12: 'Notation'              // 12 (obsolete)
};

const NS_PATHS = {
	'svg': 'http://www.w3.org/2000/svg',
	'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
	'xforms': 'http://www.w3.org/2002/xforms',
	'xquery': 'http://www.w3.org/2005/xquery-local-functions',
	'xhtml':'http://www.w3.org/1999/xhtml',
	'xml': 'http://www.w3.org/XML/1998/namespace',
	'xslt': 'http://www.w3.org/1999/XSL/Transform',
	'xlink': 'http://www.w3.org/1999/xlink',
	'mathml': 'http://www.w3.org/1998/Math/MathML',
	'xpath': 'http://www.w3.org/1999/XPath',
	'xpointer': 'http://www.w3.org/2001/XPointers',
	'xproc': 'http://www.w3.org/2005/XProc',
	'xinclude': 'http://www.w3.org/2001/XInclude',
	'dc': 'http://purl.org/dc/elements/1.1/',
	'foaf': 'http://xmlns.com/foaf/0.1/',
	'schema': 'http://schema.org/',
	'xsd': 'http://www.w3.org/2001/XMLSchema',
	'atom': 'http://www.w3.org/2005/Atom',
	'soap': 'http://schemas.xmlsoap.org/soap/envelope/',
	'wsdl': 'http://schemas.xmlsoap.org/wsdl/',
	'xevent': 'http://www.w3.org/2001/xml-events',
	'svg11': 'http://www.w3.org/2001/svg',
	'xbrl': 'http://www.xbrl.org/2003/instance'
}

export class NxElement
{
	static #WeakMap = new WeakMap();

	constructor(
		twig,
		{
			namespace,
			bark,
			plant,
			wood,
			stem,
			grow
		} = [ 'xhtml', {}, {}, {}, {}, {} ]) {
		if (! (twig instanceof Element)) {
			if (twig === null)
				return null;
			if (! nxType.isPrimitive(twig))
				throw new TypeError("Expected a string tag name for twig (e.g., 'div', 'span', 'svg').");
			twig = NxElement.CreateElement(String(twig), namespace);
		}

		if (! NxElement.#WeakMap.has(twig)) {
			NxElement.#WeakMap.set(twig, this);
			this.twig = twig;
		}

		NxElement.Attributes(twig, wood);
		NxElement.Assign(twig.style, bark);
		NxElement.Assign(twig, plant);
		return NxElement.#WeakMap.get(twig);
	}

	static CreateElement(
		element,
		namespace
	) {
		return document.createElementNS(NS_PATHS[namespace] ?? NS_PATHS.xhtml, element);
	}

	static Attributes(
		stem,
		attributes
	) {
		if (attributes) {
			Object.entries(attributes).forEach(([k, v]) => {
				stem.setAttribute(k, v);
			});
		}
		return stem;
	}

	static Assign(
		stem,
		attributes
	) {
		if (attributes) {
			Object.entries(attributes).forEach(([k, v]) => {
				stem[k] = v;
			});
		}
		return stem;
	}

	static Properties(
		stem,
		properties
	) {
		if (NxElement.#WeakMap.has(stem)) {
			Object.entries(properties).forEach(([k, v]) => {
				stem[k] = v;
			});
		}
	}

	set attributes(
		attributes
	) {
		NxElement.Attributes(this.stem, attributes);
	}

	set assign(
		properties
	) {
		Object.entries(properties).forEach(([k, v]) => {
			this[k] = v;
		});
	}

	static #fragment(stem, node) {
		//const _ = node[0][3] > node[0]
		console.log(node);
		console.log(stem.twig, stem.leaf);
	}

	static batch(nodes) {
		const f = new Uint32Array(2054);
		const s = Array.isArray(nodes)
			? [ null, ...nodes ]
			: [ null, nodes ];
		const r = new DocumentFragment();

		f[3] = 1;
		f[2] = 6;
		f[4] = 1;
		f[5] = s.length;
		s[0] = s[f[4]];
		let ptr = s;

		do {
			if (s[0] != s[f[4]]) {
				f[0] = f[4] - 1;
				s[0] = s[f[4]];
				f[1] = f[4];
				ptr = s;
			}

			for (; f[0] + 1 <= f[1]; ++f[0]) {
				const leaf = ptr[f[0]].leaf ?? undefined;

				NxElement.#fragment(ptr[f[0]], leaf);

				if (leaf instanceof Object) {
					// forgot to start at the next index 0_0
					f[f[2]++] = f[0];
					f[f[2]++] = f[1];
					// push to current pointer for later
					s.push(ptr);
					ptr = Array.isArray(leaf)
						? leaf
						: [ leaf ];
					++f[3];
					f[1] = ptr.length;
					f[0] = -1;
				}
			}

			if (f[0] + 1 > 0 && f[3] > 1) do {
				f[1] = f[--f[2]];
				f[0] = f[--f[2]] + 1;
				ptr = s.pop();
			} while (--f[3] > 0 && f[0] > f[1]);
		} while (f[3] > 1 || f[0] < f[1] || ++f[4] <= f[5]);

		return r;
	}

	appendChild(
		child
	) {
		return this.twig.appendChild(child);
	}
}

