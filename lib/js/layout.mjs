#!/usr/bin/env node
import { Type } from './type.mjs';
import { Arr } from './arr.mjs';
import { Dom } from './dom.mjs';
import { Str } from './str.mjs';
import { nexComponent } from './components.mjs';
export class nexLayout
{
	static instances = {};
	static breakpoints = [ '', 'sm', 'md', 'lg', 'xl', 'xxl' ];
	static fit = [ 'contain', 'cover', 'fill', 'scale', 'none' ];

	constructor() {
		if (new.target === nexLayout)
			return Obj.methods(nexLayout);
		else if (! Arr.in(new.target, [ nexContainer, nexRow, nexCol ]))
			throw new Error("nexLayout is intended for nexContainer, nexRow, and nexCol instances");
	}

	addElement(obj) {
		if (Type.isObject(obj) && ! Type.isDefined(this.element)) {
			const parent = this.parent.element || this.parent;
			nexLayout.instances = {...nexLayout.instances, [this.id]: this};
			this.element = Dom.append(nexComponent.div({
				'tag': this.#getTagName(),
				'id': this.id,
				...obj
			}), parent);
			this.children = [];
			this.cls = {};
			this.self = this;
			Dom.text(this.element, obj);
			Dom.html(this.element, obj);
			return this;
		}
	}

	#getTagName() {
		if (this instanceof nexContainer && ! (Dom.isTag(this.parent, 'article') || Dom.parentTag(this.parent, 'article')))
			return 'article';
		else if (this instanceof nexRow && Dom.isTag(this.parent, 'article'))
			return 'section';
		else
			return 'div';
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
		return this;
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

	justify(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			nexLayout.breakpoints,
			[ 'evenly', 'between', 'around', 'end', 'start', 'center' ]
		], '-'), 'justify-content-');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.justify,
				'clsAdd': res
			});
			this.cls.justify = res;
		}
		return this;
	}

	align(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			[ 'items', 'self' ],
			nexLayout.breakpoints,
			[ 'start', 'end', 'center', 'baseline', 'stretch' ]
		], '-'), 'align-');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.align,
				'clsAdd': res
			});
			this.cls.align = res;
		}
		return this;
	}

	container(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			Arr.add(nexLayout.breakpoints, [ 'fluid', 'container' ])
		], '-'), 'container-').replace('container-container', 'container');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.size,
				'clsAdd': res
			});
			this.cls.container = res;
		}
		return this;
	}
}

export class nexContainer extends nexLayout
{
	#rows = 0;
	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		this.id = Dom.setId(obj.id);
		this.type = 'container';
		if (Dom.isElement(obj.to))
			this.parent = obj.to;
		else
			this.parent = Dom.body(Dom.byId(obj.to));
		obj.clsSet = `${obj.clsSet} layout-container`;
		return this.addElement(obj);
	}

	flex(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			nexLayout.breakpoints,
			[ 'inline', '' ]
		], '-'), 'd-', '-flex');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.flex,
				'clsAdd': res
			});
			this.cls.flex = res;
		}
		return this;
	}

	addRows(cnt, obj) {
		if (Type.isIntegral(cnt) && cnt > 0) {
			obj = Dom.skel(obj);
			obj.parent = this;
			do {
				new nexRow(obj);
			} while (--cnt);
		}
		return this;
	}

	addCols(cnt, obj, qry) {
		obj = Dom.skel(obj);
		if (Type.isIntegral(cnt) && cnt > 0) {
			for (let i of this.alterChildren(qry))
				i.addCols(cnt, obj);
		}
		return this;
	}

	nextRow(row) {
		if (! (row instanceof nexRow))
			throw new Error("Invalid nexRow instance");
		if (Arr.in(row, this.children))
			throw new Error("Duplicate nexRow instance");
		this.children.push(row);
		return ++this.#rows;
	}
}

export class nexRow extends nexLayout
{
	#cols = 0;

	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		if (! (obj.parent instanceof nexContainer))
			throw new Error("Invalid nexContainer instance");
		this.row = obj.parent.nextRow(this);
		this.type = 'row';
		this.id = `${obj.parent.id}-r${this.row}`;
		this.parent = obj.parent;
		obj.clsSet = `${obj.clsSet} layout-container-row`;
		return this.addElement(obj);
	}

	flex(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			nexLayout.breakpoints,
			'reverse',
		], '-'), 'flex-', '-row').replace('reverse-row', 'row-reverse');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.flex,
				'clsAdd': res
			});
			this.cls.flex = res;
		}
		return this;
	}

	addCols(cnt, obj) {
		if (Type.isIntegral(cnt) && cnt > 0) {
			obj = Dom.skel(obj);
			obj.parent = this;
			do {
				new nexCol(obj);
			} while (--cnt);
		}
		return this;
	}

	nextCol(col) {
		if (! (col instanceof nexCol))
			throw new Error("Invalid nexRow instance");
		if (Arr.in(col, this.children))
			throw new Error("Duplicate nexCol instance");
		this.children.push(col);
		return ++this.#cols;
	}
}

export class nexCol extends nexLayout
{
	constructor(obj) {
		super();
		obj = Dom.skel(obj);
		if (! (obj.parent instanceof nexRow))
			throw new Error("Invalid nexRow instance");
		this.col = obj.parent.nextCol(this);
		this.type = 'col';
		this.id = `${obj.parent.id}-c${this.col}`;
		this.parent = obj.parent;
		obj.clsSet = `${obj.clsSet} layout-container-row-col`;
		return this.addElement(obj);
	}

	flex(obj) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			nexLayout.breakpoints,
			'reverse',
		], '-'), 'flex-', '-column').replace('reverse-column', 'column-reverse');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.flex,
				'clsAdd': res
			});
			this.cls.flex = res;
		}
		return this;
	}

	resize(obj, qry) {
		const res = Arr.prePostAppend(Arr.flatten(obj, [
			nexLayout.breakpoints,
			[ ...Arr.range('<12'), 'auto' ]
		], '-'), 'col-');
		if (Type.isDefined(res)) {
			this.alterSelf({
				'clsDel': this.cls.size,
				'clsAdd': res
			});
			this.cls.size = res;
		}
		return this;
	}
}

