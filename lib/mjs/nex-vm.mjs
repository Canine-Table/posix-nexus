import { nxBit32 } from "./nex-bit32.mjs"

/*
 https://people.csail.mit.edu/shanir/publications/Lock_Free.pdf

1. Parentheses / grouping
(...)

2. Member access / function call
obj.prop obj[index] func(...) new X(...)

3. Unary operators
!	~ + (unary) - (unary) typeof void delete

4. Exponentiation
**

5. Multiplicative
* / %

6. Additive
+ -

7. Bitwise shift
<< >> >>>

8. Relational
< <= > >= in

instanceof

9. Equality
== != === !==

10. Bitwise AND
&

11. Bitwise XOR
^

12. Bitwise OR
|

13. Logical AND
&&

14. Logical OR
||

15. Nullish coalescing
??

16. Conditional (ternary)
cond ? a : b

17. Assignment
= += -= *= /= &= |= ^= <<= >>= >>>= ??= ||= &&=


18. Comma operator
a, b


*/


// --- Stack / Header Indexes ---
const S_BLOCK	= 0;	 // block size (aligned)
const S_HEADER = 1;	 // header size (aligned)
const S_SIZE	 = 2;	 // total buffer size
const S_RESIZE = 3;	 // resize multiplier
const S_TOP	= 4;	 // top-most allocated slab index
const S_FREED	= 5;	 // free-list head
const S_FLAGS	= 6;	 // VM flags bitfield
const S_START	= 7;	 // the holder of the start of pools

// --- Current Offsets ---
const C_STARTING_TOP = 8;

export class NxSlab
{
	static LT256 = new Int8Array([
		-1, 0, 1, 1, 2, 2, 2, 2,
		 3, 3, 3, 3, 3, 3, 3, 3,

		// LT(4)
		4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,

		// LT(5)
		5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,

		// LT(5) again
		5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,

		// LT(6)
		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,

		// LT(6) again
		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,

		// LT(7)
		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,

		// LT(7) again
		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	]);

	constructor(
		block = 4,
		header = 2,
		size = 32,
		resize = 2,
		debug = 0,
		dir = 0,
		force = 1,
		conflict = 0,
		shared = 0
	) {
		const S = this.S = new ArrayBuffer(32);
		const I32 = this.I32 = new Int32Array(S);
		this.F32 = new Float32Array(S);
		const U8 = this.U8 = new Uint8Array(S);

		block = nxBit32.bump(block);
		header = nxBit32.bump(header);
		size = nxBit32.bump(size);
		this.modifier(
			0,
			dir &= 1,
			debug &= 1,
			force &= 1,
			conflict &= 1,
			shared &= 1
		);

		if (block < 4) {
			block = 4;
			header = 2;
		} else if (header >= block) {
			header = block >>> 1;
		}

		// Enforce minimum block size
		/*if (I32[0] < 4) {
			I32[0] = 4;
			I32[1] = 2;
		} else if (I32[1] >= I32[0]) {
			I32[1] = I32[0] >>> 1;
		}*/


		// Ensure size >= block
		if (size < block)
			size = block


		// log2(block)
		const block2  = nxBit32.log2(block);
		const size2 = nxBit32.log2(Int32Array.prototype.BYTES_PER_ELEMENT);
		const start2 = nxBit32.log2(C_STARTING_TOP);
		let start = ((C_STARTING_TOP >> block2) << block2 || block) + block;
		start = size > start ? start - block : nxBit32.bump(start);
		size -= size & (block - 1);

		// Allocate backing buffer
		const B = this.B = shared
			? new SharedArrayBuffer(size << size2)
			: new ArrayBuffer(size << size2);

		// Stack views
		const i32 = this.i32 = new Int32Array(B);
		const f32 = this.f32 = new Float32Array(B);
		const u8 = this.u8 = new Uint8Array(B);

		i32[0] = block;
		i32[1] = header;
		i32[2] = size;
		f32[3] = resize > 1.0 ? resize : 2.0;
		i32[4] = start - block;
		u8[24] = block2;
		u8[25] = size2;
		u8[26] = start2;
		i32[7] = start;
	}

