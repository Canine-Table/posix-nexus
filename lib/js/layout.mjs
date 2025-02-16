#!/usr/bin/env node
class Layout
{
	static instances = {};

	constructor() {
		if (new.target === Layout)
			return Obj.methods(Layout);
		else if (! Arr.in(new.target, [ Container, Row, Col ]))
			throw new Error("Layout is intended for Container, Row, and Col instances");
	}

	addElement(obj) {
		if (Type.isObject(obj) && ! Type.isDefined(this.element)) {
			Layout.instances = {...Layout.instances, [this.id]: this};
			this.element = Dom.apply({
				'tag': 'div',
				'id': this.id,
				'clsSet': obj.cls,
				'textIn': obj.textIn,
				'textOut': obj.textOut,
				'htmlIn': obj.htmlIn,
				'htmlOut': obj.htmlOut,
				'css': obj.css,
				'prop': obj.prop,
				'theme': obj.theme,
				'to': this.parent
			});
		}
	}

	alterParent(obj) {
		Dom.apply(Dom.skel(obj), this.parent);
		return this;
	}

	alterSelf(obj) {
		Dom.apply(Dom.skel(obj), this.element);
		return this;
	}

	*alterChildren(qry) {
		if (Type.isArray(this.children)) {
			for (let i of Arr.query(this.children, Type.isDefined(qry, Arr.range(this.children.length - 1))))
				yield i;
		}
	}

	css(obj) {
		Dom.css(this.element, obj);
		return this;
	}

	prop(obj) {
		Dom.prop(this.element, obj);
		return this;
	}

	apply(obj) {
		Dom.apply(obj, this.element);
		return this;
	}

	append(obj) {
		if (Dom.isHtml(obj))
			Dom.append(obj, this.element);
		return this;
	}
}

class Container extends Layout
{
	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		this.rows = 0;
		this.id = Dom.setId(obj.id);
		this.children = [];
		this.parent = Dom.body(Dom.byId(obj.to));
		obj.clsSet = `layout-container container-fluid ${obj.clsSet}`;
		this.addElement(obj);
	}

	addRows(cnt, obj) {
		if (Type.isIntegral(cnt) && cnt > 0) {
			obj = Dom.skel(obj);
			obj.container = this;
			do {
				new Row(obj);
			} while (--cnt);
		}
	}

	addCols(cnt, obj, qry) {
		obj = Dom.skel(obj);
		if (Type.isIntegral(cnt) && cnt > 0) {
			for (let i of this.alterChildren(qry))
				i.addCols(cnt, obj);
		}
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

class Row extends Layout
{
	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		if (! (obj.container instanceof Container))
			throw new Error("Invalid Container instance");
		this.cols = 0;
		this.row = obj.container.nextRow(this);
		this.id = `${obj.container.id}-r${this.row}`;
		this.children = [];
		this.parent = obj.container.element;
		obj.clsSet = `layout-container-row row ${obj.clsSet}`;
		this.addElement(obj);
	}

	addCols(cnt, obj) {
		if (Type.isIntegral(cnt) && cnt > 0) {
			obj = Dom.skel(obj);
			obj.row = this;
			do {
				new Col(obj);
			} while (--cnt);
		}
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

class Col extends Layout
{
	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		if (! (obj.row instanceof Row))
			throw new Error("Invalid Row instance");
		this.col = obj.row.nextCol(this);
		this.id = `${obj.row.id}-c${this.col}`;
		this.parent = obj.row.element;
		obj.clsSet = `layout-container-row-col col ${obj.clsSet}`;
		this.addElement(obj);
	}
}

class List
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("List instances require a parent to append to");
		this.parent = obj.to;
		this.items = 0;
		this.children = [];
		this.id = `${this.parent.getAttribute('id')}-list`;
		this.element = Dom.append(Component.list(obj), this.parent);
	}

	#nextItem() {
		return ++this.items;
	}

	addLink(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-b${item}`;
		this.children.push(Dom.append(Component.link(obj), this.element));
	}

	addItem(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-l${item}`;
		this.children.push(Dom.append(Component.item(obj), this.element));
	}

	addButton(obj) {
		obj = Dom.skel(obj);
		const item = this.#nextItem();
		obj.id = `${this.id}-i${item}`;
		this.children.push(Dom.append(Component.button(obj), this.element));
	}
}

