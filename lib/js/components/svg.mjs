#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Int } from '../int.mjs';
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
		obj.prop['xmlns:xlink'] = 'http://www.w3.org/1999/xlink';
		this.element = Dom.apply({ 'ns': 'svg', ...obj });
		return this;
	}

	back(num) {
		return nexClass.back(this, num);
	}

	static get #rgb() {
		return `#${Str.toUpper(Str.random(6, 'xdigit'))}`;
	}

	static get #percent() {
		return `${Int.loop(Int.wholeRandom(), 0, 100)}%`;
	}

	static get #spreadMethod() {
		return nexClass.cherryPick([ 'pad', 'reflect', 'repeat' ]);
	}

	static get #gradientUnits() {
		return nexClass.cherryPick([ 'userSpaceOnUse', 'objectBoundingBox' ]);
	}

	static get #gradient() {
		return nexClass.cherryPick([ 'radialGradient', 'linearGradient' ]);
	}

	static get #lineDecoration() {
		return nexClass.cherryPick([ 'none', 'underline', 'overline', 'line-through', 'blink' ]);
	}

	static get #font() {
		return nexClass.cherryPick([
			'system-ui', 'serif', 'sans-serif', 'Georgia', '"Lucida Console"',
			'"Courier New"','monospace', 'Arial', 'Helvetica',
			'"Times New Roman"', 'Times', '"Lucida Sans Unicode"',
		    	'"Bernard MT Condensed"', '"Book Antiqua"', '"Calisto MT"',
			'Cambria', 'Corbel', 'Ebrima', 'Elephant', '"Engravers MT"',
			'"Eras ITC"', '"Felix Titling"', '"Courier New"', 'Verdana',
			'Palatino', 'Garamond', 'Bookman', '"Comic Sans MS"',
		    	'"Trebuchet MS"', '"Arial Black"', 'Impact', 'Tahoma',
			'"Century Gothic"', '"Lucida Console"', '"Gill Sans"', 'Futura',
			'"Franklin Gothic Medium"', 'Baskerville', 'Candara', 'Calibri',
			'Optima', 'Didot', 'Rockwell', 'Monaco', 'Consolas', 'Copperplate',
			'Papyrus', '"Brush Script MT"', '"Segoe UI"', 'Perpetua', '"Goudy Old Style"',
			'"Big Caslon"', '"Bodoni MT"', '"American Typewriter"', '"Andale Mono"',
			'"Avant Garde"', '"Bell MT"',
		]);
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
			'fill-opacity': '1',
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
			'width': [ 'w', 'width' ],
			'viewBox': [ 'v', 'viewBox' ]
		}, {}, obj);
		nexClass.defaults({
			'width': '100%',
			'height': '100%',
			'viewBox': false
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

	static p_point(obj) {
		nexClass.alias({
			'points': [ 'points', 'p' ]
		}, {}, obj);
		nexClass.defaults({
			'points': false,
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

	static p_shift(obj) {
		nexClass.alias({
			'dx': [ 'dx', 'x' ],
			'dy': [ 'dy', 'y' ]
		}, {}, obj);
		nexClass.defaults({
			'dx': '0',
			'dy': '0',
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

	static p_path(obj) {
		nexClass.alias({
			'fill-rule ': [ 'fill-rule', 'rule', 'r' ],
		}, {
			'fill-rule': [ 'nonzero', 'evenodd' ]
		}, obj);
		nexClass.defaults({
			'fill-rule': 'nonzero'
		}, obj);
	}

	static p_gradient(obj) {
		if (obj.coords === 'rand') {
			obj.tag = nexSvg.#gradient;
			obj.prop.spreadMethod = nexSvg.#spreadMethod;
			if (obj.tag === 'linearGradient') {
				obj.x = [ nexSvg.#percent, nexSvg.#percent ];
				obj.y = [ nexSvg.#percent, nexSvg.#percent ];
			} else {
				obj['focal'] = {
					'fx': nexSvg.#percent,
					'fy': nexSvg.#percent
				}
				obj['circle'] = {
					'r': '300%',
					'cx': nexSvg.#percent,
					'cy': nexSvg.#percent
				}
			}
			delete obj.coords;
		}
		if (obj.tag === 'linearGradient') {
			nexSvg.p_coords('x', obj);
			nexSvg.p_coords('y', obj);
		} else if (obj.tag === 'radialGradient') {
			nexClass.prop([
				'focal',
				'circle',
			], obj, nexSvg);
		}
		nexClass.alias({
			'spreadMethod': [ 'spreadMethod', 'spread', 's' ],
			'gradientUnits': [ 'gradientUnits', 'units', 'u' ]
		}, {
			'spreadMethod': [ 'pad', 'reflect', 'repeat' ],
			'gradientUnits': [ 'userSpaceOnUse', 'objectBoundingBox' ]
		}, obj);
		nexClass.defaults({
			'spreadMethod': 'pad',
			'gradientUnits': 'objectBoundingBox'
		}, obj);
	}

	#m_stop(obj) {
		if (Type.isIntegral(obj)) {
			let p = 0;
			const inc = 100 / Number(obj);
			while (p <= 100) {
				new nexSvg({
					'tag': 'stop',
					'to': this,
					'prop': {
						'offset': `${p}%`,
						'stop-color': nexSvg.#rgb
					}
				});
				p += inc;
			}
		} else if (Type.isArray(obj)) {
			obj.forEach(i => {
				if (Type.isObject(i)) {
					new nexSvg({
						'tag': 'stop',
						'to': this,
						'prop': i
					});
				}
			})
		}
		return this;
	}

	a_colliding() {
		const bbox = this.element.getBBox();
		/*return placedText.some(el => {
			const other = el.getBBox();
			return !(bbox.x + bbox.width < other.x || // No overlap horizontally
				 bbox.x > other.x + other.width ||
				 bbox.y + bbox.height < other.y || // No overlap vertically
				 bbox.y > other.y + other.height);
		});\
		*/
	}

	get remove() {
		this.element.remove();
		if (Type.isDefined(this.parent) && neexNode.isSvg(this.parent.element)) {
			return this.parent
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
				'shift'
			], obj, nexSvg);
			if (obj.font === 'rand')
				obj.css['font-family'] = nexSvg.#font;
			if (obj.line === 'rand')
				obj.css['text-decoration-line'] = nexSvg.#lineDecoration 
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

		linearGradient(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'linearGradient';
			nexSvg.p_gradient(obj);
			if (Type.isDefined(obj.stop)) {
				obj.to = this;
				return new this.#defs(obj).#m_stop(obj.stop);
			}
			return this.defs(obj);
		}

		linearGradient(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'radialGradient';
			nexSvg.p_gradient(obj);
			if (Type.isDefined(obj.stop)) {
				obj.to = this;
				return new this.#defs(obj).#m_stop(obj.stop);
			}
			return this.defs(obj);
		}

		#filter = class extends nexSvg {
			constructor(obj) {
				if (! (Type.isDefined(obj.to.parent) && Arr.in(obj.to, obj.to.parent.nodes.filter) && Type.isDefined(obj.tag))) {
					obj.tag = 'filter';
				}
				return super(obj);
			}

			feDropShadow(obj) {

			}
		}

		filter(obj) {
			obj = Dom.skel(obj);
			obj.to = this;
			return new this.#filter(obj);
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
			nexClass.prop([
				'circle',
			], obj, nexSvg);
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
			nexClass.prop([
				'round',
				'radius'
			], obj, nexSvg);
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
			nexClass.prop([
				'line',
			], obj, nexSvg);
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
			nexClass.prop([
				'path',
				'points'
			], obj, nexSvg);
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
	
	//| Path |///////////font-family//////////////////////////////////////////////////////////////////////////////////////|
	#path = class extends nexSvg {
		constructor(obj) {
			obj = Dom.skel(obj);
			obj.tag = 'path';
			nexClass.prop([
				'path',
			], obj, nexSvg);
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

