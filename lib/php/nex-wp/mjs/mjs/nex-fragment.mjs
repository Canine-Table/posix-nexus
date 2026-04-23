import { nxObj } from "./nex-obj.mjs";
import { NxCSSOM } from "./nex-css.mjs";
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

export class NxFragment
{
	static #WeakMap = new WeakMap();
	static #Registry = Symbol('registry');
	static #TextSet = new Set([3, 8]);
	static #Ns = new Set(['</>', '!--', '<>', '&;']);

	/*
		<>: 1024
		!--: 1025
		</>: 1026
		&;: 1027

		array: 2048
		str: 2049
		object: 2050
	*/

	static #Type(
		leaf
	) {
		const frame = [
			leaf ?? '',
			2048
		]
		if (! Array.isArray(leaf)) {
			frame[0] = [ leaf ];
			frame[1] = nxType.isPrimitive(leaf)
				? 2049 :
				2050;
		}
		return frame;
	}

	static #Expand() {
		
	}

	static #Push(
		stack,
		flag,
		leaf,
		ptr
	) {
		console.log('sa')
		flag[flag[2]++] = flag[0];
		stack.push(ptr);
		console.log(ptr === leaf);
		ptr = Array.isArray(leaf)
			? leaf
			: [ leaf ];
		++flag[3];
		flag[1] = ptr.length;
		flag[0] = -1
		return ptr;
	}


	static #Reset(
		stack,
		flag,
		root
	) {
		if (nxType.isPrimitive(stack[flag[4]])) {
			root.appendChild(this.#OpRoute(root,{
				twig: this.#NamespaceMap(root).ns,
				leaf: stack[flag[4]],
				[this.#Registry]: root
			}));
			flag[4]++;
			flag[1] = 0;
			return false;
		}

		stack[flag[4]][this.#Registry] = root;
		const nsm = this.#NamespaceMap(root).nsm;
		nsm.set(root, { alt: nsm.get(root).alt })
		flag[0] = flag[4] - 1;
		flag[1] = flag[5];
		stack.length = flag[5];
		return stack;
	}

	static #RegistryMap(ptr) {
		return this.#WeakMap.get(ptr[this.#Registry]);
	}

	static #RegistryNodeMap(ptr) {
		return this.#WeakMap.get(ptr);
	}

	static #NamespaceMap(ptr) {
		const frag = this.#RegistryNodeMap(ptr)[this.#Registry];
		const reg = this.#RegistryNodeMap(frag);
		const nsm = reg.nsm;
		const fe = nsm.get(frag);
		const ret =  {
			_: reg,
			nsm: nsm,
			ns: fe.top == null
				? fe.alt
				: nsm.get(fe.top).ns
		}
		return ret;
	}

	static #UnwindNamespace(root) {
		const node = root[this.#RegistryMap(root).twig];
		const reg = this.#NamespaceMap(node);
		if (reg.nsm.last === node) {
			reg.nsm.top = reg._.ns.get(node).prev;
			reg._.ns.delete(node);
		}
	}

	static #Pull(
		stack,
		flag
	) {
		let ptr;
		do {
			flag[0] = flag[--flag[2]];
			ptr = stack.pop();
			flag[1] = ptr.length;
			//this.#UnwindNamespace(ptr[flag[0]]);
		} while (--flag[3] > 0 && flag[0] > flag[1]);

		if (flag[3] < 1 && flag[0] < flag[1])
			++flag[4];
		return ptr;
	}

	static #UpdateNamespace(
		root,
		node,
		ns
	) {
		const reg = this.#NamespaceMap(root);
		const nsm = reg.nsm;
		const fe = nsm.get(reg._[this.#Registry])
		const top = nsm.get(fe.top);
		if (! fe.top && fe.alt !== ns || top && top.ns !== ns) {
			nsm.set(node, {
				prev: fe.top ?? null,
				ns: ns
			});
			fe.top = node;
		}
	}

	static #CreateFragment(
		reg,
		ptr
	) {
		const frag = new DocumentFragment();
		frag.innerHTML = ptr[reg._.text];
		return frag;
	}

	static #IsText(
		root
	) {
		switch (root.nodeType) {
			case 3:
				return '<>';
			case 8:
				return '!--';
			default:
				return false;
		}
	}

	static #Masquerade(root, twig) {
		if (root instanceof Element || root instanceof DocumentFragment || ! this.#IsText(root))
			return root;
		const twigType = Array.isArray(twig)
			? twig[0]
			: twig;
		let nodeType = this.#IsText(root);

		if (nodeType === twigType)
			return root;

		while (nodeType !== false) {
			root = root.parentNode;
			nodeType = this.#IsText(root);
		}
		return root;
	}

	static #CreateTextComment(
		reg,
		root,
		ptr
	) {

		const cur = this.#IsText(root);
		//reg.nsm.type = node.nodeType;
		if (cur !== false) {
			if (ptr[reg._.value] !== '')
				root.nodeValue += ptr[reg._.value];
			return root;
		}

		reg.nsm.cur = ptr[reg._.twig][0];
		//console.log(root.lastChild?.nodeType)

		const node = document[ptr[reg._.twig][0] === '!--'
			? 'createComment'
			: 'createTextNode'
		](ptr[reg._.value]);
		this.#WeakMap.set(node, ptr);
		reg.nsm.type = node.nodeType;

		if (! nxType.isPrimitive(ptr[reg._.leaf]))
			this.#UpdateNamespace(root, node, ptr[reg._.twig][0]);
		return node;
	}

	static #CreateElement(
		reg,
		root,
		ptr
	) {

		const node = document.createElementNS(NS_PATHS[
			ptr.ns ?? ptr[reg._.twig][1] ?? root.namespaceURI
		] ?? NS_PATHS.xhtml, ptr[reg._.twig][0]);
		this.#WeakMap.set(node, ptr);

		if (nxType.isObject(ptr.wood)) {
			console.log('yes');
		}

		if (nxType.isPrimitive(ptr[reg._.leaf]) && ptr[reg._.leaf] !== '') {
			
			node.appendChild(this.#CreateTextComment(
				reg,
				root,
				ptr
			));
		}
		return node;
	}

	static #OpRoute(
		ptr,
		root
	) {
		const reg = this.#NamespaceMap(root);

		ptr[reg._.twig] = Array.isArray(ptr.twig)
			? ptr.twig
			: [ ptr.twig ];

		ptr[reg._.twig][0] ??= reg.ns;
		ptr[reg._.leaf] = ptr.leaf ?? '';
		ptr[reg._.value] = nxType.isPrimitive(ptr[reg._.leaf])
			? ptr[reg._.leaf]
			: '';

		switch (ptr[reg._.twig][0]) {
			case '!--': case '<>':
				return this.#CreateTextComment(
					reg,
					root,
					ptr
				);

			/* Not important for now*/
			case '</>':
				return this.#CreateFragment(
					reg,
					ptr
				);

			default:
				return this.#CreateElement(
					reg,
					root,
					ptr
				);
		}
	}

	static #Create(
		stack,
		flag,
		ptr
	) {
		const dep = flag[3];
		const cidx = flag[0];
		const pidx = flag[flag[2] - 1];
		const sidx = flag[5] + flag[3] - 1;
		let stem = ptr[cidx], root, registry;

		if (cidx > 0) {
			registry = this.#RegistryMap(ptr[cidx - 1]);
			root = ptr[cidx - 1][registry.stem];
		} else if (dep === 0) {
			registry = this.#RegistryMap(stem);
			root = stem[this.#Registry];
		} else {
			stem = stack[sidx][pidx];
			registry = this.#RegistryMap(stem);
			root = stem[registry.twig];
		}

		if (nxType.isPrimitive(ptr[cidx])) {
			ptr[cidx] = {
				twig: this.#NamespaceMap(root).ns,
				leaf: String(ptr[cidx])
			};
		}

		const twig = ptr[cidx];
		root = this.#Masquerade(root, twig.twig);

		if (twig[registry.twig])
			return twig[registry.twig];

		twig[registry.stem] = root;
		twig[this.#Registry] = registry[this.#Registry];

		if (root !== (
			twig[registry.twig] = this.#OpRoute(twig, root)
		)) {
			root.appendChild(twig[registry.twig]);
			this.#WeakMap.set(twig[registry.twig], twig);
			return twig[registry.twig];
		}
	}

	static Batch(nodes, alt, size = 2054) {
		const flag = new Int32Array(size);
		const stack = Array.isArray(nodes) ? nodes : [ nodes ];
		const root = new DocumentFragment();
		const sym = {
			twig: Symbol('twig'),
			stem: Symbol('stem'),
			leaf: Symbol('leaf'),
			value: Symbol('value')
		};

		let ptr = new WeakMap([
			[root, {
				alt: this.#Ns.has(alt) ? alt : '<>'
			}],
		]);


		this.#WeakMap.set(root, {
			...sym,
			[sym.twig]: root,
			[sym.stem]: root,
			[this.#Registry]: root,
			flag: flag,
			stack: stack,
			nsm: ptr
		});

		// starting index
		flag[2] = 6;

		// root counter
		flag[5] = stack.length;

		do {
			// depth is 0, switch roots
			if (flag[3] === 0)
				ptr = this.#Reset(stack, flag, root);

			// while the current column isnt the end of the row
			while (++flag[0] < flag[1]) {
				const leaf = ptr[flag[0]].leaf ?? undefined;
				this.#Create(stack, flag, ptr);
				if (leaf instanceof Object)
					ptr = this.#Push(stack, flag, leaf, ptr);
			}

			// if the row isnt a root node pop it, and continue
			if (flag[3] > 0)
				ptr = this.#Pull(stack, flag);

			++flag[4];
			
		} while (flag[4] < flag[5]);

		console.log(this.#WeakMap.get(root), root);
		return root;
	}
}

