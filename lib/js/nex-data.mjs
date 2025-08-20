import { nxObj } from './nex-obj.mjs';
import { nxArr } from './nex-arr.mjs';
import { nxType } from './nex-type.mjs';

export function nxData()
{
	return nxObj.methods(nxData);
}

nxData.dfs = ({ from, leaf, to }) => {
	const __ = {
		'list': nxArr.wrap(from),
		'stack': []
	};
	__.path = nxObj.path({ 'path': leaf, 'or': 'leaf' });
	__.flag = {
		'index': 0,
		'top': 0,
		'depth': 0,
		'end': __.list.length
	};
	do {
		for (; __.flag.index < __.flag.end; ++__.flag.index) {
			to(__);
			if (__.leaf = __.path(__.list[__.flag.index])) {
				if (__.flag.index < __.flag.end) {
					__.stack.push(__.list, __.flag.end, __.flag.index);
					__.flag.top += 3;
					++__.flag.depth;
				}
				__.list = nxArr.wrap(__.leaf);
				__.flag.end = __.list.length;
				__.flag.index = -1;
			}
		}
		if (__.flag.index > 0 && __.flag.top > 0) {
			__.flag.index = __.stack.pop() + 1;
			__.flag.end = __.stack.pop();
			__.list = __.stack.pop();
			__.flag.top -= 3;
			--__.flag.depth;
		}
	} while (__.flag.top > 0 || __.flag.index < __.flag.end);
}