	resizeFactor(flt) {
		const I32 = this.I32;
		this.F32[5] = flt;
		const num = I32[5];

		const cnta = num >> 23;
		if (cnta)
			return I32[5] = cnta - 127;

		// subnormal, so recompute using mantissa: c = intlog2(x) - 149;
		const cntb = num >> 16;
		if (cntb)
			return I32[5] = NxSlab.LT256[cntb] - 133;

		const cntc = num >> 8;
		return I32[5] = cntc
			? NxSlab.LT256[cntc] - 141
			: NxSlab.LT256[num] - 149;
	}

	resize() {
		const u8 = this.u8;
		const i32 = this.i32;
		const I32 = this.I32;
		const rz = this.f32[S_RESIZE] * i32[S_SIZE];
		const res = rz - (rz & (u8[24] - 1));

		const nBuf = this.U8[6] & 16
			? new SharedArrayBuffer(res << u8[25])
			: new ArrayBuffer(res << u8[25]);
		const nu8 = new Uint8Array(nBuf);
		nu8.set(u8);

		this.f32 = new Float32Array(nBuf);
		const ni32 = this.i32 = new Int32Array(nBuf);
		this.u8 = nu8;
		ni32[S_SIZE] = res;
	}

	range(ptr = 0) {
		const i32 = this.i32;
		return ptr - i32[7] >>> 0 < i32[2] - i32[7] >>> 0;
	}

	ret(ptr = 0) {
		const i32 = this.i32;
		return ptr & (i32[S_BLOCK] - 1) & -(ptr > i32[S_START] | 0);
	}

	reuse(ptr = 0) {
		if (ptr !== 0) {
			const I32 = this.I32;
			const ret = this.ret(ptr);
			const res = ptr - ret;
			I32[2] = this.i32[res + 1];
			I32[3] = ret;
			I32[4] = res;
		}
	}

	reusePrev(ptr = 0) {
		if (ptr !== 0) {
			const I32 = this.I32;
			const i32 = this.i32;
			if (ptr < i32[S_START])
				return -1;
			const ret = this.ret(ptr);
			const res = ptr - ret;
			I32[2] = i32[res + 1] - 1;
			I32[3] = ret;
			return I32[4] = res;
		}
	}

	get consoleHead() {
		const U8 = this.U8;
		const I32 = this.I32;
		console.log(
			'\nbit 0: IS_NEG', U8[5] & 1,
			'\nbit 1: IS_ALIGNED', U8[5] & 2,
			'\nbit 2: IS_FULL = NEG && !ALIGNED', U8[5] & 4,
			'\nbit 3: IS_FREED = NEG && ALIGNED', U8[5] & 8,
			'\nbit 4: IS_EMPTY = !NEG && ALIGNED', U8[5] & 16,
			'\nbit 5: IS_NORMAL = !NEG && !ALIGNED', U8[5] & 32,
			'\nbit 6: IS_BOUNDARY' , U8[5] & 64
		);
	}

	classifyHead(ptr = 0) {
		this.reuse(ptr);
		const U8 = this.U8;
		const I32 = this.I32;
		const i32 = this.i32;
		let rptr = I32[2];
		let bits = 0;

		// bit 6: IS_BOUNDARY
		let bound = 64;
		const blk = i32[S_BLOCK] - 1;

		if (rptr < 0) {
			bits |= 1;
			rptr = I32[2] = -rptr;
			bound = 0;
		}

		// bit 1: IS_ALIGNED
		// bit 6: IS_BOUNDARY
		if ((rptr & blk) === 0)
			bits |= 2 | bound;
		// bit 2: IS_FULL = NEG && !ALIGNED
		// bit 3: IS_FREED = NEG && ALIGNED
		if (bits & 1)
			bits |= bits & 2 ? 8 : 4;
		// bit 4: IS_EMPTY = !NEG && ALIGNED
		// bit 5: IS_NORMAL = !NEG && !ALIGNED
		else
			bits |= bits & 2 ? 16 : 32;
		U8[5] = bits;
	}

