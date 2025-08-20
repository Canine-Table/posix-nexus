import { nxObj } from './nex-obj.mjs';
import { nxArr } from './nex-arr.mjs';
import { nxType } from './nex-type.mjs';

export function nxBit()
{
		return nxObj.methods(nxBit);
}

nxBit.on = (b, s) => {
	return b | (1 << s);
}

nxBit.off = (b, s) => {
	return b & ~(1 << s);
}

nxBit.flip = (b, s) => {
	return b ^ (1 << s);
}

nxBit.set = (b, s) => {
	return Number.isInteger(+b) ? +b : (Number.isInteger(+s) ? +s : 0);
}

nxBit.is = (b, s) => {
	return (b & (1 << s)) !== 0;
}

nxBit.diverge = (b, s) => {
	return b ^ b >> s;
}

nxBit.cascade = (b, s) => {
	return b | b >> s;
}

nxBit.next = b => {
	b = Number(Math.abs(b)) - 1;
	if (! Number.isNumber(b) || b < 2)
		return 2;
	for (const n of [ 1, 2, 4, 8, 16 ])
		b = nxBit.cascade(b, n);
	return b + 1;
}

nxBit.parity = b => {
	b = Number(b)
	for (const n of [ 16, 8, 4, 3, 1 ])
		b = nxBit.diverge(b, n);
	return (b & 1) === 0;
}

nxBit.count = b => {
	let c = 0;
	while (b !== 0) {
		b = b & (b - 1);
		c++;
	}
	return c;
}

nxBit.isEven = b => {
	return (b & 1) === 0;
}

nxBit.toBinary = i => {
	return i.toString(2).padStart(32, '0');
}

