import { NxStack } from "./buffer.d/nex-stack.mjs";
import { nxType } from "./nex-type.mjs";

const NODE_TYPES = {
	1: 'Element',
	2: 'Attr',
	3: 'Text',
	4: 'CDATASection',
	5: 'EntityReference', // (obsolete)
	6: 'Entity', // (obsolete)
	7: 'ProcessingInstruction',
	8: 'Comment',
	9: 'Document',
	10: 'DocumentType',
	11: 'DocumentFragment',
	12: 'Notation' // (obsolete)
};

const NS_PATHS = {
	'svg': 'http://www.w3.org/2000/svg',
	'http://www.w3.org/2000/svg': 'http://www.w3.org/2000/svg',
	'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
	'http://www.w3.org/1999/02/22-rdf-syntax-ns': 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
	'xforms': 'http://www.w3.org/2002/xforms',
	'http://www.w3.org/2002/xforms': 'http://www.w3.org/2002/xforms',
	'xquery': 'http://www.w3.org/2005/xquery-local-functions',
	'http://www.w3.org/2005/xquery-local-functions': 'http://www.w3.org/2005/xquery-local-functions',
	'xhtml':'http://www.w3.org/1999/xhtml',
	'http://www.w3.org/1999/xhtml':'http://www.w3.org/1999/xhtml',
	'xml': 'http://www.w3.org/XML/1998/namespace',
	'http://www.w3.org/XML/1998/namespace': 'http://www.w3.org/XML/1998/namespace',
	'xslt': 'http://www.w3.org/1999/XSL/Transform',
	'http://www.w3.org/1999/XSL/Transform': 'http://www.w3.org/1999/XSL/Transform',
	'xlink': 'http://www.w3.org/1999/xlink',
	'http://www.w3.org/1999/xlink': 'http://www.w3.org/1999/xlink',
	'mathml': 'http://www.w3.org/1998/Math/MathML',
	'http://www.w3.org/1998/Math/MathML': 'http://www.w3.org/1998/Math/MathML',
	'xpath': 'http://www.w3.org/1999/XPath',
	'http://www.w3.org/1999/XPath': 'http://www.w3.org/1999/XPath',
	'xpointer': 'http://www.w3.org/2001/XPointers',
	'http://www.w3.org/2001/XPointers': 'http://www.w3.org/2001/XPointers',
	'xproc': 'http://www.w3.org/2005/XProc',
	'http://www.w3.org/2005/XProc': 'http://www.w3.org/2005/XProc',
	'xinclude': 'http://www.w3.org/2001/XInclude',
	'http://www.w3.org/2001/XInclude': 'http://www.w3.org/2001/XInclude',
	'dc': 'http://purl.org/dc/elements/1.1/',
	'http://purl.org/dc/elements/1.1/': 'http://purl.org/dc/elements/1.1/',
	'foaf': 'http://xmlns.com/foaf/0.1/',
	'http://xmlns.com/foaf/0.1/': 'http://xmlns.com/foaf/0.1/',
	'schema': 'http://schema.org/',
	'http://schema.org/': 'http://schema.org/',
	'xsd': 'http://www.w3.org/2001/XMLSchema',
	'http://www.w3.org/2001/XMLSchema': 'http://www.w3.org/2001/XMLSchema',
	'atom': 'http://www.w3.org/2005/Atom',
	'http://www.w3.org/2005/Atom': 'http://www.w3.org/2005/Atom',
	'soap': 'http://schemas.xmlsoap.org/soap/envelope/',
	'http://schemas.xmlsoap.org/soap/envelope/': 'http://schemas.xmlsoap.org/soap/envelope/',
	'wsdl': 'http://schemas.xmlsoap.org/wsdl/',
	'http://schemas.xmlsoap.org/wsdl/': 'http://schemas.xmlsoap.org/wsdl/',
	'xevent': 'http://www.w3.org/2001/xml-events',
	'http://www.w3.org/2001/xml-events': 'http://www.w3.org/2001/xml-events',
	'svg11': 'http://www.w3.org/2001/svg',
	'http://www.w3.org/2001/svg': 'http://www.w3.org/2001/svg',
	'xbrl': 'http://www.xbrl.org/2003/instance',
	'http://www.xbrl.org/2003/instance': 'http://www.xbrl.org/2003/instance'
}

const S_INDEX = 0;
const S_DEPTH = 1;
const S_ROOT = 2;
const S_ROOTS = 3;
const S_TOP = 4;
const S_FRAG = 5;

export class NxDom
{
	static WeakMap = new WeakMap();
	static Node = Symbol('node');

