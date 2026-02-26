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
	static #weakMap = new WeakMap();

	constructor(
		twig,
		namespace,
		{
			bark,
			wood,
			stem,
			grow
		} = [{},{},{},{}]) {
		if (! nxType.isPrimitive(twig))
			throw new TypeError("Expected a string tag name for twig (e.g., 'div', 'span', 'svg').");
		const element = NxElement.#create(String(twig), namespace);
		//customElement.define(element, this);
		const self = Object.create(null);
		NxElement.#weakMap.set(this, self);
		//this.stem = stem;
		self.twig = element;
		this.#properties(element, wood);
		//this.#properties(element.style, bark ?? {});
	}

	static #create(
		element,
		namespace
	) {
		return document.createElementNS(NS_PATHS[namespace] ?? NS_PATHS.xhtml, element);
	}

	#properties(
		stem,
		attributes
	) {
		console.log(attributes);
		Object.entries(attributes).forEach((k, v) => {
			stem.setAttribute(k, v);
		});
		return this;
	}



	get get() {
		return NxElement.#weakMap.get(this);
	}

	set(key, value) {
		this.get[key] = value;
	}

	set stem(element) {
		if (element instanceof NxElement)
			this.get.stem = new WeakRef(element.get);
	}

	get stem() {
		return NxElement.#weakMap.get(this)?.stem.deref();
	}
}

