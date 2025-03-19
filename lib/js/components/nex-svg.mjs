#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Arr } from '../arr.mjs';
import { Str } from '../str.mjs';
import { Int } from '../int.mjs';
import { nexEvent } from '../event.mjs';
import { nexClass } from '../class.mjs';
import { nexNode } from './nex-node.mjs';
import { nexLog } from '../log.mjs';

export class nexSvg extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		if (obj.to instanceof nexSvg) {
			obj.tag = [ 'svg', Type.isDefined(obj.tag, 'svg') ];
			nexClass.prop([
				'opacity',
				'color'
			], obj, nexSvg);
			['fill', 'stroke'].forEach(i => {
				switch (obj.prop[i]) {
					case 'rgb':
						obj.prop[i] = nexSvg.rgb;
						break;
					case 'url':
						break;
				}
			});
		} else {
			obj.inst = nexSvg;
			obj.tag = [ 'svg', 'svg' ];
		}
		nexClass.prop([
			'size',
			'axis',
			[ 'version', [ '1.0', '1.1', '2.0' ], '2.0' ]
		], obj, nexSvg);
		super(obj);
		return this;
	}

	static get rgb() {
		return `#${Str.toUpper(Str.random(6, 'xdigit'))}`;
	}

	static get percent() {
		return `${Int.loop(Int.wholeRandom(), 0, 100)}%`;
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

	static p_axis(obj) {
		nexClass.defaults({
			'x': '0',
			'y': '0',
		}, obj);
	}

	static p_color(obj) {
		nexClass.alias({
			'fill': [ 'fill', 'f' ],
			'stroke': [ 'stroke', 's' ]
		}, {}, obj);
		nexClass.defaults({
			'fill': 'none',
			'stroke': false,
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

	collision(elm) {
		if (nexNode.IsNode(elm.element)) {
			let bbox = elm.element.getBBox();
			const coords = this.clientCoords;
			if (bbox.x + bbox.width > coords[2])
				elm.setAttr({ 'x': coords[2] - bbox.width });
			if (bbox.y + bbox.height > coords[3])
				elm.setAttr({ 'y': coords[3] - bbox.height });
			bbox = elm.element.getBBox();
			return this.nodes[elm.tag].some(el => {
				const other = el.element.getBBox();
				return (el !== elm && !(bbox.x + bbox.width < other.x || // No overlap horizontally
					 bbox.x > other.x + other.width ||
					 bbox.y + bbox.height < other.y || // No overlap vertically
					 bbox.y > other.y + other.height));
			});
		}
	}

	static nexSvgFragment(obj) {
		if (Type.isDefined(obj)) {
			if (Type.isObject(obj))
				obj = [ obj ];
			Type.isArray(obj, ',').forEach(el => {
				if (Type.isObject(el) && (Type.isDefined(el.tag) || Type.isDefined(el.svg))) {
					nexNode.Skel(el);
					switch (el.svg) {
						case 'use':
							el.tag = [ 'svg', 'use' ];
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-use');
							nexClass.defaults({
								'href': false
							}, el);
							break;
						case 'path':
							el.tag = [ 'svg', 'path' ];
							nexClass.prop([
								'path',
							], el, nexSvg);
							nexClass.defaults({
								'd': false,
							}, el);
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-path');
							break;
					}
					delete el.svg;
					if (Type.isObject(el.child))
						el.child = [ el.child ];
					if (Type.isArray(el.child))
						el.child = nexSvg.nexSvgFragment(el.child);
				}
			});
			return obj;
		}
	}

	svg(obj) {
		if (Type.isObject(obj))
			obj = [ obj ];
		Type.isArray(obj, ',').forEach(el => {
			if (Type.isObject(el))
				el = nexSvg.nexSvgFragment(el);
		});
		return this.frag(obj);
	}
}

