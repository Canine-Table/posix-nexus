#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';

export class nexAccordion extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexAccordion;
		obj.tag = nexNode.ContainerTag(obj.tag);
		super(obj).class({
			'add': `accordion nex-accordion ${Type.isTrue(obj.flush) ? 'accordion-flush' : ''}`
		});
		this.accordion = [];
	}

	item(obj) {
		nexNode.Skel(obj);
		obj.tag = nexNode.ContainerTag(obj.tag);
		if (! Type.isObject(obj['header']))
			obj['header'] = {};
		obj['header'].tag = nexNode.HeaderTag(obj['header'].tag);
		if (! Type.isObject(obj['header']['button']))
			obj['header']['button'] = {};
		obj['header']['button'].tag = nexNode.ButtonTag(obj['header']['button'].tag, 'button');
		if (! Type.isObject(obj['collapse']))
			obj['collapse'] = {};
		obj['collapse'].tag = nexNode.ContainerTag(obj['collapse'].tag);
		if (! Type.isObject(obj['collapse']['body']))
			obj['collapse']['body'] = {};
		obj['collapse']['body'].tag = nexNode.ContainerTag(obj['collapse']['body'].tag);
		const state = this.accordion.length > 0 ? false : true;
		const accordion = this.frag(obj).nodes[obj.tag][this.nodes[obj.tag].length - 1]
		if (! Type.isObject(obj['collapse']['prop']))
			obj['collapse']['prop'] = {};
		if (! Type.isTrue(obj['alway-open']))
			obj['collapse']['prop']['data-bs-parent'] = `#${this.getAttr('id').id}`;
		accordion.class({
			'add': 'accordion-item'
		}).frag(obj['header']).nodes[obj['header'].tag][0].class({
			'add': 'accordion-header'
		}).frag(obj['header']['button']).nodes[obj['header']['button'].tag][0].class({
			'add': ` accordion-button ${Type.isTrue(state) ? '' : 'collapsed'}`
		}).setAttr({
			'type': 'button',
			'data-bs-toggle': 'collapse',
			'data-bs-target': `#${accordion.getAttr('id').id}-${obj['collapse'].tag}1`,
			'aria-expanded': state,
			'aria-controls': `${accordion.getAttr('id').id}-${obj['collapse'].tag}1`
		});
		this.accordion.push(accordion.frag(obj['collapse']).nodes[obj['collapse'].tag][0].class({
			'add': `accordion-collapse collapse ${Type.isTrue(state) ? 'show' : ''}`
		}).frag(obj['collapse']['body']).nodes[obj['collapse']['body'].tag][0].class({
			'add': 'accordion-body'
		}));
		return this;
	}
}
