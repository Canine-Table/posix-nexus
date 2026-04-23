export class NxTable
{
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

