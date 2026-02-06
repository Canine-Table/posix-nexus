import { nxObj } from './nex-obj.mjs';
import { nxBit32 } from './nex-bit32.mjs';

export function nxData()
{
	nxObj.methods(nxData);
}

nxData.dfs = (fm, cb, lf, dp) => {
	return nxBit32.next(321);
}

/*
nxData.dfs = (fm, cb, lf, dp) => {
	// index, end, top, depth, + 1000 [ index, end ]
	const flags = new Uint32Array(Number.isInteger(+depth) ? +depth * 2 + 4 : 2052);
	const path = nxObj.link(leaf ?? 'leaf').get;
	const stack = [ Array.isArray(from) ? from : [ from ] ];
	flags[1] = stack[0].length - 1;
	flags[2] = 4;
	do {
		// for index is less than end step by 1
		for (; flags[0] <= flags[1]; flags[0]++) {
			// if stack 0 (current list) flag 0 (current index) has a leaf
			call([ flags, stack ]);
			if (leaf = path(stack[0][flags[0]])) {
				flags[flags[2]++] = flags[0]; // with the index
				flags[flags[2]++] = flags[1]; // and end of list
				stack.push(stack[0]); // push the rest of it for later
				++flags[3]; // depth increases by 1
				flags[0] = -1; // new list reset index
				stack[0] = Array.isArray(leaf) ? leaf : [ leaf ]; // normalize to a list
				flags[1] = stack[0].length - 1; // new list, new length/end of list
			}
		}
		// if flag[0] (the active list index) is greater than 0, its not a been reset (had a leaf)
		// if flag[2] > 3 (non meta indexes) its still nested
		if (flags[0] > 0 && flags[3] > 1) {
			do {
				flags[1] = flags[--flags[2]]; // end
				flags[0] = flags[--flags[2]]; // index
				stack[0] = stack.pop();
			} while (--flags[3] >= 1 && flags[0] >= flags[1]);
		}
		// continue if nested or the popped stack list has not ended
	} while (flags[3] > 1 || flags[0] < flags[1]);
}
*/
