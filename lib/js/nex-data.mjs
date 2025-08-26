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

nxData._dfs = (from, call, leaf, depth) => {
	// index, end, top, depth, + 1000 [ index, end ]
	const flags = new Uint32Array(Number.isInteger(+depth) ? +depth * 2 + 4 : 2052);
	const path = nxObj.link(leaf ?? 'leaf').get;
	const stack = [ Array.isArray(from) ? from : [ from ] ];
	flags[1] = stack[0].length;
	flags[2] = 3;
	do {
		// for index is less than end step by 1
		for (; flags[0] < flags[1]; flags[0]++) {
			// if stack 0 (current list) flag 0 (current index) has a leaf
			call([ flags, stack ]);
			if (leaf = path(stack[0][flags[0]])) {
				// if the index isnt the last index of the current list
				if (flags[0] < flags[1]) {
					stack.push(stack[0]); // push the rest of it for later
					flags[flags[2]++] = flags[0]; // with the index
					flags[flags[2]++] = flags[1]; // and end of list
					++flags[3]; // depth increases by 1
				}
				flags[0] = -1; // new list reset index 
				stack[0] = Array.isArray(leaf) ? leaf : [ leaf ]; // normalize to a list
				flags[1] = stack[0].length; // new list, new length/end of list
			}
		}
		// if flag[0] (the active list index) is greater than 0, its not a been reset (had a leaf)
		// if flag[2] > 3 (non meta indexes) its still nested
		if (flags[0] > 0 && flags[3] > 1) {
			flags[1] = flags[--flags[2]]; // end
			flags[0] = flags[--flags[2]] + 1; // index
			stack[0] = stack.pop();
			--flags[3]; // top
		}
		// continue if nested or the popped stack list has not ended
	} while (flags[3] > 1 || flags[0] < flags[1]);
}

