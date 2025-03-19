import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';

export class nexForm extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexForm;
		obj.tag = 'form';
		super(obj);
		if (Type.isDefined(obj.submit))
			obj.submit = this.#onSubmit(obj.submit);
		return this;
	}

	#onSubmit(val) {
		if (/\w+\(.*\)\s*\{.*\}/s.test(val)) {
			const act = /\w+\(.*\)/.exec(val)[0];
			this.frag({
				'tag': 'script',
				'html': `function ${val}`
			});
			this.setAttr({
				'onsubmit': act
			});
		}
		return '';
	}

	input(obj) {
		if (Type.isDefined(obj)) {
			if (Type.isObject(obj))
				obj = [obj];
			const inputs = [
				'text', 'password', 'email', 'tel', 'url', 'number', 'range', 'date', 'time',
				'datetime-local', 'month', 'week', 'color', 'checkbox', 'radio', 'file', 'submit',
				'button', 'reset', 'search', 'hidden', 'area', 'textarea'
			];
			obj.forEach(inpt => {
				nexNode.Skel(inpt);
				inpt.tag = 'div'
				const form = this.frag(inpt).nodes.div[this.nodes.div.length - 1].class({
					'add': `input-group ${Type.isDefined(inpt.margins, 'mb-3')}`
				});
				if (Type.isDefined(inpt.field)) {
					if (Type.isObject(inpt.field))
						inpt.field = [inpt.field];
					inpt.field.forEach(fld => {
						if (Type.isObject(fld)) {
							nexNode.Skel(fld);
							if (Type.isDefined(fld.text)) {
								fld.prop['aria-describedby'] = form.frag({
									'tag': 'span',
									'text': fld.text,
									'cls': {
										'add': 'input-group-text'
									}
								}).nodes.span[form.nodes.span.length - 1].getAttr('id').id;
								delete fld.text;
							}
							if (Type.isDefined(fld.name)) {
								fld.prop.name = Str.camelCase(fld.name);
								fld.prop['aria-label'] = Str.camelTitleCase(fld.prop.name);
								fld.prop['aria-label'] = fld.prop['aria-label'].charAt(0).toUpperCase() + fld.prop['aria-label'].slice(1).toLowerCase();
								if (! Type.isDefined(fld.prop.placeholder))
									fld.prop.placeholder = fld.prop['aria-label'];
							}
							if (Type.isDefined(fld.type)) {
								fld.prop.type = Arr.shortStart(Type.isDefined(fld.type, 'text'), inputs) || 'text';
								if (Arr.in(fld.prop.type, [ 'area', 'textarea'])) {
									fld.tag = 'textarea';
									delete fld.prop.type;
								} else {
									fld.tag = 'input';
								}
								let container = form;
								if (Type.isDefined(fld.floating)) {
									container = form.frag({
										'tag': 'div',
										'cls': {
											'add': 'form-floating'
										}
									}).nodes.div[form.nodes.div.length - 1];
									if (! Type.isDefined(fld.prop.placeholder))
										fld.prop.placeholder = fld.floating;
								}
								container.frag(fld).nodes[fld.tag][container.nodes[fld.tag].length - 1].class({
									'add': 'form-control'
								});
								if (Type.isDefined(fld.floating)) {
									container.frag({
										'tag': 'label',
										'text': fld.floating,
										'prop': {
											'for': container.nodes[fld.tag][container.nodes[fld.tag].length - 1].getAttr('id').id
										}
									});
								}
							}
						}
					});
				}
			});
		}
		return this;
	}
}
