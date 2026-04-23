
export function nxSet(n)
{
	const r = Number(n);
	return [!(Number.isFinite(r) || Number.isInteger(r)), r];
}

nxSet.isZ = n => {
	const r = Number(n);
	if (Number.isFinite(r))
		return [Math.floor(r) === r, r];
	return [false, r];
}

nxSet.isN = n => {
	const r = nxSet.isZ(n);
	return [r[0] && r[1] > 0, r[1]]
}

nxSet.isR = n => {
	const r = Number(n);
	return [Number.isFinite(r), r];
}

