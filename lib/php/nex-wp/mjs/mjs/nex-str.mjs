import { nxObj } from './nex-obj.mjs';
import { nxType } from './nex-type.mjs';
import { nxSet } from './nex-set.mjs';

export function nxStr()
{
	nxObj.methods(nxObj);
}

nxStr.normalize = v => {
	return String(v).trim().toLowerCase();
}

nxStr.sanitize = v => {
	return String(v).replace(/[^a-zA-Z0-9_-]/g, '');
}

nxStr.lastChar = s => {
	const a = String(s).split('');
	const l = a.length - 1;
	return [l, a[l]];
}

const CHARACTERS = {
	digit: '0123456789',
	lower: 'abcdefghijklmnopqrstuvwxyz',
	upper: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
	punct: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
};

CHARACTERS.alpha = CHARACTERS.lower + CHARACTERS.upper;
CHARACTERS.alnum = CHARACTERS.alpha + CHARACTERS.digit;
CHARACTERS.graph = CHARACTERS.alnum + CHARACTERS.punct;

nxStr.random = (n = 8, o = 'alnum') => {
	// Normalize class list
	const l = nxObj.toArray(o);
	const v = new Set(['alnum','digit','graph','lower','upper','alpha','punct']);

	// Build character pool
	const p = [];
	l.forEach(c => {
		if (v.has(c)) {
			p.push(...CHARACTERS[c]);
		}
	});

	// Fallback if no valid classes
	if (p.length === 0)
		p.push(...CHARACTERS[o] ?? CHARACTERS.alnum);

	const ln = p.length;

	// Validate n using your ℤ classifier
	const z = nxSet.isZ(n);
	const len = z[0] && z[1] > 0 ? z[1] : 8;

	// Generate
	let s = "";
	for (let i = 0; i < len; i++)
		s += p[Math.floor(Math.random() * ln)];
	return s;
};

