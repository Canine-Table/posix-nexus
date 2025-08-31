import { nxObj } from './nex-obj.mjs';
import { nxArr } from './nex-arr.mjs';
import { nxType } from './nex-type.mjs';

export function nxData()
{
	return nxObj.methods(nxData);
}

nxData.dfs = (from, call, leaf, depth) => {
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


/*

// Breadth-first search mirroring your DFS ergonomics, but BFS-optimized:
// - Power-of-two ring buffer with bitmask wrap
// - Uint32Array(3) control block: [head, tail, depth]
// - No shift()/modulo; zero per-iteration allocations
// - `call` receives the same shape: [flagsCompat, stackCompat]
//   where stackCompat[0][flagsCompat[0]] === current node

nxData._bfs = (from, call, leaf, capHint = 1024, noGrow = false) => {
	// children accessor
	const path = nxObj.link(leaf ?? 'leaf').get;

	// control: [head, tail, depth]
	const ctl = new Uint32Array(3); // head=0, tail=0, depth=1 (we'll set below)
	ctl[2] = 1;

	// flags compat for `call([flags, stack])`
	// [index, end, top, depth] — we only use [0,1,3] here to emulate DFS contract
	const flags = new Uint32Array(4);
	flags[2] = 3;

	// single-element, reused "list" to preserve stack[0][flags[0]] access
	const stack = [ [ null ] ];

	// compute initial power-of-two capacity >= capHint
	let cap = 8;
	if ((capHint|0) > 0) {
		let need = capHint >>> 0;
		// next power of two
		need--;
		need |= need >>> 1;
		need |= need >>> 2;
		need |= need >>> 4;
		need |= need >>> 8;
		need |= need >>> 16;
		cap = (need + 1) >>> 0;
		if (cap < 8) cap = 8;
	}
	let mask = cap - 1;

	// ring buffer for nodes (objects), must be a regular array
	let q = new Array(cap);

	// seed queue with normalized start
	const seed = Array.isArray(from) ? from : [ from ];
	let lvlLeft = 0, nextLeft = 0;

	for (let i = 0; i < seed.length; i++) {
		// ensure capacity
		if (((ctl[1] - ctl[0]) >>> 0) === cap) {
			if (noGrow) throw new Error('BFS queue overflow');
			// grow ring buffer
			const newCap = cap << 1, newMask = newCap - 1, nq = new Array(newCap);
			for (let k = 0; k < cap; k++) nq[k] = q[(ctl[0] + k) & mask];
			q = nq; cap = newCap; mask = newMask; ctl[1] = (ctl[1] - ctl[0]) >>> 0; ctl[0] = 0;
		}
		q[ctl[1] & mask] = seed[i];
		ctl[1] = (ctl[1] + 1) >>> 0;
		lvlLeft++;
	}

	// BFS loop
	while (ctl[0] !== ctl[1]) {
		const node = q[ctl[0] & mask];
		ctl[0] = (ctl[0] + 1) >>> 0;

		// call compatibility: pretend "current list" holds only this node
		stack[0][0] = node;
		flags[0] = 0; // index
		flags[1] = 0; // end
		flags[3] = ctl[2]; // depth
		call([ flags, stack ]);

		// expand children
		const kids = path(node);
		if (kids != null) {
			if (Array.isArray(kids)) {
				const n = kids.length >>> 0;
				// ensure capacity (bulk)
				while ((((ctl[1] - ctl[0]) >>> 0) + n) > cap) {
					if (noGrow) throw new Error('BFS queue overflow');
					const newCap = cap << 1, newMask = newCap - 1, nq = new Array(newCap);
					for (let k = 0; k < cap; k++) nq[k] = q[(ctl[0] + k) & mask];
					q = nq; cap = newCap; mask = newMask; ctl[1] = (ctl[1] - ctl[0]) >>> 0; ctl[0] = 0;
				}
				for (let j = 0; j < n; j++) {
					q[ctl[1] & mask] = kids[j];
					ctl[1] = (ctl[1] + 1) >>> 0;
				}
				nextLeft += n;
			} else {
				// ensure capacity (single)
				if (((ctl[1] - ctl[0]) >>> 0) === cap) {
					if (noGrow) throw new Error('BFS queue overflow');
					const newCap = cap << 1, newMask = newCap - 1, nq = new Array(newCap);
					for (let k = 0; k < cap; k++) nq[k] = q[(ctl[0] + k) & mask];
					q = nq; cap = newCap; mask = newMask; ctl[1] = (ctl[1] - ctl[0]) >>> 0; ctl[0] = 0;
				}
				q[ctl[1] & mask] = kids;
				ctl[1] = (ctl[1] + 1) >>> 0;
				nextLeft++;
			}
		}

		// end of current level
		if ((--lvlLeft) === 0) {
			ctl[2]++; // depth++
			lvlLeft = nextLeft;
			nextLeft = 0;
		}
	}
};
*/
