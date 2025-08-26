import { nxObj } from '../nex-obj.mjs';
import { nxArr } from '../nex-arr.mjs';
import { nxType } from '../nex-type.mjs';
import { nxBit } from '../nex-bit.mjs';
import { nxStr } from '../nex-str.mjs';
import { nxFrag } from '../nex-frag.mjs';
import { nxDom } from '../components/nex-dom.mjs';
import { nxBootstrap } from './nex-bootstrap.mjs';

export function nxNavbar(o)
{
	return nxObj.methods(nxNavbar);
}

nxNavbar.frag = (o, n) => {
	const __ = n.frame.gate.bs ??= {};
	const id = nxDom[nxDom.Registry[0]]('id')();
	const node = nxDom.Symbol(n.frame, 'node')
	node.tabs ??= {};
	node.active = [ null, null ];
	node.group = id;
	node.pane = (nxDom.isNode(__?.pane) === 'Element')
		? __.pane
		: nxDom.getHook({
			'from': n.frame,
			'gate': 'node'
		})[1].stem;

	nxObj.explode({
		'from': __,
		'list': [ 'true', 'false' ]
	});

	if (__.master === 'true' && ! nxDom.isFlag('master')) {
		node.title = nxDom.Title;
		window.addEventListener('focus', () => nxDom.Title = nxDom.Registry[1].title);
		window.addEventListener('visibilitychange', () => {
			nxDom.Title = nxDom.Registry[1].title
			nxDom.Title = `${nxDom.Title} - Sleeping`;
		});
		window.addEventListener('blur', () => {
			nxDom.Title = `${nxDom.Title} - Exploring`;
		});

		window.addEventListener('hashchange', () => {
			if (nxType.defined(nxDom.Hash)) {
				const hash = nxStr.camelCase(nxStr.lastChar(nxDom.Hash, '#'));
				if (nxType.isElement(node.tabs[hash]?.[0])) {
					node.tabs[hash]?.[0].click();
				}
			}
		});
		nxDom.onFlag = 'master';
		n.frame.gate[nxDom.Registry[0]] = nxBit.on(n.frame.gate[nxDom.Registry[0]], nxDom.mapFlag('master'));
	}

	__.list = nxArr.isIn({
		'find': __?.list,
		'from': [ 'ul', 'ol' ]
	}) ? __.list : 'ul';
	__.offcanvas = nxArr.isIn({
		'from': [ 'end', 'start' ],
		'find': __.offcanvas
	}) ? __.offcanvas : undefined;

	if (nxType.defined(__.offcanvas)) {
		__.toggle = 'offcanvas';
	} else {
		__.toggle = nxArr.isIn({
			'find': __?.toggle,
			'from': [ 'offcanvas', 'collapse' ]
		})
		? __.toggle
		: 'collapse';
	}
	if (__.toggle === 'offcanvas') {
		__.h = nxDom.H(__);
		__.title = __?.[__.h] || '';
		__.backdrop = nxArr.isIn({
			'find': __.backdrop,
			'from': [ 'true', 'false', 'static' ]
		}) ? __.backdrop : 'true';
	}
	__.expand = nxBootstrap.size(__.expand);
	__.items = [];
	const master = nxBit.is(n.frame.gate[nxDom.Registry[0]], nxDom.mapFlag('master'));
	nxArr.wrap(n.frame.gate.leaf).forEach(i => {
		if (i.tag === 'li') {
			__.items.push(nxObj.merge({
				'from': i,
				'to': {
					'pin': {
						'set': 'nav-item'
					},
					'stem': {
						'1': {
							'pin': {
								'set': `nav-link ${id}`
							},
							'emit': (o) => {
								_nxNavbar.switch(n.frame, node, o, master);
							}
						}
					}
				}
			}));
		} else {
			i.tag = nxArr.isIn({
				'find': i.tag,
				'from': [ 'a', 'button' ]
			}) ? i.tag : 'a';
			__.items.push({
				'tag': 'li',
				'pin': {
					'set': 'nav-item'
				},
				'stem': {
					'1': {
						'pin': {
							'set': `nav-link ${id}`
						},
						'emit': (o) => {
							_nxNavbar.switch(n.frame, node, o, master);
						}
					}
				},
				'leaf': i
			});
		}
	});

	n.frame.gate.leaf = {
		'tag': 'div',
		'stem': {
			'-1': {
				'pin': {
					'add': `navbar navbar-expand-${__.expand}`
				},
				'data': {
					'role': 'navigation'
				}
			}
		},
		'pin': {
			'set' : 'container-fluid d-flex'
		},
		'leaf': [
			(__?.brand) ? nxObj.merge({
				'from': {
					'tag': 'a',
					'pin': {
						'set': 'navbar-brand'
					},
					'emit': (o) => {
						_nxNavbar.switch(n.frame, node, o, master);
					}
				},
				'to': __.brand
			}) : {},
			{
				'tag': 'button',
				'pin': {
					'set': 'navbar-toggler'
				},
				'data': {
					'aria-controls': id,
					'data-bs-target': `#${id}`,
					'type': 'button',
					'data-bs-toggle': __.toggle,
					'aria-expanded': false,
					'aria-label': 'Toggle navigation'
				},
				'leaf': {
					'tag': 'span',
					'pin': {
						'set': 'navbar-toggler-icon'
					}
				}
			},
			{
				'tag': 'div',
				'id': id,
				... (__.toggle === 'collapse') ? {
					'pin': { 'set': 'collapse navbar-collapse' },
					'leaf': {
						'tag': __.list,
						'pin': {
							'set': `navbar-nav d-${__.expand}-flex d-block`
						},
						'leaf': __.items
					}
				} : {
					'pin': { 'set': `offcanvas offcanvas-${__.offcanvas ?? 'end'}` },
					'data': {
						'tabindex': '-1',
						'aria-labelledby': `${id}-Label`,
						'data-bs-scroll': __.scroll === true,
						'data-bs-backdrop': __.backdrop
					},
					'leaf': [
						{
							'tag': 'div',
							'pin': {
								'add': 'offcanvas-header'
							},
							'leaf': [
								{
									'tag': __.h,
									'pin': {
										'set': `offcanvas-title ${__.h}`
									},
									'text': __.title,
									'id': `${id}-Label`
								},
								{
									'tag': 'button',
									'pin': {
										'set': 'btn-close'
									},
									'data': {
										'data-bs-dismiss': __.toggle,
										'aria-label': 'Close',
										'type': 'button'
									},
									'emit': (o) => {
										node.close = o.self
									}
								}
							]
						},
						{
							'tag': 'div',
							'pin': {
								'set': 'offcanvas-body'
							},
							'leaf': [
								__?.body || '',
								{
									'tag': __.list,
									'pin': {
										'set': `navbar-nav d-${__.expand}-flex d-block`
									},
									'leaf': __.items
								}
							]
						}
					]
				}
			}
		]
	}
}