	alloc() {
		let i32 = this.i32;
		const I32 = this.I32;
		const freed = i32[S_FREED];
		let ptr;

		if (freed === 0) {
			i32[S_TOP] += i32[S_BLOCK];
			ptr = i32[S_TOP];
		} else {
			ptr = freed;
			i32[S_FREED] = -i32[ptr + 1]; // next free
			i32[ptr] = 0; // next free
		}

		if (i32[S_TOP] >= i32[S_SIZE]) {
			this.resize();
			i32 = this.i32;
			I32[7] = 1;
		}

		i32[ptr + 1] = ptr + i32[S_HEADER];
		return I32[3] = ptr;
	}



	/*
	push2(
		data,
		ptr = 0
	) {

		// head
		this.classifyHead(ptr);
		const U8 = this.U8;
		const flgs = U8[5];

		// FREED caller broke the contract, slab does not care
		if (flgs & 8)
			return ptr;

		const I32 = this.I32;
		let i32 = this.i32;
		const hd = I32[2];
		let ret = I32[3];
		let res = I32[4];
		let rptr;

		if (flgs & 64 || flgs & 4) {
			if (U8[6] ^ 4)
				return ptr;

			if (flgs & 4) {
				rptr = -hd; //i32[I32[4] + 1];
				//I32[3] = -i32[I32[4] + 1];
				//i32[I32[3]] = data;
				i32[rptr] = data;
			} else {
				res -= i32[S_BLOCK];
			}

			rptr = this.alloc();
			if (I32[7] === 1) {
				I32[7] = 2;
				i32 = this.i32;
			}

			// we dont want an inf link loop
			//if (I32[3] > i32[S_START]) {
			if (rptr > i32[S_START]) {
				// link the past and now together
				//i32[I32[3]] = I32[4];
				i32[rptr] = res;
				//i32[I32[4] + 1] = I32[3];
				i32[res + 1] = rptr; //I32[3];
			} else {
				// the now is now the pass us /dev/null, 0, null, nil, Null, NULL whatever you perfer to call it
				//i32[I32[3]] = 0;
				i32[rptr] = 0;
			}

			//I32[4] = i32[I32[3] + 1];
			res = i32[rptr + 1];
11
			if (flgs & 64) {

				//i32[I32[4]] = data;
				//i32[I32[3] + 1] = ++I32[4];
				i32[res] = data;
				i32[rptr + 1] = ++res;
			}
			// update the test for the next iteration
			return I32[4] = res;
		}

		//I32[3] = i32[I32[4] + 1];
		rptr = hd;
		//i32[I32[3]] = data;
		i32[rptr] = data;
		
		//i32[I32[4] + 1] = ++I32[3];
		return I32[3] = i32[res + 1] = ++ptr;
		//return I32[3];
	}*/

	push(
		data,
		ptr = 0
	) {

		// head
		this.classifyHead(ptr);
		const U8 = this.U8;
		const flgs = U8[5];

		// FREED caller broke the contract, slab does not care
		if (flgs & 8)
			return ptr;

		const I32 = this.I32;
		let i32 = this.i32;


		if (flgs & 64 || flgs & 4) {
			if (U8[6] ^ 4)
				return ptr;

			if (flgs & 4) {
				I32[3] = -i32[I32[4] + 1];
				i32[I32[3]] = data;
			} else {
				I32[4] -= i32[S_BLOCK];
			}

			this.alloc();
			if (I32[7] === 1) {
				I32[7] = 2;
				i32 = this.i32;
			}

			// we dont want an inf link loop
			if (I32[3] > i32[S_START]) {
				// link the past and now together
				i32[I32[3]] = I32[4];
				//i32[I32[4] + 1] = I32[3];
			} else {
				// the now is now the pass us /dev/null, 0, null, nil, Null, NULL whatever you perfer to call it
				i32[I32[3]] = 0;
			}

			I32[4] = i32[I32[3] + 1];
			if (flgs & 64) {
				i32[I32[4]] = data;
				i32[I32[3] + 1] = ++I32[4];
			}
			// update the test for the next iteration
			return I32[4];
		}

		I32[3] = i32[I32[4] + 1];
		i32[I32[3]] = data;
		i32[I32[4] + 1] = ++I32[3];
		return I32[3];
	}

