class Layout
{
	static text = ['start', 'center', 'end'];

	constructor(obj) {
		obj = returnObjectType(obj);
		getPropList(obj, 'layout');
		this.rows = 0;
		this.id = obj.id;
		this.text = autoComplete(obj.text, Layout.text) || 'center';
		addTo(getObj(obj.to), addTag({
			'tag': 'div',
			'id': this.id,
			'clsSet': `container text-${this.text} ${obj.cls}`
		}));
	}

	rowCount() {
		return findTag({
			'tag': 'div',
			'id': this.id,
			'prop': 'class',
			'val': 'layout-row'
		}).length;
	}

	colCount() {
		return findTag({
			'tag': 'div',
			'id': this.id,
			'prop': 'class',
			'val': 'layout-row-col'
		}).length;
	}

	nextRow() {
		return ++this.rows;
	}

	isRow(row) {
		return findTag({
			'tag': 'div',
			'id': this.id,
			'prop': 'id',
			'id': `${this.id}-r${row}`,
		}).length === 1;
	}

	getRow(row) {
		if (this.isRow(row))
			return getObj(`${this.id}-r${row}`);
	}
}

class Row
{
	static justify = ['evenly', 'between', 'around', 'end', 'start', 'center'];
	static align = ['start', 'center', 'end'];

	constructor(layout, obj) {
		if (! (layout instanceof Layout))
			throw new Error("Invalid Layout instance");
		obj = returnObjectType(obj);
		this.justify = autoComplete(obj.justify, Row.justify) || 'evenly';
		this.align = autoComplete(obj.align, Row.align) || 'start';
		this.row = layout.nextRow();
		this.cols = 0;
		this.id = `${layout.id}-r${this.row}`;
		addTo(getObj(layout.id), addTag({
			'tag': 'div',
			'clsSet': `layout-row row justify-content-${this.justify} align-items-${this.align} ${obj.cls}`,
			'id': this.id
		}));
	}

	colCount() {
		return findTag({
			'tag': 'div',
			'id': this.id,
			'prop': 'class',
			'val': 'layout-row-col'
		}).length;
	}

	isCol(col) {
		return findTag({
			'tag': 'div',
			'id': this.id,
			'prop': 'id',
			'id': `${this.id}-c${col}`,
		}).length === 1;
	}

	getCol(row) {
		if (this.isCol(col))
			return getObj(`${this.id}-c${col}`);
	}

	nextCol() {
		return ++this.cols;
	}
}

class Col
{
	constructor(row, obj) {
		if (! (row instanceof Row))
			throw new Error("Invalid Row instance");
		obj = returnObjectType(obj);
		this.col = row.nextCol();
		this.id = `${row.id}-c${this.col}`;
		addTo(getObj(row.id), addTag({
			'tag': 'div',
			'id': this.id,
			'clsSet': `layout-row-col col ${obj.cls}`
		}));
	}
}


/*
Layout.prototype.addRow = function(obj)
{
	obj = returnObjectType(obj);
	obj.jst = autoComplete(isDefinedType(obj.jst, 'evenly'), [
		'evenly',
		'between',
		'around',
		'end',
		'start',
		'center'
	]) || 'evenly';
	obj.aln = autoComplete(isDefinedType(obj.aln, 'start'), [
		'start',
		'center',
		'end'
	]) || 'start';
	obj.row = this.rowCount() + 1;
	obj.clsSet = `justify-content-${obj.jst} align-items-${obj.aln}`;
	this[`r${obj.row}`] = addTo(getObj(this.tag.id), addTag({
		'tag': 'div',
		'clsSet': 'row',
		'id': `${this.tag.id}-r${obj.row}`,
	}));
	addClass(this[`r${obj.row}`], obj);
	//return this[`r${obj.row}`];
}

Layout.prototype.rowCount = function()
{
	return findTag({
		'tag': 'div',
		'id': this.tag.id,
		'prop': 'class',
		'val': 'row'
	}).length;
}

Layout.prototype.colCount = function(row)
{
	if (isDefinedType(this[`r${row}`])) {
		return findTag({
			'tag': 'div',
			'id': this[`r${row}`].id,
			'prop': 'class',
			'val': 'col'
		}).length;
	} else {
		return undefined;
	}
}

Layout.prototype.addCol = function(obj)
{
	obj = returnObjectType(obj);
	obj.row = isDefinedType(obj.row, this.rowCount() + 1);
	obj.col = this.colCount(obj.row);
	if (isDefinedType(obj.col)) {
		obj.col += 1;
		this[`r${obj.row}`][`c${obj.col}`] = addTo(getObj(this[`r${obj.row}`].id), addTag({
			'tag': 'div',
			'id': `${this.ftag.id}-r${obj.row}-c${obj.col}`,
			'clsSet': `col`
		}));
		return this[`r${obj.row}`][`c${obj.col}`];
	}
}
*/