function _nxNavbar() {
	return nxObj.methods(_nxNavbar);
}

_nxNavbar.switch = (frame, node, from, master) => {

	const hash = nxStr.camelCase(frame.gate?.rule?.name ?? nxDom.Value(from.self));

	nxDom.Data({
		'self': from.self,
		'from': { 'href': `#${hash}` }
	});

	const pane = nxFrag({
		'tag': 'div',
		'id': `${node.group}-${hash}`,
		'pin': {
			'set': `container-fluid py-3 ${node.active[0] ? 'd-none' : 'd-flex'}`
		}
	});

	node.pane.appendChild(pane);

	nxDom.Data({
		'from': {
			'href': `#${hash}`,
		},
		'self': from.self
	});

	node.tabs[hash] = [from.self]

	if (! nxType.defined(node.active[0]))
		node.active = node.tabs[hash];

	from.self.addEventListener('click', () => {
		if (node.active[0]) {
			nxDom.Pin({
				'self': node.active[0],
				'from': { 'omit': 'active' }
			});
			if (node.active.length === 1)
				node.active[1] = nxDom.ById(`${node.group}-${nxStr.camelCase(nxDom.Value(node.active[0]))}`);
			nxDom.Pin({
				'self': node.active[1],
				'from': { 'swap': { 'd-flex': 'd-none' }}
			});
		}
		nxDom.Pin({
			'self': from.self,
			'from': { 'add': 'active' }
		});
		if (! nxType.defined(node.tabs[hash][1])) {
			node.tabs[hash][1] = nxDom.ById(`${node.group}-${hash}`);
			if (master)
				nxDom.Registry[1].tabs[hash] = node.tabs[hash];
		}

		nxDom.Pin({
			'self': node.tabs[hash][1],
			'from': { 'swap': { 'd-none': 'd-flex' }}
		});
		node.active = [from.self, node.tabs[hash][1]];
		if (master)
			nxDom.Title = `${node.title} - ${nxDom.Value(from.self)}`
		if (nxDom.isNode(node.close) === 'Element')
			node.close.click();
	});

	from.self.click();
}