	head(ptr = 0) {
		const i32 = this.i32;
		const I32 = this.I32;

		// 1. normalize ptr to a pool head
		this.reusePrev(ptr);
		const blk = i32[S_BLOCK] - 1;
		let head = I32[4]; // base of current pool

		// 2. walk forward along the live chain
		while (true) {
			const link = i32[head + 1];
			// freelist or no link -> stop
			// must be block-aligned and in range to be a valid pool base
			if (link & blk ^ 0 || link <= 0 || !this.range(link))
				break;
			head = link;
		}

		// 3. compute topmost index of that last pool
		// here "topmost" is the pool's write cursor - 1
		head = (i32[head + 1] > 0 ? i32[head + 1] : head) - 1;
		return head;
	}

	top(ptr = 0) {
		const i32 = this.i32;
		const I32 = this.I32;

		this.reuse(ptr);

		const blk = i32[S_BLOCK] - 1;

		let val = i32[I32[4] + 1];
		if (val & blk ^ 0) {
			val = i32[val] // i32[i32[I32[4]] + 1]];
		}

		console.log(val)
		let head = I32[4]; // base of current pool

			//, i32[head + 1]);

		//console.log(head, i32[i32[head + 1]], i32[head + 1]);


		return head;
		/*const start  = i32[S_START];
		const top    = i32[S_TOP];
		const freed  = i32[S_FREED];
		do {
			const link = i32[head + 1];

		}*/
/*
		// 1. Prefer free list
		if (freed > 0) {
		// freed is a block base index, not a header index
		return freed;
		}

		// 2. Otherwise, next fresh block
		let next = top + block;

		// enforce bounds
		if (next < start)
		next = start;

		if (next >= i32[S_SIZE])
		return 0; // or some "OOM" sentinel

		return next;
		*/
	}

	pop(ptr = 0) {
		if (this.reusePrev(ptr) === -1)
			return ptr;
		const i32 = this.i32;
		const I32 = this.I32;
		const rptr = I32[4];
		const cur = I32[2];
		this.classifyHead();
		const U8 = this.U8;
		// FREED caller broke the contract, slab does not care
		if (U8[5] & 8)
			return ptr;
		if (rptr + i32[S_HEADER] > cur) {
			if (U8[6] ^ 4)
				return ptr;
			return I32[4] = this.free(ptr);
		}
		return i32[rptr + 1] = cur;
	}

	modifier(
		reset = 0,
		dir = 0,
		debug = 0,
		force = 0,
		conflict = 0,
		shared = 0
	) {
		/*
			0: 0000		1: 0001		2: 0010		3: 0011
			4: 0100		5: 0101		6: 0110		7: 0111
			8: 1000		9: 1001		A: 1010		B: 1011
			C: 1100		D: 1101		E: 1110		F: 1111
		*/

		const U8 = this.U8;
		let v = U8[6];
		const r = (reset === 1 | v & 128) > 0 & reset !== -1;
		v = 0xFF & v << r * 7 | r << 7;
		U8[6] = v |= (r << 7) | (debug === 1 | v & 1 ^ debug === -1) |
			((dir === 1 | v & 2) > 0 & dir !== -1) << 1 |
			((force === 1 | v & 4) > 0 & force !== -1) << 2 |
			((conflict === 1 | v & 8) > 0 & conflict !== -1) << 3 |
			((shared === 1 | v & 16) > 0 & shared !== -1) << 4;
		if (v & 1) {
			console.group("Modifier Information");
			console.log(
				'\nDebug (bit 0):', 1,
				'\nDirection (bit 1):', (v & 2),
				'\nForce (bit 2):', (v & 4),
				'\nConflict (bit 3):', (v & 8),
				'\nShared (bit 4):', (v & 16),
				'\nReset (bit 7):', (v & 128),
			);
			console.groupEnd("Modifier Information");
		}
	}


