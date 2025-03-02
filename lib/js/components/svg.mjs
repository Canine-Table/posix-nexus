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
	constructor(val) {
		if (! Dom.isHtml(nexSvg.factory) && Type.isTrue(val)) {
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
				'clsAdd': Type.isDefined(obj.colored, 'nex-svg-in'),
				...obj.svgIn,
				'prop': {
					'href': `#${obj.id}`
				}
			}), Dom.append(Dom.apply({
				'tag': 'svg',
				'ns': 'svg',
				'clsAdd': 'nex-svg-out',
				'clsAdd': Type.isDefined(obj.colored, 'nex-svg-out'),
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

export class nexSvgCanvas
{
	constructor(obj) {
		const attr = {};
		obj = Dom.skel(obj);
		if (obj.to instanceof nexSvgCanvas) {
			if (Arr.in(obj.tag, Object.keys(obj.to.tree.node)))
				obj.to.tree.node[obj.tag].push(this);
			attr.parent = obj.to;
			obj.to = obj.to.element;
		} else {
			attr.parent = null;
			obj.tag = 'svg';
		}
		if (! Dom.isElement(obj.to))
			throw new Error("nexSvgCanvas instances require a parent to append to");
		this.parent = attr.parent;
		this.tree = {
			'children': [],
			'node': {
				'rect': [],
				'ellipse': [],
				'polygon': [],
				'circle': [],
				'polyline': [],
				'path': [],
				'text': [],
				'image': [],
				'a': [],
				'g': [],
				'use': [],
				'defs': []
			}
		}
		this.element = Dom.apply({
			'ns': 'svg',
			...obj
		});
		return this;
	}

	rect(obj) {
		return new nexSvgCanvas({
			'tag': 'rect',
			'id': false,
			'to': this,
			...obj
		});
	}

	ellipse(obj) {
		return new nexSvgCanvas({
			'tag': 'ellipse',
			'id': false,
			'to': this,
			...obj
		});
	}

	polyline(obj) {
		return new nexSvgCanvas({
			'tag': 'polyline',
			'id': false,
			'to': this,
			...obj
		});
	}

	circle(obj) {
		return new nexSvgCanvas({
			'tag': 'circle',
			'id': false,
			'to': this,
			...obj
		});
	}

	polygon(obj) {
		return new nexSvgCanvas({
			'tag': 'polygon',
			'id': false,
			'to': this,
			...obj
		});
	}

	text(obj) {
		obj = Dom.skel(obj);
		obj.anchor = Type.isDefined(obj.anchor, 'middle');
		obj.prop = {
			...obj.prop,
			'text-anchor': obj.anchor,
			'dominant-baseline': obj.anchor
		};
		delete obj.anchor;
		const node = new nexSvgCanvas({
			'id': false,
			'tag': 'text',
			'to': this,
			...obj,
		});
		console.log(node.element)
		node.children = {
			'tspan': [],
			'textpath': []
		};
		
		node.tspan = obj => {
			console.log('tspan');
		}

		node.textpath = obj => {
			console.log('tspan');
		}

		return node;
	}

	path(obj) {
		obj = Dom.skel(obj);
		obj.prop.d = obj.d;
		return new nexSvgCanvas({
			'tag': 'path',
			'to': this,
			...obj
		});
	}

	image(obj) {
		return new nexSvgCanvas({
			'tag': 'image',
			'id': false,
			'to': this,
			...obj
		});
	}

	a(obj) {
		return new nexSvgCanvas({
			'tag': 'a',
			'id': false,
			'to': this,
			...obj
		});
	}

	g(obj) {
		return new nexSvgCanvas({
			'tag': 'g',
			'id': false,
			'to': this,
			...obj
		});
	}

	use(obj) {
		const node1 = new nexSvgCanvas({
			'tag': 'use',
			'to': this,
			...obj
		});
		this.tree.node.use.push(node1);
		return node1;
	}

	defs(obj) {
		obj = Dom.skel(obj);
		obj.id = false;
		const node1 = new nexSvgCanvas({
			'tag': 'defs',
			'to': this,
			...obj
		});

		this.tree.node.defs.push(node1);
		node1.children = {
			'marker': [],
			'linearGradient': [],
			'radialGradient': [],
			'symbol': [],
			'pattern': []
		};

		node1.pattern = obj => {
			obj = Dom.skel(obj);
			obj.prop.patternUnits = obj.units || 'userSpaceOnUse';
			obj.prop.x = obj.cx || '0';
			obj.prop.y = obj.fx || '0';
			obj.prop.width = obj.cy || '100%';
			obj.prop.height = obj.fy || '100%';

			const node2 = new nexSvgCanvas({
				'tag': 'pattern',
				'to': node1,
				...obj
			});
			node1.children.pattern.push(node2);
			return node2;
		}
		node1.symbol = obj => {
			obj = Dom.skel(obj);
			obj.prop.viewbox = obj.viewbox || '0 0 16 16';
			const node2 = new nexSvgCanvas({
				'tag': 'symbol',
				'to': node1,
				...obj
			});
			node1.children.symbol.push(node2);
			return node2;
		}

		node1.radialGradient = obj => {
			obj = Dom.skel(obj);
			obj.prop.r = obj.r || '50%';
			obj.prop.cx = obj.cx || '50%';
			obj.prop.fx = obj.fx || '50%';
			obj.prop.cy = obj.cy || '50%';
			obj.prop.fy = obj.fy || '50%';
			obj.prop.spreadMethod = obj.method || 'pad';
			obj.prop.gradientUnits = obj.units || 'objectBoundingBox';
			if (Type.isDefined(obj.tranform))
				obj.prop.gradientTransform = obj.tranform
			if (Type.isDefined(obj.template))
				obj.prop.href = obj.template
			const node2 = new nexSvgCanvas({
				'tag': 'radialGradient',
				'to': node1,
				...obj
			});

			node2.children = {
				'stop': [],
			};

			node1.children.linearGradient.push(node2);
			node2.stop = obj => {
				if (Type.isArray(obj)) {
					obj.forEach(i => {
						const node3 = new nexSvgCanvas({
							'tag': 'stop',
							'to': node2,
							'prop': i
						});
						node2.children.stop.push(node3);
					});
				}
				return node2;
			}
			return node2;
		}

		node1.marker = obj => {
			obj = Dom.skel(obj);
			const node2 = new nexSvgCanvas({
				'tag': 'marker',
				'to': node1,
				...obj
			});
			node1.children.marker.push(node2);
			return node2;

		}

		node1.linearGradient = obj => {
			obj = Dom.skel(obj);
			obj.prop.x1 = obj.x1 || '0%';
			obj.prop.x2 = obj.x2 || '0%';
			obj.prop.y1 = obj.y1 || '0%';
			obj.prop.y2 = obj.y2 || '0%';
			obj.prop.spreadMethod = obj.method || 'pad';
			obj.prop.gradientUnits = obj.units || 'objectBoundingBox';
			if (Type.isDefined(obj.tranform))
				obj.prop.gradientTransform = obj.tranform
			if (Type.isDefined(obj.template))
				obj.prop.href = obj.template
			const node2 = new nexSvgCanvas({
				'tag': 'linearGradient',
				'to': node1,
				...obj
			});
			
			node2.children = {
				'stop': [],
			};

			node1.children.linearGradient.push(node2);
			node2.stop = obj => {
				if (Type.isArray(obj)) {
					obj.forEach(i => {
						const node3 = new nexSvgCanvas({
							'tag': 'stop',
							'to': node2,
							'prop': i
						});
						node2.children.stop.push(node3);
					});
				}
				return node2;
			}
			return node2;
		}

		node1.marker = obj => {
			obj = Dom.skel(obj);
			const node2 = new nexSvgCanvas({
				'tag': 'marker',
				'to': node1,
				...obj
			});
			node1.children.marker.push(node2);
			return node2;
		}

		return node1;
	}
}

