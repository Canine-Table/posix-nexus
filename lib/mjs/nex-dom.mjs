import { NxSlab } from "./nex-vm.mjs";
import { nxType } from "./nex-type.mjs";


const NODE_TYPES = {
  1: 'Element',              // 1
  2: 'Attr',                 // 2
  3: 'Text',                 // 3
  4: 'CDATASection',         // 4
  5: 'EntityReference',      // 5 (obsolete)
  6: 'Entity',               // 6 (obsolete)
  7: 'ProcessingInstruction',// 7
  8: 'Comment',              // 8
  9: 'Document',             // 9
  10: 'DocumentType',         // 10
  11: 'DocumentFragment',     // 11
  12: 'Notation'              // 12 (obsolete)
};
/*

do:

    // ---------------------------------------------------------
    // 1. If depth == 0, reset to next root row
    // ---------------------------------------------------------
    if slab.i32[flags+7] == 0:
        ptr = stack[ slab.i32[flags+6] ]   // current root row

        if ptr is primitive:
            emit(ptr)
            slab.i32[flags+6]++            // rowIndex++
            slab.i32[flags+1] = 0          // rowLen = 0
            continue loop

        // ptr is non-primitive → create a new row pool
        rowPool = slab.alloc
        slab.i32[rowPool+0] = -1           // saved parent index
        slab.i32[rowPool+1] = ptr.length   // rowLen
        slab.i32[rowPool+2] = -1           // cidx
        slab.i32[rowPool+3] = 0            // parent pool
        slab.i32[rowPool+4] = 0            // next sibling
        slab.i32[rowPool+5] = slab.i32[flags+5] // rootCount

        currentPool = rowPool

    // ---------------------------------------------------------
    // 2. Iterate columns of current pool
    // ---------------------------------------------------------
    slab.i32[currentPool+2]++              // cidx++
    cidx = slab.i32[currentPool+2]

    if cidx >= slab.i32[currentPool+1]:    // cidx >= rowLen
        goto END_OF_ROW

    leaf = ptr[cidx]
    emit(leaf)

    if leaf is non-primitive:
        // DESCEND: allocate child pool
        childPool = slab.alloc

        // save current cidx into depth stack
        depthPool = slab.alloc
        slab.i32[depthPool+0] = currentPool
        slab.i32[depthPool+1] = cidx

        // update depth
        slab.i32[flags+7]++

        // initialize child pool
        slab.i32[childPool+0] = -1
        slab.i32[childPool+1] = leaf.length
        slab.i32[childPool+2] = -1
        slab.i32[childPool+3] = currentPool
        slab.i32[childPool+4] = 0
        slab.i32[childPool+5] = slab.i32[flags+5]

        currentPool = childPool
        ptr = leaf
        continue loop

    continue loop


END_OF_ROW:

    // ---------------------------------------------------------
    // 3. End of row: climb back up if depth > 0
    // ---------------------------------------------------------
    if slab.i32[flags+7] > 0:
        // pop depth frame
        depthPool = slab.peekDepth()
        parentPool = slab.i32[depthPool+0]
        savedCidx  = slab.i32[depthPool+1]

        slab.popDepth()

        slab.i32[flags+7]--       // depth--

        currentPool = parentPool
        slab.i32[currentPool+2] = savedCidx
        ptr = row represented by parentPool
        continue loop

    // ---------------------------------------------------------
    // 4. Advance to next root row
    // ---------------------------------------------------------
    slab.i32[flags+6]++           // rowIndex++

while slab.i32[flags+6] < slab.i32[flags+5]


	static Batch2(nodes) {
		const stack = nodes = Array.isArray(nodes) ? nodes : [ nodes ];
		const slab = { i32: [] };
		let i32 = slab.i32;

		i32[S_INDEX] = -1;
		i32[S_ROOT] = 0;
		i32[S_TOP] = i32[S_ROOTS] = stack.length;
		const roots = stack.length;
		i32[S_DEPTH] = 0;
		let limit = true;
		do {
			if (i32[S_DEPTH] === 0) {
				let ptr = i32[S_ROOT];
				do {
					nodes = stack[i32[S_ROOT]++];
				} while (!(Array.isArray(nodes) && nodes.length));
				const ref = i32[S_ROOT] - 1;
				if (ptr < ref) do {
					console.log(stack[ptr]);
				} while (++ptr < ref);
				i32[S_INDEX] = -1;
			if (i32[S_ROOT] >= i32[S_ROOTS])
				break
			}

			while(++i32[S_INDEX] < nodes.length) {
				const node = nodes[i32[S_INDEX]];
				if (Array.isArray(node) && node.length) {
					console.log(slab.i32[S_TOP]);
					slab.i32[S_TOP] = slab.i32[S_TOP] + 1;
					console.log(slab.i32[S_TOP]);

					if (i32[S_DEPTH]) {
						i32[i32[S_TOP]] = i32[S_ROOT];
					} else {
						i32[i32[S_TOP]] = stack.length;
						stack.push(nodes);
					}

					slab.i32[S_TOP] = slab.i32[S_TOP] + 1;

					slab.i32[slab.i32[S_TOP]] = i32[S_INDEX];
					console.log(slab.i32[S_INDEX], slab.i32[S_TOP]);
					i32 = slab.i32;
					i32[S_INDEX] = -1;
					i32[S_DEPTH] = i32[S_DEPTH] + 1;
					nodes = node;
				} else {
					console.log(node);
				}
			}

			if (i32[S_DEPTH]) {

				i32[S_INDEX] = i32[i32[S_TOP]] = i32[i32[S_TOP]] - 1;
				if (i32[S_DEPTH] < 1) {
					nodes = stack[slab.i32[slab.i32[S_TOP]]];
				} else {
					nodes = stack.pop();
					console.log(nodes, i32[S_INDEX])
					break;
				}
				i32 = slab.i32;
				i32[S_DEPTH] = i32[S_DEPTH] - 1;
			}
		} while (i32[S_ROOT] < i32[S_ROOTS]);
	}

	static Batch(nodes, pools = 128, resize = 2) {
		const slab = new NxSlab(64, 2, pools, resize);
		const stack = nodes = Array.isArray(nodes) ? nodes : [ nodes ];

		// encode initial state
		slab.i32[14] = slab.i32[9] = slab.alloc + 7;
		slab.i32[10] = -1;
		slab.i32[11] = 0;
		slab.i32[13] = stack.length;
		pools = slab.i32;

		do {
			if (!(pools[11] ^ 0)) {
				console.log('popings', nodes);
				nodes = stack[pools[12]++];
			}

			if (Array.isArray(nodes)) {
				while(++pools[10] < nodes.length) {
					const node = nodes[pools[10]];
					if (Array.isArray(node) && node.length) {
						console.log('pushing', stack.length)
						slab.i32[14] = slab.push(stack.length, slab.i32[14]);
						console.log('pushing', slab.i32[10]);
						slab.i32[14] = slab.push(slab.i32[10], slab.i32[14]);
						pools = slab.i32;
						pools[10] = -1;
						++pools[11];
						stack.push(nodes);
						nodes = node;
					} else {
						console.log(node);
					}
				}
			} else {
				console.log(nodes);
			}

			if (pools[11]) {


				resize = slab.head(slab.i32[14]);
				slab.i32[10] = slab.i32[resize];
				console.log('popping', slab.i32[resize]);
				slab.i32[14] = slab.pop(resize);

				resize = slab.head(slab.i32[14]);
				console.log('popping', slab.i32[resize]);

				nodes = stack[slab.i32[resize]];
				console.log(nodes);
				slab.i32[14] = slab.pop(resize);

				pools = slab.i32;
				pools[11]--;
			}

		} while (pools[12] <= pools[13]);
		console.log(slab.i32)
	}


*/