	peer() {
		const U8 = this.U8;
		const I32 = this.I32;	// slab scratch registers (32‑bit)
		const i32 = this.i32;	// slab header table (signed pointers)
		const blk = i32[S_BLOCK]; // block size (alignment boundary)

		const idx = I32[4]; // current block being inspected

		const p = i32[idx]; // raw previous pointer (signed: ±index)
		const n = i32[idx + 1]; // raw next pointer (signed: ±index)

		const pidx = I32[5] = (p ^ (p >> 31)) - (p >> 31); // abs(p): unsigned previous index
		const nidx = I32[6] = (n ^ (n >> 31)) - (n >> 31); // abs(n): unsigned next index

		const pn = i32[pidx + 1]; // previous block's next pointer
		const pp = i32[pidx]; // previous block's next pointer
		const nn = i32[nidx + 1]; // next block's previous pointer
		const np = i32[nidx]; // next block's previous pointer

		const ppidx = (pp ^ (pp >> 31)) - (pp >> 31);
		const pnidx = (pn ^ (pn >> 31)) - (pn >> 31);
		const nnidx = (nn ^ (nn >> 31)) - (nn >> 31);
		const npidx = (np ^ (np >> 31)) - (np >> 31);

		const pr = -((pidx & (blk - 1)) === 0 | 0) & pidx;
		const nr = -((nidx & (blk - 1)) === 0 | 0) & nidx;
		const ppr = -((ppidx & (blk - 1)) === 0 | 0) & ppidx;
		const pnr = -((pnidx & (blk - 1)) === 0 | 0) & pnidx;
		const nnr = -((nnidx & (blk - 1)) === 0 | 0) & nnidx;
		const npr = -((npidx & (blk - 1)) === 0 | 0) & npidx;

		let psn = (pnr !== 0) & (pnidx === idx) & (p ^ pn) >= 0 | 0;
		psn |= (psn & (p > 0)) << 1 | 0;

		let nsn = (npr !== 0) & (npidx === idx) & (n ^ np) >= 0 | 0;
		nsn |= (nsn & (n > 0)) << 1 | 0;

		const csn =
			(psn & 1) &
			(nsn & 1) &
			(((psn ^ nsn) >> 1) & 1);   // both exist and signs differ

		// conflict flag: 0 = next wins, 1 = prev wins
		const cf = (U8[6] & 8) >> 3;  // 0 or 1

		const ps_sn = (psn >> 1) & 1;
		const ns_sn = (nsn >> 1) & 1;

		// only the loser's sign changes
		const ns_snn = (csn & cf) ? ps_sn : ns_sn;
		const ps_snn = (csn & (cf ^ 1)) ? ns_sn : ps_sn;

		// rebuild psn/nsn with same exist bits, updated sign bits
		psn = (psn & 1) | (ps_snn << 1);
		nsn = (nsn & 1) | (ns_snn << 1);

		const lsn = (ppr !== 0) & ((pp < 0) ^ (pn < 0)) | 0;
		const rsn = (nnr !== 0) & ((nn < 0) ^ (np < 0)) | 0;

		U8[7] = psn | (nsn << 2) | (lsn << 4) | (rsn << 5);

		if (U8[6] & 1) {
			console.group("Peer Information");
				console.group("Block Pointers");
				console.log(
					"\nprevious block pointer (pidx):", pidx,
					"\nnext block pointer (nidx):", nidx,
					"\nprevious block's next pointer (pnidx):", pnidx,
					"\nprevious block's previous pointer (ppidx):", ppidx,
					"\nnext block's previous pointer (npidx):", npidx,
					"\nnext block's next pointer (nnidx):", nnidx
				);
				console.groupEnd("Block Pointers");
				console.group("Pointer");
					console.log(
						'\npointer (idx):', idx,
						'\nprevious (p):', p,
						'\nnext (n):', n,
						'\nprevious pointer (pp):', pp,
						'\nnext pointer (nn):', nn,
						'\nleft-neighbor pointer (pn):', pn,
						'\nright-neighbor pointer (np):', np
					);
				console.groupEnd("Pointer");
				console.group("Pointer Signage");
					console.log(
						'\nprevious sign (psn):', psn,
						'\nnext sign (nsn):', nsn,
						'\nleft-neighbor sign (rsn):', rsn,
						'\nright-neighbor sign (lsn):', lsn,
						'\ncenter sign (lsn):', csn
					);
				console.groupEnd("Pointer Signage");
				console.group("Bits");
					console.log(
						'\nt2:', (csn & 2) >> 1,
						'\tt8:', (csn & 8) >> 3,
						'\nb1:', (U8[7] >> 1) & 1,
						'\tb3:', (U8[7] >> 3) & 1,
						'\nbothExist:', (psn & 1) & (nsn & 1),
						"\nnibble:", (U8[7] & 0x0F).toString(2).padStart(4, '0')
					);
				console.log(nxBit32.toBinary(U8[7]))
				console.groupEnd("Bits");
			console.groupEnd("Peer Information");
		}
	}

