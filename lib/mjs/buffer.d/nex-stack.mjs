import { nxBit32 } from "../nex-bit32.mjs"

// --- Stack Indexes ---
const S_SIZE = 0; // 0-3
const S_RESIZE = 1; // 4-7
const S_TOP = 2; // 8-11
const S_MOD = 12;
// 12-15

// --- Current Offsets ---
const C_STARTING_TOP = 4;

export class NxStack
{
	constructor(
		size = 8,
		resize = 2,
		shared = 0
	) {
		size = (size ^ (size >> 31)) - (size >> 31);
		shared = shared === 1;
		const top = C_STARTING_TOP << nxBit32.log2(Int32Array.prototype.BYTES_PER_ELEMENT);
		const min = C_STARTING_TOP + top;
		size = nxBit32.bump(size ^ ((size ^ min) & -(size < min)));

		// Allocate backing buffer
		const B = this.B = shared
			? new SharedArrayBuffer(size)
			: new ArrayBuffer(size);

		// Stack views
		const i32 = this.i32 = new Int32Array(B);
		const f32 = this.f32 = new Float32Array(B);
		const u8 = this.u8 = new Uint8Array(B);

		i32[S_SIZE] = size;
		f32[S_RESIZE] = resize > 1.0 ? resize : 2.0;
		i32[S_TOP] = top;
		u8[S_MOD] = shared;
	}

	resize() {
		let u8 = this.u8;
		const i32 = this.i32;
		const sz = i32[S_SIZE];
		const rz = this.f32[S_RESIZE] * sz;
		const nz = rz - sz;
		const nBuf = u8[S_MOD] & 1
			? new SharedArrayBuffer(rz)
			: new ArrayBuffer(rz);
		const nu8 = new Uint8Array(nBuf);
		nu8.set(u8);
		this.f32 = new Float32Array(nBuf);
		const ni32 = this.i32 = new Int32Array(nBuf);
		this.u8 = nu8;
		ni32[S_SIZE] = rz;
		return nz;
	}

	push(data) {
		let u8 = this.u8;
		const i32 = this.i32;
		let top = i32[S_TOP];
		let space = i32[S_SIZE] - top;
		do {
			while (data > 0x7F && --space) {
				u8[++top] = (data & 0x7F) | 0x80;
				data >>>= 7;
			}

			if (space === 0) {
				space = this.resize() - top;
				u8 = this.u8;
				continue
			}
			u8[++top] = data;
		} while (data > 0x7F);
		return this.i32[S_TOP] = top;
	}

	peekLength() {
		const u8 = this.u8;
		let top = this.i32[S_TOP];
		if (top <= (C_STARTING_TOP << 2))
			return -1;
		// always at least one byte
		const end = top--;
		while (u8[top] & 0x80)
			--top
		return end - top;
	}

	peek() {
		let top = this.i32[S_TOP];
		if (top <= (C_STARTING_TOP << 2))
			return -1;
		const u8 = this.u8;
		let bits = u8[top];
		while (u8[--top] & 0x80)
			bits = (u8[top] & 0x7F) | (bits << 7);
		return bits;
	}

	pop() {
		let top = this.i32[S_TOP];
		if (top <= (C_STARTING_TOP << 2))
			return -1;
		const u8 = this.u8;
		let bits = u8[top];
		while (u8[--top] & 0x80)
			bits = (u8[top] & 0x7F) | (bits << 7);
		this.i32[S_TOP] = top;
		return bits;
	}

	/*index(idx) {
		let top = this.i32[S_TOP];
		if (idx <= (C_STARTING_TOP << 2) || idx > top)
			return -1;
		const u8 = this.u8;
		let left, right;
	}*/
}

