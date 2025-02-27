#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Dom } from '../dom.mjs';
import { nexEvent } from '../event.mjs';
import { nexComponent } from '../components.mjs';
export class nexSvg
{
	static factory = undefined;
	static define = {};
	constructor() {
		if (! Dom.isHtml(nexSvg.factory)) {
			nexSvg.factory = Dom.append(Dom.apply({
					'tag': 'defs',
					'ns': 'svg',
					'id': false
				}), Dom.append(Dom.apply({
				'tag': 'svg',
				'ns': 'svg',
				'id': false,
				'prop': {
					'width': 0,
					'height': 0
				},
				'css': {
					'position': 'absolute',
					'visibility': 'hidden'
				}
			}), Dom.body()));
		}
		return this;
	}

	addSvg(obj) {
		if (Type.isDefined(nexSvg.define[obj.id]) && Type.isArray(obj.svg)) {
			const elm = nexSvg.define[obj.id];
			const p = elm.element;
			let idx = elm.children.length;
			obj.svg.forEach(i => {
				i.id = `${p.id}-${idx + 1}`;
				i.ns = 'svg';
				elm.children.push(Dom.append(Dom.apply(i), p));
				idx++;
			});
		}
		return this;
	}

	addDef(obj) {
		obj = Dom.skel(obj);
		obj.tag = nexComponent.options(obj.tag, [ 'marker', 'pattern', 'clipPath', 'mask', 'symbol' ], 'symbol');
		obj.id = `${obj.tag}-${Dom.setId(obj.id)}`;
		obj.htmlIn = obj.text;
		obj.ns = 'svg';
		obj.prop.viewbox = obj.viewbox || '0 0 16 16';
		nexSvg.define[obj.id] = {
			'tag': obj.tag,
			'element': Dom.append(Dom.apply(obj), nexSvg.factory),
			'children': []
		}
		return this.addSvg(obj);
	}

	useDef(obj) {
		obj = Dom.skel(obj);
		if (Dom.isElement(obj.to) && Type.isDefined(nexSvg.define[obj.id])) {
			const id = Dom.setId(`${obj.to.id || obj.to.getAttribute('id')}-svg`);
			if (! Type.isObject(obj.svgIn))
				obj.svgIn = {};
			if (! Type.isObject(obj.svgOut))
				obj.svgOut = {};
			Dom.append(Dom.apply({
				'tag': 'use',
				'id': `${id}-use`,
				'ns': 'svg',
				'clsAdd': 'nex-svg-in',
				...obj.svgIn,
				'prop': {
					'href': `#${obj.id}`
				}
			}), Dom.append(Dom.apply({
				'tag': 'svg',
				'ns': 'svg',
				'clsAdd': 'nex-svg-out',
				'id': id,
				...obj.svgOut,
				'prop': {
					'height': obj.svgOut.height || '16',
					'width': obj.svgOut.width || '16',
					'viewBox': obj.svgOut.box || `0 0 ${obj.svgOut.width || '16'} ${obj.svgOut.height || '16'}`,
				}
			}), obj.to));

			nexEvent.add(Dom.byId(id), obj.svgOut);
			nexEvent.add(Dom.byId(`${id}-use`), obj.svgIn);
		}
		return this;
	}
	
	static *iterateSvg(obj) {
		if (! Type.isObject(obj))
			obj = {};
		const svgs = Dom.byClass(`nex-svg-${nexComponent.options(obj.id, [ 'in', 'out' ], 'out')}`);
		for (let i = 0; i < svgs.length; i++)
			yield svgs[i];
	}

	static getNS(tag) {
		return Dom.apply({
			'tag': Type.isDefined(tag, 'svg'),
			'ns': 'svg',
			'id': false
		});
	}
}

