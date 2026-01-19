import { nxBit32 } from "./nex-bit32.mjs"

/*
 * https://people.csail.mit.edu/shanir/publications/Lock_Free.pdf
 *
 */

// --- Stack / Header Indexes ---
const S_BLOCK  = 0;   // block size (aligned)
const S_HEADER = 1;   // header size (aligned)
const S_TOP    = 2;   // top-most allocated slab index
const S_FREED  = 3;   // free-list head
const S_SIZE   = 4;   // total buffer size
const S_FLAGS  = 5;   // VM flags bitfield
const S_RESIZE = 6;   // resize multiplier

// --- Constants ---
const C_SENTINAL = 0x7FFFFFFF; // max signed 32-bit

// --- Type IDs ---
const T_UTF8    = 0;
const T_INTEGER = 1;
const T_FLOAT   = 2;

// --- VM Constructor ---
export function nxVm(
    block = 16,
    header = 8,
    size = 4096,
    doublyPool = false,
    doublyFree = false,
    doublyCursor = false,
    resize = 2
) {
    // Align block + size to next power-of-two
    block = nxBit32.next(block);
    size  = nxBit32.next(size);

    // Enforce minimum block size
    if (block < 32) block = 32;

    // Header cannot exceed half the block
    const half = block >>> 1;
    if (header > half) header = half;

    // Ensure size >= block
    if (size < block) size = block;

    // Allocate backing buffer
    const buf = new ArrayBuffer(size);

    // Stack header view
    const stk = new Uint32Array(buf, 0, S_RESIZE + 1);

    // Init flags
    let flags = nxBit32.on(0, 1); // init bit

    if (doublyFree)   flags = nxBit32.on(flags, 2);
    if (doublyCursor) flags = nxBit32.on(flags, 3);
    if (doublyPool)   flags = nxBit32.on(flags, 4);

    // Write header
    stk[S_BLOCK]  = block;
    stk[S_HEADER] = header;
    stk[S_TOP]    = block * 2 + 1;
    stk[S_FREED]  = 0;
    stk[S_SIZE]   = size;
    stk[S_FLAGS]  = flags;
    stk[S_RESIZE] = resize > 1 ? resize : 2;

    return buf;
}

nxVm.sentinal = function(stk, idx)
{
	const sentinel = stk[idx];
	if (sentinel !== C_SENTINAL)
		return false;
	const endIndex = stk[idx + 1];
	if (endIndex < idx || endIndex >= stk.length)
		return false;
	const endValue = stk[endIndex];
	return (
		// identity 1: addition
		sentinel + endValue === idx + 1 &&
		// identity 2: XOR
		(sentinel ^ endValue) === (idx ^ endIndex)
	);
}

nxVm.init = function({block, header, size, doublyPool, doublyFree, doublyCursor, resize})
{
	const stk = nxVm(block, header, size, doublyPool, doublyFree, doublyCursor, resize)
}

nxVm.resize = function (buf) {
	const oU8 = new Uint8Array(buf);
	const oStk = new Int32Array(buf, 0, 6);

	const oCap = oStk[4];
	const nCap = Math.ceil(oCap * oStk[6]);

	// Create new buffer
	const nBuf = new ArrayBuffer(nCap);
	const nU8 = new Uint8Array(nBuf);

	// Copy old bytes into new buffer
	nU8.set(oU8);

	// Update header in the new buffer
	const nStk = new Int32Array(nBuf, 0, 6);
	nStk[4] = nCap;
	return nBuf;
};

nxVm.alloc = function(stk)
{
	const block = stk[0];
	const header = stk[1];
	const top = stk[2];
	const free = stk[3];
	const cap = stk[4];
	let cur;
	if (free === 0) {
		cur = top
		stk[2] = top + block;
	} else {
		cur = free;
		stk[3] = -stk[free]; // next free
	}
	if (stk[2] >= cap)
		stk = nxVm.resize(stk);
	stk[cur] = cur + header;
	return buf;
}

// free functions ////////////////////////////////////////////////////////
nxVm.free = function(stk, pl)
{
	nxBit32.is(stk[5], 2) ? nxVm._dFreeLink(stk, pl) : nxVm._sFreeLink(stk, pl);
}

nxVm.atomicFree = function(stk, pl)
{
	let head;
	do {
		head = Atomics.load(stk, 3);
		stk[pl] = head === 0 ? 0 : head;
	} while (Atomics.compareExchange(stk, 3, head, -pl) !== head);
}

// Int32Array Views


// free functions ////////////////////////////////////////////////////////
nxVm._dFreeLink = function(stk, pl)
{
	const head = stk[3];   // positive index or 0
	if (head === 0) {
		// empty list
		stk[pl] = 0; // next
		stk[pl + 1] = 0; // prev
	} else {
		// insert at head
		stk[pl] = -head;   // pl.next = head
		stk[pl + 1] = 0;   // pl.prev = none
		stk[head + 1] = -pl; // head.prev = pl
	}
	stk[3] = pl; // new head
}

nxVm._sFreeLink = function(stk, pl)
{
	const block = stk[0];
	const head = stk[3];
	stk[pl] = -head; // next pointer
	stk[3] = pl; // new head
}
 /* const nxTypeTable = [
	{ // [0]

	}
  ]*/
//const encoder = new TextEncoder();
//const bytes = encoder.encode(jsString);

