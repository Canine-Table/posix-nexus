import { Type } from '../../type.mjs';
import { Obj } from '../../obj.mjs';
import { Arr } from '../../arr.mjs';
import { Str } from '../../str.mjs';
import { Int } from '../../int.mjs';
import { nexEvent } from '../../event.mjs';
import { nexClass } from '../../class.mjs';
import { nexNode } from '../nex-node.mjs'
import { nexSvg } from '../nex-svg.mjs'

export class nexSvgDefs extends nexSvg
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexSvgDefs;
		nexClass.expand(obj, { false: [ 'axis', 'size' ] });
		if (obj.to instanceof nexSvgDefs) {
			obj.tag = Type.isDefined(obj.tag, 'defs');
			return super(obj);
		} else {
			obj.tag = 'svg';
			return super(obj).#defs();
		}
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

	static p_gradient(obj) {
		if (obj.coords === 'rand') {
			obj.tag = nexSvgDefs.#gradient;
			obj.prop.spreadMethod = nexSvgDefs.#spreadMethod;
			if (obj.tag === 'linearGradient') {
				obj.x = [ nexSvg.percent, nexSvg.percent ];
				obj.y = [ nexSvg.percent, nexSvg.percent ];
			} else {
				obj['focal'] = {
					'fx': nexSvg.percent,
					'fy': nexSvg.percent
				}
				obj['circle'] = {
					'r': '300%',
					'cx': nexSvg.percent,
					'cy': nexSvg.percent
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
			], obj, nexSvgDefs);
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
						'stop-color': nexSvg.rgb
					}
				});
				p += inc;
			}
		} else if (Type.isArray(obj)) {
			obj.forEach(i => {
				if (Type.isObject(i)) {
					new nexSvgDefs({
						'tag': 'stop',
						'to': this,
						'prop': i
					});
				}
			})
		}
		return this;
	}

	#defs(obj = {}) {
		nexNode.Skel(obj);
		obj.tag = 'defs';
		obj.to = this;
		return new nexSvgDefs(obj);
	}

	symbol(obj) {
		nexNode.Skel(obj);
		obj.tag = 'symbol';
		obj.to = this;
		nexClass.defaults({
			'viewBox': '0 0 16 16'
		}, obj);
		return new nexSvgDefs(obj);
	}

	marker(obj) {
		nexNode.Skel(obj);
		obj.tag = 'marker';
		nexSvgDefs.p_marker(obj);
		return new nexSvgDefs(obj);
	}

	linearGradient(obj) {
		nexNode.Skel(obj);
		obj.to = this;
		obj.tag = 'linearGradient';
		nexSvgDefs.p_gradient(obj);
		const node = new nexSvgDefs(obj);
		if (Type.isDefined(obj.stop))
			node.#m_stop(obj.stop);
		return node;
	}

	linearGradient(obj) {
		nexNode.Skel(obj);
		obj.to = this;
		obj = Dom.skel(obj);
		obj.tag = 'radialGradient';
		nexSvgDefs.p_gradient(obj);
		const node = new nexSvgDefs(obj);
		if (Type.isDefined(obj.stop))
			node.#m_stop(obj.stop);
		return node;
	}

	static nexSvgDefsFragment(obj) {
		if (Type.isDefined(obj)) {
			if (Type.isObject(obj))
				obj = [ obj ];
			Type.isArray(obj, ',').forEach(el => {
				if (Type.isObject(el) && (Type.isDefined(el.tag) || Type.isDefined(el.svg))) {
					nexNode.Skel(el);
					switch (el.svg) {
						case 'linearGradient':
							el.tag = [ 'svg', 'linearGradient' ];
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-linearGradient');
							nexSvgDefs.p_gradient(el);
							break;
						case 'radialGradient':
							el.tag = [ 'svg', 'radialGradient' ];
							nexSvgDefs.p_gradient(el);
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-radialGradient');
							break;
						case 'symbol':
							el.tag = [ 'svg', 'symbol' ];
							nexClass.defaults({
								'viewBox': '0 0 16 16'
							}, el);
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-symbol');
							break;
						case 'marker':
							el.tag = [ 'svg', 'marker' ];
							nexSvgDefs.p_marker(obj);
							el.cls.add = Str.merge(el.cls.add, 'nex-svg-marker');
							break;
						default:
							el = nexSvg.nexSvgFragment(el);
							break;
					}
					delete el.svg;
					if (Type.isObject(el.child))
						el.child = [ el.child ];
					if (Type.isArray(el.child))
						el.child = nexSvgDefs.nexSvgDefsFragment(el.child);
				}
			});
			return obj;
		}
	}

	defs(obj) {
		if (Type.isObject(obj))
			obj = [ obj ];
		Type.isArray(obj, ',').forEach(el => {
			if (Type.isObject(el))
				el = nexSvgDefs.nexSvgDefsFragment(el);
		});
		return this.frag(obj);
	}
}

