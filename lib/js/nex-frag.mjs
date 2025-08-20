import { nxObj } from './nex-obj.mjs';
import { nxArr } from './nex-arr.mjs';
import { nxType } from './nex-type.mjs';
import { nxData } from './nex-data.mjs';
import { nxDom } from './components/nex-dom.mjs';

/*
  {
    gate: {
      tag: String(),
      pin: {
        set: String(),
        add: String(),
        swap: String(),
        omit: String()
      },
      stem: {
        twig: {}
      },
      rule: {},
      css: {},
      data: {},
      Symbol(self): {
        css: Symbol(css),
        pin: Symbol(pin),
        data: Symbol(data),
        stem: Symbol(stem),
        node: Symbol(node),
        hook: Symbol(hook)
      },
      Symbol(css): {},
      Symbol(pin): {},
      Symbol(data): {},
      Symbol(stem): {},
      Symbol(node): {},
      Symbol(hook): Weakmap(Symbol(node), {
        self: {},
        stem: {},
        leaf: {
          twig: {}
        }
      })
    },
    key: Symbol(self)
  }
*/

export function nxFrag(o)
{
	return (nxType.defined(o)) ? __nxFrag(o) : nxObj.methods(nxFrag);
}

function __nxFrag(o)
{
	const __ = { 'root': document.createDocumentFragment() };
	nxData.dfs({
		'from': o,
		'leaf': 'gate.leaf',
		'to': (o) => {
			__.stem = (__.frame = o.stack[o.flag.top - 3]?.[o.stack[o.flag.top - 1]])
				? nxDom.getHook({ 'from': __.frame, 'gate': 'node' })[1].self
				: __.root;
			if (! nxType.isObject(o.list[o.flag.index]))
				return __.stem.appendChild(nxDom.Create(`${o.list[o.flag.index]}`));
			o.list[o.flag.index] = nxDom.Frame(o.list[o.flag.index]);
			nxDom.orHook({
				'from': o.list[o.flag.index],
				'gate': 'node',
				'key': 'stem',
				'data': __.stem
			});
			nxDom.Append(o.list[o.flag.index]);
			__nxFrag.stem(o);
		}
	});
	return __.root;
}

__nxFrag.stem = o => {
	const node = [
		o.stack[o.flag.top - 3]?.[o.stack[o.flag.top - 1]],
		o.list[o.flag.index]
	];
	const hook = [
		(nxDom.getHook({ 'from': o.list[o.flag.index], 'gate': 'node' })[1] || {}),
		(nxObj.index(nxDom.Symbol(o.list[o.flag.index], 'stem')) || {}),
		(nxObj.index(nxDom.Symbol(o.list[o.flag.index], 'stem')?.twig) || {})
	];

	if (nxType.defined(node[0])) {
		hook[0].leaf = nxObj.merge({
			'from': (nxDom.getHook({
				'from': node[0],
				'gate': 'node'
			})[1]?.leaf || {}),
			'to': (hook[0]?.leaf || {})
		});
	}

	if (nxType.defined(hook[2])) { // Twig
		__nxFrag.entries({
			'from': o,
			'to': node,
			'hook': hook,
			'leaf': 'leaf.twig'
		});
	}
	hook.pop();
	if (nxType.defined(hook[1])) { // Stem
		__nxFrag.entries({
			'from': o,
			'to': node,
			'hook': hook,
			'leaf': 'leaf'
		});
	}

	__nxFrag.apply({
		'from': hook[0],
		'to': node[1],
		'depth': o.flag.depth
	});
}

__nxFrag.entries = ({ from, hook, to, leaf }) => {
	const [ list, key ] = nxObj.toPath({ 'path': leaf, 'or': 'leaf' })(hook[0]);
	const entry = list[key] ??= {};
	let __;

	Object.entries(hook[hook.length - 1]).forEach(([k, v]) => {
		__ = parseInt(k);
		const step = from.flag.depth + __;
		if (step > from.flag.depth) {
			entry[step] = nxObj.merge({ 'to': (entry?.[step] || {}), 'from': v });
		} else if (step === from.flag.depth || step === 0) { // Not sure about keeping this branch
			to.gate = nxObj.merge({ 'to': (to.gate || {}), 'from': v });
		} else if (key !== 'twig' && (__ = from.stack[step * 3 - 3]?.[from.stack[step * 3 - 1]])) {
			__nxFrag.apply({
				'from': v,
				'to': __,
				'depth': o.flag.depth
			});
		}
	});
}

__nxFrag.apply = ({ from, to, depth, chop }) => {
	const symbols = nxType.defined(to.gate.rule?.sign)
		? nxArr.getList(to.gate.rule.sign, chop)
		: [ 'data', 'css', 'pin', 'rule' ];
	from.leaf['0'] ??= {};
	if (from.leaf?.twig?.[depth]) {
		nxObj.merge({
			'from': from.leaf.twig[depth],
			'to': from.leaf[0]
		});
		delete nxObj.isEmpty(from.leaf.twig) ? from.leaf.twig : from.leaf.twig[depth];
	}
	const __ = {};
	for (const k of to.gate.rule?.lock ? [ 0, depth ] : [ depth, 0 ]) {
		if (from.leaf?.[k]) {
			nxObj.merge({
				'from': from.leaf[k],
				'to': __
			});
			if (k !== 0)
				delete nxObj.isEmpty(from.leaf) ? from.leaf : from.leaf[k];
		}
	}

	nxObj.merge({
		'to': __,
		'from': to.gate
	});

	nxArr.getList(symbols, chop).forEach(k => {
		if (__?.[k]) {
			nxObj.merge({
				'to': nxDom.Symbol(to, k),
				'from': __[k]
			});
		}
	});

	nxDom.Apply(to);
}

