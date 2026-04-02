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
*/

const S_POINTER = 10;
const S_LINKER = 11;
const S_INDEX = 12;
const S_DEPTH = 13;
const S_CURSOR = 14;
const S_ROOT = 15;

export class NxDom
{
	static Batch(nodes, pools = 128, resize = 2) {
		const slab = new NxSlab(64, 2, pools, resize);
		const stack = Array.isArray(nodes) ? nodes : [ nodes ];

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
}

