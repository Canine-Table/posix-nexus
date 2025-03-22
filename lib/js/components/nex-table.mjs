#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';

export class nexTable extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexTable;
		obj.tag = 'table';
		let cls = [];
		if (Type.isObject(obj.variants)) {
			obj.variants.body = nexNode.Variant(obj.variants.body);
			if (Type.isDefined(obj.variants.body))
				cls.push(`table-${obj.variants.body}`);
			obj.variants.border = nexNode.Variant(obj.variants.border);
				if (Type.isDefined(obj.variants.border))
					cls.push(`border-${obj.variants.border}`);
		}
		if (Type.isDefined(obj.striped)) {
			cls.push(Type.isTrue(obj.striped) ? 'table-striped' : 'table-striped-column');
			delete obj.striped;
		}
		if (Type.isDefined(obj.border)) {
			cls.push(Type.isTrue(obj.border) ? 'table-bordered' : 'table-borderless');
		}

		if (Type.isTrue(obj.hover)) {
			cls.push('table-hover');
			delete obj.hover;
		}
		const table = super(obj).class({
			'add': `table nex-table ${cls}`
		});
		if (Type.isObject(obj.caption)) {
			obj.caption.tag = 'caption';
			const caption = table.frag(obj.caption).nodes.caption[0];
			if (Type.isTrue(obj.caption.top))
				caption.class({ 'add': 'caption-top' });
		}
		if (Type.isTrue(obj.responsive)) {
			table.parent.class({ 'add': '' });
			delete obj.responsive;
		}
		return table;
	}

	static nexTableFragment(obj) {
		if (Type.isDefined(obj)) {
			if (Type.isObject(obj))
				obj = [ obj ];
			Type.isArray(obj, ',').forEach(el => {
				if (Type.isObject(el) && (Type.isDefined(el.tag) || Type.isDefined(el.table))) {
					nexNode.Skel(el);
					switch (el.table) {
						case 'thead':
							el.tag = 'thead';
							break;
						case 'tbody':
							el.tag = 'tbody';
							break;
						case 'tr':
							el.tag = 'tr';
							break;
						case 'th':
							el.tag = 'th';
							break;
						case 'td':
							el.tag = 'td';
							break;
					}
					delete el.table;
					if (Type.isObject(el.child))
						el.child = [ el.child ];
					if (Type.isArray(el.child))
						el.child = nexTable.nexTableFragment(el.child);
				}
			});
			return obj;
		}
	}

	table(obj) {
		if (Type.isObject(obj))
			obj = [ obj ];
		Type.isArray(obj, ',').forEach(el => {
			if (Type.isObject(el))
				el = nexTable.nexTableFragment(el);
		});
		return this.frag(obj);
	}
}

