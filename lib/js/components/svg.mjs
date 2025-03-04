#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Dom } from '../dom.mjs';
import { nexEvent } from '../event.mjs';
import { nexComponent } from '../components.mjs';
import { nexClass } from '../class.mjs';

export class nexSvg
{
	constructor(obj) {
		if (nexClass.nodes({
			'def': 'svg',
			'inst': nexSvg,
			'self': this
		}, obj)) {
			nexSvg.#p_opacity(obj);
			nexSvg.#defaults({
				'fill': 'none',
				'stroke': false,
				'stroke-width': false,
				'transform': false,
			}, obj);
			['fill', 'stroke'].forEach(i => {
				switch (obj.prop[i]) {
					case 'rgb':
						obj.prop[i] = nexSvg.#rgb;
						break;
					case 'url':
						break;
				}
			});
		}
		nexSvg.#p_size(obj);
		nexSvg.#p_axis(obj);
		nexSvg.#defaults({
			'version': '2.0',
		}, obj);
		console.log(obj)
		this.element = Dom.apply({
			'ns': 'svg',
			...obj
		});

		return this;
	}

	back(num) {
		if (Type.isDefined(this.parent) && Type.isIntegral(num)) {
			let par = this.parent;
			while (--num > 0) {
				if (Type.isDefined(par.parent))
					par = par.parent;
				else
					break;
			}
			return par;
		} else {
			return this;
		}
	}

	static #ids(elm, obj) {
		if (! (Type.isDefined(obj.id) || Type.isFalse(obj.id)))
			obj.id = Dom.setId(`${elm.getAttribute('id')}-${obj.tag}${Dom.tagCount(elm, obj.tag) + 1}`);
	}

	static #defaults(def, obj) {
		if (Type.isObject(def) && Type.isObject(obj)) {
			Object.entries(def).forEach(([k, v]) => {
				if (! Type.isFalse(obj[k]) || (obj[k] == 0 && Type.isIntegral(obj[k]))) {
					if (! (Type.isDefined(obj[k]))) {
						if (! Type.isFalse(v) || ( v == 0 && Type.isIntegral(v)))
							obj.prop[k] = v;
					} else {
						obj.prop[k] = obj[k];
					}
				}
			});
		}
	}

	static get #rgb() {
		return `#${Str.toUpper(Str.random(6, 'xdigit'))}`;
	}

	static #p_axis(obj) {
		nexClass.defaults({
			'x': '0',
			'y': '0',
		}, obj);
	}

	static #p_opacity(obj) {
		nexSvg.#defaults({
			'opacity': '1'
		}, obj);
	}

	static #p_size(obj) {
		nexClass.defaults({
			'width': '100%',
			'height': '100%'
		}, obj);
	}

	static #p_round(obj) {
		nexSvg.#defaults({
			'rx': '0',
			'ry': '0',
		}, obj);
	}

	static #p_radius(obj) {
		obj.cx = obj.x;
		delete obj.x;
		obj.cy = obj.y;
		delete obj.y;
		nexSvg.#defaults({
			'cx': '0',
			'cy': '0',
		}, obj);

	}

	static #p_marker(obj) {
		obj.markerWidth = obj.width;
		delete obj.width;
		obj.markerHeight = obj.height;
		delete obj.height;
		obj.refX = obj.x;
		delete obj.x;
		obj.refY = obj.y;
		delete obj.y;
		nexSvg.#defaults({
			'markerWidth': '8',
			'markerHeight': '8',
			'orient': 'auto',
			'refX': '5',
			'refY': '5'
		}, obj);
	}

	static #p_circle(obj) {
		nexSvg.#p_radius(obj);
		nexSvg.#defaults({
			'r': '50',
		}, obj);
	}

	static #p_text(obj) {
		nexSvg.#p_axis(obj);
		nexSvg.#defaults({
			'dx': false,
			'dy': false,
			'rotate': '0',
			'textLength': false,
			'lengthAdjust': false,
			'font-size': false,
			'text-anchor': 'middle',
			'dominant-baseline': 'middle'
		}, obj);
	}

	static #p_coords(val, obj) {
		if (Type.isObject(obj) && Type.isArray(obj[val])) {
			for (let i = 0; i < obj[val].length; i++) {
			 	obj[`${val}${i + 1}`] = obj[val][i];
			}
			delete obj[val];
		}
	}

	static #p_line(obj) {
		nexSvg.#defaults({
			'x1': '0',
			'x2': '0',
			'y1': '0',
			'y2': '0'
		}, obj);
	}

	static #p_anchor(obj) {
		nexSvg.#defaults({
			'hreflang': false,
			'referrerpolicy': false,
			'type': false,
			'target': '_blank'
		}, obj);
	}

	//| Rect |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#rect = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'rect';
			nexSvg.#p_round(obj);
			nexSvg.#p_axis(obj);
			return super(obj);
		}
	}

	rect(obj) {
		obj.to = this;
		return new this.#rect(obj);
	}

	//| Circle |///////////////////////////////////////////////////////////////////////////////////////////////|
	#circle = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'circle';
			nexSvg.#p_circle(obj);
			return super(obj);
		}
	}

	circle(obj) {
		obj.to = this;
		return new this.#circle(obj);
	}

	//| Ellipse |//////////////////////////////////////////////////////////////////////////////////////////////|
	#ellipse = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'ellipse';
			nexSvg.#p_round(obj);
			nexSvg.#p_radius(obj);
			return super(obj);
		}
	}

	ellipse(obj) {
		obj.to = this;
		return new this.#ellipse(obj);
	}

	//| Line |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#line = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'line';
			nexSvg.#p_coords('x', obj);
			nexSvg.#p_coords('y', obj);
			nexSvg.#p_line(obj);
			obj.prop.fill = false;
			return super(obj);
		}
	}

	line(obj) {
		obj.to = this;
		return new this.#line(obj);
	}

	//| Polygon |//////////////////////////////////////////////////////////////////////////////////////////////|
	#polygon = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			nexSvg.#defaults({
				'points': false,
				'fill-rule': false
			}, obj);
			return super(obj);
		}
	}

	polygon(obj) {
		obj.to = this;
		obj.tag = 'polygon';
		return new this.#polygon(obj);
	}

	polyline(obj) {
		obj.to = this;
		obj.tag = 'polyline';
		return new this.#polygon(obj);
	}
	
	//| Path |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#path = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'path';
			nexSvg.#defaults({
				'd': false,
			}, obj);
			return super(obj);
		}
	}

	path(obj) {
		obj.to = this;
		return new this.#path(obj);
	}

	//| Text |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#text = class extends nexSvg {
		constructor(obj) {
			if (! (Type.isDefined(obj.to.parent) && Arr.in(obj.to, obj.to.parent.nodes.text) && Type.isDefined(obj.tag)))
				obj.tag = 'text';
			nexSvg.#p_text(obj)
			obj.htmlIn = obj.text;
			return super(obj);
		}

		tspan(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'tspan';
			return this.text(obj);
		}

		textPath(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'textPath';
			nexSvg.#defaults({
				'startOffset': false,
				'spacing': 'exact',
				'method': 'align',
				'href': false,
			}, obj);
			return this.text(obj);
		}
	}

	text(obj) {
		obj = Dom.skel(obj);
		obj.to = this;
		return new this.#text(obj);
	}

	//| A |////////////////////////////////////////////////////////////////////////////////////////////////////|
	#a = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'a';
			nexSvg.#p_anchor(obj);
			return super(obj);
		}
	}

	a(obj) {
		obj.to = this;
		return new this.#a(obj);
	}

	//| Image |////////////////////////////////////////////////////////////////////////////////////////////////|
	#image = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'image';
			nexSvg.#p_axis(obj);
			nexSvg.#defaults({
				'href': false
			}, obj);
			return super(obj);
		}
	}

	image(obj) {
		obj.to = this;
		return new this.#image(obj);
	}

	//| Use |//////////////////////////////////////////////////////////////////////////////////////////////////|
	#use = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'use';
			nexSvg.#p_axis(obj);
			nexSvg.#defaults({
				'href': false
			}, obj);
			return super(obj);
		}
	}

	use(obj) {
		obj.to = this;
		return new this.#use(obj);
	}

	//| G |////////////////////////////////////////////////////////////////////////////////////////////////////|
	#g = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'g';
			return super(obj);
		}
	}

	g(obj) {
		obj.to = this;
		return new this.#g(obj);
	}

	//| Defs |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#defs = class extends nexSvg {
		constructor(obj) {
			obj.width = false;
			obj.height = false;
			obj.opacity = false;
			obj.fill = false;
			if (! (Type.isDefined(obj.to.parent) && Arr.in(obj.to, obj.to.parent.nodes.defs) && Type.isDefined(obj.tag)))
				obj.tag = 'defs';
			return super(obj);
		}

		symbol(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'symbol';
			nexSvg.#defaults({
				'viewBox': '0 0 16 16'
			}, obj);

			return this.defs(obj);
		}
		marker(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'marker';
			nexSvg.#p_marker(obj);
			return this.defs(obj);
		}
	}

	defs(obj) {
		obj = Dom.skel(obj);
		obj.to = this;
		return new this.#defs(obj);
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