const S_INDEX = 10;
const S_DEPTH = 11;
const S_ROOT = 12;
const S_ROOTS = 13;
const S_TOP = 14;

export class NxDom
{
	static Route(i32, stack) {
		const node = stack[i32[S_INDEX]] ??= '';

		if (typeof node === 'object') {
		} else if (typeof node === 'function') {
		} else {
			console.log(node);
		}
	}

	static Batch2(nodes) {
		let idx, root, top, depth, i32;
		const stack = nodes = Array.isArray(nodes) ? nodes : [ nodes ];
		const slab = new NxSlab(8, 2, 128, 2);

		i32 = slab.i32;
		i32[S_INDEX] = -1;
		i32[S_ROOT] = -1;
		const roots = i32[S_ROOTS] = stack.length;
		root = idx = -1;
		top = depth = 0;

		do {
			if (depth === 0) {
				i32[S_INDEX] = root;
				do {
					nodes = stack[++root];
				} while (!(Array.isArray(nodes) && nodes.length) && root < roots);

				const last = roots - 1;
				const min = last ^ ((root ^ last) & -(root < last));

				while (++i32[S_INDEX] < min)
					this.Route(i32, stack);
				if (root >= roots)
					break;
				idx = -1;
			}

			if (Array.isArray(nodes) && nodes.length) {
				while(++idx < nodes.length) {
					const node = nodes[idx];
					if (Array.isArray(node) && node.length) {
						if (depth++) {

							stack[i32[++top] = stack.length] = nodes;
						} else {
							i32[++top] = root;
						}
						i32[++top] = idx;
					} else {
						this.Route(node);
					}
				}
			} else {
				this.Route(nodes);
			}
			if (depth) {
				do {
					idx = i32[top--];
					if (--depth < 1) {
						nodes = stack[top--];
						size = roots;
					} else {
						nodes = stack.pop();
						size = nodes.length
					}
				} while (depth && idx < size);
			}
		} while (root < roots);
	}

	static Batch(nodes) {
		const stack = nodes = Array.isArray(nodes) ? nodes : [ nodes ];
		let idx = -1;

		let root = -1;
		let depth = 0;
		let top = 0;
		const i32 = [];
		const roots = stack.length;
		let size;
		do {

			if (depth === 0) {
				idx = root;
				do {
					nodes = stack[++root];
				} while (!(Array.isArray(nodes) && nodes.length) && root < roots);
				size = root < roots ? root : roots - 1;


				const last = roots - 1;
				const min = last ^ ((root ^ last) & -(root < last));
				while (++idx < root) {
					this.Route(stack[idx]);
				}
				if (root >= roots)
					break;
				idx = -1;
			}

			if (Array.isArray(nodes) && nodes.length) {
				while(++idx < nodes.length) {
					const node = nodes[idx];
					if (Array.isArray(node) && node.length) {
						if (depth++) {
							size = i32[++top] = stack.length;
							stack[size] = nodes;
						} else {
							i32[++top] = root;
						}
						i32[++top] = idx;
					} else {
						this.Route(node);
					}
				}
			} else {
				this.Route(nodes);
			}

			if (depth) {
				do {
					idx = i32[top--];
					if (--depth < 1) {
						nodes = stack[top--];
						size = roots;
					} else {
						nodes = stack.pop();
						size = nodes.length
					}
				} while (depth && idx < size);
			}
		} while (root < roots);
	}
}