	static Create(stem, leaf) {
		let node;
		switch (leaf?.twig) {
			case '!--':
				node = document.createComment('404');
				break;
			case '<>': case null: case undefined:
				node = document.createTextNode();
				break;
			default:
				node = leaf[this.Node] = document.createElementNS(NS_PATHS[
					leaf.ns ?? stem?.namespaceURI
				] ?? NS_PATHS.xhtml, leaf.twig);
		}
		this.WeakMap.set(node, leaf);
		stem.appendChild(node);
		return node;
	}

	static Route(i32, stack) {
		const top = i32[S_TOP];
		const depth = i32[S_DEPTH];
		const start = i32[S_ROOTS];
		const idx = i32[S_INDEX];
		const stop = i32[top - 1];

		console.log(
			"\nindex", i32[S_INDEX],
			"\ndepth", i32[S_DEPTH],
			"\nroot ", i32[S_ROOT],
			"\nroots", i32[S_ROOTS],
			"\ntop", i32[S_TOP],
			"\nfrag", i32[S_FRAG],
			"\nstack", stack,
		);

		let ptr = i32[i32[S_TOP] - 1];
		let pptr = i32[i32[S_TOP]];

		let _ptr = i32[i32[S_TOP] - 3];
		let _pptr = i32[i32[S_TOP] - 2];
		const arr = stack[ptr];

		if (depth === 1) {
			console.log("nxt", stack[i32[pptr]])
			console.log("cur", stack[i32[S_ROOTS]])
		} else if (depth > 1) {
			let ppptr = stack[ptr][pptr];
			console.log('cur', ppptr);
			const node = Array.isArray(ppptr) ? ppptr[idx] : ppptr?.leaf[idx];
			console.log('nxt', node);
			if (depth > 2) {
				console.log('prev A?', stack[_ptr][_pptr] ?? stack[_pptr]);
			} else {
				console.log('prev B?', stack[_pptr]);
			}
		}
	}


	static Batch(nodes, size = 1024) {
		let idx, root, top, depth;
		const stack = nodes = Array.isArray(nodes) ? nodes : [ nodes ];
		const i32 = new Int32Array(size);
		root = idx = i32[S_INDEX] = i32[S_ROOT] = -1;
		const roots = i32[S_FRAG] = i32[S_ROOTS] = stack.length;
		stack.push(new DocumentFragment());
		i32[S_TOP] = top = stack.length + 1;;
		depth = 0;
		do {
			if (depth === 0) {
				i32[S_INDEX] = root;
				do {
					nodes = stack[++root];
					if (Array.isArray(nodes?.leaf) && nodes.leaf.length) {
						i32[S_ROOT] = i32[S_INDEX] = root;
						i32[S_TOP] = top;
						i32[S_DEPTH] = ++depth;
						stack[i32[++top] = stack.length] = nodes.leaf;
						i32[++top] = root;
						nodes = nodes.leaf;
					}
				} while (!(Array.isArray(nodes) && nodes.length) && root < roots);
				const last = roots - 1;
				const min = last ^ ((root ^ last) & -(root < last));
				while (++i32[S_INDEX] < min)
					this.Route(i32, stack);
				if (root >= roots)
					break;
				idx = -1;
			}
			if (Array.isArray(nodes) && nodes.length) {
				while(++idx < nodes.length) {
					const node = nodes[idx];
					if (Array.isArray(node) && node.length) {
						i32[S_DEPTH] = ++depth;
						if (depth) {
							stack[i32[++top] = stack.length] = nodes;
						} else {
							i32[++top] = root;
						}
						i32[++top] = idx;
						nodes = node;
						idx = -1;
						i32[S_TOP] = top;
					} else {
						i32[S_INDEX] = idx;
						if (nxType.isObject(node?.leaf))
							node.leaf = [node.leaf];
						if (Array.isArray(node?.leaf) && node.leaf.length) {
							i32[S_DEPTH] = ++depth;
							stack[i32[++top] = stack.length] = nodes;
							i32[++top] = idx;
							nodes = node.leaf;
							idx = -1;
							i32[S_TOP] = top;
						}
						this.Route(i32, stack);
						i32[S_INDEX] = idx;
					}
				}
			} else {
				//this.Route(i32, stack);
			}
			if (depth) {
				do {
					idx = i32[top--];
					if (--depth < 1) {
						nodes = stack[top--];
						size = roots;
					} else {
						nodes = stack.pop();
						size = nodes.length
					}
				} while (depth && idx >= size);
				i32[S_TOP] = top;
				//i32[S_INDEX] = idx;
			}
		} while (root < roots);
		console.log(stack[roots])
	}
}

