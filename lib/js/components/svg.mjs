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
			nexClass.prop([
			'stroke',
			'opacity',
			'color'
			], obj, nexSvg);
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
		nexClass.prop([
			'size',
			'axis',
			[ 'version', [ '1.0', '1.1', '2.0' ], '2.0' ]
		], obj, nexSvg);

		this.element = Dom.apply({
			'ns': 'svg',
			...obj
		});

		return this;
	}

	back(num) {
		return nexClass.back(this, num);
	}

	static get #rgb() {
		return `#${Str.toUpper(Str.random(6, 'xdigit'))}`;
	}

	static p_axis(obj) {
		nexClass.defaults({
			'x': '0',
			'y': '0',
		}, obj);
	}

	static p_color(obj) {
		nexClass.alias({
			'fill': [ 'fill', 'f' ]
		}, {}, obj);
		nexClass.defaults({
			'fill': 'none'
		}, obj);
	}

	static p_opacity(obj) {
		nexClass.alias({
			'stroke-opacity': [ 'stroke-opacity', 'stroke', 's' ],
			'fill-opacity': [ 'fill-opacity', 'fill', 'f' ],
			'opacity': [ 'opacity', 'o' ]
		}, {}, obj);
		nexClass.defaults({
			'opacity': false,
			'stroke-opacity': '1',
			'fill-opacity': '1'
		}, obj);
	}

	static p_stroke(obj) {
		nexClass.alias({
			'stroke-opacity': [ 'stroke-opacity', 'opacity', 'o' ],
			'stroke': [ 'fill', 'stroke', 's', 'f' ],
			'stroke-linejoin': [ 'join', 'linejoin', 'stroke-linejoin', 'j' ],
			'stroke-width': [ 'width', 'stroke-width', 'w' ],
			'stroke-dasharray': [ 'dash', 'dasharray', 'stroke-dasharray', 'd' ],
			'stroke-linecap': [ 'cap', 'linecap', 'stroke-linecap', 'c' ]
		}, {
			'stroke-linejoin': [ 'miter', 'round', 'bevel' ],
			'stroke-linecap': [ 'butt', 'round', 'square' ]
		}, obj);
		nexClass.defaults({
			'stroke-opacity': '1',
			'stroke': false,
			'stroke-linejoin': false,
			'stroke-width': false,
			'stroke-dasharray': false,
			'stroke-linecap': false
		}, obj);
	}

	static p_size(obj) {
		nexClass.alias({
			'height': [ 'h', 'height' ],
			'width': [ 'w', 'width' ]
		}, {}, obj);
		nexClass.defaults({
			'width': '100%',
			'height': '100%'
		}, obj);
	}

	static p_round(obj) {
		nexClass.alias({
			'rx': [ 'rx', 'x' ],
			'ry': [ 'ry', 'y' ]
		}, {}, obj);
		nexClass.defaults({
			'rx': '0',
			'ry': '0',
		}, obj);
	}

	static p_radius(obj) {
		nexClass.alias({
			'cx': [ 'cx', 'x' ],
			'cy': [ 'cy', 'y' ]
		}, {}, obj);
		nexClass.defaults({
			'cx': '0',
			'cy': '0',
		}, obj);
	}

	static p_marker(obj) {
		nexClass.alias({
			'markerWidth ': [ 'markerWidth', 'width', 'w' ],
			'markerHeight': [ 'markerHeight', 'height', 'h' ],
			'refX ': [ 'refX', 'x' ],
			'refY ': [ 'refY', 'y' ],
			'orient ': [ 'orient', 'o' ],
		}, {}, obj);
		nexClass.defaults({
			'markerWidth': '8',
			'markerHeight': '8',
			'orient': 'auto',
			'refX': '5',
			'refY': '5'
		}, obj);
	}

	static p_circle(obj) {
		nexSvg.p_radius(obj);
		nexClass.defaults({
			'r': '50',
		}, obj);
	}

	static p_focal(obj) {
		nexClass.alias({
			'fx': [ 'fx', 'x' ],
			'fy': [ 'fy', 'y' ]
		}, {}, obj);
		nexClass.defaults({
			'fx': '0',
			'fy': '0',
		}, obj);
	}

	static p_text(obj) {
		nexClass.alias({
			'text-anchor': [ 'text-anchor', 'anchor', 'a' ],
			'dominant-baseline': [ 'dominant-baseline', 'baseline', 'b' ],
			'font-size': [ 'font-size', 'size', 's' ],
			'dx': [ 'dx', 'x' ],
			'dy': [ 'dy', 'y' ],
			'rotate': [ 'rotate', 'r' ],
			'textLength': [ 'textLength', 'length', 'len', 'tL', 'l' ],
			'lengthAdjust': [ 'lengthAdjust', 'adjust', 'lA' ],
			'text-decoration-color': [ 'text-decoration-color', 'color', 'c' ],
			'text-decoration-line': [ 'text-decoration-line', 'line' ],
			'text-decoration-style': [ 'text-decoration-style', 'tds', 'ds' ]
		}, {
			'text-anchor': [ 'start', 'middle', 'end' ],
			'text-decoration-style': [ 'solid', 'double', 'dotted', 'dashed', 'wavy' ],
			'text-decoration-line': [ 'none', 'underline', 'overline', 'line-through', 'blink' ],
			'dominant-baseline': [
				'auto',
				'text-bottom',
				'alphabetic',
				'ideographic',
				'middle',
				'central',
				'mathematical',
				'hanging',
				'text-top'
			]
		}, obj);

		nexClass.defaults({
			'dx': false,
			'dy': false,
			'rotate': '0',
			'textLength': false,
			'lengthAdjust': false,
			'font-size': false,
			'text-anchor': 'middle',
			'dominant-baseline': 'middle',
			'text-decoration': false,
			'text-decoration-color': false,
			'text-decoration-style': false,
			'text-decoration-line': false,
		}, obj);
	}

	static p_coords(val, obj) {
		if (Type.isObject(obj) && Type.isArray(obj[val])) {
			for (let i = 0; i < obj[val].length; i++) {
			 	obj[`${val}${i + 1}`] = obj[val][i];
			}
			delete obj[val];
		}
	}

	static p_line(obj) {
		nexClass.defaults({
			'x1': '0',
			'x2': '0',
			'y1': '0',
			'y2': '0'
		}, obj);
	}

	static p_anchor(obj) {
		nexClass.defaults({
			'hreflang': false,
			'referrerpolicy': false,
			'type': false,
			'target': '_blank',
		}, obj);
	}

	#m_stop(obj) {
		if (Type.isArray(obj)) {
			obj.forEach(i => {
				this.defs({
						'tag': 'stop',
						'to': this,
						'prop': i
					});
				});
			}
		return this;
	}

	//| Text |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#text = class extends nexSvg {
		constructor(obj) {
			if (! (Type.isDefined(obj.to.parent) && Arr.in(obj.to, obj.to.parent.nodes.text) && Type.isDefined(obj.tag)))
				obj.tag = 'text';
			nexClass.prop([
				'text',
			], obj, nexSvg);
			obj.htmlIn = obj.txt;
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
			nexClass.defaults({
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
			nexSvg.p_anchor(obj);
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
			nexSvg.p_axis(obj);
			nexClass.defaults({
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
			nexSvg.p_axis(obj);
			nexClass.defaults({
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
			if (! (Type.isDefined(obj.to.parent) && Arr.in(obj.to, obj.to.parent.nodes.defs) && Type.isDefined(obj.tag))) {
				nexClass.expand(obj, { false: [ 'axis', 'size' ] });
				obj.tag = 'defs';
			}
			return super(obj);
		}

		symbol(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'symbol';
			nexClass.defaults({
				'viewBox': '0 0 16 16'
			}, obj);

			return this.defs(obj);
		}

		marker(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'marker';
			nexSvg.p_marker(obj);
			return this.defs(obj);
		}
	}

	defs(obj) {
		obj = Dom.skel(obj);
		obj.to = this;
		return new this.#defs(obj);
	}

	//| Rect |/////////////////////////////////////////////////////////////////////////////////////////////////|
	#rect = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'rect';
			nexClass.prop([
				'round',
			], obj, nexSvg);
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
			nexSvg.p_circle(obj);
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
			nexSvg.p_round(obj);
			nexSvg.p_radius(obj);
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
			nexSvg.p_coords('x', obj);
			nexSvg.p_coords('y', obj);
			nexSvg.p_line(obj);
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
			nexClass.defaults({
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
			nexClass.defaults({
				'd': false,
			}, obj);
			return super(obj);
		}
	}

	path(obj) {
		obj.to = this;
		return new this.#path(obj);
	}


}