	reclaim(ptr = 0) {
		this.enforce(ptr);

		const U8  = this.U8;
		const I32 = this.I32;
		const i32 = this.i32;

		const ref = I32[4];
		const prv = I32[5];
		const nxt = I32[6];
		const sn = U8[7];

		// Decode existence from psn/nsn (low nibble)
		const nsn =  sn & 3; // bits 0–1
		const psn = (sn >> 2)  & 3; // bits 2–3

		const pe = psn & 1;
		const ne = nsn & 1;

		if (ne) {
			// 0 = forward, 2 = backward
			// choose which becomes the new head
			if (pe ^ 0)
				return I32[7] = (U8[6] & 2) ? prv : nxt;

			// CASE 1: both neighbors exist -> merged chain, pick a head by direction
			return I32[7] = prv;
		}

		// CASE 3: only next exists
		if (ne)
			return I32[7] = nxt;

		// CASE 4: no peers -> this block is the head
		return I32[7] = ref;
	}

	enforce(ptr = 0) {
		this.reuse(ptr);
		this.peer();

		const U8 = this.U8;
		const I32 = this.I32;
		const i32 = this.i32;

		const hdr = i32[S_HEADER];
		const flgs = U8[7];
		const ref = I32[4];
		const prv = I32[5];
		const nxt = I32[6];

		const lw = flgs & 16;
		const rw = flgs & 32;

		if (lw) {
			if (rw) {
				// detach self completely
				i32[ref] = 0;
				i32[ref + 1] = ref + hdr;
				// link left <-> right
				i32[nxt] = prv;
				i32[prv + 1] = nxt;
				return U8[7] = 0;
			}
			// detach left only
			i32[ref] = 0;
			// keep right intact
			return U8[7] &= 0x03;
		} else if (rw) {
			// detach right only
			i32[ref + 1] = ref + hdr;
			// keep left intact
			return U8[7] &= 0x0C;
		}
		return U8[7] &= 0x0F;
	}

	free(ptr = 0) {
		this.reclaim(ptr);

		const I32 = this.I32;
		const i32 = this.i32;
		const rptr = I32[4];

		if (rptr <= i32[S_START])
			return ptr;

		// 3. push into freelist
		const freed = i32[S_FREED];

		if (freed !== 0 && (freed & (i32[S_BLOCK] - 1)) === 0) {
			// link freed block <-> freelist head
			i32[rptr + 1] = -freed;
			i32[freed] = -rptr;
		} else {
			// start new freelist
			i32[rptr + 1] = 0;
		}

		i32[S_FREED] = rptr;
		i32[rptr]  = 0;

		return I32[7]; // reclaim already chose the head
	}
}

