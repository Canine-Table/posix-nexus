#!/usr/bin/env node
class Layout
{
	static text = ['start', 'center', 'end'];
	constructor(obj) {
		obj = Dom.skel(obj);
		this.rows = 0;
		this.id = Dom.setId(obj.id);
		this.children = [];
		this.parent = Dom.body(Dom.byId(obj.to));
		this.element = Dom.apply({
			'tag': 'div',
			'id': this.id,
			'clsSet': `layout container ${obj.cls}`,
			'textIn': obj.textIn,
			'textOut': obj.textOut,
			'htmlIn': obj.htmlIn,
			'htmlOut': obj.htmlOut,
			'css': obj.css,
			'prop': obj.prop,
			'to': this.parent
		});
		this.setTextPosition(obj.text, 'center');
	}

	setTextPosition(val, def) {
		this.text = Dom.toggle(this.element, {
			'val': val,
			'opt': Layout.text,
			'del': this.text,
			'sep': ',',
			'def': def,
			'pre': 'text-'
		});
	}

	static methods() {
		Obj.methods(Layout);
	}

	alterRows(obj) {
		obj = Dom.skel(obj);
		this.children.forEach(i => {
			i.alterSelf(obj);
		});
	}
	
	alterAligns(val, def) {
		this.children.forEach(i => {
			i.setAlign(val, def);
		});
	}

	alterJustifies(val, def) {
		this.children.forEach(i => {
			i.setJustify(val, def);
		});
	}

	alterCols(obj) {
		obj = Dom.skel(obj);
		this.children.forEach(i => {
			i.alterCols(obj);
		});
	}

	alterParent(obj) {
		Dom.apply(Dom.skel(obj), this.parent);
	}

	alterSelf(obj) {
		Dom.apply(Dom.skel(obj), this.element);
	}

	nextRow(row) {
		if (! (row instanceof Row))
			throw new Error("Invalid Row instance");
		if (Arr.in(row, this.children))
			throw new Error("Duplicate Row instance");
		this.children.push(row);
		return ++this.rows;
	}
}

class Row
{
	static justify = ['evenly', 'between', 'around', 'end', 'start', 'center'];
	static align = ['start', 'center', 'end'];

	constructor(obj) {
		obj = Dom.skel(obj);
		if (! (obj.layout instanceof Layout))
			throw new Error("Invalid Layout instance");
		this.cols = 0;
		this.row = obj.layout.nextRow(this);
		this.id = `${obj.layout.id}-r${this.row}`;
		this.children = [];
		this.parent = obj.layout.element;
		this.element = Dom.apply({
			'tag': 'div',
			'id': this.id,
			'clsSet': `layout-row row ${obj.cls}`,
			'textIn': obj.textIn,
			'textOut': obj.textOut,
			'htmlIn': obj.htmlIn,
			'htmlOut': obj.htmlOut,
			'css': obj.css,
			'prop': obj.prop,
			'to': this.parent
		});
		this.setJustify(obj.justify, 'evenly');
		this.setAlign(obj.align, 'start');
	}

	static methods() {
		Obj.methods(Row)
	}

	setJustify(val, def) {
		this.justify = Dom.toggle(this.element, {
			'val': val,
			'opt': Row.justify,
			'del': this.justify,
			'sep': ',',
			'def': def,
			'pre': 'justify-content-'
		});
	}

	setAlign(val, def) {
		this.align = Dom.toggle(this.element, {
			'val': val,
			'opt': Row.align,
			'del': this.align,
			'sep': ',',
			'def': def,
			'pre': 'align-items-'
		});
	}

	alterCols(obj) {
		obj = Dom.skel(obj);
		this.children.forEach(i => {
			i.alterSelf(obj);
		});
	}

	alterParent(obj) {
		this.parent.alterSelf(Dom.skel(obj));
	}

	alterSelf(obj) {
		Dom.apply(Dom.skel(obj), this.element);
	}

	nextCol(col) {
		if (! (col instanceof Col))
			throw new Error("Invalid Row instance");
		if (Arr.in(col, this.children))
			throw new Error("Duplicate Col instance");
		this.children.push(col);
		return ++this.cols;
	}
}

class Col
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! (obj.row instanceof Row))
			throw new Error("Invalid Row instance");
		this.col = obj.row.nextCol(this);
		this.id = `${obj.row.id}-c${this.col}`;
		this.parent = obj.row.element;
		this.element = Dom.apply({
			'tag': 'div',
			'id': this.id,
			'clsSet': `layout-row-col col ${obj.cls}`,
			'textIn': obj.textIn,
			'textOut': obj.textOut,
			'htmlIn': obj.htmlIn,
			'htmlOut': obj.htmlOut,
			'css': obj.css,
			'prop': obj.prop,
			'to': this.parent
		});
	}

	static methods() {
		Obj.methods(Col)
	}

	alterParent(obj) {
		this.parent.alterSelf(Dom.skel(obj));
	}

	alterSelf(obj) {
		Dom.apply(Dom.skel(obj), this.element);
	}
}

