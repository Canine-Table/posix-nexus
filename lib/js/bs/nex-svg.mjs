import { nxArr } from '../nex-arr.mjs';
import { nxObj } from '../nex-obj.mjs';
import { nxType } from '../nex-type.mjs';
import { nxStr } from '../nex-str.mjs';
import { nxBit } from '../nex-bit.mjs';
import { nxDom } from '../components/nex-dom.mjs';

export function nxSvg()
{
	return nxObj.methods(nxType);
}

nxSvg.frag = (o, n) => {
	n.frame.gate.path = 'svg';
	const __ = Object.freeze({
		'svg': (o, n) => nxSvg.svg(o, n),
		'symbol': (o, n) => nxSvg.symbol(o, n),
		'use': (o, n) => nxSvg.use(o, n),
		'path': (o, n) => nxSvg.path(o, n)
	})[n.frame.gate.tag]
	if (nxType.isFunction(__))
		__(o, n);
}

nxSvg.svg = (o, n) => {
	let defaults = {};
	if (n.frame.gate?.rule?.load) {
		defaults = {
			'fill': 'currentColor',
			... Object.freeze({
				'icon': {
					'height': '16pt',
					'width': '16pt',
					'viewBox': '0 0 16 16'
				}
			})?.[n.frame.gate.rule.load]
		}
	}
	nxObj.merge({
		'to': nxDom.getHook({
			'gate': 'node',
			'from': n.frame
		})[1],
		'from': {
			'leaf': {
				'0': {
					'rule': {
						'namespace': 'svg'
					}
				}
			}
		}
	});
	nxObj.merge({
		'to': n.frame.gate,
		'from': {
			'data': {
				'version': nxArr.isIn({
					'find': n.frame?.data?.version,
					'from': [ '1.0', '1.1', '2.0' ]
				}) ? n.frame?.data?.version : '2.0',
				'xmlns': nxDom.Path('svg'),
				defaults
			}
		}
	});
}


nxSvg.symbol = (o, n) => {
	n.frame.gate = nxObj.merge({
		'to': n.frame.gate,
		'from': {
			'data': {
				'viewBox': '0 0 24 24',
				'width': '100%',
				'height': '100%',
				'x': '0',
				'y': '0'
			}
		}
	});
}


nxSvg.use = (o, n) => {
	n.frame.gate = nxObj.merge({
		'to': n.frame.gate,
		'from': {
			'data': {
				'href': `#${n.frame.gate.id}`
			}
		}
	});
	delete n.frame.gate.id;
}

nxSvg.path = (o, n) => {
	n.frame.gate = nxObj.merge({
		'to': n.frame.gate,
		'from': {
			'data': {
				'fill-rule': nxArr.isIn({
					'find': n.frame.gate['fill-rule'],
					'from': [ 'nonzero', 'evenodd' ]
				}) ? n.frame.gate['fill-rule'] : 'nonzero',
				'd': n.frame.gate.d
			}
		}
	});
}
