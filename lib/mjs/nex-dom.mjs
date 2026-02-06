import { nxWalker } from "./nex-walker.mjs";

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

const DTD = {
	'1.0s': {
		name: 'html',
		publicId: '-//W3C//DTD XHTML 1.0 Strict//EN',
		systemId: 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
	},
	'1.0t': {
		name: 'html',
		publicId: '-//W3C//DTD XHTML 1.0 Transitional//EN',
		systemId: 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
	},
	'1.0f': {
		name: 'html',
		publicId: '-//W3C//DTD XHTML 1.0 Frameset//EN',
		systemId: 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'
	},
	'1.1': {
		name: 'html',
		publicId: '-//W3C//DTD XHTML 1.1//EN',
		systemId: 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
	},
	'4.01s': {
		name: 'HTML',
		publicId: '-//W3C//DTD HTML 4.01//EN',
		systemId: 'http://www.w3.org/TR/html4/strict.dtd'
	},
	'4.01t': {
		name: 'HTML',
		publicId: '-//W3C//DTD HTML 4.01 Transitional//EN',
		systemId: 'http://www.w3.org/TR/html4/loose.dtd'
	},
	'4.01f': {
		name: 'HTML',
		publicId: '-//W3C//DTD HTML 4.01 Frameset//EN',
		systemId: 'http://www.w3.org/TR/html4/frameset.dtd'
	},
	'5.0': {
		name: 'html',
		publicId: '',
		systemId: ''
	},
	'mathml': {
		name: 'math',
		publicId: '-//W3C//DTD MathML 2.0//EN',
		systemId: 'http://www.w3.org/Math/DTD/mathml2/mathml2.dtd'
	},
	'svg11': {
		name: 'svg',
		publicId: '-//W3C//DTD SVG 1.1//EN',
		systemId: 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'
	}
};

const _ = {
	category(name) {
		return NODE_TYPES[name && name.nodeType] || 'Unknown';
	},
	dtd(name) {
		const value = DTD[name];
		if (value)
			return value;
		return { name: 'html', publicId: '', systemId: '' };
	}
}

export class nxDom
{
	static create(e, n) {
		return document.createElementNS(NS_PATHS[n] ?? NS_PATHS.xhtml, e);
	}

	static #getThatNode(
		method,
		category,
		setter,
		element,
		...parameters
	) {
		parameters ??= '';
		if (_.category(element) !== category)
			return document[method](...parameters);
		element[setter] = parameters[0] ?? '';
		return element;
	}

	static #create3and8(
		method,
		category,
		text,
		element
	) {
		return nxDom.#getThatNode(
			method,
			category,
			'data',
			element,
			text ?? ''
		);
	}

	static get wipe() {
		document.open();
		document.write("");
		document.close();
	}

	static text(
		text,
		element
	) {
		text = nxDom.#create3and8('createTextNode', 'Text', text, element);
		if (_.category(element) !== 'Element')
			return text;
		element.appendChild(text);
		return element;
	}

	static comment(
		text,
		element
	) {
		return nxDom.#create3and8('createComment', 'Comment', text, element);
	}

	static doctype(
		name,
		root
	) {
		const oldDtd = document.doctype;
		const parameters = _.dtd(name);

		if (_.category(oldDtd) !== 'DocumentType' || typeof name === 'string')
			name = document.implementation.createDocumentType(
				parameters.name,
				parameters.publicId,
				parameters.systemId
			);
		else
			return dtd;
		if (root === false)
			return name;
		const newDtd = name;
		name = document.documentElement;
		if (_.category(name) === 'Element') {
			if (_.category(oldDtd) === 'DocumentType')
				document.removeChild(oldDtd);
			document.insertBefore(newDtd, document.documentElement);
		} else {
			name = NS_PATHS[root] ?? NS_PATHS[root = parameters.name] ?? NS_PATHS[root = 'html'];
			document.implementation.createHTMLDocument(name, root, newDtd);
		}
		return newDtd;
	}

	static batch(...elements) {
		const fragment = new DocumentFragment();
		for (const element of elements) {
			fragment.appendChild(element);
		}
		return fragment;
	}
}

/*
  static #weakMap = new WeakMap();
  static #cssRoot = document.querySelector(':root');

  constructor(query) {
    NxNodeMap.#weakMap.set(this, new Map());
    const thisWm = this.myself;
    document.querySelectorAll(query).forEach(e => {
      thisWm.set(e, []);
      const thisWmMp = thisWm.get(e);      
      let n;
      const w = document.createTreeWalker(
        e.parentNode,
        NodeFilter.SHOW_COMMENT,
        null, false
      );
      
      while ((n = w.nextNode()))
	      thisWmMp.push(n);
    });
  }

  getText(text, tag = 'p') {
    const sentences = new DocumentFragment();
    text.split('.')
      .map(s => s.trim())
      .filter(Boolean)
      .map(s => s + '.').forEach(s => {
        const para = document.createElement(tag);
        para.innerText = s;
        sentences.appendChild(para);
    });
    return sentences;
  }


  get myself() {
    return NxNodeMap.#weakMap.get(this);
  }

   getEntryByIndex(index) {
      return Array.from(this.myself.entries())[index];
  }

  getValueByIndex(index) {
    return Array.from(this.myself.values())[index];
  }

  getKeyByIndex(index) {
    return Array.from(this.myself.keys())[index];
  }

  getPair(index) {
    const [task, code] = this.getEntryByIndex(index);
    return { task, code };
  }
}


/*
export class NxDom
{
	constructor({ dtd }) {

	}
}
*/
