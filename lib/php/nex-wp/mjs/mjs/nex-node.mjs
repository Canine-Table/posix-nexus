class NxNodeMap
{
	static #weakMap = new WeakMap();

	static #filter = {
		element: NodeFilter.SHOW_ELEMENT,
		all: NodeFilter.SHOW_ALL,
		text: NodeFilter.SHOW_TEXT,
		comment: NodeFilter.SHOW_COMMENT,
		doc: NodeFilter.SHOW_DOCUMENT,
		document: NodeFilter.SHOW_DOCUMENT,
		type: NodeFilter.SHOW_DOCUMENT_TYPE,
		doctype: NodeFilter.SHOW_DOCUMENT_TYPE,
		attr: NodeFilter.SHOW_ATTRIBUTE,
		attribute: NodeFilter.SHOW_ATTRIBUTE,
		instruction: NodeFilter.SHOW_PROCESSING_INSTRUCTION,
		frag: NodeFilter.SHOW_DOCUMENT_FRAGMENT,
		fragment: NodeFilter.SHOW_DOCUMENT_FRAGMENT
	}

	constructor(query, filter, mapCall, filterCall) {
		NxNodeMap.#weakMap.set(this, new Map());

		// normalize filter
		const filterKey = String(filter ?? 'all').toLowerCase();
		if (!(filterKey in NxNodeMap.#filter))
			throw new Error(`Unknown filter: ${filter}`);

		const nodeMask = NxNodeMap.#filter[filterKey];

		// normalize callback: must return a NodeFilter constant
		// filter callback
		filterCall = typeof filterCall === 'function'
			? filterCall
			: () => NodeFilter.FILTER_ACCEPT;

		// transform callback
		mapCall = typeof mapCall === 'function'
			? mapCall
			: (node) => node;
		const thisWm = this.myself;

		document.querySelectorAll(query).forEach(e => {
			thisWm.set(e, []);
			const thisWmMp = thisWm.get(e);

			const walker = document.createTreeWalker(
				e.parentNode,
				nodeMask,
				{
					acceptNode(node) {
						const nd = filterCall(node);

						// validate return value
						if (
							nd === NodeFilter.FILTER_ACCEPT ||
							nd === NodeFilter.FILTER_SKIP ||
							nd === NodeFilter.FILTER_REJECT
						) {
							return nd;
						}

						throw new Error(`Callback must return a NodeFilter constant, got: ${nd}`);
					}
				}
			);

			let n;
			while ((n = walker.nextNode())) {
				const mapped = mapCall(n);
				if (mapped)
					thisWmMp.push(mapped);
			}
		});
	}

	static getText(text, tag = 'p') {
		const frag = new DocumentFragment();
		for (const sentence of text.split('.')) {
			const trimmed = sentence.trim();
			if (!trimmed)
				continue;
			const el = document.createElement(tag);
			el.textContent = trimmed + '.';
			frag.appendChild(el);
		}
		return frag;
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
		const [key, value] = this.getEntryByIndex(index);
		return { key, value };
	}

	after(s, d) {
		s.parentNode.insertBefore(d, s.nextSibling);
	}

	before(s, d) {
		s.parentNode.insertBefore(d, s);
	}
}

class NxTable {

	constructor(data = [], {
		headerCount = 0,
		caption = null,
	} = {}) {

		// Normalize input into a matrix
		this.matrix = Array.isArray(data[0])
			? data.map(row => [...row])
			: [...data].map(v => [v]);

		this.headerCount = headerCount;
		this.caption = caption;

		// Internal DOM cache
		this._table = null;
	}

	[Symbol.iterator]() {
		return this.matrix[Symbol.iterator]();
	}

	rows() {
		return this.matrix;
	}

	row(i) {
		return this.matrix[i];
	}

	cell(r, c) {
		return this.matrix[r]?.[c];
	}

	table() {
		if (this._table) return this._table;

		const table = document.createElement('table');

		if (this.caption) {
			const cap = document.createElement('caption');
			cap.textContent = this.caption;
			table.appendChild(cap);
		}

		// Build THEAD
		if (this.headerCount > 0) {
			const thead = document.createElement('thead');

			for (let i = 0; i < this.headerCount; i++) {
				const tr = document.createElement('tr');
				for (const cell of this.matrix[i]) {
					const th = document.createElement('th');
					th.textContent = cell;
					tr.appendChild(th);
				}
				thead.appendChild(tr);
			}

			table.appendChild(thead);
		}

		// Build TBODY
		const tbody = document.createElement('tbody');

		for (let i = this.headerCount; i < this.matrix.length; i++) {
			const tr = document.createElement('tr');
			for (const cell of this.matrix[i]) {
				const td = document.createElement('td');
				td.textContent = cell;
				tr.appendChild(td);
			}
			tbody.appendChild(tr);
		}

		table.appendChild(tbody);

		this._table = table;
		return table;
	}

	static fromDOM(tableEl) {
		const caption = tableEl.querySelector('caption')?.textContent ?? null;

		const header = [...tableEl.querySelectorAll('thead th')]
			.map(th => th.textContent);

		const rows = [...tableEl.querySelectorAll('tbody tr')]
			.map(tr => [...tr.children].map(td => td.textContent));

		return new NxTable(rows, { header, caption });
	}
}

